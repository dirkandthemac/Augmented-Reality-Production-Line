//
//  PimpedWS.m
//  Pimped
//
//  Created by Conrad Rowlands on 13/08/2014.
//  Copyright (c) 2014 Conrad Rowlands. All rights reserved.
//

#import "AugmentedRealityWS.h"
#import "AugmentedRealityWSLocalSource.h"
#import "ProductionLine.h"

@implementation AugmentedRealityWS

NSString *const PRODUCTION_LINES_URL = BASE_URL@"/ProductionLines";

/* Overide Initialiser which uses The local source as opposed to a web service. Used for testing
        purposes */

-(instancetype)initWithLocalSource{
    self = [super init];
    if(self){
        self.FetchDelegate = [AugmentedRealityWSLocalSource alloc];
    }
    return self;
}

-(void)getProductionLines{

    if(self.FetchDelegate && [self.FetchDelegate respondsToSelector:@selector(onProductionLinesDataLoad)]){
        self.ProductionLineDataFetched(nil,[self.FetchDelegate onProductionLinesDataLoad],nil);
    }else{
        [self getWSData:PRODUCTION_LINES_URL fetchRoutine:self.ProductionLineDataFetched];
    }
}

-(dataFetched)ProductionLineDataFetched{
    
    dataFetched df=^void(NSURLResponse *response, NSData *data, NSError *connectionError){
        
        /* If we have an error then if a delegate is set up to report the error then do so
         otherwise get out of here....*/
        
        if(connectionError!=nil){
            if(self.ProductionLineLoadingDelegate && [self.ProductionLineLoadingDelegate respondsToSelector:@selector(onProductionLineLoadingError:)]){
                [self.ProductionLineLoadingDelegate onProductionLineLoadingError:connectionError];
            }
            return;
        }
        
        /* OK. If we have data then we do this..... */
        
        if(data.length>0 && connectionError==nil){
            
            /* Get the data from out of the JSON Array and into deserialised object */
            
            NSDictionary *lines = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL];
            
            NSMutableDictionary *productionLines = [[NSMutableDictionary alloc] init];
            for(NSDictionary *line in lines){
                ProductionLine *pl=[[ProductionLine alloc]initWithData:line];
                [productionLines setObject:pl forKey:pl.BeaconUid];
            }

            if(self.ProductionLineLoadingDelegate && [self.ProductionLineLoadingDelegate respondsToSelector:@selector(onProductionLineLoaded:)]){
                [self.ProductionLineLoadingDelegate onProductionLineLoaded:productionLines];
            }
        }
    };
    
    return df;
    
}

@end
