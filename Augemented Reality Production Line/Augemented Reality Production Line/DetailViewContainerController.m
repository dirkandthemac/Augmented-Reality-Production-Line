//
//  AppDelegate.m
//  SplitView Sample
//
//  Created by Ying Rao on 1/19/13.
//  Copyright (c) 2013 Ying Rao. All rights reserved.
//

#import "DetailViewContainerController.h"

@interface DetailViewContainerController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
@end

@implementation DetailViewContainerController

@synthesize detailControllers;
@synthesize loadControllersDelegate;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

-(void) loadControllers{

    if(self.loadControllersDelegate && [self.loadControllersDelegate respondsToSelector:@selector(onRequestControllers)]){

        detailControllers = [[NSMutableDictionary alloc]init];
        
        /* Get the Dictionary of all of the available Controllers and their keys.. */
        
        NSDictionary *dict= [self.loadControllersDelegate onRequestControllers];

        /* Iterate over all of the keys..... */
        
        for (id key in [dict allKeys]) {
       
            /* Get the Controller Name */
            
            id name = [dict objectForKey:key];
            
            /* Instantiate the Controller */
            
            UIViewController *vc= [self.storyboard instantiateViewControllerWithIdentifier:name];
            
            /* And add the controller to the collection by key. This way we can easily
                get to it when the user requests to see it .... */
            
            [detailControllers setValue:vc forKey:key];
            
            /* And add the Controller as a child view  */
            
            [self addChildViewController:vc];
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadControllers];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showViewUid:(NSString *)beaconUid{

    UIViewController *viewController = [detailControllers objectForKey:beaconUid] ;
   
    [self showChildViewController:viewController];
      
}



-(void)showChildViewController:(UIViewController*)content {
    if(topController != content) {
        id tmp = self.view;
        content.view.frame = [self.view frame]; // 2
        [self.view addSubview:content.view];
        [content didMoveToParentViewController:self];
        topController = content;
    }
}



#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}
@end
