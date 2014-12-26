//
//  RoutesViewController.m
//  VeriScanQR
//
//  Created by Rajeel Amjad on 24/04/2014.
//  Copyright (c) 2014 Adnan Ahmad. All rights reserved.
//

#import "RoutesViewController.h"
#import "TicketCell.h"
#import "MyLocation.h"
#import "VSLocationManager.h"
#import "TicketDTO.h"
@interface RoutesViewController () <MKMapViewDelegate> {
    MKPolyline *_routeOverlay;
    MKRoute *_currentRoute;
}
@end


@implementation RoutesViewController

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
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)])
    {
        [self setNeedsStatusBarAppearanceUpdate];
    }
    //    [self setNeedsStatusBarAppearanceUpdate];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
    self.edgesForExtendedLayout = UIRectEdgeNone;
    if( [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f ) {
        
        float statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
        for( UIView *v in [self.view subviews] ) {
            CGRect rect = v.frame;
            rect.origin.y += statusBarHeight;
            //            rect.size.height -= statusBarHeight;
            v.frame = rect;
        }
        //        CGRect frame = self.view.frame;
        //        frame.size.height = frame.size.height-statusBarHeight;
        //        frame.origin.y = frame.origin.y+statusBarHeight;
        //        self.view.frame =frame;
    }
    [super viewDidLoad];
    [self plotLocationPositions];
    [self drawRoute];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)backButtonPressed:(id)sender{
    if (self.isDirectionsShowing) {
        self.isDirectionsShowing = FALSE;
        [self.directionsView setHidden:YES];
        [self.mapView setHidden:NO];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark- TableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([self.tickets count]>0) {
        
        
        TicketCell *cell=[TicketCell resuableCellForTableView:self.routeTable withOwner:self];
        cell.indexPath=indexPath;
        [cell updateCellWithTicket:[self.tickets objectAtIndex:self.currentSelectedSection] index:self.currentSelectedTicket];
        [cell. mapButton addTarget:self action:@selector(showDirections) forControlEvents:UIControlEventTouchUpInside];
        [cell.mapButton setImage:[UIImage imageNamed:@"map_edit"] forState:UIControlStateNormal];
//        [cell.mapButton addTarget: self
//                           action: @selector(accessoryButtonTapped:withEvent:)
//                 forControlEvents: UIControlEventTouchUpInside];
//        
        //        [cell.scanButton addTarget: self
        //                            action: @selector(accessoryButtonTapped:withEvent:)
        //                  forControlEvents: UIControlEventTouchUpInside];
        
        cell.callButton.hidden = YES;
        cell.scanButton.hidden = YES;
//        cell.mapButton.hidden = YES;
        
        return cell;
    }else{
        
        static NSString *kCellIdentifier = @"MyIdentifier";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
        if (cell == nil)
        {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier] autorelease];
        }
        
        cell.textLabel.text = @"No ticket found";
        cell.textLabel.textColor=[UIColor whiteColor];
        return cell;
    }
    
    return nil;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
}
-(void)drawRoute {
    // We're working
   
    
    // Make a directions request
    MKDirectionsRequest *directionsRequest = [MKDirectionsRequest new];
    // Start at our current location
    MKMapItem *source = [MKMapItem mapItemForCurrentLocation];
    [directionsRequest setSource:source];
    // Make the destination
//    CLLocationCoordinate2D destinationCoords = CLLocationCoordinate2DMake(38.8977, -77.0365);
    TicketDTO*address=[self.tickets objectAtIndex:self.currentSelectedSection];
    
    // 1
    CLLocationCoordinate2D destinationCoords;
    destinationCoords.latitude = [address.latitude doubleValue];
    destinationCoords.longitude= [address.longitude doubleValue];
//    CLLocationCoordinate2D destinationCoords = CLLocationCoordinate2DMake(38.8977, -77.0365);
    MKPlacemark *destinationPlacemark = [[MKPlacemark alloc] initWithCoordinate:destinationCoords addressDictionary:nil];
    MKMapItem *destination = [[MKMapItem alloc] initWithPlacemark:destinationPlacemark];
    [directionsRequest setDestination:destination];
    
    MKDirections *directions = [[MKDirections alloc] initWithRequest:directionsRequest];
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        // We're done
        
        
        // Now handle the result
        if (error) {
            NSLog(@"There was an error getting your directions");
            return;
        }
        
        // So there wasn't an error - let's plot those routes
         _currentRoute = [response.routes firstObject];
        self.routeDirection = [response.routes firstObject];
        [self plotRouteOnMap:_currentRoute];
    }];
}
#pragma mark - Utility Methods
- (void)plotRouteOnMap:(MKRoute *)route
{
    if(_routeOverlay) {
        [self.mapView removeOverlay:_routeOverlay];
    }
    
    // Update the ivar
    _routeOverlay = route.polyline;
    
    // Add it to the map
    [self.mapView addOverlay:_routeOverlay];
    
}


