//
//  GraphController.m
//  Augmented Reality Production Line
//
//  Created by Conrad Rowlands on 30/09/2014.
//  Copyright (c) 2014 Conrad Rowlands. All rights reserved.
//

#import "GraphController.h"

@implementation GraphController{
    
    ShinobiChart *chart;
    
}

-(CGRect)getViewRectangle{
    return CGRectMake(10, 10, self.view.bounds.size.width, self.view.bounds.size.height);
}

-(NSString *)ChartTitle{
    return @"A Chart Title";
}
-(void)viewDidLoad{

    self.view.backgroundColor = [UIColor whiteColor];

    CGFloat margin = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) ? 10.0 : 50.0;
    
    CGRect rect = [self getViewRectangle];
    
    chart = [[ShinobiChart alloc] initWithFrame:rect];
    chart.title = [self ChartTitle];
    chart.licenseKey = @"nGhS/5V7T6e2BmiMjAxNDEwMjljb25yYWRqcm93bGFuZHNAeWFob28uY28udWs=b2s2vhsTMvEmoFrLWAsfMMGLbHb/mBqpszSOdED+4u12jB+ajKIstavqDb41kUvDkJhbq241V6Kr7o7RBwg97rwuQqigM0mMjCdHkhNZL3GbH54FSoRN0VtYWqwcWlNjwPsUQKw/K6rbHrsb/A09mWByJ46M=BQxSUisl3BaWf/7myRmmlIjRnMU2cA7q+/03ZX9wdj30RzapYANf51ee3Pi8m2rVW6aD7t6Hi4Qy5vv9xpaQYXF5T7XzsafhzS3hbBokp36BoJZg8IrceBj742nQajYyV7trx5GIw9jy/V6r0bvctKYwTim7Kzq+YPWGMtqtQoU=PFJTQUtleVZhbHVlPjxNb2R1bHVzPnh6YlRrc2dYWWJvQUh5VGR6dkNzQXUrUVAxQnM5b2VrZUxxZVdacnRFbUx3OHZlWStBK3pteXg4NGpJbFkzT2hGdlNYbHZDSjlKVGZQTTF4S2ZweWZBVXBGeXgxRnVBMThOcDNETUxXR1JJbTJ6WXA3a1YyMEdYZGU3RnJyTHZjdGhIbW1BZ21PTTdwMFBsNWlSKzNVMDg5M1N4b2hCZlJ5RHdEeE9vdDNlMD08L01vZHVsdXM+PEV4cG9uZW50PkFRQUI8L0V4cG9uZW50PjwvUlNBS2V5VmFsdWU+";
    
    chart.autoresizingMask =  ~UIViewAutoresizingFlexibleHeight;
    
    // add a pair of axes
    SChartNumberAxis *xAxis = [[SChartNumberAxis alloc] init];
    chart.xAxis = xAxis;
    
    SChartNumberAxis *yAxis = [[SChartNumberAxis alloc] init];
    chart.yAxis = yAxis;
    chart.datasource=self;
    // Add the chart to the view controller
    [self.view addSubview:chart];
    
}
/*
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
*/
@end

