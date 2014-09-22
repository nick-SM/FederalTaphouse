//
//  SMWebViewController.m
//  FederalTaphouse
//
//  Created by Nick Woodward on 9/21/14.
//  Copyright (c) 2014 softwaremerchant. All rights reserved.
//

#import "SMWebViewController.h"

@interface SMWebViewController ()

@end

@implementation SMWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURL *url = [[NSURL alloc]initWithString:@"http://www.yelp.com/search?find_desc=music&find_loc=lancaster%2C+PA&ns=1"];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
    //[self.wvWebView loadHTMLString:@"http://www.yelp.com/search?find_desc=&find_loc=lancaster%2C+PA&ns=1" baseURL:nil];
    [self.wvWebView loadRequest:request];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
