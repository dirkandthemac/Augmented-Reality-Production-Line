//
//  JSONModelsBase.h
//  Pimped
//
//  Created by Conrad Rowlands on 02/09/2014.
//  Copyright (c) 2014 Conrad Rowlands. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSONModelsBase : NSObject

-(instancetype)initWithData:(NSDictionary *)data;

-(bool) isNull;

@end
