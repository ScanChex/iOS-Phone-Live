//
//  ScanVCViewController.m
//  VeriScanQR
//
//  Created by Adnan Ahmad on 14/12/2012.
//  Copyright (c) 2012 Adnan Ahmad. All rights reserved.
//

#import "ScanVC.h"
#import "AssetVC.h"
#import "HistoryVC.h"
#import "MapVC.h"
#import "WebServiceManager.h"
#import "DownloadHelper.h"
#import "Constant.h"
#import "ReaderDocument.h"
#import <sys/xattr.h>
#import "ShowQuestionsVC.h"
#import "SVProgressHUD.h"
#import "VSSharedManager.h"
#import "TicketDTO.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "VoiceRecordViewController.h"
#import "NotesVC.h"
#import "UIImage+UIImage_Extra.h"
#import "TicketInfoDTO.h"
#import "VSLocationManager.h"
#import "ComponentsVC.h"
#import "AudioPlayerVC.h"
#import "ServiceDTO.h"
#import "ImageViewVC.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "PaymentVC.h"
#import "UserDTO.h"
#import <QuartzCore/QuartzCore.h>
#import "SharedManager.h"
#import "MessageCentreVC.h"
#import "CheckPointDTO.h"
#import "MMPickerView.h"
#import "AboutUsLinksVC.h"
#import "TicketCell.h"
#import "PDFViewController.h"
#import "HistoryDTO.h"
#import "RoutesViewController.h"
@interface ScanVC ()<showQuestionDelegate,assetDelegate,HistoryVCDelegate>
{
    UIImagePickerController *imagePickerController;
}

@property(nonatomic,retain) AssetVC *assetsView;
@property(nonatomic,retain) DocumentsVC *documentsView;
@property(nonatomic,retain) HistoryVC *historyView;
@property(nonatomic,retain) ShowQuestionsVC *questionView;
@property(nonatomic,retain) MapVC *mapView;


- (BOOL) fileExistsAtAbsolutePath:(NSString*)filename;
- (void) readPdfFileAtPath:(NSString *)filePath;
- (void) showCamera;
- (void) showImagePicker:(UIImagePickerControllerSourceType)cameraLibraryStatus;
- (void) setImageAspectRatio:(UIImage *)picture;
- (void) scanTicket;
- (NSString*) fileMIMEType:(NSString*) file;
- (BOOL) addSkipBackupAttributeToItemAtURL:(NSURL *)URL;


@end

@implementation ScanVC

@synthesize assetsView=_assetsView;
@synthesize documentsView=_documentsView;
@synthesize historyView=_historyView;
@synthesize questionView=_questionView;
@synthesize mapView=_mapView;
@synthesize savePath=_savePath;

@synthesize myProgressIndicator=_myProgressIndicator;
@synthesize recoder=_recoder;
@synthesize isSecondScan = _isSecondScan;
@synthesize scanQRManager = _scanQRManager;
@synthesize audioArray = _audioArray;
@synthesize videoArray = _videoArray;
@synthesize receivedArray = _receivedArray;
@synthesize notesimageSign = _notesimageSign;
@synthesize questionsimageSign = _questionsimageSign;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _audioArray = [[NSMutableArray alloc] initWithObjects:nil];
        _videoArray = [[NSMutableArray alloc] initWithObjects:nil];
        self.historyArray = [[NSMutableArray alloc]initWithObjects:nil];
        [[VSSharedManager sharedManager] setIsPreview:FALSE];
        self.isScanHidden = FALSE;
        self.isScanning = FALSE;
        // Custom initialization
    }
    return self;
}
+(id)initWithScan{
    
    return [[[ScanVC alloc] initWithNibName:@"ScanVC" bundle:nil] autorelease];
}
+(id)initWithPreview{
    
    return [[[ScanVC alloc] initWithPreview:@"ScanVC" bundle:nil] autorelease];
}
+(id)initWithhiddenScan {
    return [[[ScanVC alloc] initWithhiddenScan:@"ScanVC" bundle:nil] autorelease];
}
- (id)initWithhiddenScan:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _audioArray = [[NSMutableArray alloc] initWithObjects:nil];
        _videoArray = [[NSMutableArray alloc] initWithObjects:nil];
        [[VSSharedManager sharedManager] setIsPreview:TRUE];
        [self.btnSecondScan setEnabled:NO];
        self.isScanHidden = TRUE;
        
        // Custom initialization
    }
    return self;
}
- (id)initWithPreview:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _audioArray = [[NSMutableArray alloc] initWithObjects:nil];
        _videoArray = [[NSMutableArray alloc] initWithObjects:nil];
        [[VSSharedManager sharedManager] setIsPreview:TRUE];
        self.isScanHidden = FALSE;
        [self.btnSecondScan setEnabled:YES];
        // Custom initialization
    }
    return self;
}
#pragma -mark Life Cycle
- (void)viewDidLoad
{
    TicketDTO *ticketAsset =[[VSSharedManager sharedManager] selectedTicket];
    

    self.alertText =  [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 290, 200)];
    
    [self.historyArray removeAllObjects];
    UserDTO *user=[[VSSharedManager sharedManager] currentUser];
    [[WebServiceManager sharedManager] showHistory:[NSString stringWithFormat:@"%d",user.masterKey] ticketID:ticketAsset.assetID withCompletionHandler:^(id data, BOOL error){
        
        //  [SVProgressHUD dismiss];
        if (!error) {
            
            //                                [self.historyArray removeAllObjects];
            self.historyArray  = [NSMutableArray arrayWithArray:(NSMutableArray*)data];

        }
        else
            [self initWithPromptTitle:@"Error" message:(NSString *)data];
        
    }];
    if (self.isScanHidden) {
        [self.btnSecondScan setEnabled:NO];
    }
    else {
        [self.btnSecondScan setEnabled:YES];
    }
//    [self.btnSecondScan setHidden:self.isScanHidden];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageNotification:) name:kPushReceived object:nil];
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
    
    [self.btnSecondScan.layer setCornerRadius:5.0f];
    [self.backButton.layer setCornerRadius:5.0f];
    
    self.count = 1;
     [self.view setBackgroundColor:[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"color"]]];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCode:) name:K_Update_ScanCode object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(assetScanNotification:) name:@"assetScan" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelTab:) name:K_Update_ScanCode_CANCEL object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sharePDF:) name:PDF_FILE_SHARE object:nil];


    
    TicketInfoDTO *ticketInfoDTO = [[VSSharedManager sharedManager] selectedTicketInfo];
    
//    if ([[ticketInfoDTO.overDue lowercaseString] isEqualToString:@"1"]) {
//        self.suspendButton.hidden = YES;
//    }
    
    if ([[VSSharedManager sharedManager] isPreview]) {
        [self.backButton setTitle:@"RETURN" forState:UIControlStateNormal];
    }

    else {
        [self.backButton setTitle:@"CLOSE TICKET" forState:UIControlStateNormal];
        if ([ticketInfoDTO.numberOfScans isEqualToString:@"2"] ) {
            
            self.btnSecondScan.hidden = NO;
            self.isSecondScan = YES;
        }
        else if ([ticketInfoDTO.numberOfScans isEqualToString:@"1"])
        {
            self.isSecondScan =NO;
            self.btnSecondScan.hidden = NO;
        }
        
        if([[ticketInfoDTO.ticketStatus lowercaseString] isEqualToString:@"pending"])
        {
            self.isSecondScan =NO;
            self.btnSecondScan.hidden = NO;
            
        }
    }
    if ([[[[VSSharedManager sharedManager] selectedTicketInfo] notes] length]>0) {
        [self.segmentControl setTitle:@"Notes !" forSegmentAtIndex:4];
     
      if ( ![[[[VSSharedManager sharedManager] selectedTicketInfo] notes] isEqualToString:@""] ) {
      _notesimageSign.hidden=NO;
      [self.notesimageSign setImage:[UIImage imageNamed:@"excalamationIcon.png"]];
      } else {
         _notesimageSign.hidden=YES;
      }
      
    } else {
      _notesimageSign.hidden=YES;
    }
  
  
    
    if ([ticketInfoDTO.is_questions isEqualToString:@"YES"])
        [self.questionsimageSign setImage:[UIImage imageNamed:@"excalamationIcon.png"]];
    else
        self.questionsimageSign.hidden = YES;

  
  //DEBUG****remove for testing.
  //[[VSSharedManager sharedManager] setIsPreview:FALSE];
  //
  
