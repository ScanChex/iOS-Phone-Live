//
//  MapVC.h
//  VeriScanQR
//
//  Created by Adnan Ahmad on 24/12/2012.
//  Copyright (c) 2012 Adnan Ahmad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapVC : UIViewController<MKMapViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (retain, nonatomic) IBOutlet MKMapView *mapView;
@property (retain, nonatomic) IBOutlet UITableView *routeTable;
@property (retain, nonatomic) IBOutlet UILabel *totalCodes;
@property (retain, nonatomic) IBOutlet UILabel *scannedCodes;
@property (retain, nonatomic) IBOutlet UILabel *remainingCodes;
@property (nonatomic,retain) NSArray *tickets;

- (IBAction)backButtonPressed:(id)sender;
- (IBAction)currentLocationButtonPressed:(id)sender;
- (IBAction)zoomOutButtonPressed:(id)sender;

+(id)initWithMap:(BOOL)isFull;
+(id)initWithMap;
@end
