//
//  TicketCell.m
//  VeriScanQR
//
//  Created by Adnan Ahmad on 22/12/2012.
//  Copyright (c) 2012 Adnan Ahmad. All rights reserved.
//

#import "TicketCell.h"
#import "CustomCellHelper.h"
#import "TicketInfoDTO.h"
#import "TicketAddressDTO.h"
#import <QuartzCore/QuartzCore.h>
@implementation TicketCell
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

+(TicketCell *)resuableCellForTableView:(UITableView *)tableview withOwner:(UIViewController *)owner{
    
    static NSString *identifer= @"TicketCell";
    TicketCell *cell = (TicketCell *)[CustomCellHelper tableView:tableview cellWithIdentifier:identifer owner:owner];
    
    return cell;
}
+(TicketCell *)resuableCellForTableView2:(UITableView *)tableview withOwner:(UIViewController *)owner{
    
    static NSString *identifer= @"TicketCellPreview";
    TicketCell *cell = (TicketCell *)[CustomCellHelper tableView:tableview cellWithIdentifier:identifer owner:owner];
    
    return cell;
}
+(TicketCell *)resuableCellForTableViewCheckIn:(UITableView *)tableview withOwner:(UIViewController *)owner {
    static NSString *identifer= @"TicketCellCICO";
    TicketCell *cell = (TicketCell *)[CustomCellHelper tableView:tableview cellWithIdentifier:identifer owner:owner];
    
    return cell;
}
-(void)updateCellWithCheckTicket:(TicketDTO *)ticket {
    
    
    self.onHoldLabel.hidden = YES;
    self.onHoldStatus.hidden = YES;

  TicketInfoDTO *info=[ticket.tickets objectAtIndex:indexPath.row];
  
  
    [self.scanButton setTitle:@"CHECK IN" forState:UIControlStateNormal];
    [self.scanButton setBackgroundColor:[UIColor colorWithRed:164.0f/255.0f green:254.0f/255.0f blue:255.0f/255.0f alpha:1.0f]];
    TicketAddressDTO *address1 =ticket.address1;
    TicketAddressDTO *address2 =ticket.address2;
    
    self.address.text =[NSString stringWithFormat:@"%@ \n%@, %@ %@ \n",address1.street,address1.city,address1.state,address1.postalCode];
    
    if (address2) {
        
        self.address.text=[self.address.text stringByAppendingString:[NSString stringWithFormat:@"%@ \n%@, %@ %@ \n",address2.street,address2.city,address2.state,address2.postalCode]];
    }
    
    self.phoneNumber.text = [ticket.phoneNumber isEqualToString:@"<null>"] ? @"" :ticket.phoneNumber;
    self.assetID.text =[ticket.unEncryptedAssetID isEqualToString:@"<null>"] ? @"" :ticket.unEncryptedAssetID;;
    //self.clientName.text=[ticket.clientName isEqualToString:@"<null>"]? @"" :ticket.clientName; ;
    
 //   TicketInfoDTO *info=[ticket.tickets objectAtIndex:indexPath.row];
    self.ticketNumber.text=[NSString stringWithFormat:@"%@",ticket.description];
    if (info.allow_id_card_scan) {
        [self.employeeCardImageView setHidden:NO];
        
    }
    else {
        [self.employeeCardImageView setHidden:YES];
    }
    
    // NSDate *startDate=[WSUtils getDateFromString:info.startTime withFormat:@"YYYY-MM-dd hh:mm:ss"];
    // NSString *startDateString=[WSUtils getStrindFromDate:startDate withFormat:@"dd-MM-YYYY hh:mm:ss"];
    
    self.startTime.text=info.ticketID;
    [self.dateLabel setText:info.startDate];
    [self.timeLabel setText:info.startTime];
    self.clientName.text=[info.employee isEqualToString:@"<null>"]? @"" :info.employee; ;
    //    self.remainingScans.text=[NSString stringWithFormat:@"%@\n%@",info.startDate,info.startTime];
    
    //    if([info.overDue isEqualToString:@"1"]){
    //
    //        self.contentView.backgroundColor=[UIColor colorWithRed:251.0/255.0 green:194.0/255.0 blue:200.0/255.0 alpha:1.0];
    //        [self.imageSign setImage:[UIImage imageNamed:@"excalamationIcon.png"]];
    //
    //    }
    //  else
    if([ [info.ticketStatus lowercaseString] isEqualToString:@"assigned"])
    {
        if([info.overDue isEqualToString:@"0"]){
            [self.imageSign setImage:nil];
            self.contentView.backgroundColor=[UIColor colorWithRed:197.0f/255.0f green:255.0f/255.0f blue:197.0f/255.0f alpha:1.0];
            
        }
        else
        {
            [self.imageSign setImage:[UIImage imageNamed:@"excalamationIcon.png"]];
            self.contentView.backgroundColor=[UIColor colorWithRed:251.0/255.0 green:194.0/255.0 blue:200.0/255.0 alpha:1.0];
        }
    }
    else if([ [info.ticketStatus lowercaseString] isEqualToString:@"pending"])
    {
        
        [self.imageSign setImage:[UIImage imageNamed:@"lightningImage.png"]];
        self.contentView.backgroundColor=[UIColor colorWithRed:196.0f/255.0f green:208.0f/255.0f blue:255.0f/255.0f alpha:1.0];
        
    }
    else if([ [info.ticketStatus lowercaseString] isEqualToString:@"complete"])
    {
        [self.imageSign setImage:[UIImage imageNamed:@"checkmarkgreen.png"]];
        self.contentView.backgroundColor=[UIColor colorWithRed:236.0f/255.0f green:236.0f/255.0f blue:236.0f/255.0f alpha:1.0];
        if ([info.ticket_type isEqualToString:@"check_in"]) {
            [self.scanButton setBackgroundColor:[UIColor clearColor]];
        }
        else {
            [self.scanButton setTitle:@"CHECK OUT" forState:UIControlStateNormal];
            [self.scanButton setBackgroundColor:[UIColor clearColor]];
        }
//        [self.scanButton setHidden:YES];
    }
    else if([[info.ticketStatus lowercaseString] isEqualToString:@"suspended"]){
        
        [self.imageSign setImage:nil];
        self.onHoldLabel.hidden = NO;
        self.onHoldStatus.hidden  = NO;
        self.onHoldStatus.text  = info.suspended_by;
        //self.contentView.backgroundColor = [UIColor purpleColor];
        self.contentView.backgroundColor=[UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:182.0f/255.0f alpha:1.0];
        
    }

    [self.photoImageView setImage:[UIImage imageNamed:@"Photo_not_available.jpg"]];
  self.photoImageView.layer.borderWidth=3.0;
  self.photoImageView.layer.borderColor=[UIColor lightGrayColor].CGColor;
  
    NSString * tempURLString = info.photoUrl;
    tempURLString = [tempURLString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    [self.photoImageView setImageURL:[NSURL URLWithString:tempURLString]];
    NSLog(@"Photo %@",info.photoUrl);
    
  
}

-(void)updateCellWithTicket:(TicketDTO *)ticket{

    self.onHoldLabel.hidden = YES;
    self.onHoldStatus.hidden = YES;

    TicketAddressDTO *address1 =ticket.address1;
    TicketAddressDTO *address2 =ticket.address2;
    
    
    self.address.text =[NSString stringWithFormat:@"%@ \n%@, %@ %@ \n",address1.street,address1.city,address1.state,address1.postalCode];
    
    if (address2) {
        
        self.address.text=[self.address.text stringByAppendingString:[NSString stringWithFormat:@"%@ \n%@, %@ %@ \n",address2.street,address2.city,address2.state,address2.postalCode]];
    }
    
    self.phoneNumber.text = [ticket.phoneNumber isEqualToString:@"<null>"] ? @"" :ticket.phoneNumber;
    self.assetID.text =[ticket.unEncryptedAssetID isEqualToString:@"<null>"] ? @"" :ticket.unEncryptedAssetID;;
    self.clientName.text=[ticket.clientName isEqualToString:@"<null>"]? @"" :ticket.clientName; ;
    
    TicketInfoDTO *info=[ticket.tickets objectAtIndex:indexPath.row];
    self.ticketNumber.text=[NSString stringWithFormat:@"%@",ticket.description];
    if (info.allow_id_card_scan) {
        [self.employeeCardImageView setHidden:NO];
        
    }
    else {
        [self.employeeCardImageView setHidden:YES];
    }
    
   // NSDate *startDate=[WSUtils getDateFromString:info.startTime withFormat:@"YYYY-MM-dd hh:mm:ss"];
   // NSString *startDateString=[WSUtils getStrindFromDate:startDate withFormat:@"dd-MM-YYYY hh:mm:ss"];
    
    self.startTime.text=info.ticketID;
    [self.dateLabel setText:info.startDate];
    [self.timeLabel setText:info.startTime];
//    self.remainingScans.text=[NSString stringWithFormat:@"%@\n%@",info.startDate,info.startTime];
    
//    if([info.overDue isEqualToString:@"1"]){
//
//        self.contentView.backgroundColor=[UIColor colorWithRed:251.0/255.0 green:194.0/255.0 blue:200.0/255.0 alpha:1.0];
//        [self.imageSign setImage:[UIImage imageNamed:@"excalamationIcon.png"]];
//        
//    }
//  else
      if([ [info.ticketStatus lowercaseString] isEqualToString:@"assigned"])
    {
        if([info.overDue isEqualToString:@"0"]){
            [self.imageSign setImage:nil];
            self.contentView.backgroundColor=[UIColor colorWithRed:197.0f/255.0f green:255.0f/255.0f blue:197.0f/255.0f alpha:1.0];
            
        }
        else
        {
            [self.imageSign setImage:[UIImage imageNamed:@"excalamationIcon.png"]];
            self.contentView.backgroundColor=[UIColor colorWithRed:251.0/255.0 green:194.0/255.0 blue:200.0/255.0 alpha:1.0];
        }
    }
    else if([ [info.ticketStatus lowercaseString] isEqualToString:@"pending"])
    {
    
        [self.imageSign setImage:[UIImage imageNamed:@"lightningImage.png"]];
        self.contentView.backgroundColor=[UIColor colorWithRed:196.0f/255.0f green:208.0f/255.0f blue:255.0f/255.0f alpha:1.0];

    }
    else if([ [info.ticketStatus lowercaseString] isEqualToString:@"complete"])
    {
        [self.imageSign setImage:[UIImage imageNamed:@"checkmarkgreen.png"]];
        self.contentView.backgroundColor=[UIColor colorWithRed:236.0f/255.0f green:236.0f/255.0f blue:236.0f/255.0f alpha:1.0];
    }
    else if([[info.ticketStatus lowercaseString] isEqualToString:@"suspended"]){
    
        [self.imageSign setImage:nil];
        self.onHoldLabel.hidden = NO;
        self.onHoldStatus.hidden  = NO;
        self.onHoldStatus.text = info.suspended_by;
        //self.contentView.backgroundColor = [UIColor purpleColor];
        self.contentView.backgroundColor=[UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:181.0f/255.0f alpha:1.0];
    
    }
    [self.photoImageView setImage:[UIImage imageNamed:@"Photo_not_available.jpg"]];
    self.photoImageView.layer.borderWidth=3.0;
    self.photoImageView.layer.borderColor=[UIColor lightGrayColor].CGColor;
    NSString * tempURLString = info.photoUrl;
    tempURLString = [tempURLString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    [self.photoImageView setImageURL:[NSURL URLWithString:tempURLString]];
    NSLog(@"Photo %@",info.photoUrl);
    
    
}
-(void)updateCellWithTicket:(TicketDTO *)ticket index:(NSInteger)index {
    
    self.onHoldLabel.hidden = YES;
    self.onHoldStatus.hidden= YES;

    TicketAddressDTO *address1 =ticket.address1;
    TicketAddressDTO *address2 =ticket.address2;
    
    self.address.text =[NSString stringWithFormat:@"%@ \n%@, %@ %@ \n",address1.street,address1.city,address1.state,address1.postalCode];
    
    if (address2) {
        
        self.address.text=[self.address.text stringByAppendingString:[NSString stringWithFormat:@"%@ \n%@, %@ %@ \n",address2.street,address2.city,address2.state,address2.postalCode]];
    }
    
    self.phoneNumber.text = [ticket.phoneNumber isEqualToString:@"<null>"] ? @"" :ticket.phoneNumber;
    self.assetID.text =[ticket.unEncryptedAssetID isEqualToString:@"<null>"] ? @"" :ticket.unEncryptedAssetID;;
    self.clientName.text=[ticket.clientName isEqualToString:@"<null>"]? @"" :ticket.clientName; ;
    
    TicketInfoDTO *info=[ticket.tickets objectAtIndex:index];
    self.ticketNumber.text=[NSString stringWithFormat:@"%@",ticket.description];
    
    
    // NSDate *startDate=[WSUtils getDateFromString:info.startTime withFormat:@"YYYY-MM-dd hh:mm:ss"];
    // NSString *startDateString=[WSUtils getStrindFromDate:startDate withFormat:@"dd-MM-YYYY hh:mm:ss"];
    
    self.startTime.text=info.ticketID;
    
//    self.remainingScans.text=[NSString stringWithFormat:@"%@\n%@",info.startDate,info.startTime];
    [self.dateLabel setText:info.startDate];
    [self.timeLabel setText:info.startTime];
    
    //    if([info.overDue isEqualToString:@"1"]){
    //
    //        self.contentView.backgroundColor=[UIColor colorWithRed:251.0/255.0 green:194.0/255.0 blue:200.0/255.0 alpha:1.0];
    //        [self.imageSign setImage:[UIImage imageNamed:@"excalamationIcon.png"]];
    //
    //    }
    //  else
    if([ [info.ticketStatus lowercaseString] isEqualToString:@"assigned"])
    {
        if([info.overDue isEqualToString:@"0"]){
            [self.imageSign setImage:nil];
            self.contentView.backgroundColor=[UIColor colorWithRed:197.0f/255.0f green:255.0f/255.0f blue:197.0f/255.0f alpha:1.0];
            
        }
        else
        {
            [self.imageSign setImage:[UIImage imageNamed:@"excalamationIcon.png"]];
            self.contentView.backgroundColor=[UIColor colorWithRed:251.0/255.0 green:194.0/255.0 blue:200.0/255.0 alpha:1.0];
        }
    }
    else if([ [info.ticketStatus lowercaseString] isEqualToString:@"pending"])
    {
        
        [self.imageSign setImage:[UIImage imageNamed:@"lightningImage.png"]];
        self.contentView.backgroundColor=[UIColor colorWithRed:196.0f/255.0f green:208.0f/255.0f blue:255.0f/255.0f alpha:1.0];
        
    }
    else if([ [info.ticketStatus lowercaseString] isEqualToString:@"complete"])
    {
        [self.imageSign setImage:[UIImage imageNamed:@"checkmarkgreen.png"]];
        self.contentView.backgroundColor=[UIColor colorWithRed:236.0f/255.0f green:236.0f/255.0f blue:236.0f/255.0f alpha:1.0];
    }
    else if([[info.ticketStatus lowercaseString] isEqualToString:@"suspended"]){
        
        [self.imageSign setImage:nil];
        self.onHoldLabel.hidden = NO;
        self.onHoldStatus.hidden  = NO;
        self.onHoldStatus.text = info.suspended_by;
        //self.contentView.backgroundColor = [UIColor purpleColor];
      self.contentView.backgroundColor=[UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:182.0f/255.0f alpha:1.0];
        
    }

 [self.photoImageView setImage:[UIImage imageNamed:@"Photo_not_available.jpg"]];
  self.photoImageView.layer.borderWidth=3.0;
  self.photoImageView.layer.borderColor=[UIColor lightGrayColor].CGColor;
  
    NSString * tempURLString = info.photoUrl;
    tempURLString = [tempURLString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    [self.photoImageView setImageURL:[NSURL URLWithString:tempURLString]];
//    [self.photoImageView setImageURL:[NSURL URLWithString:info.photoUrl]];
    NSLog(@"Photo %@",info.photoUrl);
}

- (IBAction)callButton:(id)sender {
//    TicketDTO *ticketDTO =[self.tickets objectAtIndex:indexPath.section];
    
    
    if ([[self.phoneNumber text] length] <= 0) {
        
        return;
    }
    
    NSString *telephoneString=[[self.phoneNumber text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSMutableString *phoneString=[[NSMutableString alloc] initWithString:telephoneString];
    [phoneString setString:[phoneString stringByReplacingOccurrencesOfString:@"(" withString:@""]];
    [phoneString setString:[phoneString stringByReplacingOccurrencesOfString:@")" withString:@""]];
    [phoneString setString:[phoneString stringByReplacingOccurrencesOfString:@"-" withString:@""]];
    [phoneString setString:[phoneString stringByReplacingOccurrencesOfString:@" " withString:@""]];
    [phoneString setString:[phoneString stringByReplacingOccurrencesOfString:@"." withString:@""]];
    telephoneString = [@"telprompt://" stringByAppendingString:phoneString];
    [phoneString release];
    
    DLog(@"Phone Number is %@",telephoneString);
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telephoneString]];
}
- (void)dealloc {
    [_ticketNumber release];
    [_startTime release];
    [_address release];
    [_remainingScans release];
    [_assetID release];
    [_clientName release];
    [_phoneNumber release];
    [_scanButton release];
    [_callButton release];
    [_mapButton release];
    [_photoImageView release];
    [_imageSign release];
    [_onHoldLabel release];
    [_onHoldStatus release];
    [super dealloc];
}
@end
