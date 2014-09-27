//
//  SMDetailViewController.m
//  FederalTaphouse
//
//  Created by Nick Woodward on 9/7/14.
//  Copyright (c) 2014 softwaremerchant. All rights reserved.
//

#import "SMDetailViewController.h"
#import "SMMasterViewController.h"
#import "SMAppDelegate.h"
#import "BEER.h"

@interface SMDetailViewController ()
- (void)configureView;
@end

@implementation SMDetailViewController{
    NSDictionary *imageUrls;
}

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
    }
}

- (void)configureView
{

    if (self.detailItem) {
        //NSURL *url = [NSURL URLWithString:imageUrls[self.detailItem.beerName]];
        NSURL *url = [[NSURL alloc]initWithString:@"http://www.pokercardprotector.com/media/catalog/product/cache/1/image/9df78eab33525d08d6e5fb8d27136e95/b/e/beer.png"];
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{

            NSData *data = [NSData dataWithContentsOfURL:url];
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImage *img = [[UIImage alloc] initWithData:data];
                UIImageView *myImageView = self.lblcImage[0];
                [myImageView setContentMode:UIViewContentModeScaleAspectFit];
                [myImageView setImage:img];
            });
        });
        
        [self.lblcDescriptions[0] setValue:self.detailItem.beerName forKey:@"text"];
        [self.lblcDescriptions[1] setValue:self.detailItem.beerLocation forKey:@"text"];
        [self.lblcDescriptions[2] setValue:self.detailItem.beerSize forKey:@"text"];
        [self.lblcDescriptions[3] setValue:self.detailItem.beerABV forKey:@"text"];
        
        [self.lblcDescriptions[4] setValue:self.detailItem.beerPrice forKey:@"text"];
        //NSString *temp =self.detailItem.beerPrice;
        double price = [self.detailItem.beerPrice floatValue];
        if(price != 0.0){
            NSNumber *priceWrap = [[NSNumber alloc]initWithDouble:price];
            NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
            [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
            NSString *numberAsString = [numberFormatter stringFromNumber:priceWrap];
            [self.lblcDescriptions[4] setValue:numberAsString forKey:@"text"];
        }


        
        UILabel *descLabel =self.lblcDescriptions[5];
        [self.lblcDescriptions[5] setValue:self.detailItem.beerDescription forKey:@"text"];
        [descLabel sizeToFit];
        
        [self.lblcDescriptions[6] setValue:[self.detailItem.beerCategory valueForKey:@"categoryName"] forKey:@"text"];
        
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImageView *myImageView = self.lblcImage[0];
    [myImageView invalidateIntrinsicContentSize];

    
    imageUrls = [[NSDictionary alloc]initWithObjectsAndKeys:@"http://3.bp.blogspot.com/-Ihe81DBRRRI/UR2pOklryuI/AAAAAAAAEKM/-IJpFD-sI6M/s1600/2013-02-14+20.06.47.jpg",@"Two Brothers Cane & Ebel",nil];
 
    [self configureView];
    
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    
    if (self.interfaceOrientation == UIInterfaceOrientationLandscapeRight ||self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft ) {
        
        NSMutableArray *controllers = [[self.navigationController viewControllers]mutableCopy];
        [controllers removeLastObject];
        
        UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        SMDetailViewController *controller = [main instantiateViewControllerWithIdentifier:@"detailLandscape"];
        
        controller.detailItem = self.detailItem;

        [controllers addObject:controller];
        
        [self.navigationController setViewControllers:controllers animated:NO];
        
    }
    else{
            
            NSMutableArray *controllers = [[self.navigationController viewControllers]mutableCopy];
            [controllers removeLastObject];
            
            UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            SMDetailViewController *controller = [main instantiateViewControllerWithIdentifier:@"detailPortrait"];
        
            controller.detailItem = self.detailItem;
            [controllers addObject:controller];
            
            [self.navigationController setViewControllers:controllers animated:NO];
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
