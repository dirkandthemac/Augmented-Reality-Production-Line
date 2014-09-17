//
//  IBeaconDefinition.m
//  Augemented Reality Production Line
//
//  Created by Conrad Rowlands on 17/09/2014.
//  Copyright (c) 2014 Conrad Rowlands. All rights reserved.
//

#import "BeaconDefinition.h"

@implementation BeaconDefinition

@synthesize Uuid;
@synthesize Region;
@synthesize MajorId;
@synthesize MinorId;
@synthesize scansSinceFound;
@synthesize beaconProximity;

-(instancetype)init{
    self=[super init];
    if(self){
        beaconProximity = BPImmediate | BPNear;
    }
    
    return self;
}

-(BOOL)isProximateTo:(CLProximity)proximity{
    
    switch (proximity) {
        case CLProximityNear:
            return beaconProximity & BPNear;
        case CLProximityImmediate:
            return beaconProximity & BPImmediate;
        case CLProximityFar:
            return beaconProximity & BPFar;
        default:
            return beaconProximity & BPUnknown;
    }
}

@end
