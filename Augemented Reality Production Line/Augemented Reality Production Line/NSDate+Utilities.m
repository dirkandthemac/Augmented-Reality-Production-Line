//
//  NSDate.m
//  Pimped
//
//  Created by Conrad Rowlands on 15/08/2014.
//  Copyright (c) 2014 Conrad Rowlands. All rights reserved.
//

#import "NSDate+Utilities.h"

NSString* const JSON_DATE=@"yyyy'-'MM'-'dd'T'HH':'mm':'ss";

@implementation NSDate(Utilities)

+ (NSDate*) dateFromString:(NSString*)dateString dateFormat:(NSString*) dateFormat{
    
    /* Create the Date Formatter */

    NSDateFormatter *df=[[NSDateFormatter alloc]init];

    /* Set up the Date format */
    
    [df setDateFormat:dateFormat];

    /* And Return the Date */
    
    return [df dateFromString:dateString];
}

@end