//    self.view.backgroundColor=[UIColor blackColor];
    [self.segmentControl setSelectedSegmentIndex:0];
    [self performSelector:@selector(segmentChanged:)];
//     [self timerRepeat];
//    self.startTimer = [NSTimer scheduledTimerWithTimeInterval:60.0
//                       
//                                                       target:self
//                       
//                                                     selector:@selector(timerRepeat)
//                       
//                                                     userInfo:nil
//                       
//                                                      repeats:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [_scanQRManager release];
    _scanQRManager = nil;
    

    [super viewWillDisappear:animated];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_segmentControl release];
    [_btnSecondScan release];
    [_audioArray release];
    [_videoArray release];
    [_scanQRManager release];
    _scanQRManager = nil;
    [_assetsView release];
    _assetsView = nil;
    [_startTimer invalidate];
    _startTimer = nil;
    [_suspendButton release];
    [_alertText release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setSegmentControl:nil];
    [super viewDidUnload];
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self segmentChanged:self.segmentControl];
    
}


#pragma -mark Methods




-(BOOL)fileExistsAtAbsolutePath:(NSString*)filename {
    
    BOOL isDirectory;
    BOOL fileExistsAtPath = [[NSFileManager defaultManager] fileExistsAtPath:filename isDirectory:&isDirectory];
    return fileExistsAtPath && !isDirectory;
}

- (BOOL) addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    const char* filePath = [[URL path] fileSystemRepresentation];
    const char* attrName = "com.apple.MobileBackup";
    
    u_int8_t attrValue = 1;
    int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
    
    return result == 0;
    
}

- (NSString*) fileMIMEType:(NSString*) file {
    CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (CFStringRef)[file pathExtension], NULL);
    CFStringRef MIMEType = UTTypeCopyPreferredTagWithClass (UTI, kUTTagClassMIMEType);
    CFRelease(UTI);
    return [(NSString *)MIMEType autorelease];
}

-(void)setImageAspectRatio:(UIImage *)picture{
    
    //640 * 480
    //480 * 640
    ////Resize Image
    
    ////For land Scape mode
    if (picture.size.height >= 640.0 && picture.size.width >= 480.0 && picture.size.width > picture.size.height) {
        
        picture=[picture imageWithImage:picture scaledToSize:CGSizeMake(320.0,240.0)];
    }
    else if (picture.size.height >= 640.0 && picture.size.width >= 480.0 && picture.size.width < picture.size.height)///for portrait mode
    {
        picture=[picture imageWithImage:picture scaledToSize:CGSizeMake(240.0,320.0)];
    }
    else if(picture.size.width < 480.0 && picture.size.height >= 640.0){
        
        picture=[picture imageWithImage:picture scaledToSize:CGSizeMake(picture.size.width/6,320.0)];
        
    }
    else if(picture.size.width >= 640.0 && picture.size.height<480.0){
        
        picture=[picture imageWithImage:picture scaledToSize:CGSizeMake(320.0,picture.size.height/8)];
    }
    
    else if(picture.size.width >= 480.0 && picture.size.height >= 680.0){
        
        picture=[picture imageWithImage:picture scaledToSize:CGSizeMake(240.0,320.0)];
        
    }
    else if(picture.size.width >= 640.0 && picture.size.height >= 480.0){
        
        picture=[picture imageWithImage:picture scaledToSize:CGSizeMake(320.0,240.0)];
    }
}


