//
//  AppDelegate.m
//  SplitView Sample
//
//  Created by Ying Rao on 1/19/13.
//  Copyright (c) 2013 Ying Rao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailViewController.h" 



@protocol LoadControllersDelegate <NSObject>
@required
-(NSDictionary*) onRequestControllers;
@end

@interface DetailViewContainerController : UIViewController <UISplitViewControllerDelegate> {
    UIViewController* topController;
}

-(void)showViewUid:(NSString*)beaconUid;

/* Dictionary of available controllers */

@property (strong, nonatomic) NSDictionary *detailControllers;

/* Load Controllers Delegate.... */

@property (strong, nonatomic) id<LoadControllersDelegate> loadControllersDelegate;

@end
