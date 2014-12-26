//
//  RouteCell.h
//  VeriScanQR
//
//  Created by Adnan Ahmad on 30/01/2013.
//  Copyright (c) 2013 Adnan Ahmad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TicketDTO.h"
@interface RouteCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UITextView *adress;
@property (retain, nonatomic) IBOutlet UILabel *codes;
@property (retain, nonatomic) IBOutlet UILabel *date;
@property (retain, nonatomic) NSIndexPath * indexPath;


+(RouteCell *)resuableCellForTableView:(UITableView *)tableview withOwner:(UIViewController *)owner;
-(void)updateCellWithTicket:(TicketDTO *)ticket;

@end