- (IBAction)segmentChanged:(id)sender {
    
    NSInteger selectedSegment =[self.segmentControl selectedSegmentIndex];
    
    switch (selectedSegment) {
            
        case 0:{
            
            if (!self.assetsView) {
                
                self.assetsView=[AssetVC initWithAsset];
                
                self.assetsView.delegate=self;
                [self.scrollView addSubview:self.assetsView.view];
                [self.scrollView setContentSize:self.assetsView.view.frame.size];
//                self.assetsView.view.frame=CGRectMake(5.0, self.segmentControl.frame.origin.y+self.segmentControl.frame.size.height+5.0, 310, self.assetsView.view.frame.size.height-60.0);
            }
            [self.assetsView setScanCVPointer:self];
            self.assetsView.view.hidden=NO;
            self.questionView.view.hidden=YES;
            self.documentsView.view.hidden=YES;
            self.historyView.view.hidden=YES;
            self.mapView.view.hidden=YES;
           [[VSSharedManager sharedManager] setIsHistoryTab:FALSE];
          
            
            break;
        }
        case 1:{
            
            if (!self.questionView) {
                
                [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
   
                UserDTO*user=[[VSSharedManager sharedManager] currentUser];
                TicketDTO *ticket=[[VSSharedManager sharedManager] selectedTicket];
                TicketInfoDTO *ticketinfo =[[VSSharedManager sharedManager] selectedTicketInfo];
                [[WebServiceManager sharedManager] getQuetsions:[NSString stringWithFormat:@"%d",user.masterKey] assetID:ticket.assetID tikcetID:ticketinfo.tblTicketID withCompletionHandler:^(id data,BOOL error){
                    
                    [SVProgressHUD dismiss];
                    
                    if (!error) {
                    
                        
                        self.questionView=[ShowQuestionsVC initWithQuesitons:(NSMutableArray*)data history:self.historyArray];
                        self.questionView.delegate=self;
//                        [self.view addSubview:self.questionView.view];
                        [self.scrollView addSubview:self.questionView.view];
                        [self.scrollView setContentSize:self.questionView.view.frame.size];
//                        self.questionView.view.frame=CGRectMake(5.0, self.segmentControl.frame.origin.y+self.segmentControl.frame.size.height+5.0, 310, self.questionView.view.frame.size.height-60.0);
                    }
                    else{
                     
                        //[self initWithPromptTitle:@"Error" message:(NSString*)data];
                        
                        self.questionView=[ShowQuestionsVC initWithQuesitons:nil history:self.historyArray];
                        self.questionView.delegate=self;
                        [self.scrollView addSubview:self.questionView.view];
                        [self.scrollView setContentSize:self.questionView.view.frame.size];
//                        [self.view addSubview:self.questionView.view];
//                        self.questionView.view.frame=CGRectMake(5.0, self.segmentControl.frame.origin.y+self.segmentControl.frame.size.height+5.0, 310, self.questionView.view.frame.size.height-60.0);
                        
                    }
                }];
                
            }
            if (![[VSSharedManager sharedManager] isPreview]) {
                [self.questionView.submitButtonl setHidden:NO];
                
            }
            else {
                [self.questionView.submitButtonl setHidden:YES];
            }
            
            self.assetsView.view.hidden=YES;
            self.questionView.view.hidden=NO;
            self.documentsView.view.hidden=YES;
            self.historyView.view.hidden=YES;
            self.mapView.view.hidden=YES;
          [[VSSharedManager sharedManager] setIsHistoryTab:FALSE];
          
            
            break;
        }
        case 2:{
            
            if (!self.documentsView) {
                
                [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
   
                UserDTO*user=[[VSSharedManager sharedManager] currentUser];
                TicketDTO *ticket=[[VSSharedManager sharedManager] selectedTicket];
                
                
                [[WebServiceManager sharedManager] showDocuments:[NSString stringWithFormat:@"%d",user.masterKey] assetID:ticket.assetID withCompletionHandler:^(id data,BOOL error){
                    
                    [SVProgressHUD dismiss];
                    
                    if (!error) {
                        
                        self.documentsView=[DocumentsVC initWithDocumentWithArray:(NSArray*)data andDelegate:self];
                        [self.scrollView addSubview:self.documentsView.view];
                        [self.scrollView setContentSize:self.documentsView.view.frame.size];
//                        [self.view addSubview:self.documentsView.view];
//                        self.documentsView.view.frame=CGRectMake(5.0, self.segmentControl.frame.origin.y+self.segmentControl.frame.size.height+5.0, 310, self.documentsView.view.frame.size.height-60.0);
                    }
                    else
                        [self initWithPromptTitle:@"Error" message:(NSString*)data];
                    
                }];
            }
            else{
                
                UserDTO*user=[[VSSharedManager sharedManager] currentUser];
                TicketDTO *ticket=[[VSSharedManager sharedManager] selectedTicket];
                [[WebServiceManager sharedManager] showDocuments:[NSString stringWithFormat:@"%d",user.masterKey] assetID:ticket.assetID withCompletionHandler:^(id data,BOOL error){
                    
                    if (!error) {
                        
                        self.documentsView.documents=[NSArray arrayWithArray:(NSArray*)data];
                        [self.documentsView.documenTable reloadData];
                        
                    }
                    else
                        [self initWithPromptTitle:@"Error" message:(NSString*)data];
                    
                }];
                
                
            }
            self.assetsView.view.hidden=YES;
            self.questionView.view.hidden=YES;
            self.documentsView.view.hidden=NO;
            self.historyView.view.hidden=YES;
            self.mapView.view.hidden=YES;
          [[VSSharedManager sharedManager] setIsHistoryTab:FALSE];
          
            
            break;
        }
        case 3:{
            
            if (!self.historyView) {
                
                self.historyView=[HistoryVC initWithHistory];
                [self.scrollView addSubview:self.historyView.view];
                [self.scrollView setContentSize:self.historyView.view.frame.size];
//                [self.view addSubview:self.historyView.view];
//                self.historyView.view.frame=CGRectMake(5.0, self.segmentControl.frame.origin.y+self.segmentControl.frame.size.height+5.0, 310, self.historyView.view.frame.size.height-60.0);
                self.historyView.delegate=self;
            }
            
            [self.historyView getHistory];
            self.assetsView.view.hidden=YES;
            self.questionView.view.hidden=YES;
            self.documentsView.view.hidden=YES;
            self.historyView.view.hidden=NO;
            self.mapView.view.hidden=YES;
            [[VSSharedManager sharedManager] setIsHistoryTab:TRUE];
          
            
            break;
        }
        case 4:{
            if ([[[[VSSharedManager sharedManager] selectedTicketInfo] notes] length]>0) {
                 [self initWithPromptTitle:@"Ticket Notes" message:[[[VSSharedManager sharedManager] selectedTicketInfo] notes]];
              
            }
            else {
              
                [self initWithPromptTitle:@"Ticket Notes" message:@"---"];
            }
            [self.notesimageSign setImage:[UIImage imageNamed:@"checkmarkgreen.png"]];
            
            break;
        }
        default:
            break;
    }
}

- (IBAction)menuButtonPressed:(id)sender {
    if ([[VSSharedManager sharedManager] isPreview]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        if (self.questionView.isSubmited==NO && [self.questionView.questionArray count] >0) {
            
            [self initWithPromptTitle:@"Answer All Required Questions" message:@"Please answer all required questions"];
            
            return;
        }
        int count = 0;
        for (int i = 0; i<[self.assetsView.checkpointCheckArray count];i++) {
            if ([[self.assetsView.checkpointCheckArray objectAtIndex:i] boolValue]) {
                count++;
            }
        }
        if (!count == 0) {
            [self initWithPromptTitle:@"Scan Checkpoints" message:@"Please scan all check points"];
            return;
        }
        
        TicketInfoDTO *ticketInfoDTO = [[VSSharedManager sharedManager] selectedTicketInfo];
        
        if ([ticketInfoDTO.numberOfScans isEqualToString:@"1"])
            
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Closing Ticket"
                                                         message:@"Please confirm that you want to close this ticket"
                                                        delegate:self
                                               cancelButtonTitle:@"Cancel"
                                               otherButtonTitles:@"Ok",nil];
            [alert show];
            [alert release];
            //        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
        }
        else
        {
            if (self.count<2) {
                
                
                [self initWithPromptTitle:@"Needed Second Scan" message:@"You need a second scan to close this ticket"];
                
                return;
            }
    
            
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Closing Ticket"
                                                         message:@"Please confirm that you want to close this ticket"
                                                        delegate:self
                                               cancelButtonTitle:@"Cancel"
                                               otherButtonTitles:@"Ok",nil];
            [alert show];
            [alert release];
        }
    }
}


- (IBAction)nextScanButtonPressed:(id)sender {
    
}

- (IBAction)SecondScanButtonPressed:(id)sender {
    
    
    // self.currentScannedCode =@"uestotc5mdq0mc0wmdaxltawmdetmdawmq==";
        
    // self.currentScannedCode =@"uestmda3ltawmditmdawms0wmdax";
    // [self scanTicket];
    // [self showQrScanner];

    self.isScanning = TRUE;
    if (!_scanQRManager) {
         _scanQRManager = [[ScanQRManager alloc] init];
    }
   
    [self.view addSubview:self.scanQRManager.view];
    [_scanQRManager showQrScanner];

}

- (IBAction)onClickSuspend:(id)sender {
    
    CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] init];
    [self.alertText setText:@""];
    // Add some custom content to the alert view
    [alertView setContainerView:[self createDemoView:@"Please enter reason to suspend a ticket"]];
    // Modify the parameters
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"Cancel", @"OK", nil]];
    //        [alertView setDelegate:self];
    
    // You may use a Block, rather than a delegate.
    [alertView setOnButtonTouchUpInside:^(CustomIOS7AlertView *alertView, int buttonIndex) {
        NSString* detailString = [self.alertText text];
        NSLog(@"String is: %@", detailString); //Put it on the debugger
        if ( buttonIndex == 0){
            return; //If cancel or 0 length string the string doesn't matter
        }
        if (buttonIndex == 1 && [detailString length]>0) {

            UserDTO*user=[[VSSharedManager sharedManager] currentUser];
            TicketInfoDTO *selectedTicketInfo = [[VSSharedManager sharedManager] selectedTicketInfo];
            
            //
             NSString *startDateString=[WSUtils getStringFormCurrentDate];
             NSString *userID =  [[NSUserDefaults standardUserDefaults] valueForKey:@"userID"];
            [SVProgressHUD show];
            [[WebServiceManager sharedManager] suspendTicket:[NSString stringWithFormat:@"%d",user.masterKey] ticketID:selectedTicketInfo.tblTicketID stopTime:startDateString StopReason:detailString userID:userID withCompletionHandler:^(id data, BOOL error) {
                
                [SVProgressHUD dismiss];
                
                if (!error) {
                    
                    [self.navigationController popViewControllerAnimated:YES];
                }
                
            }];
            
        }
        [alertView close];
    }];
    
    [alertView setUseMotionEffects:true];
    
    // And launch the dialog
    [alertView show];
    

}
-(void)assetScanNotification:(NSNotification*)notif {
    self.isScanning = TRUE;
    if (!_scanQRManager) {
        _scanQRManager = [[ScanQRManager alloc] init] ;
    }
    
    [self.view addSubview:self.scanQRManager.view];
    [_scanQRManager showQrScanner];
}

