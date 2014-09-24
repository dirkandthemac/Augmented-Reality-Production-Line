//
//  MasterViewController.h
//  Augemented Reality Production Line
//
//  Created by Conrad Rowlands on 17/09/2014.
//  Copyright (c) 2014 Conrad Rowlands. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "AugmentedRealityWS.h"
#import "DetailViewContainerController.h"

@class DetailViewController;

@interface MasterViewController : UITableViewController <NSFetchedResultsControllerDelegate,ProductionLineLoadingDelegate,LoadControllersDelegate>

@property (strong, nonatomic) DetailViewController *detailViewController;
@property (strong, nonatomic) DetailViewContainerController *detailViewContainerController;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSDictionary *AllProductionLines;


@end

