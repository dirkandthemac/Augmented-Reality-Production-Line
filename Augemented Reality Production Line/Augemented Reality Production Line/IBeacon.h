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

@interface IBeacon : NSObject<CLLocationManagerDelegate>

/* The property to which the delegate for the beacons protocol is assigned
 */

@property(nonatomic,weak)id<BeaconsFoundDelegate> beaconsFoundDelegate;



/* Method to invoke the start of monitoring for the beacons we are interested in... */

-(void) startMonitoring;

/* Method to terminate the  monitoring of beacons we are interested in... */

-(void) terminateMonitoring;

/* Class initialisation */

-(instancetype) init;

/* method used to raise the beacons have changed event to any listening classes */

-(void) beaconsHaveChanged;

@end