-(void)scanTicket
{
    if (self.isScanning) {
        self.isScanning = FALSE;
        if (self.assetsView && self.assetsView.isAssetScan) {
            CheckPointDTO * checkPointDTO = [[[[VSSharedManager sharedManager] selectedTicket] checkPoints] objectAtIndex:self.assetsView.currentPressedScanTag];
            if ([[[VSSharedManager sharedManager]selectedTicketInfo] allow_id_card_scan]) {
                if ([[self.currentScannedCode lowercaseString] isEqualToString:checkPointDTO.qr_code] || [[self.currentScannedCode lowercaseString] isEqualToString:[[[VSSharedManager sharedManager] currentUser] employee_card_id]]) {
                    [SVProgressHUD show];
                    TicketInfoDTO *ticket=[[VSSharedManager sharedManager] selectedTicketInfo];
                    CLLocation *lasKnownLocation=[[VSLocationManager sharedManager] lastKnownLocation];
                    UserDTO *user=[[VSSharedManager sharedManager] currentUser];
                    TicketDTO * ticketDTO = [[VSSharedManager sharedManager] selectedTicket];
                    [[WebServiceManager sharedManager] scanCheckPointTicket:ticket.tblTicketID assetID:ticketDTO.assetID latitude:[NSString stringWithFormat:@"%.7f",lasKnownLocation.coordinate.latitude] longitude:[NSString stringWithFormat:@"%.7f",lasKnownLocation.coordinate.longitude] masterKey:[NSString stringWithFormat:@"%d", user.masterKey] userName:[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"] checkPointID:checkPointDTO.checkpoint_id withCompletionHandler:^(id data, BOOL error){
                        if (!error) {
                            [SVProgressHUD dismissWithSuccess:@"Check Point Scanned Successfully"];
                            [self.assetsView setIsAssetScan:FALSE];
                            [self.assetsView.checkpointCheckArray replaceObjectAtIndex:self.assetsView.currentPressedScanTag withObject:[NSString stringWithFormat:@"%@",[NSNumber numberWithBool:FALSE]]];
                            [self.assetsView.serviceTable reloadData];
                        }
                        else {
                            [SVProgressHUD dismiss];
                            [self initWithPromptTitle:@"Error" message:(NSString *)data];
                        }
                        
                    }];
                    
                }
                else
                {
                    [self initWithPromptTitle:@"Wrong Asset" message:@"You have scanned a wrong asset"];
                    
                    return;
                    
                }
                
                
                
            }
            else {
                //            if (![[@"mjaxmzk5nduwmtky" lowercaseString] isEqualToString:checkPointDTO.qr_code]) {
                
                if (![[self.currentScannedCode lowercaseString] isEqualToString:checkPointDTO.qr_code]) {
                    
                    [self initWithPromptTitle:@"Wrong Asset" message:@"You have scanned a wrong asset"];
                    
                    return;
                }
                else
                {
                    [SVProgressHUD show];
                    TicketInfoDTO *ticket=[[VSSharedManager sharedManager] selectedTicketInfo];
                    CLLocation *lasKnownLocation=[[VSLocationManager sharedManager] lastKnownLocation];
                    UserDTO *user=[[VSSharedManager sharedManager] currentUser];
                    TicketDTO * ticketDTO = [[VSSharedManager sharedManager] selectedTicket];
                    [[WebServiceManager sharedManager] scanCheckPointTicket:ticket.tblTicketID assetID:ticketDTO.assetID latitude:[NSString stringWithFormat:@"%.7f",lasKnownLocation.coordinate.latitude] longitude:[NSString stringWithFormat:@"%.7f",lasKnownLocation.coordinate.longitude] masterKey:[NSString stringWithFormat:@"%d", user.masterKey] userName:[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"] checkPointID:checkPointDTO.checkpoint_id withCompletionHandler:^(id data, BOOL error){
                        if (!error) {
                            [SVProgressHUD dismissWithSuccess:@"Check Point Scanned Successfully"];
                            [self.assetsView setIsAssetScan:FALSE];
                            [self.assetsView.checkpointCheckArray replaceObjectAtIndex:self.assetsView.currentPressedScanTag withObject:[NSString stringWithFormat:@"%@",[NSNumber numberWithBool:FALSE]]];
                            [self.assetsView.serviceTable reloadData];
                        }
                        else {
                            [SVProgressHUD dismiss];
                            [self initWithPromptTitle:@"Error" message:(NSString *)data];
                        }
                        
                    }];
                }
            }
            
        }
        else {
            DLog(@"Self.CurrentCode %@",self.currentScannedCode);
            
            TicketDTO *ticketAsset=[[VSSharedManager sharedManager] selectedTicket];
            
            if ([[[VSSharedManager sharedManager]selectedTicketInfo] allow_id_card_scan]) {
                if ([[self.currentScannedCode lowercaseString] isEqualToString:[ticketAsset.assetCode lowercaseString]] || [[self.currentScannedCode lowercaseString] isEqualToString:[[[VSSharedManager sharedManager] currentUser] employee_card_id]] ) {
                    [SVProgressHUD show];
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
                                                
                                                //  self.view.userInteractionEnabled=YES;
                                                [SVProgressHUD dismissWithSuccess:@"Ticket Scanned Successfully"];
                                                if ([[VSSharedManager sharedManager] isPreview]) {
                                                    [[VSSharedManager sharedManager] setIsPreview:FALSE];
                                                    [self timerRepeat];
                                                    self.startTimer = [NSTimer scheduledTimerWithTimeInterval:60.0
                                                                       
                                                                                                       target:self
                                                                       
                                                                                                     selector:@selector(timerRepeat)
                                                                       
                                                                                                     userInfo:nil
                                                                       
                                                                                                      repeats:YES];
                                                    if (!error)
                                                    {
                                                        [self.backButton setTitle:@"CLOSE TICKET" forState:UIControlStateNormal];
                                                        TicketInfoDTO *ticketInfoDTO = [[VSSharedManager sharedManager] selectedTicketInfo];
                                                        if (![ticketAsset.assetType isEqualToString:@"inspection"])
                                                        {
                                                            [[VSLocationManager sharedManager] setAssetID:ticketAsset.assetID];
                                                        }
                                                        if ([ticketInfoDTO.numberOfScans isEqualToString:@"2"] ) {
                                                            
                                                            self.btnSecondScan.hidden = NO;
                                                            self.isSecondScan = YES;
                                                        }
                                                        else if ([ticketInfoDTO.numberOfScans isEqualToString:@"1"])
                                                        {
                                                            self.isSecondScan =NO;
                                                            self.btnSecondScan.hidden = NO;
                                                        }
                                                        
                                                        if([[ticketInfoDTO.ticketStatus lowercaseString] isEqualToString:@"pending"])
                                                        {
                                                            self.isSecondScan =NO;
                                                            self.btnSecondScan.hidden = NO;
                                                            
                                                        }
                                                        
                                                        if ([[ticketInfoDTO.ticketStatus lowercaseString] isEqualToString:@"suspended"]) {
                                                            
                                                            UserDTO*user=[[VSSharedManager sharedManager] currentUser];
                                                            NSString *startDateString=[WSUtils getStringFormCurrentDate];
                                                            NSString *userID =  [[NSUserDefaults standardUserDefaults] valueForKey:@"userID"];
                                                            [SVProgressHUD show];
                                                            
                                                            [[WebServiceManager sharedManager] restartTicket:[NSString stringWithFormat:@"%d",user.masterKey] ticketID:ticketInfoDTO.tblTicketID restartTime:startDateString userID:userID withCompletionHandler:^(id data, BOOL error) {
                                                                
                                                                [SVProgressHUD dismiss];
                                                                if (!error) {
                                                                    
                                                                    
                                                                }
                                                            }];

                                                        }
                                                        
                                                    }
                                                }
                                                else {
                                                    self.count++;
                                                    if (!error)
                                                    {
                                                        if (![ticketAsset.assetType isEqualToString:@"inspection"])
                                                        {
                                                            [[VSLocationManager sharedManager] setAssetID:ticketAsset.assetID];
                                                        }
                                                        
                                                    }
                                                    else
                                                    {
                                                        [self initWithPromptTitle:@"Error" message:(NSString *)data];
                                                    }
                                                }
                                                [self.assetsView.serviceTable reloadData];
                                                
                                            }];
                    
                }
                else
                {
                    [self initWithPromptTitle:@"Wrong Asset" message:@"You have scanned a wrong asset"];
                    
                    return;
                    
                }
                
            }
            else {
                if (![[self.currentScannedCode lowercaseString] isEqualToString:[ticketAsset.assetCode lowercaseString]]) {
                    
                    [self initWithPromptTitle:@"Wrong Asset" message:@"You have scanned a wrong asset"];
                    
                    return;
                }
                else
                {
                    
                    [SVProgressHUD show];
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
                                                
                                                //  self.view.userInteractionEnabled=YES;
                                                [SVProgressHUD dismissWithSuccess:@"Ticket Scanned Successfully"];
                                                if ([[VSSharedManager sharedManager] isPreview]) {
                                                    [[VSSharedManager sharedManager] setIsPreview:FALSE];
                                                    if (!error)
                                                    {
                                                        [self.backButton setTitle:@"CLOSE TICKET" forState:UIControlStateNormal];
                                                        TicketInfoDTO *ticketInfoDTO = [[VSSharedManager sharedManager] selectedTicketInfo];
                                                        if (![ticketAsset.assetType isEqualToString:@"inspection"])
                                                        {
                                                            [[VSLocationManager sharedManager] setAssetID:ticketAsset.assetID];
                                                        }
                                                        if ([ticketInfoDTO.numberOfScans isEqualToString:@"2"] ) {
                                                            
                                                            self.btnSecondScan.hidden = NO;
                                                            self.isSecondScan = YES;
                                                        }
                                                        else if ([ticketInfoDTO.numberOfScans isEqualToString:@"1"])
                                                        {
                                                            self.isSecondScan =NO;
                                                            self.btnSecondScan.hidden = NO;
                                                        }
                                                        
                                                        if([[ticketInfoDTO.ticketStatus lowercaseString] isEqualToString:@"pending"])
                                                        {
                                                            self.isSecondScan =NO;
                                                            self.btnSecondScan.hidden = NO;
                                                            
                                                        }
                                                        
                                                    }
                                                }
                                                else {
                                                    self.count++;
                                                    if (!error)
                                                    {
                                                        if (![ticketAsset.assetType isEqualToString:@"inspection"])
                                                        {
                                                            [[VSLocationManager sharedManager] setAssetID:ticketAsset.assetID];
                                                        }
                                                    }
                                                    else
                                                    {
                                                        [self initWithPromptTitle:@"Error" message:(NSString *)data];
                                                    }
                                                }
                                                [self.assetsView.serviceTable reloadData];
                                                
                                            }];
                }
                
                
            }
            
        }
    }
    
    
    
    
}
//*****************************************Reading Pdf*************************************************

