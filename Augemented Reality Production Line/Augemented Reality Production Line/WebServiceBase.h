//
//  WebServiceBase.h
//  Augemented Reality Production Line
//
//  Created by Conrad Rowlands on 18/09/2014.
//  Copyright (c) 2014 Conrad Rowlands. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebServiceBase : NSObject

/* Definition for handling the loading of data subsequent to a web invocation */

typedef void (^dataFetched)(NSURLResponse *response, NSData *data, NSError *connectionError);

-(void)getWSData:(NSString*)url fetchRoutine:(dataFetched) fetchRoutine;

@end
