//
//  SplashVC.h
//  VeriScanQR
//
//  Created by Adnan Ahmad on 10/02/2013.
//  Copyright (c) 2013 Adnan Ahmad. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SplashVC : UIViewController

@property (retain, nonatomic) IBOutlet UIView *iPhone5Splash;
@property (retain, nonatomic) IBOutlet UILabel * versionNumberLabel;

+(id) initWithSplash;
- (IBAction)loginButtonPressed:(id)sender;
- (IBAction)aboutUsButtonPressed:(id)sender;
- (IBAction)privacyButtonPressed:(id)sender;
- (IBAction)termsButtonPressed:(id)sender;
- (IBAction)contactUSButtonPressed:(id)sender;
@end