#pragma mark- DocumentDelegate
-(void)selectedFileWithPath:(NSString *)filePath{
    
    DLog(@"file Path %@",filePath);
    
    
    if ([self fileExistsAtAbsolutePath:[NSString stringWithFormat:@"%@%@",DEST_PATH,[filePath lastPathComponent]]]) {
        
        [self readPdfFileAtPath:[filePath lastPathComponent]];
        ////Display that file
    }else{
        
        self.savePath=[NSString stringWithFormat:@"%@%@",DEST_PATH,[filePath lastPathComponent]];
        DownloadVC *downloadVC=[DownloadVC initWithDownloadPath:filePath andDelegate:self];
        [downloadVC showInViewController:self];
        
    }
}

-(void)uploadPDFWithFilePath:(NSURL *)filePath
{
    
    NSData *fileData = [[NSData alloc] initWithContentsOfURL:filePath];

    if (!filePath) {
        return;
    }
    
    UserDTO*user=[[VSSharedManager sharedManager] currentUser];
    [SVProgressHUD showWithStatus:@"Uploading..." maskType:SVProgressHUDMaskTypeBlack];
    [[WebServiceManager sharedManager] uploadPdf:[NSString stringWithFormat:@"%d",user.masterKey]
                                       historyID:[[VSSharedManager sharedManager] historyID]
                                     contentType:@"application/pdf"
                                         pdfData:fileData
                                    // pdfFilePath:filePath
                                     progressBar:self.myProgressIndicator
                           withCompletionHandler:^(id data,BOOL error){
                               
                               [SVProgressHUD dismiss];
                               //  self.view.userInteractionEnabled=YES;
                               
                               [self.myProgressIndicator removeFromSuperview];
                               if (!error)
                                   [self initWithPromptTitle:@"Document Uploaded" message:@"Document uploaded successfully"];
                               else{
                                   [self initWithPromptTitle:@"Error" message:(NSString *)data];
                               }
                               
                           }];

}
-(void)readPdfFileAtPath:(NSString *)filePath{
    
    
    NSString *path;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    path = [[paths objectAtIndex:0] stringByAppendingPathComponent:filePath];
    assert(path != nil); // Path to last PDF file
//    NSString * tempString = [filePath stringByReplacingOccurrencesOfString:@".pdf" withString:@""];
    if([[filePath lowercaseString] rangeOfString:@".pdf"].length>0) {
        if ([SharedManager getInstance].isEditable) {
         
//            UserDTO*user=[[VSSharedManager sharedManager] currentUser];
//            TicketInfoDTO *selectedTicketInfo = [[VSSharedManager sharedManager] selectedTicketInfo];
//            
//            NSString *userMasterKey = [NSString stringWithFormat:@"%d", user.masterKey];
//            NSString *ticketID = selectedTicketInfo.tblTicketID;
//            
//            long currentTime = (long)[[NSDate date] timeIntervalSince1970];
//    
//            NSString *fileName = [NSString stringWithFormat:@"%@_%@_%ld.pdf",userMasterKey,ticketID,currentTime];
//            NSString *newFilePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:fileName];
//            NSError *error = nil;
//            
//            [[NSFileManager defaultManager] copyItemAtPath:path toPath:newFilePath error:&error];
//            
            
            //if (!error) {
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    self.docController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:path]];
                    self.navigationController.toolbarHidden = YES;
                    BOOL isValid = [self.docController presentOpenInMenuFromRect:CGRectZero inView:self.view animated:YES];
                    
                    if (isValid) {
                        
                        NSLog(@"yeahhh");
                    }
                    else{
                        
                        NSLog(@"False");
                    }

                });
                
            //}
            
            
            /*
            self.pdfViewController = [[PDFViewController alloc] initWithPath:path];
            UINavigationController * navigationController = [[UINavigationController alloc] initWithRootViewController:self.pdfViewController];
            navigationController.view.autoresizingMask =  UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin;
            navigationController.navigationBar.translucent = NO;
            UIBarButtonItem* saveBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(save:)];
            
            [self.pdfViewController.navigationItem setRightBarButtonItems:@[saveBarButtonItem]];
            [self presentViewController:navigationController animated:YES completion:nil];*/
        }
        else {
            [self openPDFWithPath:path];
        }
        
    }
    else {
        [self.navigationController pushViewController:[AboutUsLinksVC initWithFile:path] animated:YES];
    }
    
	   
}
//*****************************************************************//


