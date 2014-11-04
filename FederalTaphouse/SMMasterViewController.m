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
#import "SMRefresh.h"
//http://pngimg.com/upload/beer_PNG2330.png
@interface SMMasterViewController ()
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (IBAction)refresh:(id)sender;

@end

@implementation SMMasterViewController{
    UITableView *selectedTable;
}

- (void)awakeFromNib
{
    [super awakeFromNib];

}

-(void)loadImageIntoTable:(UIImageView *) imageView{
    NSURL *url = [[NSURL alloc]initWithString:@"http://www.pokercardprotector.com/media/catalog/product/cache/1/image/9df78eab33525d08d6e5fb8d27136e95/b/e/beer.png"];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *img = [[UIImage alloc] initWithData:data];
    [imageView performSelectorOnMainThread:@selector(setImage:) withObject:img waitUntilDone:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    SMAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    if(self.managedObjectContext == nil){
        [appDelegate initCoreData];
    }
    //NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
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
        [self.managedObjectContext save:nil];
    }
    NSLog(@"%@",self.selectedCategory.categoryName);
    //NSPredicate *predicate =[NSPredicate predicateWithFormat:@"beerCategory.categoryName = %@", self.selectedCategory.categoryBeers];
    //[self.fetchedResultsController.fetchRequest setPredicate:predicate];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo name];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIInterfaceOrientation intOrientation = [self interfaceOrientation];
    selectedTable =tableView;
    if(UIInterfaceOrientationIsLandscape(intOrientation) || intOrientation == UIInterfaceOrientationPortraitUpsideDown){
        [self performSegueWithIdentifier:@"toDetailLandscapeFromMaster" sender:nil];
    }
    else{
        [self performSegueWithIdentifier:@"toDetailPortraitFromMaster" sender:nil];
    }

}

/*- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if(self.searchDisplayController.active == YES){
        return nil;
    }
    NSMutableArray *titles;
    titles = [NSMutableArray new];
    
    
    for (int i=0;i<[[self.fetchedResultsController sections] count];i++){
        [titles addObject:[[self.fetchedResultsController.sections[i] name] substringToIndex:2]];
    }

    return titles;
    
}*/


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}


- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"toDetailPortraitFromMaster"] || [[segue identifier] isEqualToString:@"toDetailLandscapeFromMaster"]) {
        NSIndexPath *indexPath = [selectedTable indexPathForSelectedRow];
        NSManagedObject *object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        [[segue destinationViewController] setDetailItem:(BEER *)object];
    }
}

#pragma mark - Fetched results controller

- (IBAction)refresh:(id)sender {

    [SMRefresh refresh:self.managedObjectContext];
    
    
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // Background color
    view.tintColor = [UIColor colorWithRed:0.329 green:0.557 blue:0.827 alpha:1.000];
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor whiteColor]];

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
    
    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"beerCategory.categoryName = %@", self.selectedCategory.categoryName];
    [fetchRequest setPredicate:predicate];

    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"beerName" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".

    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:@"beerCategory.categoryName" cacheName:nil];
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
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationNone];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationNone];
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
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    
    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    NSArray *cellviews = cell.subviews;
    UIView *myView = cellviews[0];
    UIView *cellImage = [myView viewWithTag:2];
    UIView *cellLabel= [myView viewWithTag:1];
    UILabel *lblNew= (UILabel *)[myView viewWithTag:3];
    
    
    lblNew.text = [self findIfNew:[object valueForKey:@"beerDateAdded"]];
    [lblNew sizeToFit];
    //cellviews = [view1 subviews];
    [cellLabel setValue:[object valueForKey:@"beerName"] forKey:@"text"];
    
    NSOperationQueue *queue = [NSOperationQueue new];
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self
                                                                            selector:@selector(loadImageIntoTable:)
                                                                              object:cellImage];
    [queue addOperation:operation];

}


-(NSString *)findIfNew:(NSString *)date{
    NSDate *today = [NSDate date];
    NSDateFormatter *myDateFormetter = [[NSDateFormatter alloc]init];
    [myDateFormetter setDateFormat:@"MM/dd/yyyy HH:mm:ss a"];
    NSDate *beerDate;
    beerDate = [myDateFormetter dateFromString:date];
    NSLog(@"%@",today);
    NSLog(@"%@",beerDate);
    
    NSCalendar *c = [NSCalendar currentCalendar];

    NSDateComponents *components = [c components:NSDayCalendarUnit fromDate:beerDate toDate:today options:0];
    NSInteger diff = components.day;
    if (diff<=7)
        return @"NEW!";
    return @"";
}



@end
