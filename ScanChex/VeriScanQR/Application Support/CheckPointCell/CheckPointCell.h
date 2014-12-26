//
//  CheckPointCell.h
//  VeriScanQR
//
//  Created by Rajeel Amjad on 08/05/2014.
//  Copyright (c) 2014 Adnan Ahmad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CheckPointDTO.h"

@interface CheckPointCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UITextView * descriptionTextView;
@property (nonatomic, retain) IBOutlet UIButton * scanButton;
@property (nonatomic, retain) IBOutlet UILabel * time;
@property (nonatomic, retain) IBOutlet UIButton * checkMarkButton;
+(CheckPointCell *)resuableCellForTableView:(UITableView *)tableview withOwner:(UIViewController *)owner;
-(void)updateCellWithMessage:(CheckPointDTO *)messageDTO :(NSString*)isScanned;


@end
