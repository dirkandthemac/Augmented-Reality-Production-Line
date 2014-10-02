//
//  HistoricalPipelineGraphController.m
//  Augmented Reality Production Line
//
//  Created by Conrad Rowlands on 01/10/2014.
//  Copyright (c) 2014 Conrad Rowlands. All rights reserved.
//

#import "HistoricalPipelineGraphController.h"

@implementation HistoricalPipelineGraphController


-(CGRect)getViewRectangle{
    return CGRectMake(0, 0, self.view.bounds.size.width, 220
                      );
}

-(NSString *)ChartTitle{
    return @"Average Weekly Pipeline Value";
}

-(NSInteger)numberOfSeriesInSChart:(ShinobiChart *)chart{
    return 4;
}

-(SChartSeries *)sChart:(ShinobiChart *)chart seriesAtIndex:(NSInteger)index{
    SChartLineSeries *lineSeries = [[SChartLineSeries alloc] init];
    
    // the first series is a cosine curve, the second is a sine curve
    if (index == 0) {
        lineSeries.title = [NSString stringWithFormat:@"2014-2013"];
    } else if (index == 1) {
        lineSeries.title = [NSString stringWithFormat:@"2013-2012"];
    } else if (index == 2) {
        lineSeries.title = [NSString stringWithFormat:@"2012-2011"];
    } else {
        lineSeries.title = [NSString stringWithFormat:@"2011-2010"];
    }
    
    return lineSeries;
}
-(NSInteger)sChart:(ShinobiChart *)chart numberOfDataPointsForSeriesAtIndex:(NSInteger)seriesIndex{
    return 52;
}

-(id<SChartData>)sChart:(ShinobiChart *)chart dataPointAtIndex:(NSInteger)dataIndex forSeriesAtIndex:(NSInteger)seriesIndex{
    
    SChartDataPoint *datapoint = [[SChartDataPoint alloc] init];
    
    // both functions share the same x-values
    double xValue = dataIndex ;/// 10.0;
    datapoint.xValue = [NSNumber numberWithInt:xValue];
    
    int r=0;
    // compute the y-value for each series
    if (seriesIndex == 0) {
        r=arc4random_uniform((dataIndex * 500)+100)+100000 +(dataIndex*100) ;
        //      datapoint.yValue = [NSNumber numberWithDouble:cosf(xValue)];
    } else if(seriesIndex==1) {
        r=arc4random_uniform((dataIndex * 370)+100)+95000+(dataIndex*95);
    } else if(seriesIndex==2) {
        r=arc4random_uniform((dataIndex * 250)+100)+92000+(dataIndex*90);
    }else{
        r=arc4random_uniform((dataIndex * 200)+100)+88000+(dataIndex*80);
    }
    datapoint.yValue = [NSNumber numberWithInt:r];
    
    return datapoint;
}

@end