#pragma mark- DownloadVC Delegate
-(void)fileDownloadedSuccessfullyWithPath:(NSString *)savedPath{
    
    if([[savedPath lowercaseString] rangeOfString:@".pdf"].length>0)
    {
        [self readPdfFileAtPath:savedPath];
    }
    else if([[savedPath lowercaseString] rangeOfString:@".mp4"].length>0)
    {
        if ([self.videoArray count]<[self.receivedArray count]) {
            [self downloadVideoWithURL:self.receivedArray];
        }
        else {
            if ([self fileExistsAtAbsolutePath:[_videoArray objectAtIndex:0]]) {
                NSMutableArray * tempArray = [NSMutableArray array];
                for (int i =0; i<[_videoArray count]; i++) {
                    [tempArray addObject:[NSString stringWithFormat:@"Video %d",i+1]];
                }
                [MMPickerView showPickerViewInView:self.view
                                       withStrings:tempArray
                                       withOptions:nil
                                        completion:^(NSString *selectedString) {
                                            
                                            int i =   [tempArray indexOfObject:selectedString];
                                            [self openVideoWithPath:[_videoArray objectAtIndex:i]];
                                        }];
                
                //           [self openVideoWithPath:[_videoArray objectAtIndex:0]];
                ////Display that file
            }
//            NSString *path;
//            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//            path = [[paths objectAtIndex:0] stringByAppendingPathComponent:savedPath];
//            assert(path != nil); // Path to last Video file
//            
//            [self openVideoWithPath:path];
        }
       
        
    }
    else if([[savedPath lowercaseString] rangeOfString:@".caf"].length>0  || [[savedPath lowercaseString] rangeOfString:@".mp3"].length>0)
    {
    
        if ([self.audioArray count]<[self.receivedArray count]) {
            [self downloadAudioWithURL:self.receivedArray];
        }
        else {
            NSString *path;
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            path = [[paths objectAtIndex:0] stringByAppendingPathComponent:savedPath];
            assert(path != nil); // Path to last audio file
            
            [self.navigationController pushViewController:[AudioPlayerVC initWithAudioPlayer:self.audioArray] animated:YES];
        }
        
        
    }
    else {
        [self readPdfFileAtPath:savedPath];
    }
}


#pragma mark- ShowQuestions Delegate

-(void)videoButtonPressed{
    
    [self showCamera];
}
-(void)audioButtonPressed{
    
    [self.navigationController pushViewController:[VoiceRecordViewController initWithRecording] animated:YES];
}
-(void)notesButtonPressed{
//    if ([self.self.historyView.historyArray count]>0) {
//        HistoryDTO *historyData=[self.historyView.historyArray objectAtIndex:0];
//        [self.navigationController pushViewController:[NotesVC initWithCompontentNotes:historyData.notes] animated:YES];
//    }
//    else {
        [self.navigationController pushViewController:[NotesVC initWithNotes] animated:YES];
//    }
    
    
}
-(void)allQuestionsAnswered{
  
  [self.questionsimageSign setImage:[UIImage imageNamed:@"checkmarkgreen.png"]];
  
  
}



