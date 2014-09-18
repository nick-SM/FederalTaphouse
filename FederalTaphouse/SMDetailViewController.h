//
//  SMDetailViewController.h
//  FederalTaphouse
//
//  Created by Nick Woodward on 9/7/14.
//  Copyright (c) 2014 softwaremerchant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BEER.h"
@interface SMDetailViewController : UIViewController
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *lblcImage;

@property (strong, nonatomic) BEER *detailItem;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *lblcDescriptions;

@end
