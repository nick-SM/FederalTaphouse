//
//  SMLiveMusicViewController.m
//  FederalTaphouse
//
//  Created by Nick Woodward on 9/8/14.
//  Copyright (c) 2014 softwaremerchant. All rights reserved.
//

#define FTlat 40.041403
#define FTlong -76.305794

#import "SMViewOnMap.h"

@interface SMViewOnMap ()

@end

@implementation SMViewOnMap{
    MKUserLocation *userloc;
    BOOL directionsDrawn;
    NSArray *arrRoutes;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    
    directionsDrawn = NO;

    userloc = userLocation;
    for(id obj in arrRoutes){
        MKRoute *route = obj;
        [self.mvMap removeOverlay:route.polyline];
    }
    [self drawMap];

}

- (void) drawMap{
    CLLocationCoordinate2D coord;
    coord = CLLocationCoordinate2DMake(FTlat, FTlong);
    MKCoordinateRegion region;
    
    if(userloc == nil){
        region = MKCoordinateRegionMakeWithDistance(coord, 100, 100);
    }
    else{
        MKCoordinateSpan locationSpan;
        locationSpan.latitudeDelta =1.1*abs(userloc.coordinate.latitude - FTlat);
        locationSpan.longitudeDelta =1.1*abs(userloc.coordinate.longitude  -FTlong);
        CLLocationCoordinate2D locationCenter;
        locationCenter.latitude = (FTlat + userloc.coordinate.latitude) / 2;
        locationCenter.longitude = (FTlong + userloc.coordinate.longitude) / 2;
        region = MKCoordinateRegionMake(locationCenter, locationSpan);
    }
    [self.mvMap setRegion:[self.mvMap regionThatFits:region] animated:YES];
    
    
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    
    point.coordinate = coord;
    point.title = @"Federal Taphouse";
    //point.subtitle = @"I'm here!!!";
    
    [self.mvMap addAnnotation:point];
    
    if(directionsDrawn==NO && userloc!=nil){
        
        MKPlacemark *destination = [[MKPlacemark alloc]initWithCoordinate:coord addressDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"",@"", nil] ];
        
        MKPlacemark *source = [[MKPlacemark alloc]initWithCoordinate:userloc.coordinate addressDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"",@"", nil] ];
        
        MKMapItem *federalTaphouse;
        federalTaphouse = [[MKMapItem alloc]initWithPlacemark:destination];
        
        MKMapItem *currentLocation =[[MKMapItem alloc]initWithPlacemark:source];
        
        MKDirectionsRequest *request = [[MKDirectionsRequest alloc]init];
        [request setSource:currentLocation];
        [request setDestination:federalTaphouse];
        [request setTransportType:MKDirectionsTransportTypeAutomobile];
        
        MKDirections *direction = [[MKDirections alloc]initWithRequest:request];
        
        [direction calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
            
            NSLog(@"response = %@",response);
            arrRoutes = [response routes];
            [arrRoutes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                
                MKRoute *rout = obj;
                
                MKPolyline *line = [rout polyline];
                [self.mvMap addOverlay:line];
                NSLog(@"Rout Name : %@",rout.name);
                NSLog(@"Total Distance (in Meters) :%f",rout.distance);
                
                NSArray *steps = [rout steps];
                
                NSLog(@"Total Steps : %d",[steps count]);
                
                [steps enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    NSLog(@"Rout Instruction : %@",[obj instructions]);
                    NSLog(@"Rout Distance : %f",[obj distance]);
                }];
            }];
        }];
        directionsDrawn = YES;
    }
}

- (MKOverlayView *)mapView:(MKMapView *)mapView rendererForOverlay:(id)overlay{
    MKPolylineRenderer *renderer =
    [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    renderer.strokeColor = [UIColor blueColor];
    renderer.lineWidth = 5.0;
    return renderer;
    
    
   /* if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolylineView* aView = [[MKPolylineView alloc]initWithPolyline:(MKPolyline*)overlay] ;
        //MKPolylineView* other = [[MKPolylineView allo]initw]
        aView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.5];
        aView.lineWidth = 10;
        return aView;
    }
    return nil;*/
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mvMap.delegate = (id)self;
    directionsDrawn = NO;
    [self drawMap];


    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString: @"toDirections"]){
        MKRoute *route;
        route = arrRoutes[0];
        
        [[segue destinationViewController] setValue:route.steps forKey:@"steps"];
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
