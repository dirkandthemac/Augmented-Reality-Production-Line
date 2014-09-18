//
//  BeaconProtocols.h
//  Augemented Reality Production Line
//
//  Created by Conrad Rowlands on 17/09/2014.
//  Copyright (c) 2014 Conrad Rowlands. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 
 Beacons Found Protocol.... Used for Reporting when the list of Beacons found
 changes from that previously found.....
 
 */

@protocol BeaconsFoundDelegate <NSObject>
@required
-(void) onBeaconsChanged:(NSMutableDictionary*)beacons;
@end

@protocol BeaconMonitorFoundDelegate <NSObject>
@required
-(void) onBeaconsChanged:(NSMutableDictionary*)beacons BeaconKey:(NSString*) beaconKey;
@end


@interface BeaconProtocols : NSObject

@end
