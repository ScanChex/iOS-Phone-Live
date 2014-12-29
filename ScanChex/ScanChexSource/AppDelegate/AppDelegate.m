//
//  AppDelegate.m
//  VeriScanQR
//
//  Created by Adnan Ahmad on 12/12/2012.
//  Copyright (c) 2012 Adnan Ahmad. All rights reserved.
//

#import "AppDelegate.h"
#import "SplashVC.h"
#import "VSLocationManager.h"
#import "Flurry.h"
#import "MessageCentreVC.h"
#import "Constant.h"
#import "LoginVC.h"
#import "UIAlertView+Blocks.h"


#define MINUTES_TO_LOGOUT 10

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@implementation AppDelegate
@synthesize navController;

- (void)dealloc
{
    [navController release];
    [_window release];
    [_viewController release];
    [super dealloc];
}

+(id)sharedDelegate
{
    return [[UIApplication sharedApplication] delegate];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    

    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
    [[SharedManager getInstance] setIsMessage:FALSE];

 
    
    [[UIDevice currentDevice] setBatteryMonitoringEnabled:YES];
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"color"]) {
        NSData *colorData = [NSKeyedArchiver archivedDataWithRootObject:[UIColor blackColor]];
        [[NSUserDefaults standardUserDefaults] setObject:colorData forKey:@"color"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
   
    [Flurry setCrashReportingEnabled:YES];
    [Flurry setAppVersion:@"1.0"];
    [Flurry startSession:@"Z55KW4WFBHXS3FZ8DV6G"];
    
    self.viewController = [LoginVC initWithLogin];
    navController=[[UINavigationController alloc] initWithRootViewController:self.viewController];
    
    navController.navigationBarHidden=YES;
    navController.navigationBar.translucent = NO;
    self.window.rootViewController = navController;
    [self.window makeKeyAndVisible];
    UIFont *Boldfont = [UIFont boldSystemFontOfSize:10.0f];
    
    [[UILabel appearanceWhenContainedIn:[UITableViewHeaderFooterView class], nil] setFont:[UIFont boldSystemFontOfSize:11.0f]];
//    NSDictionary *attributes = [NSDictionary dictionaryWithObject:Boldfont forKey:UITextAttributeFont];
    [[UISegmentedControl appearance] setTitleTextAttributes:@{
                                                              NSFontAttributeName : Boldfont
                                                              } forState:UIControlStateNormal];
    
    //    [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@",deviceTK] forKey:@"apns_device_token"];

    DLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"apns_device_token"]);
    // Let the device know we want to receive push notifications

    //[[UIApplication sharedApplication] registerForRemoteNotificationTypes:
    // (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    

    [self performSelector:@selector(postPushNotificationIfNeeded) withObject:nil afterDelay:1.0];
    //Push Notification change for IOS 8
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    }

    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    //clear notifications
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    if (launchOptions != nil)
	{
		NSDictionary *dictionary = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
		if (dictionary != nil)
		{
            [[SharedManager getInstance] setIsMessage:TRUE];
			NSLog(@"Launched from push notification: %@", dictionary);
			
            ///Handle PushNotificaiton Thing here 
		}
	}
  
  // If application is launched due to  notification,present another view controller.
//  UILocalNotification *notification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
//  
//  if (notification)
//  {
//    LoginVC *loginViewController = [[LoginVC alloc]initWithNibName:NSStringFromClass([LoginVC class]) bundle:nil];
//    [self.window.rootViewController presentViewController:loginViewController animated:YES completion:nil];
//    
//  }
  
    #if TARGET_IPHONE_SIMULATOR
    [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@",@"na"] forKey:@"apns_device_token"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    #endif
    return YES;
  
  
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSString *deviceTK=[NSString stringWithFormat:@"%@",deviceToken];
    deviceTK=[deviceTK stringByReplacingOccurrencesOfString:@"<" withString:@""];
    deviceTK=[deviceTK stringByReplacingOccurrencesOfString:@">" withString:@""];
    deviceTK=[deviceTK stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSLog(@"deviceTk %@",deviceTK);
//    UIAlertView * tempAlert = [[UIAlertView alloc] initWithTitle:@"DeviceToken" message:deviceTK delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    [tempAlert show];
    
    [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@",deviceTK] forKey:@"apns_device_token"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

-(void)deniedPushNotificationAccessAlert{
    
    __block RIButtonItem *okItem = [RIButtonItem itemWithLabel:@"OK" action:^{
        
        if (![self checkForPushNotificationPermission]) {
            
            [self deniedPushNotificationAccessAlert];
        }
    }];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Go to settings-->Notifications-->Enable ScanChex Push notification" message:@"" cancelButtonItem:okItem otherButtonItems:nil];
    [alertView show];
    [alertView release];
}

-(BOOL)checkForPushNotificationPermission{

    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")){
        UIUserNotificationType* type = [[[UIApplication sharedApplication] currentUserNotificationSettings] types];
        if (type == UIUserNotificationTypeNone)
            return NO;
        else
            return YES;
    }
    else {
        UIRemoteNotificationType types = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        if (types == UIRemoteNotificationTypeNone)
            return NO;
        else
            return YES;
    }
}

-(void)postPushNotificationIfNeeded{

    BOOL isFirstLaunch = [[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"];
    if (!isFirstLaunch) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else{
        
        if (![self checkForPushNotificationPermission]) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:PushNotificationPermissionPopup object:nil];
            //[self deniedPushNotificationAccessAlert];
        }
    }


}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	NSLog(@"Failed to get token, error: %@", error);
    
    if (![self checkForPushNotificationPermission]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:PushNotificationPermissionPopup object:nil];

        //[self deniedPushNotificationAccessAlert];
    }
    //[self deniedPushNotificationAccessAlert];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    
    if (application.applicationState == UIApplicationStateInactive || application.applicationState == UIApplicationStateBackground) {
        //opened from a push notification when the app was on background
        [application setApplicationIconBadgeNumber:application.applicationIconBadgeNumber+1];
        [[SharedManager getInstance] setIsMessage:TRUE];
        
    }
    else if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        //opened from a push notification when the app was in foreground
        [application setApplicationIconBadgeNumber:0];
        [[SharedManager getInstance] setIsMessage:TRUE];
        [[NSNotificationCenter defaultCenter] postNotificationName:kPushReceived object:nil];
       
    }
    
    UIAlertView * tempAlert = [[[UIAlertView alloc]initWithTitle:@"New Message" message:@"Press OK to view message" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil] autorelease];
    [tempAlert setTag:-922];
    [tempAlert show];
    
