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
@synthesize BeaconKey;
@synthesize locationManager;
@synthesize locationRegion;
@synthesize initialised;
@synthesize availableBeacons;

-(instancetype)initWithBeacon:(BeaconDefinition *)beaconDef{

    self = [super init];
    if (self) {

        
        /* Store a reference to the beacon definition */
        
        beaconDefintion=beaconDef;
        
        /* And the key for this definition */
        
        BeaconKey = [BeaconDefinition beaconKeyFromBeacon:beaconDef];
        
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
        
        /* Initialise the Beacon with the Proximity ID and the Identifier */
        
        locationRegion = [[CLBeaconRegion alloc]initWithProximityUUID:beaconDefintion.Uuid identifier:beaconDefintion.Region];
        
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
        [self.beaconsFoundDelegate onBeaconsChanged:availableBeacons BeaconKey:BeaconKey];
    }
}

-(BOOL)addBeacons:(NSMutableDictionary *)foundBeacons{
    
    BOOL hasChanged = NO;
    
    NSMutableArray *beaconsToDelete = [[NSMutableArray alloc]init];
    
    /* Iterate over all of the beacons within Range...... */
    
    for (BeaconDefinition *def in availableBeacons) {

        /* Get the Key we are using frst off.... */
        
        NSString *key = [BeaconDefinition beaconKeyFromBeacon:def];
        
        /* Now get the beacon from the new beacons list..... */
        
        CLBeacon *beacon = [foundBeacons objectForKey:key];
        
        /* If there is no beacon The this beacon has dissapeared... To allow for some play 
                with the low energy aspect we merely increment a count at this point to allow
                    for instances where the loss is merely a blip.....
         
            We make a note of the keys of any that are marked for deletion and will remove them 
                outside of the main loop
         */
    
        if(!beacon){
            def.scansSinceFound++;
            if(def.scansSinceFound>2){
                [beaconsToDelete addObject:key];
            }
            
        /* Otherwise.... the Beacons was found. Ensure that the beacon count is thus reset */
            
        }else{
            if(def.scansSinceFound>0){
                def.scansSinceFound=0;
            }
        }
    }

    hasChanged = beaconsToDelete.count==0 ? NO : YES;
    
    /* OK. Remove any marked for deletion.... */
    
    for (NSString *key in beaconsToDelete) {
        [availableBeacons removeObjectForKey:key];
    }
    
    /* Iterate over the newly found items and add them immediately */
    
    for (CLBeacon *beacon in foundBeacons) {

        /* Get the Key we are using frst off.... */
        
        NSString *key = [BeaconDefinition beaconKeyFromCLBeacon:beacon];

        /* If the beacon already has a definition then get its definition */
        
        BeaconDefinition *def= [availableBeacons objectForKey:key];
        
        /* And if we dound no matching definition then create one and add it to the collection */
        
        if(!def){
            BeaconDefinition *newDef = [[BeaconDefinition alloc]initWithClBeacon:beacon];
            [availableBeacons setObject:newDef forKey:key];
            if(hasChanged==NO){
                hasChanged=YES;
            }
        }
    }

    /* And let the caller know the selection has changed */
    
    return hasChanged;
}

/* Delegate invoked from the LocationManager to report that beacons have been ranged.... */

- (void) locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    
    /* Create a temporary dictionary for the found beacons within range ... */
    
    NSMutableDictionary *beaconsInRange = [[NSMutableDictionary alloc]init];
    
    /* Iterae ove the found beacons and see if they are in the 
        required proximities... Any that are add to the temporary collection*/
    
    for (CLBeacon *beacon in beacons) {
        
        if ([beaconDefintion isProximateTo:beacon.proximity]) {
            [beaconsInRange setObject:beacon forKey:[BeaconDefinition beaconKeyFromCLBeacon:beacon]];
        }
    }
    
    /* And add the beacons.... If the beacons in the collections change then we let the delegate know that  it needs to refresh its data */
    
    if([self addBeacons:beaconsInRange]){
        [self beaconsHaveChanged];
    }
}


@end
