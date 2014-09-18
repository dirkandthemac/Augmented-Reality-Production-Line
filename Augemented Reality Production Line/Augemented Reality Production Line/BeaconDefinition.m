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

-(instancetype)initWithClBeacon:(CLBeacon *)beacon{
    
    self=[self init];
    if(self){
        self.Uuid=beacon.proximityUUID;
        self.MajorId=beacon.major;
        self.MinorId=beacon.minor;
    }
    return self;
}

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

+(NSString *)beaconKeyFromCLBeacon:(CLBeacon *)beacon{
    return [NSString stringWithFormat:@"%@-%@-%@",beacon.proximityUUID,beacon.major,beacon.minor];
}

+(NSString *)beaconKeyFromBeacon:(BeaconDefinition *)beacon{
    return [NSString stringWithFormat:@"%@-%ld-%ld",beacon.Uuid,(long)beacon.MajorId,(long)beacon.MinorId];
}
@end
