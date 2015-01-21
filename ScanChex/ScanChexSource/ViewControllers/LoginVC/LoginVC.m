//
//  LoginVC.m
//  VeriScanQR
//
//  Created by Adnan Ahmad on 13/12/2012.
//  Copyright (c) 2012 Adnan Ahmad. All rights reserved.
//

#import "LoginVC.h"
#import "ResetPasswordVCViewController.h"
#import "TicketsVC.h"
#import "SVProgressHUD.h"
#import "VSSharedManager.h"
#import "AdminVC.h"
#import "SelectionVC.h"
#import <QuartzCore/QuartzCore.h>
#import "AboutUsLinksVC.h"
#import "UIAlertView+Blocks.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"

@interface LoginVC ()

@end

@implementation LoginVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
+(id)initWithLogin{
    
    return [[[LoginVC alloc] initWithNibName:@"LoginVC" bundle:nil] autorelease];
}

- (void)viewDidLoad
{
//    if( [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f ) {
//        
//        float statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
//        for( UIView *v in [self.view subviews] ) {
//            CGRect rect = v.frame;
//            rect.origin.y += statusBarHeight;
//            rect.size.height -= statusBarHeight;
//            v.frame = rect;
//        }
//    }
     [self.view setBackgroundColor:[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"color"]]];
    [super viewDidLoad];
    for (UIView * v in [self.view subviews]) {
        if ([v isKindOfClass:[UIButton class]]) {
            if ([[[(UIButton*)v titleLabel] text] isEqualToString:@"LOGIN"]) {
                v.layer.cornerRadius = 5.0f;
            }
            if ([[[(UIButton*)v titleLabel] text] isEqualToString:@"FORGOT PASSWORD"]) {
                v.layer.cornerRadius = 2.0f;
            }
        }
    }
    // Do any additional setup after loading the view from its nib.
    
    self.companyID.text=[[NSUserDefaults standardUserDefaults] objectForKey:@"companyID"];
    self.userID.text=[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"];

    UserDTO *userDTO  = [self loadUserObjectWithKey:@"user"];
    
    if (!IsEmpty(userDTO.company_logo)) {
        
        [self.companyLogo sd_setImageWithURL:[NSURL URLWithString:userDTO.company_logo] placeholderImage:[UIImage imageNamed:@"logo.png"]];

    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deniedPushNotificationAccessAlert) name:PushNotificationPermissionPopup object:nil];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_companyID release];
    [_userID release];
    [_password release];
    [_companyLogo release];
    [super dealloc];
}


- (IBAction)loginButtonPressed:(id)sender {
    
    
    [[NSUserDefaults standardUserDefaults] setObject:self.companyID.text forKey:@"companyID"];
    [[NSUserDefaults standardUserDefaults] setObject:self.userID.text forKey:@"userID"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    
    if ([self.companyID.text length] == 0) {
        
        [self initWithPromptTitle:@"Enter Company Id" message:@"Company Id should not be empty"];

        return;
    }
    else if ([self.userID.text length] == 0) {
        
        [self initWithPromptTitle:@"Enter User Id" message:@"User Id should not be empty"];
        
        return;
    }
    else if ([self.password.text length] == 0) {
        
        [self initWithPromptTitle:@"Enter Password" message:@"Password should not be empty"];
        
        return;
    }


    [self resignKeyBoard];
  
 // UserDTO *user =[[VSSharedManager sharedManager] currentUser];
 // UserDTO *user = [self loadUserObjectWithKey:@"user"];
//  
 // if ( ( [user.name isEqual:[NSNull null]] ) || ( [user.name length] == 0 ) ) {
//  
  
    [self deleteUserObjectWithKey:@"user"];

    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    
    [[WebServiceManager sharedManager] loginWithCustomerID:self.companyID.text userID:self.userID.text password:self.password.text withCompletionHandler:^(id data,BOOL error){
        
        [SVProgressHUD dismiss];
        
        if (!error){
         
            [[VSSharedManager sharedManager] setUserName:self.userID.text];
            UserDTO*user =[[VSSharedManager sharedManager] currentUser];
            if ([user.levelID isEqualToString:@"Admin"])
                [self.navigationController pushViewController:[AdminVC initWithAdmin] animated:YES];
            else {
              
              [self saveUserObject:user];
              
                [self.navigationController pushViewController:[SelectionVC initWithSelection] animated:YES];
            }
          
        }
        else
            [self initWithPromptTitle:@"Error" message:(NSString*)data];
        
    }];
 // }
  
  /*else {
    
   // UserDTO*user =[[VSSharedManager sharedManager] currentUser];
    
    if ([user.levelID isEqualToString:@"Admin"])
      [self.navigationController pushViewController:[AdminVC initWithAdmin] animated:YES];
    else
      [self.navigationController pushViewController:[SelectionVC initWithSelection] animated:YES];
   
  }*/
  

}

-(void)saveUserObject:(UserDTO *)userobject
{
  NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
  NSData *myEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:userobject];
  [prefs setObject:myEncodedObject forKey:@"user"];
  [prefs synchronize];
}

-(UserDTO *)loadUserObjectWithKey:(NSString*)key
{
  NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
  NSData *myEncodedObject = [prefs objectForKey:key ];
  UserDTO *obj = (UserDTO *)[NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
  return obj;
}


-(void)deleteUserObjectWithKey:(NSString*)key
{
  NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
  [prefs removeObjectForKey:key];
  [prefs synchronize];
  
}


-(void)deniedPushNotificationAccessAlert{
    
    //dispatch_async(dispatch_get_main_queue(), ^{
       
        __block RIButtonItem *okItem = [RIButtonItem itemWithLabel:@"OK" action:^{
            
            if (![[AppDelegate sharedDelegate] checkForPushNotificationPermission]) {
                
                [self deniedPushNotificationAccessAlert];
            }
        }];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Go to settings-->Notifications-->Enable ScanChex Push notification" message:@"" cancelButtonItem:okItem otherButtonItems:nil];
        [alertView show];
        [alertView release];
    //});
}




-(void)resignKeyBoard
{
    [self.companyID resignFirstResponder];
    [self.userID resignFirstResponder];
    [self.password resignFirstResponder];
}
#pragma mark -TextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

#pragma mark- IBActions
- (IBAction)aboutUsButtonPressed:(id)sender {
    
    [self.navigationController pushViewController:[AboutUsLinksVC initWithAboutUS:@"http://scanchex.com/about-scanchex/"] animated:YES];
}

- (IBAction)privacyButtonPressed:(id)sender {
    
    [self.navigationController pushViewController:[AboutUsLinksVC initWithAboutUS:@"http://scanchex.com/privacy-policy/"] animated:YES];
}

- (IBAction)termsButtonPressed:(id)sender {
    
    [self.navigationController pushViewController:[AboutUsLinksVC initWithAboutUS:@"http://scanchex.com/terms-of-service/"] animated:YES];
}

- (IBAction)contactUSButtonPressed:(id)sender {
    
    [self.navigationController pushViewController:[AboutUsLinksVC initWithAboutUS:@"http://scanchex.com/contact-us/"] animated:YES];
}

- (IBAction)forgotPasswordButtonPressed:(id)sender {
    
    ResetPasswordVCViewController *resetVC=[ResetPasswordVCViewController initWithResetPassword];
    [self.navigationController pushViewController:resetVC animated:YES];
}

- (IBAction)forgotUserIDButtonPressed:(id)sender {
    
    [self initWithPromptTitle:@"Forgot UserID" message:@"Forgot UserID Button Pressed"];
    
}

@end
