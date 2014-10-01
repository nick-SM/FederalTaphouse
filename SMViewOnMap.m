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
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnDirections;

@end

@implementation SMViewOnMap{
    MKUserLocation *userloc;
    BOOL directionsDrawn;
    NSArray *arrRoutes;
    CLLocationManager *manager;
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

    [self drawMap];

}

-(void) clearLine{
    [self.mvMap removeOverlays:self.mvMap.overlays];
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
        locationSpan.latitudeDelta =1.3*fabs(userloc.coordinate.latitude - FTlat);
        locationSpan.longitudeDelta =1.3*fabs(userloc.coordinate.longitude  -FTlong);

        CLLocationCoordinate2D locationCenter;
        locationCenter.latitude = (FTlat + userloc.coordinate.latitude) / 2;
        locationCenter.longitude = (FTlong + userloc.coordinate.longitude) / 2;
        region = MKCoordinateRegionMake(locationCenter, locationSpan);
    }
    [self.mvMap setRegion:[self.mvMap regionThatFits:region] animated:YES];
    
    
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    
    point.coordinate = coord;
    point.title = @"Federal Taphouse";
    
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
            //if(self.sLocationChanged.enabled == YES){
            [self.btnDrawRouteCollection[0] setHidden:NO];
            [self.btnDrawRouteCollection[1] setHidden:NO];
            self.btnDirections.enabled = true;
            //}
            [arrRoutes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                
                MKRoute *rout = obj;
                
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
    //MKPolylineView *view2;
    //MKOverlayView *view;
    renderer.strokeColor = [UIColor blueColor];
    renderer.lineWidth = 5.0;
    
    //view
    return (MKOverlayView *)renderer;
    
    
   /* if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolylineView* aView = [[MKPolylineView alloc]initWithPolyline:(MKPolyline*)overlay] ;
        //MKPolylineView* other = [[MKPolylineView allo]initw]
        aView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.5];
        aView.lineWidth = 10;
        return aView;
    }
    return nil;*/
}

- (void)viewDidLoad{
    [super viewDidLoad];
    manager = [[CLLocationManager alloc]init];
    
    @try {
        [manager requestWhenInUseAuthorization];

    }
    @catch (NSException *exception) {
    }
    @finally {
    }
    self.btnDirections.enabled = false;
    //self.mvMap.showsUserLocation = YES;
    self.mvMap.delegate = (id)self;
    directionsDrawn = NO;
    [self.btnDrawRouteCollection[0] setHidden:YES];
    [self.btnDrawRouteCollection[1] setHidden:YES];
    //self.mvMap.autoresizingMask = self.view.autoresizingMask;
    [self drawMap];


    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
  //   Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    //[self clearLine];
    //[self.sLocationChanged setOn:NO];
    //self.mvMap.showsUserLocation = NO;
    if([segue.identifier isEqualToString: @"toDirections"]){
        if(arrRoutes!=nil){
            MKRoute *route;
            route = arrRoutes[0];
            
            [[segue destinationViewController] setValue:route.steps forKey:@"steps"];
        }
        else{

        }
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

/*- (IBAction)changeLocationPresser:(UISwitch *)sender {
    if(sender.isOn == NO){
        //[manager requestWhenInUseAuthorization];
        [self clearLine];
        self.mvMap.showsUserLocation = NO;
        [self.btnDrawRouteCollection[0] setHidden:YES];
        [self.btnDrawRouteCollection[1] setHidden:YES];
    }
    else{
        self.mvMap.showsUserLocation = YES;
        //[self.btnDrawRouteCollection[0] setHidden:NO];
        //[self.btnDrawRouteCollection[1] setHidden:NO];
    }
}*/
- (IBAction)getDirections:(id)sender {
    if(arrRoutes!=nil){
        [self performSegueWithIdentifier:@"toDirections" sender:nil];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Location not Found" message:@"Please enable location services and press 'Display User Location' switch to view directions" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)drawRoute:(id)sender {
    if(arrRoutes!=nil){
        [self clearLine];
        MKPolyline *line =[arrRoutes[0] polyline];
        [self.mvMap addOverlay:line];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Location not Found" message:@"Please enable location services and wait for the location to update" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}
- (IBAction)clearRoute:(id)sender {
    [self clearLine];
}
@end
