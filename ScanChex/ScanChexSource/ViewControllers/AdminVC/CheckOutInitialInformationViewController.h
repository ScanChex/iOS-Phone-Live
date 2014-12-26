//
//  CheckOutInitialInformationViewController.h
//  ScanChex
//
//  Created by Rajeel Amjad on 26/07/2014.
//  Copyright (c) 2014 Adnan Ahmad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScanQRManager.h"
@interface CheckOutInitialInformationViewController : ScanQRManager <UITextFieldDelegate, UITextViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
+(id)initCheckWithScan;
+(id)initCheckWithManual;

@property (nonatomic, retain) IBOutlet UIImageView * assetImageView;
@property (nonatomic, retain) IBOutlet UITextField * descriptionTextField;
@property (nonatomic, retain) IBOutlet UITextField * serialNumberTextField;
@property (nonatomic, retain) IBOutlet UITextField * assetIDTextField;
@property (nonatomic, retain) IBOutlet UITextView * addressTextView;
@property (nonatomic, retain) IBOutlet UITextField * departmentTextField;
@property (nonatomic, retain) IBOutlet UIScrollView * scrollView;
@property (nonatomic, retain) NSString * currentSelectedAsset;
@property (nonatomic, retain) NSString * currentSelectedlientID;
@property (nonatomic, retain) NSMutableArray * addressesArray;
@property (nonatomic, retain) NSString * currentSelectedClientId;

@property (assign) BOOL isScan;
@property (nonatomic, retain) NSMutableDictionary * dataDict;
@property (nonatomic, retain) IBOutlet UIButton * scanButton;
@property (nonatomic, retain) IBOutlet UITextField * clientTextField;

- (IBAction)backButtonPressed:(id)sender;
-(IBAction)checkOutAction:(id)sender;
-(void)fetchAllData;
-(void)resignKeyboard;

@end
