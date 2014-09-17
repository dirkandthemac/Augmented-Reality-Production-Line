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

@property NSString* Uuid;
@property NSString* Region;
@property NSInteger MajorId;
@property NSInteger MinorId;
@property NSInteger scansSinceFound;
@property BeaconProximity beaconProximity;

-(instancetype)init;

-(BOOL) isProximateTo:(CLProximity)proximity;

@end
