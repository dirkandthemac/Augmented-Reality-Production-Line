//
//  JSONModelsBase.m
//  Pimped
//
//  Created by Conrad Rowlands on 02/09/2014.
//  Copyright (c) 2014 Conrad Rowlands. All rights reserved.
//

#import "JSONModelsBase.h"

@implementation JSONModelsBase

-(instancetype)initWithData:(NSDictionary *)data{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}


-(bool)isNull{
    [self doesNotRecognizeSelector:_cmd];
    return false;
}

@end
