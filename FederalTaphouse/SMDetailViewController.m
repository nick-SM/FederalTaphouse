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
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.
    //self.detailDescriptionLabel.text = @"SKBNDAJ";
    if (self.detailItem) {

        
        [self.lblcDescriptions[0] setValue:self.detailItem.beerName forKey:@"text"];
        [self.lblcDescriptions[1] setValue:self.detailItem.beerLocation forKey:@"text"];
        [self.lblcDescriptions[2] setValue:self.detailItem.beerSize forKey:@"text"];
        [self.lblcDescriptions[3] setValue:self.detailItem.beerABV forKey:@"text"];
        [self.lblcDescriptions[4] setValue:self.detailItem.beerPrice forKey:@"text"];
        
        UILabel *descLabel =self.lblcDescriptions[5];
        [self.lblcDescriptions[5] setValue:self.detailItem.beerDescription forKey:@"text"];
        [descLabel sizeToFit];
        
        [self.lblcDescriptions[6] setValue:[self.detailItem.beerCategory valueForKey:@"categoryName"] forKey:@"text"];
        
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //[[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
	//[[NSNotificationCenter defaultCenter] addObserver:self
                                             //selector:@selector(onDeviceOrientationDidChange:)
                                               //  name:UIDeviceOrientationDidChangeNotification
                                               //object:nil];
    [self configureView];
    
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    //NSString *newtotal;
    
    if (self.interfaceOrientation == UIInterfaceOrientationLandscapeRight ||self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft ) {
        
        NSMutableArray *controllers = [[self.navigationController viewControllers]mutableCopy];
        [controllers removeLastObject];
        
        //[self.navigationController popViewControllerAnimated:NO];
        UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        SMDetailViewController *controller = [main instantiateViewControllerWithIdentifier:@"detailLandscape"];
        
        
        controller.detailItem = self.detailItem;

        [controllers addObject:controller];
        
        [self.navigationController setViewControllers:controllers animated:NO];
        //[self.navigationController pushViewController:controller animated:NO];
        //[controllers[controllers.count -2] performSegueWithIdentifier:@"toDetailLandscapeFromMaster" sender:nil];
        
        
        
    }
    else{
            
            NSMutableArray *controllers = [[self.navigationController viewControllers]mutableCopy];
            [controllers removeLastObject];
            
            //[self.navigationController popViewControllerAnimated:NO];
            UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            SMDetailViewController *controller = [main instantiateViewControllerWithIdentifier:@"detailPortrait"];
        
            controller.detailItem = self.detailItem;
            [controllers addObject:controller];
            
            [self.navigationController setViewControllers:controllers animated:NO];
    }
}

/*- (void)onDeviceOrientationDidChange:(NSNotification *)notification
{
    // A delay must be added here, otherwise the new view will be swapped in
	// too quickly resulting in an animation glitch
    //[self performSelector:@selector(updateLandscapeView) withObject:nil afterDelay:0];
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController *controller;
    
    if(controller ==nil){
        controller= [board instantiateViewControllerWithIdentifier:@"detailLandscape"];
    }
    [self.navigationController pushViewController:controller animated:NO];
}*/

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
