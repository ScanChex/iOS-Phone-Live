//
//  ScanVCViewController.h
//  VeriScanQR
//
//  Created by Adnan Ahmad on 14/12/2012.
//  Copyright (c) 2012 Adnan Ahmad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseVC.h"
#import "DocumentsVC.h"
#import "DownloadVC.h"
#import "PDFAndMoviePlayerVC.h"
#import "ScanQRManager.h"
#import "PDFViewController.h"
#import "PDF.h"
#import "PDFDocument.h"


@interface ScanVC : PDFAndMoviePlayerVC<DocumentDelegate,DownloadVCDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate,UIActionSheetDelegate,UITableViewDataSource,UITableViewDelegate>

@property (retain, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (retain, nonatomic) NSString *savePath;
@property (retain,nonatomic)UIProgressView *myProgressIndicator;
@property (retain,nonatomic) UIImagePickerController *recoder;
@property (assign, nonatomic) BOOL isSecondScan;
@property (retain, nonatomic) IBOutlet UIButton *btnSecondScan;
@property (nonatomic, retain) ScanQRManager *scanQRManager;
@property (retain, nonatomic) NSMutableArray *audioArray;
@property (retain, nonatomic) NSMutableArray *videoArray;
@property (assign) NSInteger count;
@property (retain, nonatomic) NSArray * receivedArray;
@property (nonatomic, assign) BOOL isPreview;
@property (nonatomic ,strong) IBOutlet UIButton *backButton;
@property (nonatomic, assign) BOOL isScanHidden;
@property (nonatomic, assign) BOOL isScanning;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain , nonatomic) NSDate * startDate;
@property (retain, nonatomic) NSTimer * startTimer;
@property (nonatomic, strong)  PDFViewController *  pdfViewController;
@property (nonatomic, retain) NSMutableArray * historyArray;
@property (retain, nonatomic) IBOutlet UIImageView *notesimageSign;
@property (retain, nonatomic) IBOutlet UIImageView *questionsimageSign;
@property (retain, nonatomic) IBOutlet UIButton *suspendButton;
@property (nonatomic, retain) UITextView * alertText;
@property (retain, nonatomic) IBOutlet UIImageView *companyLogo;
@property (nonatomic, assign) BOOL isLandScape;


@property (retain)UIDocumentInteractionController *docController;


+(id)initWithScan;
+(id)initWithPreview;
+(id)initWithhiddenScan;
- (id)initWithPreview:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
- (id)initWithhiddenScan:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;


- (NSString*) fileMIMEType:(NSString*) file;
- (IBAction)segmentChanged:(id)sender;
- (IBAction)menuButtonPressed:(id)sender;
- (IBAction)nextScanButtonPressed:(id)sender;
- (IBAction)SecondScanButtonPressed:(id)sender;
- (IBAction)onClickSuspend:(id)sender;
-(void)messageNotification:(NSNotification*)notif;
-(void)assetScanNotification:(NSNotification*)notif;
- (NSString *)elapsedTimeSince:(NSDate *)date;
-(void)timerRepeat;
-(void)showDirections;
@end
