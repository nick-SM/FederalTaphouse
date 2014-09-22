//
//  SMCategoryTableViewController.h
//  FederalTaphouse
//
//  Created by Nick Woodward on 9/21/14.
//  Copyright (c) 2014 softwaremerchant. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMCategoryTableViewController : UITableViewController

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

- (IBAction)refresh:(id)sender;
@end
