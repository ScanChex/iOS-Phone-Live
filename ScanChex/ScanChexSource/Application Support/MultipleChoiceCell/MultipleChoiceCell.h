//
//  MultipleChoiceCell.h
//  VeriScanQR
//
//  Created by Adnan Ahmad on 28/01/2013.
//  Copyright (c) 2013 Adnan Ahmad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionDTO.h"
@interface MultipleChoiceCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UITextView *question;
@property (retain, nonatomic) IBOutlet UILabel *answer1;
@property (retain, nonatomic) IBOutlet UILabel *answer2;
@property (retain, nonatomic) IBOutlet UILabel *answer3;
@property (retain, nonatomic) IBOutlet UILabel *answer4;
@property (nonatomic, assign) UIViewController *owner;
@property (nonatomic, retain) NSIndexPath *indexPath;
@property (retain, nonatomic) IBOutlet UIButton *btn1;
@property (retain, nonatomic) IBOutlet UIButton *btn2;
@property (retain, nonatomic) IBOutlet UIButton *btn3;
@property (retain, nonatomic) IBOutlet UIButton *btn4;

+(MultipleChoiceCell *)resuableCellForTableView:(UITableView *)tableview withOwner:(UIViewController *)owner;
-(void)updateCellWithData:(QuestionDTO*)question;
-(IBAction)answerSelected:(id)sender;

@end
