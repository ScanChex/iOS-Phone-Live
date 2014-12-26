//
//  PaymentVC.h
//  VeriScanQR
//
//  Created by Adnan Ahmad on 02/03/2014.
//  Copyright (c) 2014 Adnan Ahmad. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PayPalMobile.h"
#import "SignatureViewController.h"

@interface PaymentVC : BaseVC <PayPalPaymentDelegate,SignatureViewControllerDelegate,UITableViewDelegate,UITableViewDataSource>

@property (retain, nonatomic) IBOutlet UIScrollView *paymentScrollView;
@property(nonatomic, strong, readwrite) PayPalPayment *completedPayment;
@property(nonatomic, strong, readwrite) NSString *environment;
@property(nonatomic, assign, readwrite) BOOL acceptCreditCards;
@property (nonatomic, retain) SignatureViewController * signatureController;
@property (nonatomic, retain) IBOutlet UIView * signatureView;
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) IBOutlet UITextView * customerTextView;
@property (retain, nonatomic) IBOutlet UIButton * payNowButton;
@property (retain, nonatomic) IBOutlet UIButton * returnButton;
@property (retain, nonatomic) UIImage * signature;
@property (retain, nonatomic) NSString * additionalCommentString;
@property (nonatomic, retain) UITextView * alertText;
@property (nonatomic, retain) IBOutlet UIView * additionalPaymentView;
@property (nonatomic, retain) IBOutlet UILabel * assetID;
@property (nonatomic, retain) IBOutlet UILabel * ticketID;
@property (nonatomic, retain) IBOutlet UILabel * amountDue;
@property (nonatomic, retain) IBOutlet UILabel * date;
+ (id)initWithPayment;
- (IBAction)onClickPayNow:(id)sender;
- (IBAction)onClickReturn:(id)sender;
-(IBAction)onCLickAdditionalComments:(id)sender;
- (UIView *)createDemoView:(NSString*)text;
-(IBAction)payPalBUttonClicked:(id)sender;
-(IBAction)paymentButtonsCLicked:(id)sender;
-(void)sendPaymentInformationtoServer: (NSString*)type;
@end
