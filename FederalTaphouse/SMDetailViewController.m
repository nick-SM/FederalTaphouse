//
//  SMDetailViewController.m
//  FederalTaphouse
//
//  Created by Nick Woodward on 9/7/14.
//  Copyright (c) 2014 softwaremerchant. All rights reserved.
//

#import "SMDetailViewController.h"
#import "SMAppDelegate.h"
#import "BEER.h"

@interface SMDetailViewController ()
- (void)configureView;
@end

@implementation SMDetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        //[self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.
    //self.detailDescriptionLabel.text = @"SKBNDAJ";
    if (self.detailItem) {
        SMAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        NSManagedObjectContext *context = [appDelegate managedObjectContext];
        NSFetchRequest *fetchBeer = [[NSFetchRequest alloc]
                                           initWithEntityName:@"BEER"];
        
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"beerName=%@",self.detailItem.beerName];
        [fetchBeer setPredicate:pred];
        NSArray *objects = [context executeFetchRequest:fetchBeer error:nil];
        
        BEER *selectedBeer = objects[0];
        //self.detailDescriptionLabel.text = [self.detailItem valueForKey:@"beerName"];
        //for(int i = 0; i<[self.lblcDescriptions count];i++){
            
        //}

        [self.lblcDescriptions[0] setValue:self.detailItem.beerName forKey:@"text"];
        [self.lblcDescriptions[1] setValue:self.detailItem.beerLocation forKey:@"text"];
        [self.lblcDescriptions[2] setValue:self.detailItem.beerSize forKey:@"text"];
        [self.lblcDescriptions[3] setValue:self.detailItem.beerABV forKey:@"text"];
        [self.lblcDescriptions[4] setValue:self.detailItem.beerPrice forKey:@"text"];
        [self.lblcDescriptions[5] setValue:self.detailItem.beerDescription forKey:@"text"];
        
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureView];
    
     //self.detailDescriptionLabel.text = @"SKBNDAJ";
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
