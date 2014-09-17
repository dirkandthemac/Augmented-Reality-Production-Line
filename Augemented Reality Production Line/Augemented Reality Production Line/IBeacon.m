//
//  IBeacon.m
//  Pimped
//
//  Created by Conrad Rowlands on 10/09/2014.
//  Copyright (c) 2014 Conrad Rowlands. All rights reserved.
//

#import "IBeacon.h"

@implementation IBeacon

/* Synthesize all of the proeprties that we wish to be available within this 
        instance of the class */

@synthesize initialised;
@synthesize beaconsFoundDelegate;
@synthesize lastSelection;
@synthesize changedCount;

/* Terminate all Monitoring currently in progress from this instance */

-(void)terminateMonitoring{
    
    [locationManager stopMonitoringForRegion:locationRegion];
    [locationManager stopRangingBeaconsInRegion:locationRegion];
}

/* Delegate invoked when the User securitizes the Location Service in the general settings
    section of the iPad..... */

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    NSLog(@"Authorise Status: %d", status);
}

/* Initialisation code for this class */

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        /* Initialise the Manager */
        
        locationManager=[[CLLocationManager alloc]init];
        
        /* And set the delegate up */
        
        locationManager.delegate=self;

        /* And now Start updating the Location..... */
        
        if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            [self.locationManager requestAlwaysAuthorization];
        }
        
        lastSelection = [[NSMutableArray alloc]init];
        
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
        NSUUID *proximityID = [[NSUUID alloc]initWithUUIDString:UUID];
    
    /* Initialise the Beacon with the Proximity ID and the Identifier */
    
        locationRegion = [[CLBeaconRegion alloc]initWithProximityUUID:proximityID identifier:REGION];

        locationRegion.notifyOnEntry=YES;
        locationRegion.notifyOnExit=YES;
    
    /* And Now Start the monitoring  */
        
        if([CLLocationManager isRangingAvailable]==YES  ){
            [locationManager startRangingBeaconsInRegion:locationRegion];
        }
        initialised=YES;
    }
}

/* Delegate used to report on any failures when monitoring a region...... */

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error {
    NSLog(@"Failed monitoring region: %@", error);
}

/* Delegate used to report any general errors from the LocationManager */

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"Location manager failed: %@", error);
}

/* Delegate used to report that a region was entered ..... */

- (void)locationManager:(CLLocationManager *)manager
         didEnterRegion:(CLRegion *)region{
    
}

/* Delegate used to report that a region was exited ..... */

- (void)locationManager:(CLLocationManager *)manager
          didExitRegion:(CLRegion *)region{
    
}

/* Delegate used to report that monitoring was invoked on a region ..... */

- (void) locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region
{
}

/* Delegate used to report thatthe state is being determined upon a region ..... */

- (void) locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region{
}

/* Method used to invoke the calling of the delegates that are called whenever the list of 
        beacons has changed.....*/

-(void)beaconsHaveChanged{
    if(self.beaconsFoundDelegate && [self.beaconsFoundDelegate respondsToSelector:@selector(onBeaconsChanged:)]){
        [self.beaconsFoundDelegate onBeaconsChanged:lastSelection];
    }
}

/* Delegate invoked from the LocationManager to report that beacons have been ranged.... */

- (void) locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    
    /* Create a temporary Array... */
    
    NSMutableArray *beaconsInRange = [[NSMutableArray alloc]init];

    /* Now iterate over all of the beacons found and add the beacons found within the
            required proximities to the temporary collection ...... */
    
    for (CLBeacon *beacon in beacons) {
        CLProximity prox = beacon.proximity;
        switch (prox) {
            case CLProximityImmediate:
            case CLProximityNear:{
                [beaconsInRange addObject:beacon];
                break;
            }
            default:
                break;
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
