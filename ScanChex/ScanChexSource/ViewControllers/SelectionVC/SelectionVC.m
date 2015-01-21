//
//  SelectionVC.m
//  VeriScanQR
//
//  Created by Adnan Ahmad on 02/04/2013.
//  Copyright (c) 2013 Adnan Ahmad. All rights reserved.
//

#import "SelectionVC.h"
#import "UserDTO.h"
#import "TicketsVC.h"
#import "WebServiceManager.h"
#import "MapVC.h"
#import "SharedManager.h"
#import "AboutUsLinksVC.h"
#import "VSLocationManager.h"
#import "UIImageView+WebCache.h"

@interface SelectionVC ()
-(void)updateTickets;

@end

@implementation SelectionVC


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

+(id)initWithSelection{

    return [[[SelectionVC alloc] initWithNibName:@"SelectionVC" bundle:nil] autorelease];
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([[SharedManager getInstance] isMessage]) {
        [self.lblMessage setHidden:YES];
        [self.imgAlert setImage:[UIImage imageNamed:@"Chat.png"]];
    }
    else {
        [self.lblMessage setHidden:NO];
        [self.imgAlert setImage:nil];
    }
}
-(void)messageNotification:(NSNotification*)notif {
    [self.lblMessage setHidden:YES];
    [self.imgAlert setImage:[UIImage imageNamed:@"Chat.png"]];
}
- (void)viewDidLoad
{
    
    
    VSLocationManager *locationManager = [VSLocationManager sharedManager];
    BOOL isFirstLaunch = [[NSUserDefaults standardUserDefaults] boolForKey:@"isFirstLaunch"];
    if (!isFirstLaunch) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isFirstLaunch"];
    }
    
    locationManager.isFirstLaunch = !isFirstLaunch;
    [locationManager startListening];

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageNotification:) name:kPushReceived object:nil];
    if ([[SharedManager getInstance] isMessage]) {
        [self.lblMessage setHidden:YES];
        [self.imgAlert setImage:[UIImage imageNamed:@"Chat.png"]];
    }
    else {
        [self.lblMessage setHidden:NO];
        [self.imgAlert setImage:nil];
    }
     [self.view setBackgroundColor:[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"color"]]];
    [super viewDidLoad];
    if( [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f ) {
        
        float statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
        for( UIView *v in [self.view subviews] ) {
            CGRect rect = v.frame;
            rect.origin.y += statusBarHeight;
            //            rect.size.height -= statusBarHeight;
            v.frame = rect;
        }
        //        CGRect frame = self.view.frame;
        //        frame.size.height = frame.size.height-statusBarHeight;
        //        frame.origin.y = frame.origin.y+statusBarHeight;
        //        self.view.frame =frame;
        CGRect rect = self.messageView.frame;
        rect.origin.y -= statusBarHeight;
//        rect.origin.y -= statusBarHeight;
        self.messageView.frame = rect;
    }
    // Do any additional setup after loading the view from its nib.
   
    [self initalizeUIComponents];
}

-(void)initalizeUIComponents
{

    UserDTO *user=[[VSSharedManager sharedManager] currentUser];
    self.name.text=user.name;
    self.logo.layer.borderWidth=3.0;
    self.logo.layer.borderColor=[UIColor lightGrayColor].CGColor;
  
  
    if (![user.logo isKindOfClass:[NSNull class]])
        [self.logo setImageURL:[NSURL URLWithString:user.logo]];
    
    UserDTO *userDTO = [[SharedManager getInstance] loadUserObjectWithKey:@"user"];
    
    if (!IsEmpty(userDTO.company_logo)) {
        
        [self.companyLogo sd_setImageWithURL:[NSURL URLWithString:userDTO.company_logo] placeholderImage:[UIImage imageNamed:@"logo.png"]];
    }
    
    if (IS_IPHONE5) {
        
//        self.messageView.frame = CGRectMake(self.messageView.frame.origin.x, self.messageView.frame.origin.y + IPHONE_5_HEIGHT_DIFFERENCE ,self.messageView.frame.size.width, self.messageView.frame.size.height );
    }
    self.lblMessage.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)ticketsButtonPressed:(id)sender{

    [self.navigationController pushViewController:[TicketsVC initWithTickets] animated:YES];
}
-(IBAction)viewMapButtonPressed:(id)sender{

    [self updateTickets];
}
-(IBAction)logoutButtonPressed:(id)sender{

    [[VSLocationManager sharedManager] stopListening];
    UserDTO * user = [[VSSharedManager sharedManager] currentUser];
    [[WebServiceManager sharedManager] logoutWithMasterKey:[NSString stringWithFormat:@"%d",user.masterKey] username:[[VSSharedManager sharedManager] currentUser].name session_id:[[VSSharedManager sharedManager] currentUser].session_id withCompletionHandler:^(id data,BOOL error){
      
      [self deleteUserObjectWithKey:@"user"];
        
    }];
    [self.navigationController popToRootViewControllerAnimated:YES];
}


-(void)deleteUserObjectWithKey:(NSString*)key
{
  NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
  [prefs removeObjectForKey:key];
  [prefs synchronize];
  
}

- (IBAction)messageButtonPressed:(id)sender {
    [[SharedManager getInstance] setIsMessage:FALSE];
     [self.imgAlert setImage:nil];
     [self.lblMessage setHidden:NO];
    
    [self.navigationController pushViewController:[MessageCentreVC initWithMessageCentre] animated:YES];
}

-(void)updateTickets{

//    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
//    
//    UserDTO*user=[[VSSharedManager sharedManager] currentUser];
//    
//    [[WebServiceManager sharedManager] getTickets:[NSString stringWithFormat:@"%d",user.masterKey] fromDate:nil toDate:nil userName:[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"] withCompletionHandler:^(id data,BOOL error){
//        
//        [SVProgressHUD dismiss];
//        
//        if (!error) {
    
                [self.navigationController pushViewController:[MapVC initWithMap:YES] animated:YES];
//                
//        }
//        else
//            [self initWithPromptTitle:@"Error" message:(NSString *)data];
//        
//    }];
    
    
}

-(IBAction)customizeButtonPressed:(id)sender {
    InfColorPickerController* picker = [ InfColorPickerController colorPickerViewController ];
    UIColor * tempColor = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"color"]];
    picker.sourceColor = tempColor;
    picker.delegate = self;
    
    [ picker presentModallyOverViewController: self ];
}

-(IBAction)idButtonPressed:(id)sender {
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    UserDTO*user=[[VSSharedManager sharedManager] currentUser];
    [[WebServiceManager sharedManager] getID:[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"] masterkey:[NSString stringWithFormat:@"%d",user.masterKey] withCompletionHandler:^(id data ,BOOL error){
        [SVProgressHUD dismiss];
        if (!error) {
            
            if(data){
                [self.navigationController pushViewController:[[AboutUsLinksVC alloc]initWithID:(NSString*)data] animated:YES];
                
            }
        }
        //        [self updateMessages];
    }];
}
- (void) colorPickerControllerDidFinish: (InfColorPickerController*) picker
{
    NSData *colorData = [NSKeyedArchiver archivedDataWithRootObject:picker.resultColor];
    [[NSUserDefaults standardUserDefaults] setObject:colorData forKey:@"color"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [ self dismissViewControllerAnimated:YES completion:Nil];
//    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"myColor"];
//    UIColor *color = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"myColor"]];
    [self.view setBackgroundColor:[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"color"]]];
}

- (void)dealloc {
     [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_messageView release];
    [_imgAlert release];
    [_lblMessage release];
    [_btnMessage release];
    [_companyLogo release];
    [super dealloc];
}
@end

