//
//  SMDirectionsViewController.m
//  FederalTaphouse
//
//  Created by Nick Woodward on 9/9/14.
//  Copyright (c) 2014 softwaremerchant. All rights reserved.
//

#import "SMDirectionsViewController.h"

@interface SMDirectionsViewController ()

@end

@implementation SMDirectionsViewController{
    NSArray *steps;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tvDirections.text = @"";
    if(steps != nil){
        for(int i=0;i<[steps count];i++){
            MKRouteStep *step;
            step = steps[i];
            self.tvDirections.text = [self.tvDirections.text stringByAppendingString:[step instructions]];
            self.tvDirections.text = [self.tvDirections.text stringByAppendingString:@"\n"];
            
        }
    }

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
