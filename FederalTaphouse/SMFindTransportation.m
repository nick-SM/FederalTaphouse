//
//  SMLiveMusicViewController.m
//  FederalTaphouse
//
//  Created by Nick Woodward on 9/10/14.
//  Copyright (c) 2014 softwaremerchant. All rights reserved.
//

#import "SMFindTransportation.h"
#define FTlat 40.041403
#define FTlong -76.305794

@interface SMFindTransportation ()

@end

@implementation SMFindTransportation

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
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = @"Transportation";
    request.region = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(FTlat, FTlong), 800, 800);
    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        for(MKMapItem *mapItem in response.mapItems){
            MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
            annotation.coordinate = mapItem.placemark.coordinate;
            annotation.title      = mapItem.name;
            annotation.subtitle   = mapItem.placemark.title;
            [self.mvMap addAnnotation:annotation];
        }
        //NSLog(@"Map Items: %@", response.mapItems);
    }];

    [self.mvMap setRegion:[self.mvMap regionThatFits:request.region] animated:YES];
   

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
