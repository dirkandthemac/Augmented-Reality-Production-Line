//
//  IMonitorBeacon.m
//  Augemented Reality Production Line
//
//  Created by Conrad Rowlands on 17/09/2014.
//  Copyright (c) 2014 Conrad Rowlands. All rights reserved.
//

#import "BeaconMonitor.h"
#import "BeaconDefinition.h"

@implementation BeaconMonitor

@synthesize beaconsFoundDelegate;
@synthesize beaconDefintion;
@synthesize locationManager;
@synthesize locationRegion;
@synthesize initialised;
@synthesize availableBeacons;

-(instancetype)initWithBeacon:(BeaconDefinition *)beaconDef{

    self = [super init];
    if (self) {

        /* Stre a reference to the beacon definition */
        
        beaconDefintion=beaconDef;
        
        /* Initialise the Manager */
        
        locationManager=[[CLLocationManager alloc]init];
        
        /* And set the delegate up */
        
        locationManager.delegate=self;
        
        /* And now Start updating the Location..... */
        
        if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            [self.locationManager requestAlwaysAuthorization];
        }
        
        availableBeacons = [[NSMutableDictionary alloc]init];
        
        [locationManager startUpdatingLocation];
        
    }
    return self;
}

/* Start the monitoring of the required Beacons...... */

-(void)startMonitoring{
    
    /* Get the Proximity ID */
    
    if(CLLocationManager.locationServicesEnabled
       &&
       CLLocationManager.authorizationStatus==kCLAuthorizationStatusAuthorizedAlways){
        
        /* Get the UUID for the Beacon Definition */
        
        NSUUID *proximityID = [[NSUUID alloc]initWithUUIDString:beaconDefintion.Uuid];
        
        /* Initialise the Beacon with the Proximity ID and the Identifier */
        
        locationRegion = [[CLBeaconRegion alloc]initWithProximityUUID:proximityID identifier:beaconDefintion.Region];
        
        locationRegion.notifyOnEntry=YES;
        locationRegion.notifyOnExit=YES;
        
        /* And Now Start the monitoring  */
        
        if([CLLocationManager isRangingAvailable]==YES  ){
            [locationManager startRangingBeaconsInRegion:locationRegion];
        }
        initialised=YES;
    }
}


/* Terminate all Monitoring currently in progress from this instance */

-(void)terminateMonitoring{
    
    [locationManager stopMonitoringForRegion:locationRegion];
    [locationManager stopRangingBeaconsInRegion:locationRegion];
}

/* Method used to invoke the calling of the delegates that are called whenever the list of
 beacons has changed.....*/

-(void)beaconsHaveChanged{
    if(self.beaconsFoundDelegate && [self.beaconsFoundDelegate respondsToSelector:@selector(onBeaconsChanged:)]){
        [self.beaconsFoundDelegate onBeaconsChanged:availableBeacons];
    }
}

/* Delegate invoked from the LocationManager to report that beacons have been ranged.... */

- (void) locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    
    /* Create a temporary Array... */
    
    NSMutableArray *beaconsInRange = [[NSMutableArray alloc]init];
    
    /* Iterae ove the found beacons and see if they are in the 
        required proximities... Any that are add to the temporary collection*/
    
    for (CLBeacon *beacon in beacons) {
        
        if ([beaconDefintion isProximateTo:beacon.proximity]) {
            [beaconsInRange addObject:beacon];
        }
    }
    
    /* If the number of beacons in the collections is different to the number last found then
     we invoke the delegate which forces the app to refresh itself..... */
    
    if(beaconsInRange.count!=lastSelection.count){
        changedCount++;
        if(changedCount>2){
            lastSelection=beaconsInRange;
            [self beaconsHaveChanged];
            changedCount=0;
        }
    }else{
        changedCount=0;
    }
}


@end
