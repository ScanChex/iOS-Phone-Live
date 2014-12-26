//
//  ResetPasswordVCViewController.m
//  VeriScanQR
//
//  Created by Adnan Ahmad on 17/12/2012.
//  Copyright (c) 2012 Adnan Ahmad. All rights reserved.
//

#import "ResetPasswordVCViewController.h"
#import "SVProgressHUD.h"
#import "AboutUsLinksVC.h"
@interface ResetPasswordVCViewController ()

@end

@implementation ResetPasswordVCViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

+(id)initWithResetPassword{
    
    return [[[ResetPasswordVCViewController alloc] initWithNibName:@"ResetPasswordVCViewController" bundle:nil] autorelease];
}

- (void)viewDidLoad
{
    for (UIView * v in [self.view subviews]) {
        if ([v isKindOfClass:[UIButton class]]) {
            if ([[[(UIButton*)v titleLabel] text] isEqualToString:@"RESET PASSWORD"]) {
                v.layer.cornerRadius = 5.0f;
            }
            if ([[[(UIButton*)v titleLabel] text] isEqualToString:@"BACK"]) {
                v.layer.cornerRadius = 2.0f;
            }
        }
    }
     [self.view setBackgroundColor:[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"color"]]];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_companyID release];
    [_username release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setCompanyID:nil];
    [self setUsername:nil];
    [super viewDidUnload];
}
- (IBAction)resetButtonPressed:(id)sender {
    

    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];

    [[WebServiceManager sharedManager] resetPassword:self.companyID.text username:self.username.text withCompletionHandler:^(id data,BOOL error){
        [SVProgressHUD dismiss];

        if (!error) {
            [self initWithPromptTitle:@"Reset Successfully" message:(NSString *)data];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
            [self initWithPromptTitle:@"Error" message:(NSString *)data];
    }];
}

- (IBAction)backButtonPressed:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma UITextField Delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{

    [textField resignFirstResponder];

    return YES;
}

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
@end
