//
//  SplashVC.m
//  VeriScanQR
//
//  Created by Adnan Ahmad on 10/02/2013.
//  Copyright (c) 2013 Adnan Ahmad. All rights reserved.
//

#import "SplashVC.h"
#import "LoginVC.h"
#import "AboutUsLinksVC.h"

@interface SplashVC ()

@end


@implementation SplashVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

+(id) initWithSplash{

    return [[[SplashVC alloc] init] autorelease];
}

-(id)init{

    if (IS_IPHONE5) {
    
        self=[super initWithNibName:@"SplashiPhone5" bundle:nil];
    }
    else{
    
        self=[super initWithNibName:@"SplashVC" bundle:nil];
    }
    return self;
}

- (void)viewDidLoad
{
     [self.view setBackgroundColor:[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"color"]]];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSDictionary* infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString* version = [infoDict objectForKey:@"CFBundleVersion"];
    
    self.versionNumberLabel.text = [NSString stringWithFormat:@"Version:%@",version];
    
    [UIApplication sharedApplication].statusBarHidden=YES;
}

-(void)viewWillDisappear:(BOOL)animated{

    [UIApplication sharedApplication].statusBarHidden=NO;

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginButtonPressed:(id)sender {
    
    [self.navigationController pushViewController:[LoginVC initWithLogin] animated:YES];
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
- (void)dealloc {
    [_versionNumberLabel release];
    [_iPhone5Splash release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setVersionNumberLabel:nil];
    [self setIPhone5Splash:nil];
    [super viewDidUnload];
}
@end
