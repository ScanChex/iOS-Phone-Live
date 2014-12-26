//
//  AppDelegate.h
//  VeriScanQR
//
//  Created by Adnan Ahmad on 12/12/2012.
//  Copyright (c) 2012 Adnan Ahmad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SharedManager.h"
#import "IQKeyboardManager.h"
@class SplashVC;

@interface AppDelegate : UIResponder <UIApplicationDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) SplashVC *viewController;
@property (strong, nonatomic) UINavigationController *navController;

+(id)sharedDelegate;
@end
