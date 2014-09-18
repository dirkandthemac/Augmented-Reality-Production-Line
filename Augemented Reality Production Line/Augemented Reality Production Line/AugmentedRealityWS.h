//
//  PimpedWS.h
//  Pimped
//
//  Created by Conrad Rowlands on 13/08/2014.
//  Copyright (c) 2014 Conrad Rowlands. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebServiceBase.h"

#define BASE_URL @"http://web-apps/AugmentedReality/api/test"
#define NOUGHT @""

extern NSString *const PRODUCTION_LINES_URL;

/* Delegate Definitions, one for each type of Data Source. These are used to
 allow us to spoof the web service for development purposes.....*/

@protocol FetchDelegates <NSObject>
@required
-(NSData*) onProductionLinesDataLoad;
//-(NSData*) onProjectDataLoad:(NSNumber*)projectID;
@end

/* Production Line Delegates */

@protocol ProductionLineLoadingDelegate <NSObject>
@required
-(void) onProductionLineLoaded:(NSDictionary*)ProductionLines;
-(void) onProductionLineLoadingError:(NSError *)ConnectionError;
@end

@interface AugmentedRealityWS : WebServiceBase

/* Delegates used for loading of all of the Web Service Data */

@property(nonatomic,weak)id<ProductionLineLoadingDelegate> ProductionLineLoadingDelegate;

/* Fetch Delegates (Used for spoofing Web Service Calls) */

@property(nonatomic,strong)id<FetchDelegates> FetchDelegate;

/* Interface Methods */

- (void) getProductionLines;

-(instancetype) initWithLocalSource;

/* Delegate Property Declarations */

-(dataFetched)ProductionLineDataFetched;

@end
