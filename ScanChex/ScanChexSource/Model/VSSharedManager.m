//
//  VSSharedManager.m
//  VeriScanQR
//
//  Created by Adnan Ahmad on 16/12/2012.
//  Copyright (c) 2012 Adnan Ahmad. All rights reserved.
//

#import "VSSharedManager.h"
#import <MapKit/MapKit.h>
#import "VSLocationManager.h"

@implementation VSSharedManager

@synthesize currentUser=_currentUser;
@synthesize ticketInfo=_ticketInfo;
@synthesize selectedTicket=_selectedTicket;
@synthesize selectedTicketInfo=_selectedTicketInfo;
@synthesize userName=_userName;
@synthesize historyID=_historyID;
@synthesize CurrentSelectedSection = _CurrentSelectedSection;
@synthesize CurrentSelectedIndex = _CurrentSelectedIndex;

static VSSharedManager *sharedInstance;

+(id)sharedManager{
    
    if(sharedInstance==nil){
        
        sharedInstance= [[VSSharedManager alloc] init];
        
        
    }
    return sharedInstance;
}

-(void)openMapWithLocation:(TicketDTO *)address
{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
 
        //location is valid -> navigate
        CLLocationCoordinate2D start = [[[VSLocationManager sharedManager] currentLocation] coordinate];
        CLLocationCoordinate2D end = CLLocationCoordinate2DMake([address.latitude doubleValue], [address.longitude doubleValue]);
        
        //create class object
        Class mapItemClass = [MKMapItem class];
        
        //check ios6, check if response to selector
        if (mapItemClass && [mapItemClass respondsToSelector:@selector(openMapsWithItems:launchOptions:)])
        {
            /** create end location **/
            //Creates the coordinates for navigation
            CLLocationCoordinate2D coordinate_end = CLLocationCoordinate2DMake(end.latitude, end.longitude);
            
            //Creates placemark into map
            MKPlacemark *placemark_end = [[[MKPlacemark alloc] initWithCoordinate:coordinate_end
                                                               addressDictionary:nil] autorelease];
            
            //And finaly create map Item into map
            MKMapItem *mapItem_end = [[[MKMapItem alloc] initWithPlacemark:placemark_end] autorelease];
            
            //You can name the object
            [mapItem_end setName:address.unEncryptedAssetID];
            
            
            /** create start location **/
            //this is exactly the same as the previous case
            //create coordinates
            CLLocationCoordinate2D coordinate_start = CLLocationCoordinate2DMake(start.latitude, start.longitude);
            //create placemark
            MKPlacemark *placemark_srart = [[[MKPlacemark alloc] initWithCoordinate:coordinate_start addressDictionary:nil] autorelease];
            //create map item
            MKMapItem *mapItem_start = [[[MKMapItem alloc] initWithPlacemark:placemark_srart] autorelease];
            //named nam item
            [mapItem_start setName:@"Current Location"];
            
            //Or create map item with current location
            //MKMapItem *currentLocationMapItem = [MKMapItem mapItemForCurrentLocation];
            
            // Set the directions mode
            //NSString * const MKLaunchOptionsDirectionsModeDriving;
            //NSString * const MKLaunchOptionsDirectionsModeWalking;
            NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving};
            
            //open native maps
            [MKMapItem openMapsWithItems:@[mapItem_start, mapItem_end]
                           launchOptions:launchOptions];
            
            
            
            
            //or navigate from current location
            //        [MKMapItem openMapsWithItems:@[currentLocationMapItem, mapItem_end] launchOptions:launchOptions];
        }else{
            //create url with start and end coordinates
            NSURL *url = [[[NSURL alloc] initWithString: [NSString stringWithFormat:@"http://maps.google.com/maps?saddr=%1.6f,%1.6f&daddr=%1.6f,%1.6f",
                                                          start.latitude, start.longitude, end.latitude, end.longitude]] autorelease];
            
            //open google maps in safari
            [[UIApplication sharedApplication] openURL:url];
        }
        

    });
   
}

@end
