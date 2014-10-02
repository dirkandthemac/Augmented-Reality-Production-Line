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

/* Method used to provide a list of the controllers when requested to do so....
    This controllers list is required by the detailContainerController which keeps a key list
        so that it knows which controller to load when a given key is selected.....*/

-(NSDictionary *)onRequestControllers{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    
    for (ProductionLine *p in [AllProductionLines objectEnumerator]) {
        [dict setValue:p.ControllerName forKey:p.UniqueBeaconID];
    }
    
    return dict;
}

/* Delegate invoked from the IBeacons classes whenever the list of beacons in range changes....  */

-(void)onBeaconsChanged:(NSMutableDictionary *)beacons{

    BOOL changed=NO;
    
    NSString *key=nil;
    
    /* If there was only one beacon in range then get the production line associated 
            with this range and store a reference as this being the last selected... Otherwise
                clear the last selected reference out..... */
    
    if (beacons.count==1) {
        BeaconDefinition *def = [[beacons objectEnumerator]nextObject];
        key=[BeaconDefinition beaconKeyFromBeacon:def];
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
    }else if (beacons.count==0){
        LastMovedInto=nil;
    }

    /* And if the production line we are at was not the last one then invoke a show of the details
        and visually select the production line in the list */
    
    if(changed==YES){
        [self.detailViewContainerController showViewUid:[self LastMovedInto].UniqueBeaconID];
        
        if(key!=nil){
            
            NSArray *keys = [AllProductionLines allKeys];
        
            int row=0;
            NSIndexPath *indexPath = nil;
            for (NSString *itKey in keys) {
                if([key compare:itKey]==NSOrderedSame){
                    indexPath = [NSIndexPath indexPathForRow:(int)row inSection:0];
                    break;
                }
                row++;
            }
            if(indexPath){
                [self.tableView selectRowAtIndexPath:indexPath
                                            animated:YES scrollPosition:UITableViewScrollPositionMiddle];
                
            }
        }

    }
}

/* Load the available Production lines by querying the web service/embedded JSON request file */

- (void) LoadProductionLines{
    
    /* OK. Load all of the Production Lines. As we are specifying to initwithLocalSource this means
        that we will not be using a web service to load the data. */
    
    AugmentedRealityWS *ws = [[AugmentedRealityWS alloc]initWithLocalSource];
    ws.ProductionLineLoadingDelegate=self;
    [ws getProductionLines];
    
}

/* Method called when the production lines are loaded from the data source. As well as 
    initialising the Master list with all of the individual Production Lines this is also
        the point at which we set up the IBeacon monitoring. We use a dictionary to ensure
            that we are only monitoring unique beacon uuids. Ranges are not important in setting
                up the monitoring. */

- (void)onProductionLineLoaded:(NSDictionary *)ProductionLines{

    /* Assign to the main collection of Production Lines */
    
    self.AllProductionLines=ProductionLines;
    
    /* Now create the monitoring information */
    
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
    
    /* OK. Terminate the Monitor Beacon terminating if we are already monitoring.... */
    
    if(ProductionLinesBeaconMonitor!=nil){
        [ProductionLinesBeaconMonitor terminateMonitoring];
    }
    
    /* And re-prime the monitoring classes ready for monitoring */
    
    ProductionLinesBeaconMonitor=[IBeacon alloc];
    ProductionLinesBeaconMonitor.beaconsFoundDelegate=self;
    ProductionLinesBeaconMonitor = [ProductionLinesBeaconMonitor initWithBeacons:beaconDefs];
    
    /* Start Monitoring... */
    
    [ProductionLinesBeaconMonitor startMonitoring];
    
}

-(void)onProductionLineLoadingError:(NSError *)ConnectionError{
    
}

/* Method to return the currently selected production line */

-(ProductionLine*)getSelectedProductionLine{
    return [self getProductionLineByIndexPath:[self.tableView indexPathForSelectedRow]];
}

/* Return a production line by index path */

-(ProductionLine*)getProductionLineByIndexPath:(NSIndexPath*) indexPath{
    NSArray *keys = [AllProductionLines allKeys];
    id key = [keys objectAtIndex:indexPath.row];
    ProductionLine *line = [AllProductionLines objectForKey:key];
    return line;
}

/* Main Vew Did Load Routine */

- (void)viewDidLoad {
   
    [super viewDidLoad];
    
    /* Now Load the Production Lines */
    
    [self LoadProductionLines];
    
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;

    self.detailViewContainerController = (DetailViewContainerController *)[[self.splitViewController.viewControllers lastObject] viewControllers][0];
    
    /* Set the Delegate for loading to this Controller */
    
    self.detailViewContainerController.loadControllersDelegate=self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender {
}

#pragma mark - Segues

/* Main Segue.... Not used as we load items from the story board by controller name */

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
        }
    }
}

#pragma mark - Table View

/* This is effectively the Segue Code... When an item is clicked pass of to the detailviewcontainer
    controle to let it handle the loading of view controllers associated to the production line selected */

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if([indexPath row] < 3) {
        [self.detailViewContainerController showViewUid:[self getSelectedProductionLine].UniqueBeaconID];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return AllProductionLines.count;
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
}

/* SInple row configuration */

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {

    NSArray *keys = [AllProductionLines allKeys];
    id key = [keys objectAtIndex:indexPath.row];
    ProductionLine *line = [AllProductionLines objectForKey:key];
    cell.textLabel.text=line.LineName;
    cell.imageView.image =[UIImage imageNamed:line.Image];
    cell.detailTextLabel.text=line.Contact;
}

#pragma mark - Fetched results controller

/* Fetched Results Controller...  Functionality no longer used in this prototype... */

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
