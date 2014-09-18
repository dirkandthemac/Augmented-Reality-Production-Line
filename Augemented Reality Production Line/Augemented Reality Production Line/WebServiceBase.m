//
//  WebServiceBase.m
//  Augemented Reality Production Line
//
//  Created by Conrad Rowlands on 18/09/2014.
//  Copyright (c) 2014 Conrad Rowlands. All rights reserved.
//

#import "WebServiceBase.h"

@implementation WebServiceBase

-(void)getWSData:(NSString *)url fetchRoutine:(dataFetched)fetchRoutine{
    
    NSURL *uri = [NSURL URLWithString:url];
        
        /* And create the URL Request */
        
    NSURLRequest *request = [NSURLRequest requestWithURL:uri];
        
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:fetchRoutine];
}

@end
