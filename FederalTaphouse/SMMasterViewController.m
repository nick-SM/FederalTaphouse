//
//  SMMasterViewController.m
//  FederalTaphouse
//
//  Created by Nick Woodward on 9/7/14.
//  Copyright (c) 2014 softwaremerchant. All rights reserved.
//

#import "SMMasterViewController.h"
#import "SMOnlineCourseWebService.h"
#import "SMDetailViewController.h"
#import "SMAppDelegate.h"
#import "CATEGORY.h"
#import "BEER.h"

@interface SMMasterViewController ()
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end

@implementation SMMasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    SMAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    if(self.managedObjectContext == nil){
        [appDelegate initCoreData];
    }
    //self.navigationItem.rightBarButtonItem = self.editButtonItem;
    //SMAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSFetchRequest *fetchBeers = [[NSFetchRequest alloc]
                                   initWithEntityName:@"BEER"];
    
    NSArray *objects = [self.managedObjectContext executeFetchRequest:fetchBeers error:nil];
    
    if([objects count]== 0){
        
        NSString *path = [[NSBundle mainBundle] bundlePath];
        NSString *finalPath = [path stringByAppendingPathComponent:@"Beers.plist"];
        NSDictionary *plistDict = [NSDictionary dictionaryWithContentsOfFile:finalPath];
        NSArray *categories = [plistDict allKeys];

        
        for (int i=0;i<[categories count];i++){
            CATEGORY *moCategory;
            
            
            moCategory = [NSEntityDescription
                            insertNewObjectForEntityForName:@"CATEGORY"
                            inManagedObjectContext:self.managedObjectContext];
            
            moCategory.categoryName = categories[i];
            
            NSDictionary *embededPlistDict = plistDict[categories[i]];
            NSArray *beers = [embededPlistDict allKeys];
            NSDictionary *attributes;
            for (int j=0;j<[beers count];j++){
                BEER *moBeer;
                moBeer = [NSEntityDescription
                                insertNewObjectForEntityForName:@"BEER"
                                inManagedObjectContext:self.managedObjectContext];
                moBeer.beerCategory = moCategory;
                moBeer.beerName = beers[j];
                
                attributes = embededPlistDict[beers[j]];
                moBeer.beerPrice = attributes[@"Price"];
                moBeer.beerLocation = attributes[@"Location"];
                moBeer.beerABV = attributes[@"ABV"];
                moBeer.beerSize = attributes[@"Size"];
                moBeer.beerDescription = attributes[@"Description"];
                moBeer.beerCategory = moCategory;
            }
        }
    }
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender
{
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
    
    // If appropriate, configure the new managed object.
    // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
    //[newManagedObject setValue:[NSDate date] forKey:@"timeStamp"];
    
    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
         // Replace this implementation with code to handle the error appropriately.
         // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //NSLog(@"%i",[[self.fetchedResultsController sections] count]);
    return [[self.fetchedResultsController sections] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo name];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    if(UIDeviceOrientationIsLandscape(deviceOrientation)){
        [self performSegueWithIdentifier:@"toDetailLandscapeFromMaster" sender:nil];
    }
    else{
        [self performSegueWithIdentifier:@"toDetailPortraitFromMaster" sender:nil];
    }

}


- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    NSMutableArray *titles;
    titles = [NSMutableArray new];
    
    SMAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSFetchRequest *fetchCategories = [[NSFetchRequest alloc]
                                       initWithEntityName:@"CATEGORY"];
    NSArray *objects = [context executeFetchRequest:fetchCategories error:nil];
    CATEGORY *moCategory;
    
    for (int i=0;i<[[self.fetchedResultsController sections] count];i++){
        moCategory = objects[i];
        [titles addObject:[moCategory.categoryName substringToIndex:2]];
    }
    [titles sortUsingSelector:@selector(compare:)];
    return titles;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
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
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"toDetailPortraitFromMaster"] || [[segue identifier] isEqualToString:@"toDetailLandscapeFromMaster"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSManagedObject *object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        [[segue destinationViewController] setDetailItem:object];
    }
}

#pragma mark - Fetched results controller

- (IBAction)refresh:(id)sender {
    //[context deleteObject:];
    NSFetchRequest * allBeers = [[NSFetchRequest alloc] initWithEntityName:@"BEER"];
    NSFetchRequest * allCategories = [[NSFetchRequest alloc] initWithEntityName:@"CATEGORY"];
    NSArray * beers = [self.managedObjectContext executeFetchRequest:allBeers error:nil];
    NSArray * categories = [self.managedObjectContext executeFetchRequest:allCategories error:nil];
    for (NSManagedObject * beer in beers) {
        [self.managedObjectContext deleteObject:beer];    }
    
    for (NSManagedObject * category in categories) {
        [self.managedObjectContext deleteObject:category];
    }
    
    SMOnlineCourseWebService *service = [[SMOnlineCourseWebService alloc]init];
    
    NSMutableArray *inputElements = [[NSMutableArray alloc]init];
    
    NSMutableArray *elementValues = [[NSMutableArray alloc]init];
    
    NSDictionary *result = [service doWebService:@"getBeerList" withElements:inputElements forValues:elementValues];
    
    NSArray *beerNames = result[@"beer_name"];
    NSArray *beerCategorys = result[@"beer_category_name"];
    NSArray *beerDescriptions = result[@"beer_description"];
    NSArray *beerABVs = result[@"beer_ABV"];
    NSArray *beerLocations = result[@"beer_size"];
    NSArray *beerPrices = result[@"beer_price"];
    NSArray *beerSizes = result[@"beer_size"];
    
    NSMutableDictionary *catDict = [NSMutableDictionary new];
    for(int i = 0;i< [beerCategorys count];i++){
        if(![catDict[beerCategorys[i]]  isEqual: nil]){
            CATEGORY *moCategory;
            moCategory = [NSEntityDescription
                          insertNewObjectForEntityForName:@"CATEGORY"
                          inManagedObjectContext:self.managedObjectContext];
            
            moCategory.categoryName = beerCategorys[i];
            [catDict setObject:moCategory forKey:beerCategorys[i]];
        }
    }
    
    for(int i = 0;i< [beerNames count];i++){
        BEER *moBEER;
        moBEER = [NSEntityDescription
                      insertNewObjectForEntityForName:@"BEER"
                      inManagedObjectContext:self.managedObjectContext];
        moBEER.beerName = beerNames[i];
        moBEER.beerLocation = beerLocations[i];
        moBEER.beerSize = beerSizes[i];
        moBEER.beerDescription = beerDescriptions[i];
        moBEER.beerPrice = beerPrices[i];
        moBEER.beerABV = beerABVs[i];
        moBEER.beerCategory = catDict[beerCategorys[i]];
        
        
    }
}

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"BEER" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    //Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"beerCategory.categoryName" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:@"beerCategory.categoryName" cacheName:@"Master"];
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

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = [object valueForKey:@"beerName"];
}

@end
