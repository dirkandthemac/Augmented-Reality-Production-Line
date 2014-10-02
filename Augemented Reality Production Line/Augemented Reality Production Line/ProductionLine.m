//
//  ProductionLine.m
//  Augemented Reality Production Line
//
//  Created by Conrad Rowlands on 18/09/2014.
//  Copyright (c) 2014 Conrad Rowlands. All rights reserved.
//

#import "ProductionLine.h"
#import "NSNull+Utilities.h"

@implementation ProductionLine

@synthesize BeaconUid;
@synthesize MajorId;
@synthesize MinorId;
@synthesize LineName;
@synthesize ControllerName;
@synthesize Contact;
@synthesize Image;

/* Initialise with the beacon information */

-(instancetype)initWithData:(NSDictionary *)data{

    self = [super init];
    if(self){
        
        self.BeaconUid=[NSNull handleNulls:[data objectForKey:@"BeaconUID"]];
        self.MajorId=[data objectForKey:@"MajorID"];
        self.MinorId=[data objectForKey:@"MinorID"];
        self.LineName=[NSNull handleNulls:[data objectForKey:@"LineName"]];
        self.ControllerName=[NSNull handleNulls:[data objectForKey:@"Controller"]];
        self.Image=[NSNull handleNulls:[data objectForKey:@"Image"]];
        self.Contact=[NSNull handleNulls:[data objectForKey:@"Contact"]];
        
    }
    return self;
}

/* Return the Unique Beacon ID.. This equates to the UID + MAjor ID + Minor ID */

-(NSString *)UniqueBeaconID{
    return [NSString stringWithFormat:@"%@-%@-%@",BeaconUid,MajorId,MinorId];
}
@end
