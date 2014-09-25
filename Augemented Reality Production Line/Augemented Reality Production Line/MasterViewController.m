//
//  MasterViewController.m
//  Augemented Reality Production Line
//
//  Created by Conrad Rowlands on 17/09/2014.
//  Copyright (c) 2014 Conrad Rowlands. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "ProductionLine.h"


@interface MasterViewController ()

@end

@implementation MasterViewController

@synthesize AllProductionLines;
@synthesize ProductionLinesBeaconMonitor;
@synthesize LastMovedInto;

- (void)awakeFromNib {
    [super awakeFromNib];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
}

-(NSDictionary *)onRequestControllers{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    
    for (ProductionLine *p in [AllProductionLines objectEnumerator]) {
        [dict setValue:p.ControllerName forKey:p.UniqueBeaconID];
    }
    
    return dict;
}

-(void)onBeaconsChanged:(NSMutableDictionary *)beacons{
    BOOL changed=NO;
    for (id key in [AllProductionLines allKeys]) {
        NSLog(@"Keys = %@",key);
    }
    if (beacons.count==1) {
        BeaconDefinition *def = [[beacons objectEnumerator]nextObject];
        NSString *key=[BeaconDefinition beaconKeyFromBeacon:def];
        NSLog(@"Beacon Key = %@",key);
        ProductionLine *pl= [AllProductionLines objectForKey:key];
        if(pl){
            if(!LastMovedInto){
                LastMovedInto=pl;
                changed=YES;
            }else if(LastMovedInto.UniqueBeaconID!=pl.UniqueBeaconID){
                LastMovedInto=pl;
                changed=YES;
            }
        }
    }
    
    if(changed==YES){
        [self.detailViewContainerController showViewUid:[self LastMovedInto].UniqueBeaconID];
    }
}

- (void) LoadProductionLines{
    
    /* OK. Load all of the Production Lines */
    
    AugmentedRealityWS *ws = [[AugmentedRealityWS alloc]initWithLocalSource];
    ws.ProductionLineLoadingDelegate=self;
    [ws getProductionLines];
    
}

- (void)onProductionLineLoaded:(NSDictionary *)ProductionLines{
    self.AllProductionLines=ProductionLines;
    NSMutableDictionary *beaconIds =[[NSMutableDictionary alloc]init];
    NSMutableArray *beaconDefs = [[NSMutableArray alloc]init];
    
    for (ProductionLine *p in [AllProductionLines objectEnumerator]) {
        
        /* Now create a Beacon Definition from this info.... */
        
        BeaconDefinition *def = [[BeaconDefinition alloc]initWithData:p.BeaconUid major:p.MajorId minor:p.MinorId region:p.LineName Proximity:BPImmediate|BPNear];
        
        /* Add it to an array */
        
        if(![beaconIds objectForKey:def.Uuid]){
            [beaconIds setObject:def forKey:def.Uuid];
            [beaconDefs addObject:def];
        }
    }
    
    /* OK. Recreate the Monitor Beacon terminating if we are already monitoring.... */
    
    if(ProductionLinesBeaconMonitor!=nil){
        [ProductionLinesBeaconMonitor terminateMonitoring];
    }
    
    ProductionLinesBeaconMonitor=[IBeacon alloc];
    ProductionLinesBeaconMonitor.beaconsFoundDelegate=self;
    ProductionLinesBeaconMonitor = [ProductionLinesBeaconMonitor initWithBeacons:beaconDefs];
    
    /* And Start Monitoring */

    
    [ProductionLinesBeaconMonitor startMonitoring];
    
}

-(void)onProductionLineLoadingError:(NSError *)ConnectionError{
    
}

-(ProductionLine*)getSelectedProductionLine{
    return [self getProductionLineByIndexPath:[self.tableView indexPathForSelectedRow]];
}

-(ProductionLine*)getProductionLineByIndexPath:(NSIndexPath*) indexPath{
    
    NSArray *keys = [AllProductionLines allKeys];
    id key = [keys objectAtIndex:indexPath.row];
    ProductionLine *line = [AllProductionLines objectForKey:key];
    return line;
}

- (void)viewDidLoad {
   
    [super viewDidLoad];
    
    /* Now Load the Production Lines */
    
    [self LoadProductionLines];
    
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    /*
    self.detailViewContainerController = (DetailViewContainerController *)[[[self.splitViewController.viewControllers lastObject] viewControllers][0] viewControllers][0];
*/
    self.detailViewContainerController = (DetailViewContainerController *)[[self.splitViewController.viewControllers lastObject] viewControllers][0];
    
    /* Set the Delegate for loading to this Controller */
    
    self.detailViewContainerController.loadControllersDelegate=self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender {
    /*
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
        
    // If appropriate, configure the new managed object.
    // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
    [newManagedObject setValue:[NSDate date] forKey:@"timeStamp"];
        
    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
     */
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {

        /* Get the Currently selected Production Line */
        
        ProductionLine *line = [self getSelectedProductionLine];

        /* Now get a reference to the detail controller that we are going to pass of this
         project to.... */
        
        UITabBarController *tbc = [segue destinationViewController];
        
        for (UINavigationController *nav in tbc.viewControllers) {
            
            /* Set the View Controller that we want to Interface with .... */
            
            UIViewController *ctl = (UIViewController*)[nav topViewController];

            /* Set the Bar Back Button..... */
            
            ctl.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
            /*
            PimpedWS *ws = [[PimpedWS alloc] initWithLocalSource];
            ws.projectLoadingDelegate=(DetailViewController*)ctl;
            [ws getProjectById:project.Id];
             */
        }
    }
}

#pragma mark - Table View

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if([indexPath row] < 3) {
        [self.detailViewContainerController showViewUid:[self getSelectedProductionLine].UniqueBeaconID];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
//    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return AllProductionLines.count;
//    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    /*
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
            
        NSError *error = nil;
        if (![context save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
     */
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {

    NSArray *keys = [AllProductionLines allKeys];
    id key = [keys objectAtIndex:indexPath.row];
    ProductionLine *line = [AllProductionLines objectForKey:key];
    cell.textLabel.text=line.LineName;
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeStamp" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Master"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
	     // Replace this implementation with code to handle the error appropriately.
	     // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return _fetchedResultsController;
}    

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

/*
// Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed. 
 
 - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    // In the simplest, most efficient, case, reload the table view.
    [self.tableView reloadData];
}
 */

@end
