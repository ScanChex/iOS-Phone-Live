//
//  CheckInCheckOutViewController.h
//  ScanChex
//
//  Created by Rajeel Amjad on 26/07/2014.
//  Copyright (c) 2014 Adnan Ahmad. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckInCheckOutViewController : UIViewController

+(id)initCheckInOutVC;

- (IBAction)backButtonPressed:(id)sender;
-(IBAction)checkOut:(id)sender;
-(IBAction)checkIn:(id)sender;


@end
