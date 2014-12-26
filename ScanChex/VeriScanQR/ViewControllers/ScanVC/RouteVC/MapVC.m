//
//  MapVC.m
//  VeriScanQR
//
//  Created by Adnan Ahmad on 24/12/2012.
//  Copyright (c) 2012 Adnan Ahmad. All rights reserved.
//

#import "MapVC.h"
#import "MyLocation.h"
#import "AddressesDTO.h"
#import "TicketDTO.h"
#import "VSSharedManager.h"
#import "RouteCell.h"
#import "TicketCell.h"
#import "VSLocationManager.h"
#import "RoutesViewController.h"

@interface MapVC ()

@property(nonatomic,assign) BOOL _doneInitialZoom;
@property(nonatomic,retain) NSArray *addresses;
@property (nonatomic,assign) BOOL isCurrentLocation;

- (void)initalizeMap;
- (void)plotLocationPositions;
- (void)updateGUI;
- (void)recenterMap;

@end

@implementation MapVC
@synthesize addresses=_addresses;
@synthesize tickets=_tickets;
@synthesize isCurrentLocation =_isCurrentLocation;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

+(id)initWithMap{
    
    if (IS_IPHONE5) {
        
        return [[[MapVC alloc] initWithNibName:@"MapiPhone5VC" bundle:nil] autorelease];

    }
    return [[[MapVC alloc] initWithNibName:@"MapVC" bundle:nil] autorelease];
}
+(id)initWithMap:(BOOL)isFull{

    return [[[MapVC alloc] initWithNibName:@"MapVCFullScreen" bundle:nil] autorelease];
}

#pragma mark- Life Cycle
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
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
     [self.view setBackgroundColor:[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"color"]]];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.isCurrentLocation= NO;
    [self updateGUI];
    [self initalizeMap];
    [self plotLocationPositions];
    
    
//    NSArray *coordinates = [self.mapView valueForKeyPath:@"annotations"];
//
//    
//    // Position the map so that all overlays and annotations are visible on screen.
//    MKMapRect regionToDisplay = [self mapRectForAnnotations:coordinates];    
//    if (!MKMapRectIsNull(regionToDisplay)) self.mapView.visibleMapRect = regionToDisplay;
//
    
    
    //[self plotLocationPositions];
}


