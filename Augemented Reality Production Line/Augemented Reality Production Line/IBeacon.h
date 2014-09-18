//
//  IBeacon.h
//  Pimped
//
//  Created by Conrad Rowlands on 10/09/2014.
//  Copyright (c) 2014 Conrad Rowlands. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "BeaconProtocols.h"
#import "BeaconProximity.h"
#import "BeaconDefinition.h"

@interface IBeacon : NSObject<BeaconMonitorFoundDelegate>

/* The property to which the delegate for the beacons protocol is assigned
 */

@property(nonatomic,weak)id<BeaconsFoundDelegate> beaconsFoundDelegate;

/* The results of the last monitor updates.... */

@property(nonatomic,strong) NSMutableDictionary *Results;

/* List of all of the monitors currently running.... */

@property(nonatomic,strong)NSMutableDictionary *monitors;

/* Specifies whether we are currently Monitoring or not */

@property(nonatomic,assign)BOOL isMonitoring;

/* Method to invoke the start of monitoring for the beacons we are interested in... */

-(void) startMonitoring;

/* Method to terminate the  monitoring of beacons we are interested in... */

-(void) terminateMonitoring;

/* Class initialisation */

-(instancetype) initWithBeacons:(NSMutableArray*) beacons;

/* Method used to add a beacon to monitor..... */

-(void) addBeaconToMonitor:(BeaconDefinition*) definition;

/* method used to raise the beacons have changed event to any listening classes */

-(void) beaconsHaveChanged;

@end
