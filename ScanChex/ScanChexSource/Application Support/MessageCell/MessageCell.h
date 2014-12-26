//
//  MessageCell.h
//  VeriScanQR
//
//  Created by Adnan Ahmad on 07/01/2014.
//  Copyright (c) 2014 Adnan Ahmad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageDTO.h"
#import "AsyncImageView.h"
@protocol DSTableViewCellWithDynamicHeight <NSObject>

+ (CGFloat)heightForCellWidth:(CGFloat)cellWidth;
@end
@interface MessageCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UILabel *lblMessage;
@property (retain, nonatomic) IBOutlet AsyncImageView *imgMessage;
@property (retain , nonatomic) IBOutlet UIButton * replyButton;
@property (retain, nonatomic) IBOutlet UILabel * timeLabel;

+(MessageCell *)resuableCellForTableView:(UITableView *)tableview withOwner:(UIViewController *)owner;
+(MessageCell *)resuableCellForTableView2:(UITableView *)tableview withOwner:(UIViewController *)owner;
-(void)updateCellWithMessage:(MessageDTO *)messageDTO;
+ (CGFloat)heightForCellWidth:(CGFloat)cellWidth;
@end
