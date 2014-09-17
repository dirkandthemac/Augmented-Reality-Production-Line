//
//  NSDate.h
//  Pimped
//
//  Created by Conrad Rowlands on 15/08/2014.
//  Copyright (c) 2014 Conrad Rowlands. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString* const JSON_DATE;

@interface NSDate(Utilities)

+ (NSDate*) dateFromString:(NSString*)dateString dateFormat:(NSString*) dateFormat;

@end
