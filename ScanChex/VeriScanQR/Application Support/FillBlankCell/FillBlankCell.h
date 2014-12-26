//
//  FillBlankCell.h
//  VeriScanQR
//
//  Created by Adnan Ahmad on 09/01/2013.
//  Copyright (c) 2013 Adnan Ahmad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionDTO.h"

@interface FillBlankCell : UITableViewCell

@property (nonatomic, assign) UIViewController *owner;
@property (nonatomic, retain) NSIndexPath *indexPath;
@property (retain, nonatomic) IBOutlet UITextView *question;
@property (retain, nonatomic) IBOutlet UITextField *answer;

+(FillBlankCell *)resuableCellForTableView:(UITableView *)tableview withOwner:(UIViewController *)owner;
-(void)updateCellWithData:(QuestionDTO *)question;
@end