-(void)uploadImagePressed{
    
    UIActionSheet *sheet=[[UIActionSheet alloc] initWithTitle:@"Share Image" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Camera" otherButtonTitles:@"Library",nil];
    [sheet showInView:self.view];
    [sheet release];
}


#pragma mark- HistoryVCDelegate

-(void)showNotes:(NSArray *)notes
{
    //push notes view
    [self.navigationController pushViewController:[NotesVC initWithCompontentNotes:notes] animated:YES];
}

-(void)downloadVideoWithURL:(NSArray *)path
{
    [_videoArray removeAllObjects];
    _receivedArray = path;
     NSMutableArray * tempArray = [[[NSMutableArray alloc] initWithObjects:nil] autorelease];
    for (int i = 0; i<[path count]; i++) {
        if ([self fileExistsAtAbsolutePath:[NSString stringWithFormat:@"%@%@",DEST_PATH,[[[path objectAtIndex:i] objectForKey:@"video"] lastPathComponent]]]) {
            [_videoArray addObject:[NSString stringWithFormat:@"%@%@",DEST_PATH,[[[path objectAtIndex:i] objectForKey:@"video"] lastPathComponent]]];
        }
        else {
            [tempArray addObject:[path objectAtIndex:i]];
        }
    }
    if ([tempArray count]>0) {
        //        for (int i = 0; i<[_audioArray count]; i++) {
        self.savePath=[NSString stringWithFormat:@"%@%@",DEST_PATH,[[[tempArray objectAtIndex:0] objectForKey:@"video"] lastPathComponent]];
        DownloadVC *downloadVC=[DownloadVC initWithDownloadPath:[[tempArray objectAtIndex:0] objectForKey:@"video"] andDelegate:self];
        [downloadVC showInViewController:self];
        //        }
    }
    else {
        if ([self fileExistsAtAbsolutePath:[_videoArray objectAtIndex:0]]) {
            NSMutableArray * tempArray = [NSMutableArray array];
            for (int i =0; i<[_videoArray count]; i++) {
                [tempArray addObject:[NSString stringWithFormat:@"Video %d",i+1]];
            }
            [MMPickerView showPickerViewInView:self.view
                                   withStrings:tempArray
                                   withOptions:nil
                                    completion:^(NSString *selectedString) {
                                        
                                      int i =   [tempArray indexOfObject:selectedString];
                                        [self openVideoWithPath:[_videoArray objectAtIndex:i]];
                                    }];
            
//           [self openVideoWithPath:[_videoArray objectAtIndex:0]];
            ////Display that file
        }
        //            else{
        
    }
//    if ([self fileExistsAtAbsolutePath:[NSString stringWithFormat:@"%@%@",DEST_PATH,[path lastPathComponent]]]) {
//        
//        [self openVideoWithPath:[NSString stringWithFormat:@"%@%@",DEST_PATH,[path lastPathComponent]]];
//        ////Display that file
//    }else{
//        
//        self.savePath=[NSString stringWithFormat:@"%@%@",DEST_PATH,[path lastPathComponent]];
//        DownloadVC *downloadVC=[DownloadVC initWithDownloadPath:path andDelegate:self];
//        [downloadVC showInViewController:self];
//        
//    }

    
}

-(void)downloadAudioWithURL:(NSArray *)path
{
    [_audioArray removeAllObjects];
    _receivedArray = path;
    NSMutableArray * tempArray = [[[NSMutableArray alloc] initWithObjects:nil] autorelease];
    for (int i = 0; i<[path count]; i++) {
        if ([self fileExistsAtAbsolutePath:[NSString stringWithFormat:@"%@%@",DEST_PATH,[[[path objectAtIndex:i] objectForKey:@"audio"] lastPathComponent]]]) {
            [_audioArray addObject:[NSString stringWithFormat:@"%@%@",DEST_PATH,[[[path objectAtIndex:i] objectForKey:@"audio"] lastPathComponent]]];
        }
        else {
            [tempArray addObject:[path objectAtIndex:i]];
        }
    }
    if ([tempArray count]>0) {
//        for (int i = 0; i<[_audioArray count]; i++) {
            self.savePath=[NSString stringWithFormat:@"%@%@",DEST_PATH,[[[tempArray objectAtIndex:0] objectForKey:@"audio"] lastPathComponent]];
            DownloadVC *downloadVC=[DownloadVC initWithDownloadPath:[[tempArray objectAtIndex:0] objectForKey:@"audio"] andDelegate:self];
            [downloadVC showInViewController:self];
//        }
    }
    else {
        if ([self fileExistsAtAbsolutePath:[_audioArray objectAtIndex:0]]) {
            
            [self.navigationController pushViewController:[AudioPlayerVC initWithAudioPlayer:_audioArray] animated:YES];
            ////Display that file
        }
//            else{

    }
//    if ([self fileExistsAtAbsolutePath:[NSString stringWithFormat:@"%@%@",DEST_PATH,[path lastPathComponent]]]) {
//        
//        [self.navigationController pushViewController:[AudioPlayerVC initWithAudioPlayer:[NSString stringWithFormat:@"%@%@",DEST_PATH,[path lastPathComponent]]] animated:YES];
//        ////Display that file
//    }else{
//
//        self.savePath=[NSString stringWithFormat:@"%@%@",DEST_PATH,[path lastPathComponent]];
//        DownloadVC *downloadVC=[DownloadVC initWithDownloadPath:path andDelegate:self];
//        [downloadVC showInViewController:self];
//
//    }
}

-(void)downloadImageWithURL:(NSArray *)path
{
    [self.navigationController pushViewController:[ImageViewVC initWithURL:path] animated:YES];
}

#pragma mark- action Sheet Delegate

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
//**********************Video Recording******************************//

-(void)showCamera{
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIImagePickerController *videoRecorder = [[UIImagePickerController alloc]init];
        NSArray *sourceTypes = [UIImagePickerController availableMediaTypesForSourceType:videoRecorder.sourceType];
        DLog(@"Available types for source as camera = %@", sourceTypes);
        if (![sourceTypes containsObject:(NSString*)kUTTypeMovie] ) {
            [self initWithPromptTitle:@"Device Not Supported" message:@"Device not supported for video recording"];
            return;
        }
        
        videoRecorder.sourceType = UIImagePickerControllerSourceTypeCamera;
        videoRecorder.mediaTypes = [NSArray arrayWithObject:(NSString*)kUTTypeMovie];
        videoRecorder.videoQuality = UIImagePickerControllerQualityTypeLow;
        videoRecorder.videoMaximumDuration = 120;
        videoRecorder.delegate = self;
        self.recoder=videoRecorder;
        [videoRecorder release];
        
        [self presentViewController:self.recoder animated:YES completion:nil];

    }
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
       // [self presentModalViewController:imagePickerController animated:YES];
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }
    else
    {
        //show alert
        [self initWithPromptTitle:@"Source not avaliable" message:@"Source is not avaliable"];
    }
}
#pragma mark- UIImagePicker Delegate


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([type isEqualToString:(NSString *)kUTTypeVideo] ||[type isEqualToString:(NSString *)kUTTypeMovie]) { // movie != video
        
        NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
        NSData *videoData = [NSData dataWithContentsOfURL:videoURL];
        //You can store the path of the saved video file in sqlite/coredata here.
      
    //  http://stackoverflow.com/questions/20282672/record-save-and-or-convert-video-in-mp4-format
      
//      if (CFStringCompare ((__bridge_retained CFStringRef) mediaType, kUTTypeMovie, 0) == kCFCompareEqualTo)
//      {
//        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(moviePath))
//        {
//          NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//          NSString *moviePath = [[info objectForKey:UIImagePickerControllerMediaURL] path];
//          NSString *videoPath1 =[NSString stringWithFormat:@"%@/xyz.mov",docDir];
//          NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
//          NSData *videoData = [NSData dataWithContentsOfURL:videoURL];
//          [videoData writeToFile:videoPath1 atomically:NO];
//          //  UISaveVideoAtPathToSavedPhotosAlbum(moviePath, self, nil, nil);
//        }
//      }
//      
//      AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:videoPath1] options:nil];
//      NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
//      
//      if ([compatiblePresets containsObject:AVAssetExportPresetLowQuality])
//      {
//        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]initWithAsset:avAsset presetName:AVAssetExportPresetPassthrough];
//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//        videoPath = [NSString stringWithFormat:@"%@/xyz.mp4", [paths objectAtIndex:0]];
//        exportSession.outputURL = [NSURL fileURLWithPath:videoPath];
//        NSLog(@"videopath of your mp4 file = %@",videoPath);  // PATH OF YOUR .mp4 FILE
//        exportSession.outputFileType = AVFileTypeMPEG4;
//        
//        //  CMTime start = CMTimeMakeWithSeconds(1.0, 600);
//        //  CMTime duration = CMTimeMakeWithSeconds(3.0, 600);
//        //  CMTimeRange range = CMTimeRangeMake(start, duration);
//        //   exportSession.timeRange = range;
//        //  UNCOMMENT ABOVE LINES FOR CROP VIDEO
//        [exportSession exportAsynchronouslyWithCompletionHandler:^{
//          
//          switch ([exportSession status]) {
//              
//            case AVAssetExportSessionStatusFailed:
//              NSLog(@"Export failed: %@", [[exportSession error] localizedDescription]);
//              
//              break;
//              
//            case AVAssetExportSessionStatusCancelled:
//              
//              NSLog(@"Export canceled");
//              
//              break;
//              
//            default:
//              
//              break;
//              
//          }
//          UISaveVideoAtPathToSavedPhotosAlbum(videoPath, self, nil, nil);
//          [exportSession release];
//          
//        }];
//        
//      }
      
        self.myProgressIndicator=[[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
        self.myProgressIndicator.frame=CGRectMake(10, 260, 300, 14);
        [self.view addSubview:self.myProgressIndicator];
        
       
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];

        UserDTO*user=[[VSSharedManager sharedManager] currentUser];
        
        [[WebServiceManager sharedManager] uploadVideo:[NSString stringWithFormat:@"%d",user.masterKey]
                                             historyID:[[VSSharedManager sharedManager] historyID]
                                           contentType:[self fileMIMEType:(NSString *)videoURL]
                                             videoData:videoData progressBar:self.myProgressIndicator
                                 withCompletionHandler:^(id data,BOOL error){
            
                                     [SVProgressHUD dismiss];
                                     self.view.userInteractionEnabled=YES;
            
                                     [self.myProgressIndicator removeFromSuperview];
                                     if (!error)
                                         [self initWithPromptTitle:@"Video Uploaded" message:@"Video uploaded successfully"];
                                     else
                                         [self initWithPromptTitle:@"Error" message:(NSString *)data];
            
            
        }];
        
    }else{
        
        UIImage *image =[info objectForKey:@"UIImagePickerControllerOriginalImage"];
        image=[image fixOrientation];
        image=[image imageWithImage:image scaledToSize:CGSizeMake(320,240)];
        
        [self setImageAspectRatio:image];
//        NSData *imageData = UIImagePNGRepresentation(image);
        NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
        
        
        
        NSString *path;
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"image.jpeg"];
        
       __block NSError *fileError;
        //if file already exist on that path remove that file and then save new on that path
        [[NSFileManager defaultManager] removeItemAtPath:path error:&fileError];
        [[NSFileManager defaultManager] createFileAtPath:path
                                                contents:imageData
                                              attributes:nil];
        
        
        ///////////Tell os not to back up /////////////////////////////////
        [self addSkipBackupAttributeToItemAtURL:[NSURL URLWithString:path]];
        ///////////////////////////////////////////////////////////////////

        
        self.myProgressIndicator=[[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
        self.myProgressIndicator.frame=CGRectMake(10, 260, 300, 14);
        [self.view addSubview:self.myProgressIndicator];
        
        
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];

        UserDTO*user=[[VSSharedManager sharedManager] currentUser];
        
        [[WebServiceManager sharedManager] uploadImage:[NSString stringWithFormat:@"%d",user.masterKey]
                                             historyID:[[VSSharedManager sharedManager] historyID]
                                           contentType:[self fileMIMEType:path]
                                             imageData:imageData
                                           progressBar:self.myProgressIndicator
                                 withCompletionHandler:^(id data,BOOL error){
            
            [SVProgressHUD dismiss];
          //  self.view.userInteractionEnabled=YES;
            
            [self.myProgressIndicator removeFromSuperview];
            if (!error)
                [self initWithPromptTitle:@"Image Uploaded" message:@"Image uploaded successfully"];
            else{
                [self initWithPromptTitle:@"Error" message:(NSString *)data];
            }
    
            
            [[NSFileManager defaultManager] removeItemAtPath:path error:&fileError];
            
        }];
    }
    
}
////////////////////////////////////////////////////////////////