- (void)dealloc {
    [_mapView release];
    [_routeTable release];
    [_totalCodes release];
    [_scannedCodes release];
    [_remainingCodes release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setMapView:nil];
    [self setRouteTable:nil];
    [self setTotalCodes:nil];
    [self setScannedCodes:nil];
    [self setRemainingCodes:nil];
    [super viewDidUnload];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark- Methods
-(void)updateGUI{
    
    self.mapView.showsUserLocation=YES;
    self.mapView.delegate=self;
    self.tickets=[NSArray arrayWithArray:[[VSSharedManager sharedManager] ticketInfo]];
//    [self currentLocationButtonPressed:nil];
    
}



- (void)plotLocationPositions{
    
    
    for (id<MKAnnotation> annotation in self.mapView.annotations) {
        [self.mapView removeAnnotation:annotation];
    }
    
    self.addresses=[NSArray arrayWithArray:[[VSSharedManager sharedManager] ticketInfo]];
    
    for (int i=0; i<[self.addresses count] ;i++) {
        
        TicketDTO*address=[self.addresses objectAtIndex:i];
        double  latitude = [address.latitude doubleValue];
        double  longitude = [address.longitude doubleValue];
        NSString * name1 =address.unEncryptedAssetID;
      
      NSArray *tickets = address.tickets;
      
      NSString *ticketstatus = [[tickets objectAtIndex:0] ticketStatus];
      NSString *pinColor=@"";
      
      if ( [ticketstatus isEqualToString:@"pending"]) {
        pinColor = @"blue";
      } else if ( [ticketstatus isEqualToString:@"complete"]) {
          pinColor = @"checkered";
      }else   if ( [ticketstatus isEqualToString:@"Assigned"]) {
            pinColor = @"green";
          }else {
            pinColor = @"red";
          }
      
        
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
        MyLocation *annotation = [[MyLocation alloc] initWithName:name1 address:addressLocation coordinate:coordinate  pincolor:pinColor];
        [self.mapView addAnnotation:annotation];
        
       
    }
    
    MyLocation *annotation = [[MyLocation alloc] initWithName:@"Current Location" address:@"" coordinate:[[[VSLocationManager sharedManager] currentLocation] coordinate] pincolor:@"green"] ;
    [self.mapView addAnnotation:annotation];
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
-(void)initalizeMap{
    
    
//    if ([self.addresses count]>0)
//    {
//        for (int i=0; i<[self.addresses count] ;i++) {
//
//        TicketDTO*address=[self.addresses objectAtIndex:i];
//        
//        // 1
//        CLLocationCoordinate2D zoomLocation;
//        zoomLocation.latitude = [address.latitude doubleValue];
//        zoomLocation.longitude= [address.longitude doubleValue];
//        
//        // 2
//        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
//        // 3
//        MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
//        // 4
//        [self.mapView setRegion:adjustedRegion animated:YES];
////            [self.mapView showAnnotations:<#(NSArray *)#> animated:<#(BOOL)#>]
//            
//        }
//    }
    
}


-(IBAction)backButtonPressed:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)currentLocationButtonPressed:(id)sender {
    
    self.isCurrentLocation=YES;
    
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.001;
    span.longitudeDelta = 0.001;
    CLLocationCoordinate2D location;
    location.latitude = self.mapView.userLocation.coordinate.latitude;
    location.longitude = self.mapView.userLocation.coordinate.longitude;
    region.span = span;
    region.center = location;
    [self.mapView setRegion:region animated:YES];
    
}

- (IBAction)zoomOutButtonPressed:(id)sender {
    
    [self recenterMap];
}

/**
 * Center the map on an area covering all annotations on the map.
 */
- (void)recenterMap {
    
    NSArray *coordinates = [self.mapView valueForKeyPath:@"annotations.coordinate"];
    // look for the minimum and maximum coordinate
    CLLocationCoordinate2D maxCoord = {-90.0f, -180.0f};
    CLLocationCoordinate2D minCoord = {90.0f, 180.0f};
    for(NSValue *value in coordinates) {
        CLLocationCoordinate2D coord = {0.0f, 0.0f};
        [value getValue:&coord];
        if(coord.longitude > maxCoord.longitude) {
            maxCoord.longitude = coord.longitude;
        }
        if(coord.latitude > maxCoord.latitude) {
            maxCoord.latitude = coord.latitude;
        }
        if(coord.longitude < minCoord.longitude) {
            minCoord.longitude = coord.longitude;
        }
        if(coord.latitude < minCoord.latitude) {
            minCoord.latitude = coord.latitude;
        }
    }
    // create a region
    MKCoordinateRegion region = {{0.0f, 0.0f}, {0.0f, 0.0f}};
    region.center.longitude = (minCoord.longitude + maxCoord.longitude) / 2.0;
    region.center.latitude = (minCoord.latitude + maxCoord.latitude) / 2.0;
    // calculate the span
    region.span.longitudeDelta = maxCoord.longitude - minCoord.longitude;
    region.span.latitudeDelta = maxCoord.latitude - minCoord.latitude;
    // center the map on that region
    [self.mapView setRegion:region animated:YES];
}


- (MKMapRect) mapRectForAnnotations:(NSArray*)annotationsArray
{
    MKMapRect mapRect = MKMapRectNull;
    
    //annotations is an array with all the annotations I want to display on the map
    for (id<MKAnnotation> annotation in annotationsArray) {
        
        MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
        MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0, 0);
        
        if (MKMapRectIsNull(mapRect))
        {
            mapRect = pointRect;
        } else
        {
            mapRect = MKMapRectUnion(mapRect, pointRect);
        }
    }
    
    return mapRect;
}

#pragma mark- MapView Delegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    static NSString *identifier = @"MyLocation";
    if ([annotation isKindOfClass:[MyLocation class]]) {
        
        MKAnnotationView *annotationView = (MKAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        } else {
            annotationView.annotation = annotation;
        }
        
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
      
      MyLocation *ann = (MyLocation *) annotation;
      
      if ( [ann.pinColor isEqualToString:@"green"] ) {
        annotationView.image=[UIImage imageNamed:@"fgreen_flag_32.png"];//here we use a nice image instead of the default pins
      } else if ( [ann.pinColor isEqualToString:@"checkered"] ) {
        annotationView.image=[UIImage imageNamed:@"checkered32.png"];//here we use a nice image instead of the default pins
        
      }
      else if ( [ann.pinColor isEqualToString:@"blue"] ) {
        annotationView.image=[UIImage imageNamed:@"fblue_flag_32.png"];//here we use a nice image instead of the default pins
      }
      else {
        annotationView.image=[UIImage imageNamed:@"fred_flag_32.png"];//here we use a nice image instead of the default pins
        
      }
    
        return annotationView;
    }
    
    return nil;
}
- (void)mapView:(MKMapView *)aMapView didUpdateUserLocation:(MKUserLocation *)aUserLocation {
 
    if (self.isCurrentLocation==YES) {
        
    
        MKCoordinateRegion region;
        MKCoordinateSpan span;
        span.latitudeDelta = 0.005;
        span.longitudeDelta = 0.005;
        CLLocationCoordinate2D location;
        location.latitude = aUserLocation.coordinate.latitude;
        location.longitude = aUserLocation.coordinate.longitude;
        region.span = span;
        region.center = location;
        [aMapView setRegion:region animated:YES];
    }
    
    
}