//    UIAlertView *alert =[[[UIAlertView alloc] initWithTitle:@"PushNotification Works"
//                                                    message:[userInfo objectForKey:@"data"]
//                                                   delegate:nil
//                                          cancelButtonTitle:@"Ok"
//                                          otherButtonTitles:nil] autorelease];
//    [alert show];
   
        
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([alertView tag] == -922) {
        if (buttonIndex == 1) {
            [[SharedManager getInstance] setIsMessage:FALSE];
            
            UINavigationController * tempController = (UINavigationController*)self.window.rootViewController;
            if ([[tempController viewControllers] count]>2) {
                [tempController pushViewController:[MessageCentreVC initWithMessageCentre] animated:YES];
            }
            else {
                UIAlertView * tempAlert = [[[UIAlertView alloc]initWithTitle:@"Error" message:@"You must Login to view your messages" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
                [tempAlert setTag:-922];
                [tempAlert show];
            }
            
        }
        
    }
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    UIBackgroundTaskIdentifier myLongTask;
    
    myLongTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
    }];
  
  //Schedule local notification after 10 mins
 // NSDate *newDate = [[NSDate date] dateByAddingTimeInterval:10*60];
  //[self scheduleAlarmForDate:newDate];
    
     NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
    NSString *backGroundTime = [dateFormat stringFromDate:[NSDate date]];
    [[NSUserDefaults standardUserDefaults]setValue:backGroundTime forKey:@"backGroundTime"];
    [dateFormat release];
    NSLog(@"In applicationDidEnterBackground");

}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    [self postPushNotificationIfNeeded];

    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
    NSString *foreGroundTime = [dateFormat stringFromDate:[NSDate date]];
    [dateFormat release];
    
    NSString *backGroundTime = [[NSUserDefaults standardUserDefaults]valueForKey:@"backGroundTime"];
    int timeDifferenceInMinutes = [self minCalculation_backgroundtime:backGroundTime forgroundTime:foreGroundTime];
    
    if (timeDifferenceInMinutes >= MINUTES_TO_LOGOUT) {
        
        [self.navController popToRootViewControllerAnimated:YES];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:PDF_FILE_SHARE object:url];
    
//    NSFileManager *filemgr = [NSFileManager defaultManager];
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSString* inboxPath = [documentsDirectory stringByAppendingPathComponent:@"Inbox"];
//    NSArray *dirFiles = [filemgr contentsOfDirectoryAtPath:inboxPath error:nil];
//    
    return YES;
}

// Call this method to calculate the duration of inactivity
-(int)minCalculation_backgroundtime:(NSString *)backgroundTime forgroundTime:(NSString *)foreGroundTime
{
    NSDateFormatter *dateformat = [[NSDateFormatter alloc]init];
    [dateformat setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
    
    NSDate *lastDate = [dateformat dateFromString:foreGroundTime];
    NSDate *todaysDate = [dateformat dateFromString:backgroundTime];
    [dateformat release];
    NSTimeInterval lastDiff = [lastDate timeIntervalSinceNow];
    NSTimeInterval todaysDiff = [todaysDate timeIntervalSinceNow];
    NSTimeInterval dateDiff = lastDiff - todaysDiff;
    int min = dateDiff/60;
    
    return min;
}

- (void)scheduleAlarmForDate:(NSDate*)theDate
{
  UIApplication* app = [UIApplication sharedApplication];
  NSArray*    oldNotifications = [app scheduledLocalNotifications];
  
  // Clear out the old notification before scheduling a new one.
  if ([oldNotifications count] > 0)
    [app cancelAllLocalNotifications];
  
  // Create a new notification.
  UILocalNotification* alarm = [[UILocalNotification alloc] init];
  if (alarm)
  {
    alarm.fireDate = theDate;
    alarm.timeZone = [NSTimeZone defaultTimeZone];
    alarm.repeatInterval = 0;
    alarm.soundName = @"alarmsound.caf";
    alarm.alertBody = @"Please re-login";
    
    [app scheduleLocalNotification:alarm];
  }
}


@end
