//
//  MessageCentreVC.h
//  VeriScanQR
//
//  Created by Adnan Ahmad on 07/01/2014.
//  Copyright (c) 2014 Adnan Ahmad. All rights reserved.
//

#import "BaseVC.h"
#import "WebServiceManager.h"
#import "CustomIOS7AlertView.h"
#import "DSTableViewWithDynamicHeight.h"

@interface MessageCentreVC : BaseVC<UITableViewDelegate, UITableViewDataSource,UIAlertViewDelegate>

@property (retain, nonatomic) IBOutlet UITableView *messageTable;
@property (retain, nonatomic) NSMutableArray *messagesArray;
@property (retain, nonatomic) IBOutlet UILabel *name;
@property (retain, nonatomic) IBOutlet UILabel * dateLabel;
@property (retain, nonatomic) IBOutlet UIView * tableHeader;
@property (retain, nonatomic) IBOutlet UIView * tableFooter;
@property (nonatomic, assign) NSInteger currentSelectedCell;
@property (nonatomic, retain) UITextView * alertText;
@property (nonatomic, retain) NSString * period;
@property (nonatomic, retain) IBOutlet UIButton * todayButton;
@property (nonatomic, retain) IBOutlet UIButton * weekButton;
@property (nonatomic, retain) IBOutlet UIButton * monthButton;
@property (nonatomic, retain) IBOutlet UIButton * twoMonthsButton;

@property (nonatomic, retain) IBOutlet UILabel * todayLabel;
@property (nonatomic, retain) IBOutlet UILabel * weekLabel;
@property (nonatomic, retain) IBOutlet UILabel * monthLabel;
@property (nonatomic, retain) IBOutlet UILabel * twoMonthsLabel;

+(id)initWithMessageCentre;
- (IBAction)onBackClick:(id)sender;
-(void)fetchData;
-(void)postReply:(NSString*) detailstring;
-(void) refreshControlValueChanged:(UIRefreshControl *) sender ;
-(IBAction)newButtonPressed:(id)sender;
- (UIView *)createDemoView:(NSString*)text;
-(IBAction)changePeriod:(id)sender;
@end
