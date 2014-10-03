
#import <UIKit/UIKit.h>
#import "DetailViewController.h" 



/* Load Controllers Delegate. Used to allow the control to request the controllers
    that it is to support..... */

@protocol LoadControllersDelegate <NSObject>
@required
-(NSDictionary*) onRequestControllers;
@end

@interface DetailViewContainerController : UIViewController <UISplitViewControllerDelegate> {
    UIViewController* topController;
}

/* Method used to invoke the showing of a screeen by a particular Beacon UID*/

-(void)showViewUid:(NSString*)controllerUid;

/* Dictionary of available controllers */

@property (strong, nonatomic) NSDictionary *detailControllers;

/* Load Controllers Delegate.... */

@property (strong, nonatomic) id<LoadControllersDelegate> loadControllersDelegate;

@end
