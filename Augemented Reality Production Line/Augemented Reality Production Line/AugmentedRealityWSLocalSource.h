//
//  AugmentedRealityWSLocalSource.h
//  Augemented Reality Production Line
//
//  Created by Conrad Rowlands on 18/09/2014.
//  Copyright (c) 2014 Conrad Rowlands. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AugmentedRealityWS.h"

@interface AugmentedRealityWSLocalSource : NSObject <FetchDelegates>

/* Helper Method */

- (NSData *)loadLocalJSONData:(NSString *)filename;

-(NSData*) onProductionLinesDataLoad;

@end
