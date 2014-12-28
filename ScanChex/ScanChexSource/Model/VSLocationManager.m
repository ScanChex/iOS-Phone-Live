//
//  VSLocationManager.m
//  VeriScanQR
//
//  Created by Adnan Ahmad on 23/12/2012.
//  Copyright (c) 2012 Adnan Ahmad. All rights reserved.
//

#import "VSLocationManager.h"
#import "WebServiceManager.h"
#import "UserDTO.h"
#import "VSSharedManager.h"
#import "Constant.h"
#import <sys/utsname.h>
#import "UIAlertView+Blocks.h"


#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)


@interface VSLocationManager()

@property (nonatomic, retain)CLLocationManager *manager;
//Threading//
@property (nonatomic) BOOL updaterStopped;
@property (nonatomic, retain) NSThread *updaterThread;

@end
@implementation VSLocationManager

@synthesize lastKnownLocation;
@synthesize manager;
@synthesize assetID=_assetID;

int locationUpdateInterval = 300;//5 mins

static VSLocationManager *sharedInstance;


+(id)sharedManager{
    
    if(sharedInstance==nil)
    {
        
        sharedInstance= [[VSLocationManager alloc] init];
        
    }
    
    return sharedInstance;
    
}

-(void)startListening{
    
    if(!self.manager)
    {
        self.manager= [[[CLLocationManager alloc] init] autorelease];
    
        [self checkForLocationStatus];
        self.manager.delegate=self;
        self.assetID=[[[NSString alloc] initWithString:@"0"] autorelease];
        //Set some parameters for the location object.
        [self.manager setDistanceFilter:kCLDistanceFilterNone];
        [self.manager setDesiredAccuracy:kCLLocationAccuracyBest];
        [self.manager setHeadingFilter:kCLHeadingFilterNone];
        [self.manager setHeadingOrientation:CLDeviceOrientationUnknown];
    }
   
  
    if (([[[UIDevice currentDevice] systemVersion] floatValue]>=6.0)) {
        
        [self.manager setPausesLocationUpdatesAutomatically:NO];
    }
  
  SEL requestSelector = NSSelectorFromString(@"requestWhenInUseAuthorization");
  if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined &&
      [self.manager respondsToSelector:requestSelector]) {
    //((void (*)(id, SEL))[self.manager methodForSelector:requestSelector])(self.manager, requestSelector);
      
      [[UIApplication sharedApplication] sendAction:@selector(requestWhenInUseAuthorization)
                                                 to:self.manager
                                               from:self
                                           forEvent:nil];

    [self.manager startUpdatingHeading];
    [self.manager startUpdatingLocation];
  } else {
    [self.manager startUpdatingHeading];
    [self.manager startUpdatingLocation];
  }
    //[self.manager startUpdatingHeading];
    //[self.manager startUpdatingLocation];
    
}

//////For Signification Location Updation////

-(void)startListeningWithSignificantChanges{
    
    if(!self.manager){
        
        self.manager= [[[CLLocationManager alloc] init] autorelease];
        self.manager.delegate=self;
        //Set some parameters for the location object.
        [self.manager setDistanceFilter:kCLDistanceFilterNone];
        [self.manager setDesiredAccuracy:kCLLocationAccuracyBest];
        
        if (([[[UIDevice currentDevice] systemVersion] floatValue]>=6.0)) {
            
            [self.manager setPausesLocationUpdatesAutomatically:NO];
        }
        
    }
    [self.manager startMonitoringSignificantLocationChanges];
}

-(void)stopListeningWithSignificationChanges{
    
    [self.manager stopMonitoringSignificantLocationChanges];
}

-(void)stopListening{
    
    [self.manager stopUpdatingHeading];
    [self.manager stopUpdatingLocation];
    
}