-(void)drawRoute:(CLLocationCoordinate2D) sourceCoordinates desitnation:(CLLocationCoordinate2D)destinationCoordinates{
    
    
    DLog(@"Draw Route");
    MKPlacemark *source = [[MKPlacemark alloc]initWithCoordinate:sourceCoordinates addressDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"",@"", nil] ];
    
    MKMapItem *srcMapItem = [[MKMapItem alloc]initWithPlacemark:source];
    [srcMapItem setName:@""];
    
    MKPlacemark *destination = [[MKPlacemark alloc]initWithCoordinate:destinationCoordinates addressDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"",@"", nil] ];
    
    MKMapItem *distMapItem = [[MKMapItem alloc]initWithPlacemark:destination];
    [distMapItem setName:@""];
    
    [self findDirectionsFrom:srcMapItem to:distMapItem];
}


- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    DLog(@"rendererForOverlay");

    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolyline *route = overlay;
        MKPolylineRenderer *routeRenderer = [[MKPolylineRenderer alloc] initWithPolyline:route];
        routeRenderer.strokeColor = [UIColor blueColor];
        return routeRenderer;
    }
    else return nil;
}


- (void)findDirectionsFrom:(MKMapItem *)source
                        to:(MKMapItem *)destination
{
    
    DLog(@"MKDirectionsRequest");

    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    request.source = source;
    request.destination = destination;
    request.requestsAlternateRoutes = YES;
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];

    [directions calculateDirectionsWithCompletionHandler:
     ^(MKDirectionsResponse *response, NSError *error) {
         if (error) {
             NSLog(@"Error is %@",error);
         } else {
             [self showDirections:response];
             
         }
     }];
}

//shows the routes on the mapView
- (void)showDirections:(MKDirectionsResponse *)response
{
    for (MKRoute *route in response.routes) {
        [_mapView addOverlay:route.polyline level:MKOverlayLevelAboveRoads];
    }
    
}



#pragma mark- TableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [self.tickets count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    TicketDTO *ticket=[self.tickets objectAtIndex:section];
    NSMutableArray *ticketsData=[NSMutableArray arrayWithArray:ticket.tickets];
    
    return [ticketsData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([self.tickets count]>0) {
        
        
        TicketCell *cell=[TicketCell resuableCellForTableView:self.routeTable withOwner:self];
        cell.indexPath=indexPath;
        [cell updateCellWithTicket:[self.tickets objectAtIndex:indexPath.section]];
       
        [cell.mapButton addTarget: self
                            action: @selector(accessoryButtonTapped:withEvent:)
                  forControlEvents: UIControlEventTouchUpInside];
        
//        [cell.scanButton addTarget: self
//                            action: @selector(accessoryButtonTapped:withEvent:)
//                  forControlEvents: UIControlEventTouchUpInside];
        
        cell.callButton.hidden = YES;
        cell.scanButton.hidden = YES;
        
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

- (void)accessoryButtonTapped: (UIControl *) button withEvent: (UIEvent *) event{
    
   
    NSIndexPath * indexPath = [self.routeTable indexPathForRowAtPoint: [[[event touchesForView: button] anyObject] locationInView: self.routeTable]];
    if ( indexPath == nil )
        return;
    
    
    self.isCurrentLocation=NO;

    [[VSSharedManager sharedManager] openMapWithLocation:[self.tickets objectAtIndex:indexPath.section]];

    
    /*
    RoutesViewController * tempRoute = [[RoutesViewController alloc] initWithNibName:@"RoutesViewController" bundle:[NSBundle mainBundle]];
    tempRoute.tickets = self.tickets;
    tempRoute.currentSelectedTicket = indexPath.row;
    tempRoute.currentSelectedSection = indexPath.section;
    [self.navigationController pushViewController:tempRoute animated:YES];
    */
//    TicketDTO *ticket=[self.tickets objectAtIndex:indexPath.section];
//    
//    
//    CLLocation *currentLocation = [[VSLocationManager sharedManager] currentLocation];
//
//    // 1
//    CLLocationCoordinate2D zoomLocation;
//    zoomLocation.latitude = [ticket.latitude doubleValue];
//    zoomLocation.longitude= [ticket.longitude doubleValue];
//    
//    
//    // 2
//    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 1.0*METERS_PER_MILE, 1.0*METERS_PER_MILE);
//    // 3
//    MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
//    // 4
//    [self.mapView setRegion:adjustedRegion animated:YES];
//
//    [self drawRoute:currentLocation.coordinate desitnation:zoomLocation];
}

@end
