//
//  UploadAdminVC.m
//  VeriScanQR
//
//  Created by Adnan Ahmad on 13/04/2013.
//  Copyright (c) 2013 Adnan Ahmad. All rights reserved.
//

#import "UploadAdminVC.h"
#import "WebServiceManager.h"
#import "SVProgressHUD.h"
#import "AssetInfoDTO.h"
#import "AsyncImageView.h"
#import "VSLocationManager.h"
#import "UIImage+UIImage_Extra.h"
#import <QuartzCore/QuartzCore.h>


@interface UploadAdminVC ()
{
    UIImagePickerController *imagePickerController;
}
-(id)initWithImage:(UIImage *)image assetID:(NSString *)asset isPicture:(BOOL)isPic;
-(void)updateGUI:(AssetInfoDTO *)assetInfo;
-(void)getAssetInformation;
-(void)setImageAspectRatio;


@end

@implementation UploadAdminVC

@synthesize picture=_picture;
@synthesize assetIDString=_assetIDString;
@synthesize isPicture=_isPicture;
@synthesize myProgressIndicator=_myProgressIndicator;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

+(id)initWithUpload:(UIImage *)image assetID:(NSString *)assetID isPicture:(BOOL)isPic
{

    return [[[UploadAdminVC alloc] initWithImage:image assetID:assetID isPicture:isPic] autorelease];
}

-(id)initWithImage:(UIImage *)image assetID:(NSString *)asset isPicture:(BOOL)isPic
{

    self=[super initWithNibName:@"UploadAdminVC" bundle:nil];
    
    if (self) {
        
       // self.picture=image;
        self.assetIDString =[NSString stringWithFormat:@"%@",asset];
        self.isPicture=isPic;
    }
    
    return self;
}

- (void)viewDidLoad
{
     [self.view setBackgroundColor:[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"color"]]];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self getAssetInformation];
    
    
    self.asset.layer.masksToBounds = YES;
    //imageView.layer.cornerRadius = 5.0;
    self.asset.layer.borderWidth=3.0;
    self.asset.layer.borderColor=[UIColor whiteColor].CGColor;
    
    if(IS_IPHONE5){
    
        self.submit.frame=CGRectMake(self.submit.frame.origin.x, 471, self.submit.frame.size.width, self.submit.frame.size.height);
        self.cancel.frame=CGRectMake(self.cancel.frame.origin.x, 471, self.cancel.frame.size.width, self.cancel.frame.size.height);
        self.takePicture.frame=CGRectMake(self.takePicture.frame.origin.x, 471, self.takePicture.frame.size.width, self.takePicture.frame.size.height);

    }
    
}

-(void)getAssetInformation
{

    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];

    UserDTO *user=[[VSSharedManager sharedManager] currentUser];
    
    [[WebServiceManager sharedManager] getAssetInfo:[NSString stringWithFormat:@"%d",user.masterKey] assetID:self.assetIDString withCompletionHandler:^(id data, BOOL error)
     {
         
         [SVProgressHUD dismiss];
         [self updateGUI:(AssetInfoDTO *)data];
         
     }];

}