#pragma mark- AlertView Delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([alertView tag] == -922) {
        if (buttonIndex == 1) {
            [[SharedManager getInstance] setIsMessage:FALSE];
            
            
            [self.navigationController pushViewController:[MessageCentreVC initWithMessageCentre] animated:YES];
        }
        
    }
    else {
        if (buttonIndex==1) {
            
            
            TicketInfoDTO *selectedTicketInfo = [[VSSharedManager sharedManager] selectedTicketInfo];
            UserDTO * userdto = [[VSSharedManager sharedManager] currentUser];
            //        if ([selectedTicketInfo.numberOfScans isEqualToString:@"2"])
            //
            //        {
            
            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
            
            [[WebServiceManager sharedManager] closeTicket:[[VSSharedManager sharedManager] historyID] ticketID:selectedTicketInfo.tblTicketID technician:selectedTicketInfo.technicain employer:userdto.masterKey withCompletionHandler:^(id data, BOOL error){
                
                [SVProgressHUD dismiss];
                
                if (!error) {
                    
                    [[VSLocationManager sharedManager] setAssetID:@"0"];
                    
                    [self.navigationController pushViewController:[PaymentVC initWithPayment] animated:YES];
                    
                }else{
                    
                    [self initWithPromptTitle:@"Network Error" message:@"Check your internet connection"];
                }
                
            }];
            //        }
            //        else
            //            [self.navigationController pushViewController:[PaymentVC initWithPayment] animated:YES];
        }
    }
    
    
}


#pragma -mark assetDelegate
-(void)partButtonPressed:(ServiceDTO *)components{

    ///Push component VC
    
    [self.navigationController pushViewController:[ComponentsVC initWithComponents:components] animated:YES];
}

#pragma mark- NSNotification Center

-(void)updateCode:(NSNotification *)info{
    
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
    
        self.currentScannedCode = (NSString *)[info object];
        [self scanTicket];
        [self removeQRView];
        
        self.view.userInteractionEnabled = YES;
    });
}

-(void)cancelTab:(NSNotification*)info
{
    dispatch_async(dispatch_get_main_queue(), ^{
    
        [self removeQRView];
        
        self.view.userInteractionEnabled = YES;
    });
}

-(void)sharePDF:(NSNotification *)notif{

    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSURL *url =(NSURL *) [notif object];
        [self uploadPDFWithFilePath:url];
    });
}

-(void)removeQRView{
    
   
   
    if (_scanQRManager)
    {
       
        _scanQRManager.view.hidden = YES;
         [_scanQRManager.view removeFromSuperview];
//        self.scanQRManager = nil;
    }
 
    self.view.userInteractionEnabled = YES;
}

-(void)messageNotification:(NSNotification*)notif {
//    UIAlertView * tempAlert = [[[UIAlertView alloc]initWithTitle:@"New Message" message:@"Press OK to view message" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil] autorelease];
//    [tempAlert setTag:-922];
//    [tempAlert show];
}

#pragma mark- TableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    if ([self.tickets count]>0) {
    
        
        TicketCell *cell=[TicketCell resuableCellForTableView:self.tableView withOwner:self];
        cell.indexPath=indexPath;
  //  VSSharedManager * temp = [VSSharedManager sharedManager];
    NSInteger tempint = [[VSSharedManager sharedManager] CurrentSelectedIndex];
        [cell updateCellWithTicket:[[VSSharedManager sharedManager] selectedTicket] index:tempint];
//    [cell.mapButton setHidden:YES];
        [cell. mapButton addTarget:self action:@selector(showDirections) forControlEvents:UIControlEventTouchUpInside];
        //        [cell.mapButton addTarget: self
        //                           action: @selector(accessoryButtonTapped:withEvent:)
        //                 forControlEvents: UIControlEventTouchUpInside];
        //
        //        [cell.scanButton addTarget: self
        //                            action: @selector(accessoryButtonTapped:withEvent:)
        //                  forControlEvents: UIControlEventTouchUpInside];
        
        cell.callButton.hidden = YES;
        cell.scanButton.hidden = YES;
        //        cell.mapButton.hidden = YES;
        
        return cell;
//    }else{
//        
//        static NSString *kCellIdentifier = @"MyIdentifier";
//        
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
//        if (cell == nil)
//        {
//            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier] autorelease];
//        }
//        
//        cell.textLabel.text = @"No ticket found";
//        cell.textLabel.textColor=[UIColor whiteColor];
//        return cell;
//    }
    
//    return nil;
    
}
-(void)showDirections {
    
    [[VSSharedManager sharedManager] openMapWithLocation:[[VSSharedManager sharedManager] selectedTicket]];

    /*
    RoutesViewController * tempRoute = [[RoutesViewController alloc] initWithNibName:@"RoutesViewController" bundle:[NSBundle mainBundle]];
    tempRoute.tickets = [NSArray arrayWithArray:[[VSSharedManager sharedManager] ticketInfo]];
    tempRoute.currentSelectedTicket = [[VSSharedManager sharedManager] CurrentSelectedIndex];
    tempRoute.currentSelectedSection = [[VSSharedManager sharedManager] CurrentSelectedSection];
    [self.navigationController pushViewController:tempRoute animated:YES];
     */
}

- (NSString *)elapsedTimeSince:(NSDate *)date {
    NSTimeInterval timeInterval = [date timeIntervalSinceNow];
    NSAssert(timeInterval<0, @"Please provide past date for elapsed time");
    
    timeInterval = abs(timeInterval);
    
    double seconds = 60;
    double minutes = 60;
    double hours = 24;
    
    int noOfSeconds = fmod(timeInterval, seconds);
    int noOfMinutes = timeInterval/seconds;
    
    if (noOfMinutes == 0) {
        return @"";
    } else if (noOfMinutes > 0) {
        int noOfHours = noOfMinutes/minutes;
        if (noOfHours == 0) {
            return [NSString stringWithFormat:@"%d %@", (int)noOfMinutes, (int)noOfMinutes == 1? @"Minute":@"Minutes"];
        } else {
            int noOfDays = noOfHours/hours;
            if (noOfDays == 0) {
                return [NSString stringWithFormat:@"%d %@", (int)noOfHours, (int)noOfHours == 1? @"Hour":@"Hours"];
            } else {
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"MMM d, y"];
                return [dateFormatter stringFromDate:date];
            }
        }
    }
    return @"";
}
-(void)timerRepeat {
    if (!self.startDate) {
        self.startDate = [NSDate date];
    }
    [self.assetsView.timeInLabel setText:[SharedManager stringFromDate:self.startDate withFormat:@"HH:mm"]];
    [self.assetsView.totalTimeLabel setText:[self elapsedTimeSince:self.startDate]];
}


- (UIView *)createDemoView:(NSString*)text
{
    UIView *demoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 290, 200)];
    [self.alertText setFrame:CGRectMake(0, 50, 290,150)];
    UILabel *imageView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 290, 50)];
    [imageView setTextAlignment:NSTextAlignmentCenter];
    [imageView setText:text];
    [imageView setNumberOfLines:2];
    [imageView setLineBreakMode:NSLineBreakByWordWrapping];
    [demoView addSubview:self.alertText];
    [demoView addSubview:imageView];
    
    return demoView;
}


@end
