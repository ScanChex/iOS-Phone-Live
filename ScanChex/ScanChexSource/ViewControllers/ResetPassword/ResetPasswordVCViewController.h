//
//  ResetPasswordVCViewController.h
//  VeriScanQR
//
//  Created by Adnan Ahmad on 17/12/2012.
//  Copyright (c) 2012 Adnan Ahmad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseVC.h"
#import "WebServiceManager.h"

@interface ResetPasswordVCViewController : BaseVC<UITextFieldDelegate>

+(id)initWithResetPassword;
@property (retain, nonatomic) IBOutlet UITextField *companyID;
@property (retain, nonatomic) IBOutlet UITextField *username;

- (IBAction)resetButtonPressed:(id)sender;
- (IBAction)backButtonPressed:(id)sender;

- (IBAction)aboutUsButtonPressed:(id)sender;
- (IBAction)privacyButtonPressed:(id)sender;
- (IBAction)termsButtonPressed:(id)sender;
- (IBAction)contactUSButtonPressed:(id)sender;
@end
