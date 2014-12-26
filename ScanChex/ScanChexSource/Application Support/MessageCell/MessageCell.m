//
//  MessageCell.m
//  VeriScanQR
//
//  Created by Adnan Ahmad on 07/01/2014.
//  Copyright (c) 2014 Adnan Ahmad. All rights reserved.
//

#import "MessageCell.h"
#import "CustomCellHelper.h"

@implementation MessageCell

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

+(MessageCell *)resuableCellForTableView:(UITableView *)tableview withOwner:(UIViewController *)owner
{
    
    static NSString *identifer= @"MessageCell";
    MessageCell *cell = (MessageCell *)[CustomCellHelper tableView:tableview cellWithIdentifier:identifer owner:owner];
    
    return cell;
    
}
+(MessageCell *)resuableCellForTableView2:(UITableView *)tableview withOwner:(UIViewController *)owner
{
    
    static NSString *identifer= @"MessageCellUser";
    MessageCell *cell = (MessageCell *)[CustomCellHelper tableView:tableview cellWithIdentifier:identifer owner:owner];
    
    return cell;
    
}
-(void)updateCellWithMessage:(MessageDTO *)messageDTO
{

    if ([[[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"] lowercaseString] isEqualToString:[messageDTO.sender_id lowercaseString]]) {
        [self.replyButton setHidden:YES];
        
    }
    else {
        [self.replyButton setHidden:NO];
    }
    self.lblMessage.text = messageDTO.message;
    [self.lblMessage setNumberOfLines:0];
    NSString * tempstring  = messageDTO.sender_photo;
    tempstring = [tempstring stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    [self.imgMessage setImageURL:[NSURL URLWithString:tempstring]];
    [self.timeLabel setText:messageDTO.date_time];
//    [tempstring release];
//    NSString *cellText = self.lblMessage.text;
//    UIFont *cellFont = self.lblMessage.font;
//    CGSize constraintSize = CGSizeMake(230, MAXFLOAT);
//    CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
//    CGRect frame = self.lblMessage.frame;
//    frame.size = labelSize;
//    self.lblMessage.frame = frame;
//    [self.lblMessage sizeToFit];

}

- (void)dealloc {
    [_imgMessage release];
    [_lblMessage release];
    [_timeLabel release];
    [super dealloc];
}

+ (CGFloat)heightForCellWidth:(CGFloat)cellWidth {
    return cellWidth / 2;
};

@end
