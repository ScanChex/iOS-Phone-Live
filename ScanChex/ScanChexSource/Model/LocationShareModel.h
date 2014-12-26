//
//  LocationShareModel.h
//  Location
//
//  Created by Rick
//  Copyright (c) 2014 Location. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BackgroundTaskManager.h"
#import <CoreLocation/CoreLocation.h>

@interface LocationShareModel : NSObject

@property (nonatomic, retain) NSTimer *timer;
@property (nonatomic, retain) NSTimer * delay10Seconds;
@property (nonatomic, retain) BackgroundTaskManager * bgTask;
@property (nonatomic, retain) NSMutableArray *myLocationArray;

+(id)sharedModel;

@end
