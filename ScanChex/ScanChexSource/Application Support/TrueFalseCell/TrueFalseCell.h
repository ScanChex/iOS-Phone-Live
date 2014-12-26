//
//  TrueFalseCell.h
//  VeriScanQR
//
//  Created by Adnan Ahmad on 26/01/2013.
//  Copyright (c) 2013 Adnan Ahmad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionDTO.h"

@interface TrueFalseCell : UITableViewCell

@property (nonatomic, assign) UIViewController *owner;
@property (nonatomic, retain) NSIndexPath *indexPath;
@property (retain, nonatomic) IBOutlet UITextView *question;
@property (retain, nonatomic) IBOutlet UIButton *trueButton;
@property (retain, nonatomic) IBOutlet UIButton *falseButton;

@property (nonatomic,assign) BOOL isTrue;
@property (nonatomic,assign) BOOL isFalse;
+(TrueFalseCell *)resuableCellForTableView:(UITableView *)tableview withOwner:(UIViewController *)owner;
-(void)updateCellWithData:(QuestionDTO*)question;
- (IBAction)trueButtonPressed:(id)sender;
- (IBAction)falseButtonPressed:(id)sender;

@end
