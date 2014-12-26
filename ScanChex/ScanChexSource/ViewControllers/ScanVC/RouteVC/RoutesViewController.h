//
//  RoutesViewController.h
//  VeriScanQR
//
//  Created by Rajeel Amjad on 24/04/2014.
//  Copyright (c) 2014 Adnan Ahmad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@interface RoutesViewController : UIViewController<MKMapViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (retain, nonatomic) IBOutlet MKMapView *mapView;
@property (retain, nonatomic) IBOutlet UITableView *routeTable;
@property (nonatomic, assign) NSInteger currentSelectedTicket;
@property (nonatomic, assign) NSInteger currentSelectedSection;
@property (nonatomic,retain) NSArray *tickets;
@property (assign) BOOL isDirectionsShowing;
@property (nonatomic, retain) IBOutlet UITextView * directionsView;
@property (nonatomic, retain) MKRoute* routeDirection;

- (IBAction)backButtonPressed:(id)sender;
-(void)drawRoute;
- (void)plotRouteOnMap:(MKRoute *)route;
-(void)showDirections;
-(void)MakeDirections:(MKRoute*)route;
- (void)plotLocationPositions;
@end
