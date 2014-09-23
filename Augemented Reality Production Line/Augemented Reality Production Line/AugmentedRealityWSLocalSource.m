//
//  AugmentedRealityWSLocalSource.m
//  Augemented Reality Production Line
//
//  Created by Conrad Rowlands on 18/09/2014.
//  Copyright (c) 2014 Conrad Rowlands. All rights reserved.
//

#import "AugmentedRealityWSLocalSource.h"

@implementation AugmentedRealityWSLocalSource

/* Helper Method */

- (NSData *)loadLocalJSONData:(NSString *)filename{
    NSString *filePath = [[NSBundle mainBundle]pathForResource:filename ofType:@"json"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:filePath];
    return data;
}

-(NSData*) onProductionLinesDataLoad{
    return [self loadLocalJSONData:@"productionlines"];
}

@end
