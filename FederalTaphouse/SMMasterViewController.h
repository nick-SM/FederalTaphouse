//
//  SMMasterViewController.h
//  FederalTaphouse
//
//  Created by Nick Woodward on 9/7/14.
//  Copyright (c) 2014 softwaremerchant. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreData/CoreData.h>

@interface SMMasterViewController : UITableViewController <NSFetchedResultsControllerDelegate>
- (IBAction)refresh:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *tvMainTable;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
-(void) returnFromDetail;

@end
