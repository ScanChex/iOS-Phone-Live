//
//  LoginVC.h
//  VeriScanQR
//
//  Created by Adnan Ahmad on 13/12/2012.
//  Copyright (c) 2012 Adnan Ahmad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseVC.h"
#import "WebServiceManager.h"

@interface LoginVC : BaseVC<UITextFieldDelegate>

+(id)initWithLogin;

@property (retain, nonatomic) IBOutlet UITextField *companyID;
@property (retain, nonatomic) IBOutlet UITextField *userID;
@property (retain, nonatomic) IBOutlet UITextField *password;

- (IBAction)loginButtonPressed:(id)sender;
- (IBAction)forgotPasswordButtonPressed:(id)sender;
- (IBAction)forgotUserIDButtonPressed:(id)sender;

- (IBAction)aboutUsButtonPressed:(id)sender;
- (IBAction)privacyButtonPressed:(id)sender;
- (IBAction)termsButtonPressed:(id)sender;
- (IBAction)contactUSButtonPressed:(id)sender;

@end
