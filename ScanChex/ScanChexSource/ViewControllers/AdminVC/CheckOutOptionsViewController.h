//
//  CheckOutOptionsViewController.h
//  ScanChex
//
//  Created by Rajeel Amjad on 26/07/2014.
//  Copyright (c) 2014 Adnan Ahmad. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckOutOptionsViewController : UIViewController
+(id)initCheckOutOptions;
- (IBAction)backButtonPressed:(id)sender;
- (IBAction)scanCode:(id)sender;
- (IBAction)manualLookUp:(id)sender;
- (IBAction)checkedOutToday:(id)sender;
@end
