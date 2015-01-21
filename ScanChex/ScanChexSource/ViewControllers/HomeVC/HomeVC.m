//
//  HomeVC.m
//  VeriScanQR
//
//  Created by Adnan Ahmad on 13/12/2012.
//  Copyright (c) 2012 Adnan Ahmad. All rights reserved.
//

#import "HomeVC.h"
#import "ScanQRManager.h"
#import "Constant.h"
#import "ScanVC.h"
#import "UserDTO.h"
#import "VSSharedManager.h"
#import "SVProgressHUD.h"
#import "VSLocationManager.h"

@interface HomeVC ()

-(void)scanTicket;

@end

@implementation HomeVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

+(id)initWithHome{
    
    return [[[HomeVC alloc] initWithNibName:@"HomeVC" bundle:nil] autorelease];
}

- (void)viewDidLoad
{
    if( [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f ) {
        
        float statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
        for( UIView *v in [self.view subviews] ) {
            CGRect rect = v.frame;
            rect.origin.y += statusBarHeight;
//            rect.size.height -= statusBarHeight;
            v.frame = rect;
        }
    }
     [self.view setBackgroundColor:[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"color"]]];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    UserDTO *user=[[VSSharedManager sharedManager] currentUser];
    self.name.text=user.name;
    
    if (!IsEmpty(user.logo))
        [self.logoImage setImageURL:[NSURL URLWithString:user.logo]];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCode:) name:K_Update_ScanCode object:nil];    
  }


-(void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    

}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    NSArray *viewControllers = self.navigationController.viewControllers;
    
    
	if ([viewControllers indexOfObject:self] == NSNotFound)
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma - NSNotification Center

-(void)updateCode:(NSNotification *)info{
    
//    [self scanTicket];

}

#pragma mark- Functions
-(void)scanTicket
{

    DLog(@"Self.CurrentCode %@",self.currentScannedCode);
    
    
    
    TicketDTO *ticketAsset=[[VSSharedManager sharedManager] selectedTicket];
    
    
   if (![[self.currentScannedCode lowercaseString] isEqualToString:[ticketAsset.assetCode lowercaseString]]) {
        
        [self initWithPromptTitle:@"Wrong Asset" message:@"You have scanned a wrong asset"];
        
        return;
    }
    else
    {
        
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
        TicketInfoDTO *ticket=[[VSSharedManager sharedManager] selectedTicketInfo];
        CLLocation *lasKnownLocation=[[VSLocationManager sharedManager] lastKnownLocation];
        UserDTO *user=[[VSSharedManager sharedManager] currentUser];
        
        [[WebServiceManager sharedManager] scanTicket:ticket.tblTicketID
                                              assetID:ticketAsset.assetID
                                             latitude:[NSString stringWithFormat:@"%.7f",lasKnownLocation.coordinate.latitude]
                                            longitude:[NSString stringWithFormat:@"%.7f",lasKnownLocation.coordinate.longitude]
                                            masterKey:[NSString stringWithFormat:@"%d", user.masterKey]
                                             userName:[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"]
                                             handsetMake:@"Apple"
                                                   os:[[UIDevice currentDevice] systemVersion]
                                          modelNumber:[[UIDevice currentDevice] platformString]
                                         serialNumber:[[[UIDevice currentDevice] identifierForVendor] UUIDString]
                                withCompletionHandler:^(id data, BOOL error){
                                    
                                    [SVProgressHUD dismissWithSuccess:@"Ticket Scanned Successfully"];
                                    
                                    if (!error)
                                    {
                                        if (![ticketAsset.assetType isEqualToString:@"inspection"])
                                        {
                                            [[VSLocationManager sharedManager] setAssetID:ticketAsset.assetID];
                                        }
                                        
                                        [[NSNotificationCenter defaultCenter] removeObserver:self];
                                        
                                        [self.navigationController pushViewController:[ScanVC initWithScan] animated:YES];
                                    }
                                    else
                                    {
                                        [self initWithPromptTitle:@"Error" message:(NSString *)data];
                                    }
                                }];
    }

}
- (IBAction)scanTagButtonPressed:(id)sender {
    
    
       // self.currentScannedCode = @"uestotc5mdq0mc0wmdaxltawmdetmdawmq==";
       // [self scanTicket];
       [self showQrScanner];

}
- (IBAction)scannedScheduleButtonPressed:(id)sender {
   
    [self.navigationController pushViewController:[ScanVC initWithScan] animated:YES];
}

- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc {
    [_name release];
    [_logo release];
    [_logoImage release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setName:nil];
    [self setLogo:nil];
    [self setLogoImage:nil];
    [super viewDidUnload];
}

@end
