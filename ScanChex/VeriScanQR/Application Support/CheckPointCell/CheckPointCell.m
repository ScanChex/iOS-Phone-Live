//
//  CheckPointCell.m
//  VeriScanQR
//
//  Created by Rajeel Amjad on 08/05/2014.
//  Copyright (c) 2014 Adnan Ahmad. All rights reserved.
//

#import "CheckPointCell.h"
#import "CustomCellHelper.h"
#import <QuartzCore/QuartzCore.h>
#import "VSSharedManager.h"
@implementation CheckPointCell

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

+(CheckPointCell *)resuableCellForTableView:(UITableView *)tableview withOwner:(UIViewController *)owner
{
    
    static NSString *identifer= @"CheckPointCell";
    CheckPointCell *cell = (CheckPointCell *)[CustomCellHelper tableView:tableview cellWithIdentifier:identifer owner:owner];
    
    return cell;
    
}
-(void)updateCellWithMessage:(CheckPointDTO *)checkPointDTO :(NSString*)isScanned
{
    if ([[VSSharedManager sharedManager] isPreview]) {
        [self.scanButton setHidden:YES];
        [self.checkMarkButton setHidden:NO];
        
    }
    else {
        
        [self.scanButton setHidden:NO];
        [self.checkMarkButton setHidden:YES];
        if ([isScanned boolValue]) {
            [self.scanButton setHidden:NO];
        }
        else {
            [self.checkMarkButton setHidden:NO];
            [self.checkMarkButton setImage:[UIImage imageNamed:@"friend_selected"] forState:UIControlStateNormal];
            [self.scanButton setHidden:YES];
        }
    }
    [self.time setText:checkPointDTO.time];
    [self.scanButton.layer setCornerRadius:5.0f];
    [self.descriptionTextView setText:checkPointDTO.description];
    
    

    
}

- (void)dealloc {
    [_scanButton release];
    [_descriptionTextView release];
    [_time release];
    [_checkMarkButton release];
    [super dealloc];
}

@end
