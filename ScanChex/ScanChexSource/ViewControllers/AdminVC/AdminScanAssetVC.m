//
//  AdminScanAssetVC.m
//  VeriScanQR
//
//  Created by Adnan Ahmad on 12/04/2013.
//  Copyright (c) 2013 Adnan Ahmad. All rights reserved.
//

#import "AdminScanAssetVC.h"
#import "UploadAdminVC.h"
#import "WebServiceManager.h"
#import "AssetInfoDTO.h"
#import "VSLocationManager.h"
#import "BlockAlertView.h"

@interface AdminScanAssetVC ()

-(id)initWithImage:(UIImage *)image isPicture:(BOOL)isPic;
-(void)getAssetInformation;

@end

@implementation AdminScanAssetVC

@synthesize scannerImage=_scannerImage;
@synthesize isPicture=_isPicture;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

+(id)initwithScannerImage:(UIImage *)image isPicture:(BOOL)isPic
{
    return [[[AdminScanAssetVC alloc] initWithImage:image isPicture:isPic] autorelease];
}

-(id)initWithImage:(UIImage *)image isPicture:(BOOL)isPic{

    self=[super initWithNibName:@"AdminScanAssetVC" bundle:nil];
    
    if (self) {
        
        if (isPic)
            self.scannerImage=image;
        
        self.isPicture=isPic;
    }
    return self;
}

- (void)viewDidLoad
{
     [self.view setBackgroundColor:[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"color"]]];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateScanner:) name:K_Update_ScanCode object:Nil];

}



#pragma mark- NSNOTIFICATION CENTRE

-(void)updateScanner:(NSNotification *)info
{

    DLog(@"Current Scan %@",self.currentScannedCode);
    [self getAssetInformation];
}

-(void)getAssetInformation
{
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    UserDTO *user=[[VSSharedManager sharedManager] currentUser];
    [[WebServiceManager sharedManager] getAssetInfo:[NSString stringWithFormat:@"%d",user.masterKey] assetID:self.currentScannedCode withCompletionHandler:^(id data, BOOL error)
     {
         
         [SVProgressHUD dismiss];
         AssetInfoDTO *assetInfo =  (AssetInfoDTO *)data;
         CLLocation *lasKnownLocation=[[VSLocationManager sharedManager] lastKnownLocation];

         BlockAlertView *alert = [BlockAlertView alertWithTitle:@"Location"
                                                        message:[NSString stringWithFormat:@"Previous Latitude:\n %@\n Previous Longitude:\n%@\n Current Latitude:\n%@\n Current Longitude:\n%@",assetInfo.latitude,assetInfo.longitude,[NSString stringWithFormat:@"%.7f",lasKnownLocation.coordinate.latitude],[NSString stringWithFormat:@"%.7f",lasKnownLocation.coordinate.longitude]]];
         
         [alert setCancelButtonWithTitle:@"Cancel" block:^{
         
             [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
         }];
         [alert addButtonWithTitle:@"Proceed" block:^{
             
             
             [self.navigationController pushViewController:[UploadAdminVC initWithUpload:self.scannerImage assetID:[NSString stringWithFormat:@"%@",self.currentScannedCode] isPicture:self.isPicture] animated:YES];

         }];
         [alert show];
         

         }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:K_Update_ScanCode object:nil];
    [_logo release];
    [super dealloc];
}
- (IBAction)scannerButtonPressed:(id)sender {

    
    // self.currentScannedCode =@"vvmtnjqyntc5mc0wmdaxltawmdatmdawmq==";
   //  [[NSNotificationCenter defaultCenter] postNotificationName:K_Update_ScanCode object:nil];

    [self showQrScanner];
}

- (IBAction)backButtonPressed:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
