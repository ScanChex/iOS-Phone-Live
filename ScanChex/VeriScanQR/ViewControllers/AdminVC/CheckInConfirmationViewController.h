//
//  CheckInConfirmationViewController.h
//  ScanChex
//
//  Created by Rajeel Amjad on 13/08/2014.
//  Copyright (c) 2014 Adnan Ahmad. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckInConfirmationViewController : UIViewController
@property (nonatomic, retain) IBOutlet UIScrollView * scrollView;
@property (nonatomic, retain) IBOutlet UILabel * descriptionLabel;
@property (nonatomic, retain) IBOutlet UILabel * serialNumberLabel;
@property (nonatomic, retain) IBOutlet UILabel * assetIdLabel;
@property (nonatomic, retain) IBOutlet UILabel * departmentLabel;
@property (nonatomic, retain) IBOutlet UITextView * addressTextView;
@property (nonatomic, retain) IBOutlet UIImageView * assetImageView;
@property (nonatomic, retain) IBOutlet UITextField * employeeTextField;
@property (nonatomic, retain) IBOutlet UITextField * ticketIDTextField;
@property (nonatomic, retain) IBOutlet UITextField * returnTextField;
@property (nonatomic, retain) NSMutableDictionary * initialData;
@property (nonatomic, retain) NSString * ticketID;

- (IBAction)backButtonPressed:(id)sender;
- (IBAction)closeButtonPressed:(id)sender;
+(id)initWithData:(NSDictionary*)data ticketID:(NSString*)ticketId;
@end
