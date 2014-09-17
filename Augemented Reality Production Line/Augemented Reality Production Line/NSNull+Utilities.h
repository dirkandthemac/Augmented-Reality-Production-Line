//
//  NSNull.h
//  Pimped
//
//  Created by Conrad Rowlands on 28/08/2014.
//  Copyright (c) 2014 Conrad Rowlands. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNull (Utilities)

+(void)initialize;

+(NSString *) handleNulls:(NSString*)input;
+(NSNumber *) handleNumberNulls:(NSString*)input;
+(NSNumber *)handleNumberNulls:(NSString *)input nullValue:(NSNumber*)nullValue;

+(NSInteger *) handleIntNulls:(NSString*)input;
+(NSInteger *) handleIntNulls:(NSString *)input nullValue:(NSInteger*)nullValue;

@end
