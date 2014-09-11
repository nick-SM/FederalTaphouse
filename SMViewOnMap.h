//
//  SMLiveMusicViewController.h
//  FederalTaphouse
//
//  Created by Nick Woodward on 9/8/14.
//  Copyright (c) 2014 softwaremerchant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface SMViewOnMap : UIViewController
@property (weak, nonatomic) IBOutlet MKMapView *mvMap;
- (IBAction)changeLocationPresser:(UISwitch *)sender;
@property (weak, nonatomic) IBOutlet UISwitch *sLocationChanged;
- (IBAction)getDirections:(id)sender;
- (IBAction)drawRoute:(id)sender;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btnDrawRouteCollection;
- (IBAction)clearRoute:(id)sender;


@end
