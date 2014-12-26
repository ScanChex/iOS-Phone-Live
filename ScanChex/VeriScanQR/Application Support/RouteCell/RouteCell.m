//
//  RouteCell.m
//  VeriScanQR
//
//  Created by Adnan Ahmad on 30/01/2013.
//  Copyright (c) 2013 Adnan Ahmad. All rights reserved.
//

#import "RouteCell.h"
#import "CustomCellHelper.h"
#import "TicketInfoDTO.h"
@implementation RouteCell

@synthesize indexPath;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(RouteCell *)resuableCellForTableView:(UITableView *)tableview withOwner:(UIViewController *)owner{
 
    static NSString *identifer= @"RouteCell";
    RouteCell *cell = (RouteCell *)[CustomCellHelper tableView:tableview cellWithIdentifier:identifer owner:owner];
    
    return cell;

}
-(void)updateCellWithTicket:(TicketDTO *)ticket{
   
    self.adress.text=[NSString stringWithFormat:@"%@ \n %@", ticket.address1,![ticket.address2 isKindOfClass:[NSNull class]] ? ticket.address2 : @""];
    self.codes.text=ticket.totalCodes;
    TicketInfoDTO *info=[ticket.tickets objectAtIndex:indexPath.row];
    self.date.text=info.startTime;

}
- (void)dealloc {
    [_adress release];
    [_codes release];
    [_date release];
    [super dealloc];
}
@end
