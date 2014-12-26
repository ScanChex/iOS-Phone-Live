//
//  BackgroundTaskManager.h
//
//  Created by Puru Shukla on 20/02/13.
//  Copyright (c) 2013 Puru Shukla. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BackgroundTaskManager : NSObject
@property (nonatomic, strong)NSMutableArray* bgTaskIdList;

+(instancetype)sharedBackgroundTaskManager;

-(UIBackgroundTaskIdentifier)beginNewBackgroundTask;

@end
