//
//  ServiceCell.m
//  VeriScanQR
//
//  Created by Adnan Ahmad on 30/04/2013.
//  Copyright (c) 2013 Adnan Ahmad. All rights reserved.
//

#import "ServiceCell.h"
#import "CustomCellHelper.h"
@implementation ServiceCell

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

+(ServiceCell *)resuableCellForTableView:(UITableView *)tableview withOwner:(UIViewController *)owner
{

    static NSString *identifer= @"ServiceCell";
    ServiceCell *cell = (ServiceCell *)[CustomCellHelper tableView:tableview cellWithIdentifier:identifer owner:owner];
    
    return cell;

}
-(void)updateCellWithServices:(ServiceDTO *)service
{

    self.name.text=service.model;
    self.txtDescription.text=service.description;
    [self.time setText:service.estimated_time];
    if ([service.checkStatus isEqualToString:@"0"]) {
        
        [self.checkButton setImage:[UIImage imageNamed:@"friend_unselected"] forState: UIControlStateNormal];
    }
    else
    {
        [self.checkButton setImage:[UIImage imageNamed:@"friend_selected"] forState:UIControlStateNormal];
    }

}
- (void)dealloc {
    [_name release];
   // [_description release];
    [_checkButton release];
    [_time release];
    [_txtDescription release];
    [super dealloc];
}
@end