#pragma mark - MKMapViewDelegate methods
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
    renderer.strokeColor = [UIColor blueColor];
    renderer.lineWidth = 4.0;
    return  renderer;
}

-(void)showDirections {
    [self MakeDirections:self.routeDirection];
}
-(void)MakeDirections:(MKRoute*)route {
    NSString * stepString = @"";
//    MKRoute * route = [_currentRoute mutableCopy];
//    NSArray * temp = route.steps;
    for (int i = 0; i<[route.steps count]; i++) {
        MKRouteStep *routeStep = [_currentRoute.steps objectAtIndex:i];
        stepString = [NSString stringWithFormat:@"%@ \n %d. %@",stepString,i+1,routeStep.instructions];
    }
    self.isDirectionsShowing = TRUE;
    [self.mapView setHidden:YES];
    [self.directionsView setHidden:NO];
    [self.directionsView setText:stepString];
}

- (void)plotLocationPositions{
    
    
    for (id<MKAnnotation> annotation in self.mapView.annotations) {
        [self.mapView removeAnnotation:annotation];
    }
    
//    self.addresses=[NSArray arrayWithArray:[[VSSharedManager sharedManager] ticketInfo]];
    
//    for (int i=0; i<[self.tickets count] ;i++) {
    
        TicketDTO*address=[self.tickets objectAtIndex:self.currentSelectedSection];
        double  latitude = [address.latitude doubleValue];
        double  longitude = [address.longitude doubleValue];
        NSString * name1 =address.unEncryptedAssetID;
        
        
        if ([name1 isKindOfClass:[NSNull class]]) {
            
            name1=@"Undefined";
        }
        
        TicketAddressDTO *address1 =address.address1;
        TicketAddressDTO *address2 =address.address2;
        
        NSString * addressLocation =[NSString stringWithFormat:@"%@ \n%@, %@ %@ \n",address1.street,address1.city,address1.state,address1.postalCode];
        
        if (address2) {
            
            addressLocation=[addressLocation stringByAppendingString:[NSString stringWithFormat:@"%@ \n%@, %@ %@ \n",address2.street,address2.city,address2.state,address2.postalCode]];
        }
        
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = latitude;
        coordinate.longitude = longitude;
        MyLocation *annotation = [[MyLocation alloc] initWithName:name1 address:addressLocation coordinate:coordinate] ;
        [self.mapView addAnnotation:annotation];
        
        
//    }
    
    MyLocation *annotation1 = [[MyLocation alloc] initWithName:@"Current Location" address:@"" coordinate:[[[VSLocationManager sharedManager] currentLocation] coordinate]] ;
    [self.mapView addAnnotation:annotation1];
    //    MKMapRect zoomRect = MKMapRectNull;
    //    MKMapPoint annotationPoint = MKMapPointForCoordinate(self.mapView.userLocation.coordinate);
    //    MKMapRect zoomRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.1, 0.1);
    //    for (id <MKAnnotation> annotation in self.mapView.annotations)
    //    {
    //        MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
    //        MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.1, 0.1);
    //        zoomRect = MKMapRectUnion(zoomRect, pointRect);
    //    }
    //    [self.mapView setVisibleMapRect:zoomRect animated:YES];
    [self.mapView showAnnotations:self.mapView.annotations animated:YES];
    
    
    
}
#pragma mark- MapView Delegate
//Different image for map pins
//http://stackoverflow.com/questions/14999128/shows-different-pin-images-in-mkmapview?rq=1

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    static NSString *identifier = @"MyLocation";
    if ([annotation isKindOfClass:[MyLocation class]]) {
        
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        } else {
            annotationView.annotation = annotation;
        }
        
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
        annotationView.image=[UIImage imageNamed:@"fgreen_flag_32.png"];//here we use a nice image instead of the default pins
        
        return annotationView;
    }
    
    return nil;
}
@end
