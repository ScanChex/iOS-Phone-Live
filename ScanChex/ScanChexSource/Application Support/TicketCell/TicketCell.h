//
//  TicketCell.h
//  VeriScanQR
//
//  Created by Adnan Ahmad on 22/12/2012.
//  Copyright (c) 2012 Adnan Ahmad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TicketDTO.h"
#import "AsyncImageView.h"
@interface TicketCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UILabel *ticketNumber;
@property (retain, nonatomic) IBOutlet UILabel *startTime;
@property (retain, nonatomic) IBOutlet UITextView *address;
@property (retain, nonatomic) IBOutlet UITextView *remainingScans;
@property (retain, nonatomic) NSIndexPath * indexPath;
@property (retain, nonatomic) IBOutlet UILabel *assetID;
@property (retain, nonatomic) IBOutlet UILabel *clientName;
@property (retain, nonatomic) IBOutlet UITextView *phoneNumber;
@property (retain, nonatomic) IBOutlet UIButton *scanButton;
@property (retain, nonatomic) IBOutlet UIButton *callButton;
@property (retain, nonatomic) IBOutlet UIButton *mapButton;
@property (retain, nonatomic) IBOutlet AsyncImageView *photoImageView;
@property (retain, nonatomic) IBOutlet UIImageView *imageSign;
@property (retain, nonatomic) IBOutlet UILabel *timeLabel;
@property (retain, nonatomic) IBOutlet UILabel *dateLabel;
@property (retain, nonatomic) IBOutlet UIImageView * employeeCardImageView;
@property (retain, nonatomic) IBOutlet UILabel *onHoldLabel;
@property (retain, nonatomic) IBOutlet UILabel *onHoldStatus;

+(TicketCell *)resuableCellForTableView:(UITableView *)tableview withOwner:(UIViewController *)owner;
+(TicketCell *)resuableCellForTableView2:(UITableView *)tableview withOwner:(UIViewController *)owner;
+(TicketCell *)resuableCellForTableViewCheckIn:(UITableView *)tableview withOwner:(UIViewController *)owner;
-(void)updateCellWithTicket:(TicketDTO *)ticket;
-(void)updateCellWithCheckTicket:(TicketDTO *)ticket;
-(void)updateCellWithTicket:(TicketDTO *)ticket index:(NSInteger)index;
- (IBAction)callButton:(id)sender;


@end
