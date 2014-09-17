//
//  BeaconProximity.h
//  Augemented Reality Production Line
//
//  Created by Conrad Rowlands on 17/09/2014.
//  Copyright (c) 2014 Conrad Rowlands. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 * CLProximity
 *
 * Discussion:
 *    Represents the current proximity of an entity.
 *
 */

typedef enum BeaconProximity:NSInteger{
    BPUnknown=1>>0,
    BPImmediate=1>>1,
    BPNear=1>>2,
    BPFar=1>>3
} BeaconProximity;