-(CLLocation *)currentLocation{
    
    if(!self.lastKnownLocation){
        
        self.lastKnownLocation = [self.manager location];
    }
    
    return self.lastKnownLocation;
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation;
{
    
    self.lastKnownLocation = newLocation;
    
    NSDate *newLocationTimestamp = newLocation.timestamp;
    NSDate *lastLocationUpdateTiemstamp;
    
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.bgTask = [BackgroundTaskManager sharedBackgroundTaskManager];
    [self.bgTask beginNewBackgroundTask];
    if (userDefaults) {
        
        lastLocationUpdateTiemstamp = [userDefaults objectForKey:kLastLocationUpdateTimestamp];
        
        if (!([newLocationTimestamp timeIntervalSinceDate:lastLocationUpdateTiemstamp] < locationUpdateInterval)) {
            //NSLog(@"New Location: %@", newLocation);
            

            [self performSelector:@selector(updateLocationToServer) withObject:nil];
            [userDefaults setObject:newLocationTimestamp forKey:kLastLocationUpdateTimestamp];
            [userDefaults synchronize];
        }
    }
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    self.lastKnownLocation = [locations lastObject];
    
    NSDate *newLocationTimestamp = self.lastKnownLocation.timestamp;
    NSDate *lastLocationUpdateTiemstamp;
    
    self.bgTask = [BackgroundTaskManager sharedBackgroundTaskManager];
    [self.bgTask beginNewBackgroundTask];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (userDefaults) {
        
        lastLocationUpdateTiemstamp = [userDefaults objectForKey:kLastLocationUpdateTimestamp];
        
        if (!([newLocationTimestamp timeIntervalSinceDate:lastLocationUpdateTiemstamp] < locationUpdateInterval)) {
            
            [self performSelector:@selector(updateLocationToServer) withObject:nil];
            [userDefaults setObject:newLocationTimestamp forKey:kLastLocationUpdateTimestamp];
            [userDefaults synchronize];
        }
    }

    
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    /*
     The delegate function will be called when the permission status changes the application should then attempt to handle the change appropriately by changing UI or setting up or tearing down data structures.
     */
    
    if (self.isFirstLaunch) {
        self.isFirstLaunch = NO;
        return;
    }
    
    if(status == kCLAuthorizationStatusNotDetermined) {
        
        [self deniedLocationAccessAlert];
    }
    else if(status == kCLAuthorizationStatusRestricted) {
        [self deniedLocationAccessAlert];
    }
    else if(status == kCLAuthorizationStatusDenied) {
        [self deniedLocationAccessAlert];
    }
    else if(status == kCLAuthorizationStatusAuthorizedAlways) {
        
        
    }
}

-(void)checkForLocationStatus{

    if (!self.isFirstLaunch) {
     
        if (![CLLocationManager locationServicesEnabled]) {
            
            [self deniedLocationAccessAlert];
        }
    }
}

-(void)deniedLocationAccessAlert{
    
    __block RIButtonItem *okItem = [RIButtonItem itemWithLabel:@"OK" action:^{
        
        switch ([CLLocationManager authorizationStatus]) {
            case kCLAuthorizationStatusNotDetermined:
                [self deniedLocationAccessAlert];
                break;
            case kCLAuthorizationStatusRestricted:
                [self deniedLocationAccessAlert];
                break;
            case kCLAuthorizationStatusDenied:
                [self deniedLocationAccessAlert];
                break;
        
            default:
                break;
        }
        
    }];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Go to settings-->Privcay-->Location Settings-->Enable ScanChex location settings" message:@"" cancelButtonItem:okItem otherButtonItems:nil];
    [alertView show];
    
}


-(void)applicationEnterBackground{
//    CLLocationManager *locationManager = [LocationTracker sharedLocationManager];
//    locationManager.delegate = self;
//    locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
//    locationManager.distanceFilter = kCLDistanceFilterNone;
//    [locationManager startUpdatingLocation];
  
  
  CLLocationManager *locationManager = [VSLocationManager sharedManager];
  locationManager.delegate = self;
  locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
  locationManager.distanceFilter = kCLDistanceFilterNone;
  
  if(IS_OS_8_OR_LATER) {
    [locationManager requestAlwaysAuthorization];
  }
  [locationManager startUpdatingLocation];
  
    //Use the BackgroundTaskManager to manage all the background Task
    self.bgTask = [BackgroundTaskManager sharedBackgroundTaskManager];
    [self.bgTask beginNewBackgroundTask];
}


-(void)updateLocationToServer{

    
    CLLocation *lasKnownLocation= self.lastKnownLocation;
    UserDTO *user=[[VSSharedManager sharedManager] currentUser];
    
   
    NSString * deviceTokenString  =[[NSUserDefaults standardUserDefaults] objectForKey:@"apns_device_token"];

    [[WebServiceManager sharedManager] updateLocation:[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"]
                                            masterKey:[NSString stringWithFormat:@"%d", user.masterKey]
                                              assetId:self.assetID
                                           deviceMake:@"Apple"
                                          deviceModel:machineName()
                                             deviceOS:[[UIDevice currentDevice] systemVersion]
                                             deviceID:deviceTokenString//[[[UIDevice currentDevice] identifierForVendor] UUIDString]
                                             latitude:[NSString stringWithFormat:@"%.7f",lasKnownLocation.coordinate.latitude]
                                            longitude:[NSString stringWithFormat:@"%.7f",lasKnownLocation.coordinate.longitude]
                                                speed:[NSString stringWithFormat:@"%.2f",lasKnownLocation.speed]
                                        batteryStatus:[NSString stringWithFormat:@"%.2f",[[UIDevice currentDevice] batteryLevel]]
                                withCompletionHandler:^(id data, BOOL error){
                                            
                                                if (!error) {
                                                    
                                                    DLog(@"%@",@"Location Updated");
                                                }else{
                                                    
                                                    DLog(@"%@",@"Failed");
                                                }

                                            }];

}



- (void)startUpdating{
    
    /*if already running*/
    if(!self.updaterStopped){
        [self.updaterThread cancel];
    }
    
    
    self.updaterStopped=NO;
    self.updaterThread= [[NSThread alloc] initWithTarget:self selector:@selector(updateLocation) object:nil];
    [self.updaterThread start];
    
    
    
}
- (void)stopUpdating{
    
    self.updaterStopped=YES;
    [self.updaterThread cancel];
    
}


- (void)requestUpdates{
    
    [self stopUpdating];
    [self startUpdating];
    
}

- (void)updateLocation{
    
    
    @autoreleasepool {
        
       
        [self startListening];
        
        //wait here
        [NSThread sleepForTimeInterval:kUPDATE_INTERVAL];
        
        
        //check if we have been stoped
        if([[NSThread currentThread] isCancelled] || self.updaterStopped){
            return ;
        }
        
        //else spawn again
        [self startUpdating];
        
    }
    
}

NSString* machineName()
{
    struct utsname systemInfo;
    uname(&systemInfo);
    
    return [NSString stringWithCString:systemInfo.machine
                              encoding:NSUTF8StringEncoding];
}

-(void)dealloc{
    
   // DLog(@"%@ dealloced", NSStringFromClass([self class]));
    [manager release];
    [lastKnownLocation release];
    [super dealloc];
}

@end
