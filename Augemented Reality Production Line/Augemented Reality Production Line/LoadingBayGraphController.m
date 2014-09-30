//
//  LoadingBayGraphController.m
//  Augmented Reality Production Line
//
//  Created by Conrad Rowlands on 30/09/2014.
//  Copyright (c) 2014 Conrad Rowlands. All rights reserved.
//

#import "LoadingBayGraphController.h"

@implementation LoadingBayGraphController

-(CGRect)getViewRectangle{
    return CGRectMake(0, 0, self.view.bounds.size.width, 120);
}

-(NSString *)ChartTitle{
    return @"Loading Bay Efficiency (Units per hour)";
}
/*-(instancetype)init{
    
    self = [super init];
    if (self) {
            self.ChartTitle=@"Loading Bay Efficiency (Units per hour)";
    }
    return self;
}*/

-(NSInteger)numberOfSeriesInSChart:(ShinobiChart *)chart{
    return 3;
}

-(SChartSeries *)sChart:(ShinobiChart *)chart seriesAtIndex:(NSInteger)index{
    SChartLineSeries *lineSeries = [[SChartLineSeries alloc] init];
    
    // the first series is a cosine curve, the second is a sine curve
    if (index == 0) {
        lineSeries.title = [NSString stringWithFormat:@"Loading Bay 1"];
    } else if (index == 1) {
        lineSeries.title = [NSString stringWithFormat:@"Loading Bay 2"];
    } else {
        lineSeries.title = [NSString stringWithFormat:@"Loading Bay 3"];
    }
    
    return lineSeries;
}
-(NSInteger)sChart:(ShinobiChart *)chart numberOfDataPointsForSeriesAtIndex:(NSInteger)seriesIndex{
    return 40;
}

-(id<SChartData>)sChart:(ShinobiChart *)chart dataPointAtIndex:(NSInteger)dataIndex forSeriesAtIndex:(NSInteger)seriesIndex{
    
    SChartDataPoint *datapoint = [[SChartDataPoint alloc] init];
    
    // both functions share the same x-values
    double xValue = dataIndex ;/// 10.0;
    datapoint.xValue = [NSNumber numberWithInt:xValue];
    
    int r=0;
    // compute the y-value for each series
    if (seriesIndex == 0) {
        r=arc4random_uniform(11)+30;
        //      datapoint.yValue = [NSNumber numberWithDouble:cosf(xValue)];
    } else if(seriesIndex==1) {
        r=arc4random_uniform(13)+40;
        //        datapoint.yValue = [NSNumber numberWithDouble:sinf(xValue)];
    }else{
        r=arc4random_uniform(14)+50;
    }
    datapoint.yValue = [NSNumber numberWithInt:r];
    
    return datapoint;
}

@end

