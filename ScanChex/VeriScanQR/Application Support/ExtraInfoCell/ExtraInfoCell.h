//
//  ExtraInfoCell.h
//  VeriScanQR
//
//  Created by Adnan Ahmad on 09/04/2013.
//  Copyright (c) 2013 Adnan Ahmad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComponentDTO.h"

@interface ExtraInfoCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UITextView *txtDescription;
@property (retain, nonatomic) IBOutlet UILabel *price;
@property (retain, nonatomic) IBOutlet UILabel *total;
@property (retain, nonatomic) IBOutlet UILabel *qty;
@property (retain, nonatomic) IBOutlet UIButton *notes;

+(ExtraInfoCell *)resuableCellForTableView:(UITableView *)tableview withOwner:(UIViewController *)owner;
-(void)updateCellWithComponents:(ComponentDTO *)component;

@end
