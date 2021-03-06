//
//  RawMaterialsGraphController.m
//  Augmented Reality Production Line
//
//  Created by Conrad Rowlands on 01/10/2014.
//  Copyright (c) 2014 Conrad Rowlands. All rights reserved.
//

#import "RawMaterialsGraphController.h"

@implementation RawMaterialsGraphController

-(CGRect)getViewRectangle{
    return CGRectMake(0, 0, self.view.bounds.size.width, 220);
}

-(NSString *)ChartTitle{
    return @"Average Weekly Raw Materials Stock Level";
}

-(NSInteger)numberOfSeriesInSChart:(ShinobiChart *)chart{
    return 6;
}

-(SChartSeries *)sChart:(ShinobiChart *)chart seriesAtIndex:(NSInteger)index{
    SChartLineSeries *lineSeries = [[SChartLineSeries alloc] init];
    
    // the first series is a cosine curve, the second is a sine curve
    if (index == 0) {
        lineSeries.title = [NSString stringWithFormat:@"40 mm (Mix 1)"];
    } else if (index == 1) {
        lineSeries.title = [NSString stringWithFormat:@"32 mm (Mix 1)"];
    } else if (index == 2) {
        lineSeries.title = [NSString stringWithFormat:@"38 mm (Mix 1)"];
    } else if (index==3) {
        lineSeries.title = [NSString stringWithFormat:@"40 mm (Mix 2)"];
    } else if (index == 4) {
        lineSeries.title = [NSString stringWithFormat:@"32 mm (Mix 2)"];
    } else if (index == 5) {
        lineSeries.title = [NSString stringWithFormat:@"38 mm (Mix 2)"];
    }
    
    return lineSeries;
}
-(NSInteger)sChart:(ShinobiChart *)chart numberOfDataPointsForSeriesAtIndex:(NSInteger)seriesIndex{
    return 52;
}

-(id<SChartData>)sChart:(ShinobiChart *)chart dataPointAtIndex:(NSInteger)dataIndex forSeriesAtIndex:(NSInteger)seriesIndex{
    
    
    SChartDataPoint *datapoint = [[SChartDataPoint alloc] init];
    
    @try {
        
        // both functions share the same x-values
        double xValue = dataIndex ;/// 10.0;
        datapoint.xValue = [NSNumber numberWithInt:xValue];
        
        int r=0;
        r=arc4random_uniform(((52-dataIndex) * 50)+(10 * seriesIndex))+ 100 +((52-dataIndex)*10) ;
        datapoint.yValue = [NSNumber numberWithInt:r];
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    @finally {
    }
    
    return datapoint;
}


@end
