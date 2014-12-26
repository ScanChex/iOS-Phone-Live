//
//  CheckInStepOneViewController.h
//  ScanChex
//
//  Created by Rajeel Amjad on 13/08/2014.
//  Copyright (c) 2014 Adnan Ahmad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignatureViewController.h"

@interface CheckInStepOneViewController : UIViewController<SignatureViewControllerDelegate,UITextFieldDelegate, UITextViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIScrollViewDelegate>
@property (nonatomic, retain) IBOutlet UIScrollView * scrollView;
@property (nonatomic, retain) NSMutableDictionary * initialData;
@property (nonatomic, retain) NSMutableDictionary * assetData;
@property (nonatomic, retain) NSString * selectedAsset;
@property (nonatomic, retain) IBOutlet UIImageView * assetImageView;
@property (nonatomic, retain) NSString * uploadedSignaturePath;
@property (nonatomic, retain) NSString * currentSelectedClient;
@property (nonatomic, retain) NSString * currentSelectedAssetId;
@property (nonatomic, retain) NSString * currentSelectedAssetPhoto;
@property (nonatomic, retain) NSString * currentSelectedDateFormat;

@property (nonatomic, retain) IBOutlet UILabel * descriptionLabel;
@property (nonatomic, retain) IBOutlet UILabel * ticketIdLabel;
@property (nonatomic, retain) IBOutlet UILabel * serialNumberLabel;
@property (nonatomic, retain) IBOutlet UILabel * assetIdLabel;
@property (nonatomic, retain) IBOutlet UILabel * departmentLabel;
@property (nonatomic, retain) IBOutlet UITextView * addressTextView;

@property (nonatomic, retain) IBOutlet UITextField * employeeTextField;
@property (nonatomic, retain) IBOutlet UITextField * departmentTextField;
@property (nonatomic, retain) IBOutlet UITextField * dateTextField;
@property (nonatomic, retain) IBOutlet UITextField * dueTextField;
@property (nonatomic, retain) IBOutlet UITextField * toleranceTextField;
@property (nonatomic, retain) IBOutlet UITextField * clientTextField;
@property (nonatomic, retain) IBOutlet UITextField * addressTextField;
@property (nonatomic, retain) IBOutlet UITextField * referenceTextField;
@property (nonatomic, retain) IBOutlet UITextView * notesTextView;

@property (nonatomic, retain) SignatureViewController * signatureController;
@property (nonatomic, retain) IBOutlet UIView * signatureView;

@property (nonatomic, retain) IBOutlet UIButton * checkButton;
+(id)initWithData:(NSDictionary*)data assetData:(NSMutableDictionary*)assetData selectedAsset:(NSString*)selectedAsset;
-(IBAction)checkButtonPressed:(id)sender;
- (IBAction)backButtonPressed:(id)sender;
-(IBAction)checkOutPressed:(id)sender;
@end