//
//  StockGraphController.m
//  Augmented Reality Production Line
//
//  Created by Conrad Rowlands on 30/09/2014.
//  Copyright (c) 2014 Conrad Rowlands. All rights reserved.
//

#import "StockGraphController.h"

@implementation StockGraphController

-(CGRect)getViewRectangle{
    return CGRectMake(0, 0, self.view.bounds.size.width, 170);
}

-(NSString *)ChartTitle{
    return @"Historical Stock Levels";
}
/*-(instancetype)init{
 
 self = [super init];
 if (self) {
 self.ChartTitle=@"Loading Bay Efficiency (Units per hour)";
 }
 return self;
 }*/

-(NSInteger)numberOfSeriesInSChart:(ShinobiChart *)chart{
    return 1;
}

-(SChartSeries *)sChart:(ShinobiChart *)chart seriesAtIndex:(NSInteger)index{
    SChartLineSeries *lineSeries = [[SChartLineSeries alloc] init];
    
    // the first series is a cosine curve, the second is a sine curve
    lineSeries.title = [NSString stringWithFormat:@"Historical Stock Level (units)"];
    
    return lineSeries;
}
-(NSInteger)sChart:(ShinobiChart *)chart numberOfDataPointsForSeriesAtIndex:(NSInteger)seriesIndex{
    return 365;
}

-(id<SChartData>)sChart:(ShinobiChart *)chart dataPointAtIndex:(NSInteger)dataIndex forSeriesAtIndex:(NSInteger)seriesIndex{
    
    SChartDataPoint *datapoint = [[SChartDataPoint alloc] init];
    
    // both functions share the same x-values
    double xValue = dataIndex ;/// 10.0;
    datapoint.xValue = [NSNumber numberWithInt:xValue];
    
    int r=0;
    // compute the y-value for each series
    if (seriesIndex == 0) {
        r=arc4random_uniform(75)+75;
    }
    datapoint.yValue = [NSNumber numberWithInt:r];
    
    return datapoint;
}

@end
