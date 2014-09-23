//
//  ProductionLine.h
//  Augemented Reality Production Line
//
//  Created by Conrad Rowlands on 18/09/2014.
//  Copyright (c) 2014 Conrad Rowlands. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModelsBase.h"

@interface ProductionLine : JSONModelsBase

@property (nonatomic,strong) NSString* BeaconUid;
@property (nonatomic,strong) NSNumber* MajorId;
@property (nonatomic,strong) NSNumber* MinorId;
@property (nonatomic,strong) NSString* LineName;

-(NSString*) UniqueBeaconID;

@end
