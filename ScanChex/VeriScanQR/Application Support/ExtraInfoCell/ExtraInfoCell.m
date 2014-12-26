//
//  ExtraInfoCell.m
//  VeriScanQR
//
//  Created by Adnan Ahmad on 09/04/2013.
//  Copyright (c) 2013 Adnan Ahmad. All rights reserved.
//

#import "ExtraInfoCell.h"
#import "CustomCellHelper.h"

@implementation ExtraInfoCell

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


+(ExtraInfoCell *)resuableCellForTableView:(UITableView *)tableview withOwner:(UIViewController *)owner{

    static NSString *identifer= @"ExtraInfoCell";
    ExtraInfoCell *cell = (ExtraInfoCell *)[CustomCellHelper tableView:tableview cellWithIdentifier:identifer owner:owner];
    
    return cell;

}
-(void)updateCellWithComponents:(ComponentDTO *)component{

    self.txtDescription.text =[NSString stringWithFormat:@"  %@ \n %@",component.compID,component.description];
    self.qty.text=component.qty;
    self.price.text=component.price;
    self.total.text=component.totalPrice;
}

- (void)dealloc {
    [_txtDescription release];
    [_price release];
    [_total release];
    [_notes release];
    [_qty release];
    [super dealloc];
}

@end
