//
//  VSLocationManager.h
//  VeriScanQR
//
//  Created by Adnan Ahmad on 23/12/2012.
//  Copyright (c) 2012 Adnan Ahmad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "BackgroundTaskManager.h"

@interface VSLocationManager : NSObject<CLLocationManagerDelegate>


@property (nonatomic, retain)CLLocation *lastKnownLocation;
@property (nonatomic,retain)NSString * assetID;
@property (nonatomic,retain) BackgroundTaskManager * bgTask;
@property (nonatomic,assign) BOOL isFirstLaunch;


+(id)sharedManager;
-(void)startListening;
-(void)stopListening;
-(CLLocation *)currentLocation;

///Threading//
- (void)startUpdating;
- (void)stopUpdating;
- (void)startListeningWithSignificantChanges;
- (void)stopListeningWithSignificationChanges;
- (void)requestUpdates;
- (void)checkForLocationStatus;

@end