-(void)updateGUI:(AssetInfoDTO *)assetInfo
{

    if (self.isPicture) {
        
        self.takePicture.hidden=NO;
    }
    else
    {
    
        self.takePicture.hidden=YES;
    }
    
    UserDTO *user=[[VSSharedManager sharedManager] currentUser];

    if (![user.logo isKindOfClass:[NSNull class]])
    {
        [self.logo setImageURL:[NSURL URLWithString:user.logo]];
    }

    if (![assetInfo.photo isKindOfClass:[NSNull class]])
    {
        [self.asset setImageURL:[NSURL URLWithString:assetInfo.photo]];
    }
        
    self.lblDescription.text=assetInfo.description;
    self.serialNumber.text  =![assetInfo.serialNumber isEqualToString:@"<null>"] ? assetInfo.serialNumber : @"N/A";
    self.address.text =[NSString stringWithFormat:@"%@ \n%@, %@ %@",assetInfo.street,assetInfo.city,assetInfo.state,assetInfo.postalCode];
    self.lastScannedDate.text=![assetInfo.scannedDate isEqualToString:@"<null>"] ? assetInfo.scannedDate : @"N/A";
    self.enployee.text =[NSString stringWithFormat:@"%@ is assigned",assetInfo.fullName ];
    self.assetID.text=assetInfo.assetID;
    
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_logo release];
    [_asset release];
    [_assetID release];
    [_lblDescription release];
    [_serialNumber release];
    [_address release];
    [_lastScannedDate release];
    [_enployee release];
    [_submit release];
    [_cancel release];
    [_takePicture release];
    [super dealloc];
}
- (IBAction)submitButtonPressed:(id)sender {
    
    
    [self setImageAspectRatio];
    
    NSString *type =nil;

    type=@"both";

    if (self.isPicture) {
        
        type=@"both";
    
        self.myProgressIndicator=[[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
        self.myProgressIndicator.frame=CGRectMake(10, 260, 300, 14);
        [self.view addSubview:self.myProgressIndicator];
    
    }
    else
    {
        self.myProgressIndicator=nil;
        type=@"location";
    }

    UserDTO *user=[[VSSharedManager sharedManager] currentUser];
    CLLocation *lasKnownLocation=[[VSLocationManager sharedManager] lastKnownLocation];

    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];

    NSData *imageData = UIImagePNGRepresentation(self.picture);
    
    [[WebServiceManager sharedManager] updateAdminLocationORImage:[NSString stringWithFormat:@"%.7f",lasKnownLocation.coordinate.latitude]
                                                        longitude:[NSString stringWithFormat:@"%.7f",lasKnownLocation.coordinate.longitude]
                                                        masterKey:[NSString stringWithFormat:@"%d", user.masterKey]
                                                          assetID:self.assetIDString
                                                        imageData:imageData companyID:[[NSUserDefaults standardUserDefaults] objectForKey:@"companyID"]
                                                             type:type
                                                      progressBar:self.myProgressIndicator
                                            withCompletionHandler:^(id data, BOOL error){

                                                [SVProgressHUD dismiss];                                                
                                                [self.myProgressIndicator removeFromSuperview];
                                                [self.myProgressIndicator release];
                                                [self getAssetInformation];
                                                
                                            }];
}

- (IBAction)cancelButtonPressed:(id)sender {
    
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
}

- (IBAction)takePictureButtonPressed:(id)sender {

    UIActionSheet *sheet=[[UIActionSheet alloc] initWithTitle:@"Share Image" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Camera" otherButtonTitles:@"Library",nil];
    [sheet showInView:self.view];
    [sheet release];

}
- (void)showImagePicker:(UIImagePickerControllerSourceType)cameraLibraryStatus
{
    // Create image picker controller
    imagePickerController = [[[UIImagePickerController alloc] init] autorelease];
    
    
    if ([UIImagePickerController isSourceTypeAvailable:cameraLibraryStatus])
    {
        // Set source to the Source Type
        imagePickerController.sourceType =  cameraLibraryStatus;
        // Delegate is self
        imagePickerController.delegate = self;
        // Allow editing of image ?
        imagePickerController.allowsEditing = NO;
        
        // Show image picker
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }
    else
    {
        //show alert
        
        [self initWithPromptTitle:@"Source not avaliable" message:@"Source is not avaliable"];
    }
    
}
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image =[info objectForKey:@"UIImagePickerControllerOriginalImage"];
    image=[image fixOrientation];
    
    self.picture=image;
    [self.asset setImage:self.picture];
    self.takePicture.hidden=YES;
    
}


-(void)setImageAspectRatio{
    
    
    //640 * 480
    //480 * 640
    
    ////Resize Image
    
    ////For land Scape mode
    if (self.picture.size.height >= 640.0 && self.picture.size.width >= 480.0 && self.picture.size.width > self.picture.size.height) {
        
        self.picture=[self.picture imageWithImage:self.picture scaledToSize:CGSizeMake(320.0,240.0)];
    }
    else if (self.picture.size.height >= 640.0 && self.picture.size.width >= 480.0 && self.picture.size.width < self.picture.size.height)///for portrait mode
    {
        self.picture=[self.picture imageWithImage:self.picture scaledToSize:CGSizeMake(240.0,320.0)];
    }
    else if(self.picture.size.width < 480.0 && self.picture.size.height >= 640.0){
        
        self.picture=[self.picture imageWithImage:self.picture scaledToSize:CGSizeMake(self.picture.size.width/6,320.0)];
        
    }
    else if(self.picture.size.width >= 640.0 && self.picture.size.height<480.0){
        
        self.picture=[self.picture imageWithImage:self.picture scaledToSize:CGSizeMake(320.0,self.picture.size.height/8)];
    }
    
    else if(self.picture.size.width >= 480.0 && self.picture.size.height >= 680.0){
        
        self.picture=[self.picture imageWithImage:self.picture scaledToSize:CGSizeMake(240.0,320.0)];
        
    }
    else if(self.picture.size.width >= 640.0 && self.picture.size.height >= 480.0){
        
        self.picture=[self.picture imageWithImage:self.picture scaledToSize:CGSizeMake(320.0,240.0)];
    }
}

- (NSString*)generateCallId {
    
    return [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIxntervalSince1970]];
}

#pragma mark -
#pragma  action Sheet Delegate

- (void)actionSheetCancel:(UIActionSheet *)actionSheet
{
    [actionSheet dismissWithClickedButtonIndex:2 animated:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    switch (buttonIndex)
    {
        case 0:
        {
            [self showImagePicker:UIImagePickerControllerSourceTypeCamera];
            break;
        }
        case 1:
        {
            [self showImagePicker:UIImagePickerControllerSourceTypePhotoLibrary];
            break;
        }
            
        default:
            break;
    }
    
}


@end
