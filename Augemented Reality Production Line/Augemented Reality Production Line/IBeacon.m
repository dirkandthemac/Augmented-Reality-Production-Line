//
//  IBeacon.m
//  Pimped
//
//  Created by Conrad Rowlands on 10/09/2014.
//  Copyright (c) 2014 Conrad Rowlands. All rights reserved.
//

#import "IBeacon.h"
#import "BeaconMonitor.h"
#import "BeaconMonitorResult.h"

@implementation IBeacon

/* Synthesize all of the proeprties that we wish to be available within this 
        instance of the class */

@synthesize beaconsFoundDelegate;
@synthesize monitors;
@synthesize isMonitoring;
@synthesize Results;


/* Terminate all Monitoring currently in progress from this instance */

-(void)terminateMonitoring{

    for (BeaconMonitor *monitor in monitors) {
        [monitor terminateMonitoring];
    }
    /* No Longer Monitoring */
    
    isMonitoring=false;
}

/* Delegate invoked when the User securitizes the Location Service in the general settings
    section of the iPad..... */

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    
    /* If we are monitoring and the user restricts access then stop monitoring otherwise
        if we are not monitoring and the user allows monitoring the start monitoring */
    
    switch(status){
        case kCLAuthorizationStatusAuthorizedAlways:
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            if(!isMonitoring){
                [self startMonitoring];
            }
        default:
            if(isMonitoring){
                [self terminateMonitoring];
            }
    }
}

-(void)addBeaconToMonitor:(BeaconDefinition *)definition{

    /* Get the beacon key.... */
    
    NSString *key =[BeaconDefinition beaconKeyFromBeacon:definition];

    /* If the beacon with this key is not aleady being monitored..... */
   
    if(![monitors objectForKey:key] ){

        /* Create the Monitor */
        
        BeaconMonitor *monitor = [[BeaconMonitor alloc]initWithBeacon:definition];

        /* Ensure that this class acts as the delegate for any beacons found events */
        
        monitor.beaconMonitorFoundDelegate=self;
        
        /* Add the key to the Monitors collection */
        
        [monitors setObject:monitor forKey:key];
        
        /* And start monitoring if the other beacons are monitoring */
        
        if (isMonitoring) {
            [monitor startMonitoring];
        }
    }
}

/* Initialisation code for this class */

- (instancetype)initWithBeacons:(NSMutableArray *)beacons
{
    self = [super init];
    if (self) {
        monitors=[[NSMutableDictionary alloc]init];
        for (BeaconDefinition *def in beacons) {
            [self addBeaconToMonitor:def];
        }
    }
    return self;
}

/* Start the monitoring of the required Beacons...... */

-(void)startMonitoring{
    
    /* Get the Proximity ID */

    if(!isMonitoring){

        for (BeaconMonitor *monitor in [monitors objectEnumerator]) {
            [monitor startMonitoring];
        }
        
        isMonitoring=YES;
    }
}

/* Handle the list of beacons changing from any one of the underlying beacons monitors.....*/

- (void)onBeaconsChanged:(NSMutableDictionary *)beacons BeaconKey:(NSString *)beaconKey {
    
    BOOL allCompiled=YES;
    
    /* If the results were all run through we destroyed the objects.. so recreate for another go 
            through */
    
    if(!Results){

        /* Recreate the Results Dictionary with all of the 
            available keys */
        
        Results = [[NSMutableDictionary alloc]init];
        for (BeaconMonitor *monitor in [monitors objectEnumerator]) {
            [Results setObject:[[BeaconMonitorResult alloc]init] forKey:monitor.BeaconKey];
        }
    }

    /* Get the current Beacon Monitor and assign the results delivered into it.... */
    
    BeaconMonitorResult *res = [Results objectForKey:beaconKey];
    if (res) {
        res.results=beacons;
    }
    
    /* Now Iterate over the results collection and if at least one is incomplete then mark the operation
        as not yet complete so that we dont notify the caller too much */
    
    for (BeaconMonitorResult *mr in [Results objectEnumerator]) {
        if(!mr.results){
            allCompiled=false;
            break;
        }
    }
    
    /* OK. Once all of the results have been compiled we create one dictionary that has COPIES of the
            data and we use that to nitify the calling app that the data has changed.... This way we avoid reference issues. */
    
    if(allCompiled){
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        
        for (BeaconMonitor *mon in [monitors objectEnumerator]) {
            [dict addEntriesFromDictionary:mon.availableBeacons];
        }
        
        [self.beaconsFoundDelegate onBeaconsChanged:dict];
        
        /* Reset the Results collection as .... we will start the process over again */
        
        Results=nil;
    }
}

@end
