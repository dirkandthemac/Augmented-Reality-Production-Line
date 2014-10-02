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

/* Initialise with a range of Near and Immediate as good defaults */

-(instancetype)init{
    self=[super init];
    if(self){
        beaconProximity = BPImmediate | BPNear;
    }
    
    return self;
}

/* Initialise using a beacon*/

-(instancetype)initWithClBeacon:(CLBeacon *)beacon{
    
    self=[self init];
    if(self){
        Uuid=beacon.proximityUUID;
        MajorId=beacon.major;
        MinorId=beacon.minor;
    }
    return self;
}

/* Initialise with just the raw data  */

-(instancetype)initWithData:(NSString *)uid major:(NSNumber *)major minor:(NSNumber *)minor region:(NSString *)region Proximity:(BeaconProximity)proximity{
    self=[super init];
    if(self){
        Uuid=[[NSUUID alloc]initWithUUIDString:uid];
        MajorId=major;
        MinorId=minor;
        Region=region;
        beaconProximity = proximity;
    }
    return self;
}

/* Function to return whether or not a Beacon is proximate according to the defined proximation
        settings */

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

/* Static Function to return the unique beacon id from a CLBeacon object */

+(NSString*)beaconKeyFromCLBeacon:(CLBeacon *)beacon{
    return [NSString  stringWithFormat:@"%@-%d-%d",beacon.proximityUUID.UUIDString,[beacon.major intValue],[beacon.minor intValue]];
}

/* Static Function to return the unique beacon id from a Beacon defintion object */

+(NSString*)beaconKeyFromBeacon:(BeaconDefinition *)beacon{
    return [NSString stringWithFormat:@"%@-%d-%d",beacon.Uuid.UUIDString,[beacon.MajorId intValue],[beacon.MinorId intValue]];
}
@end
