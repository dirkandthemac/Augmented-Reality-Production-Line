//
//  NSNull.m
//  Pimped
//
//  Created by Conrad Rowlands on 28/08/2014.
//  Copyright (c) 2014 Conrad Rowlands. All rights reserved.
//

#import "NSNull+Utilities.h"

@implementation NSNull(Utilities)

+(void)initialize{
    
}

+(NSString *)handleNulls:(NSString *)input{
    return input==(id)[NSNull null]? @"":input;
}

+(NSNumber *)handleNumberNulls:(NSString *)input{
    return [NSNull handleNumberNulls:input nullValue:0];
}
+(NSNumber *)handleNumberNulls:(NSString *)input nullValue:(NSNumber*)nullValue {
    NSNumberFormatter *ns = [[NSNumberFormatter alloc]init];
    [ns setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber *nm=[ns numberFromString:input];
    return input==(id)[NSNull null]? nullValue: nm;
}

+(NSInteger *)handleIntNulls:(NSString *)input{
    return [NSNull handleIntNulls:input nullValue:0];
}

+(NSInteger *)handleIntNulls:(NSString *)input nullValue:(NSInteger *)nullValue{
    return input==(id)[NSNull null] ? nullValue: [input integerValue];
    
}
@end
