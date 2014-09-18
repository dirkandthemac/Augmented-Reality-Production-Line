//
//  IBeaconDefinition.h
//  Augemented Reality Production Line
//
//  Created by Conrad Rowlands on 17/09/2014.
//  Copyright (c) 2014 Conrad Rowlands. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BeaconProximity.h"
#import <CoreLocation/CoreLocation.h>

@interface BeaconDefinition : NSObject

@property NSUUID* Uuid;
@property NSString* Region;
@property NSNumber* MajorId;
@property NSNumber* MinorId;
@property NSInteger scansSinceFound;
@property BeaconProximity beaconProximity;

-(instancetype)init;

-(instancetype) initWithClBeacon:(CLBeacon*) beacon;

-(instancetype) initWithData:(NSString*) uid major:(NSNumber*) major minor:(NSNumber*)minor region:(NSString*) region Proximity:(BeaconProximity) proximity;

/* Returns whether or not the Proximity passed is within the defined range specified by the user */

-(BOOL) isProximateTo:(CLProximity)proximity;

/* Creates a beacon key from a CLBeacon object. This will be unique and can be used for dictionaries etc */

+(NSString*) beaconKeyFromCLBeacon:(CLBeacon*)beacon;

/* Creates a beacon key from a Beacon Definiton object. This will be unique and can be used for dictionaries etc */

+(NSString*) beaconKeyFromBeacon:(BeaconDefinition*)beacon;

@end
