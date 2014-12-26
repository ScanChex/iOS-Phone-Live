//
//  ServiceCell.h
//  VeriScanQR
//
//  Created by Adnan Ahmad on 30/04/2013.
//  Copyright (c) 2013 Adnan Ahmad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceDTO.h"

@interface ServiceCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UILabel *name;
//@property (retain, nonatomic) IBOutlet UITextView *description;
@property (retain, nonatomic) IBOutlet UITextView *txtDescription;
@property (retain, nonatomic) IBOutlet UIButton *checkButton;
@property (retain, nonatomic) IBOutlet UILabel * time;
+(ServiceCell *)resuableCellForTableView:(UITableView *)tableview withOwner:(UIViewController *)owner;
-(void)updateCellWithServices:(ServiceDTO *)service;
@end
