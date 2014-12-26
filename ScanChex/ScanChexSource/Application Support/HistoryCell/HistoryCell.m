//
//  HistoryCell.m
//  VeriScanQR
//
//  Created by Adnan Ahmad on 30/01/2013.
//  Copyright (c) 2013 Adnan Ahmad. All rights reserved.
//

#import "HistoryCell.h"
#import "CustomCellHelper.h"
#import <QuartzCore/QuartzCore.h>
@implementation HistoryCell

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

+(HistoryCell *)resuableCellForTableView:(UITableView *)tableview withOwner:(UIViewController *)owner{

    static NSString *identifer= @"HistoryCell";
    HistoryCell *cell = (HistoryCell *)[CustomCellHelper tableView:tableview cellWithIdentifier:identifer owner:owner];
    
    return cell;

}
-(void)updateCellWithTicket:(HistoryDTO *)ticket{

    self.date.text=ticket.date;
    self.technician.text=[[ticket.fullName description] isEqualToString:@"<null>"] ? @"":ticket.fullName ;
//    self.service.text=ticket.service;
    
    DLog(@"ticket.warrenty %@",ticket.warranty);
    DLog(@"tickets length %@",ticket.notes);
    if ([[ticket.warranty lowercaseString] isEqualToString:@"y"]) {
        
        [self.yes setImage:[UIImage imageNamed:@"friend_selected"]];
    }
    else if ([[ticket.warranty lowercaseString] isEqualToString:@"n"]) {
        
        [self.yes setImage:[UIImage imageNamed:@"friend_unselected"]];
    }
    
    else{
    
        [self.yes setImage:[UIImage imageNamed:@"friend_unselected"]];
        [self.no setImage:[UIImage imageNamed:@"friend_unselected"]];
    }
    TicketInfoDTO * tempTicketInfo = [[VSSharedManager sharedManager] selectedTicketInfo];
    [self.ticketNoLabel setText:ticket.ticketID];
    
    if ([ticket.notes count]==0){ self.notes.hidden=YES; self.notesLabel.hidden = YES; }else{ self.notes.hidden=NO;self.notesLabel.hidden = NO;self.notesLabel.text = [NSString stringWithFormat:@"%d",[ticket.notes count]]; [self.notesLabel.layer setCornerRadius:5.0f];}
    if ([ticket.voice count]==0){ self.voice.hidden=YES; self.voiceLabel.hidden = YES;}else{ self.voice.hidden=NO;self.voiceLabel.hidden = NO;self.voiceLabel.text = [NSString stringWithFormat:@"%d",[ticket.voice count]];[self.voiceLabel.layer setCornerRadius:5.0f];}
    if ([ticket.video count]==0){ self.video.hidden=YES;  self.videoLabel.hidden = YES;}else{ self.video.hidden=NO;self.videoLabel.hidden = NO;self.videoLabel.text = [NSString stringWithFormat:@"%d",[ticket.video count]];[self.videoLabel.layer setCornerRadius:5.0f];}
    if ([ticket.imgURL count]==0){self.image.hidden=YES; self.imageLabel.hidden = YES;}else{ self.image.hidden=NO;self.imageLabel.hidden = NO;self.imageLabel.text = [NSString stringWithFormat:@"%d",[ticket.imgURL count]];[self.imageLabel.layer setCornerRadius:5.0f];}
}

- (void)dealloc {
    [_date release];
    [_technician release];
//    [_service release];
    [_yes release];
    [_no release];
    [_notes release];
    [_voice release];
    [_video release];
    [_image release];
    [super dealloc];
}
@end
