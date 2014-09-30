//
//  GraphController.h
//  Augmented Reality Production Line
//
//  Created by Conrad Rowlands on 30/09/2014.
//  Copyright (c) 2014 Conrad Rowlands. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <ShinobiCharts/ShinobiCharts.h>
#import <stdlib.h>

@interface GraphController : UIViewController <SChartDatasource>{
   
}

- (NSString*) ChartTitle;

-(CGRect) getViewRectangle;


@end
