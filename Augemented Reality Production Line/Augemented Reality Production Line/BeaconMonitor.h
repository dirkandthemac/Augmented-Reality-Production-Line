//
//  IMonitorBeacon.h
//  Augemented Reality Production Line
//
//  Created by Conrad Rowlands on 17/09/2014.
//  Copyright (c) 2014 Conrad Rowlands. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BeaconProtocols.h"
#import "BeaconDefinition.h"
#import <CoreLocation/CoreLocation.h>

@interface BeaconMonitor : NSObject <CLLocationManagerDelegate>

@property (nonatomic,strong) BeaconDefinition* beaconDefintion;

/* The property to which the delegate for the beacons protocol is assigned
 */

@property(nonatomic,weak)id<BeaconsFoundDelegate> beaconsFoundDelegate;

/* The Location Manager for the Beacons Interface */

@property (nonatomic,strong) CLLocationManager* locationManager;

/* The Region that we are interested in... */

@property(nonatomic,strong) CLBeaconRegion* locationRegion;


/* Specifies if the Beacons Class has been initialised.... */

@property (nonatomic,assign) BOOL initialised;

/* The current List of Selected Beacons */

@property(nonatomic,strong) NSMutableDictionary* availableBeacons;

/* Method to invoke the start of monitoring for the beacons we are interested in... */

-(void) startMonitoring;

/* Method to terminate the  monitoring of beacons we are interested in... */

-(void) terminateMonitoring;

/* Class initialisation */

-(instancetype) initWithBeacon:(BeaconDefinition*)beaconDef;

/* method used to raise the beacons have changed event to any listening classes */

-(void) beaconsHaveChanged;


@end
