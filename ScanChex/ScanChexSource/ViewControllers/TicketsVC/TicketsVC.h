//
//  TicketsVC.h
//  VeriScanQR
//
//  Created by Adnan Ahmad on 22/12/2012.
//  Copyright (c) 2012 Adnan Ahmad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
#import "BaseVC.h"
#import "WebServiceManager.h"
#import "TicketDTO.h"
@interface TicketsVC : BaseVC<UITableViewDelegate,UITableViewDataSource,WebServiceManagerDelegate>


@property (retain, nonatomic) IBOutlet AsyncImageView *logo;
@property (retain, nonatomic) IBOutlet UITableView *ticketsTable;
@property(nonatomic,retain)   NSMutableArray *tickets;
@property (retain, nonatomic) IBOutlet UITextView *messages;
@property(nonatomic,retain)TicketDTO *ticketData;
@property (retain, nonatomic) IBOutlet UILabel *messageLbl;
@property (retain, nonatomic) IBOutlet UIImageView *messageImage;
@property(nonatomic,retain) NSTimer *timer;
@property (retain, nonatomic) NSMutableArray *messagesArray;
@property (retain, nonatomic) IBOutlet UIImageView *imgAlert;
@property (retain, nonatomic) IBOutlet UILabel *lblMessage;
@property (retain, nonatomic) IBOutlet UIButton *btnMessage;
-(IBAction)messageButtonPressed:(id)sender;
-(void)messageNotification:(NSNotification*)notif;

+ (id)initWithTickets;
- (IBAction)logoutButtonPressed:(id)sender;
@end
