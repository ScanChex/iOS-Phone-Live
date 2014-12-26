//
//  TrueFalseCell.m
//  VeriScanQR
//
//  Created by Adnan Ahmad on 26/01/2013.
//  Copyright (c) 2013 Adnan Ahmad. All rights reserved.
//

#import "TrueFalseCell.h"
#import "CustomCellHelper.h"
#import "ShowQuestionsVC.h"
@implementation TrueFalseCell

@synthesize owner,indexPath;

@synthesize isTrue=_isTrue;
@synthesize isFalse=_isFalse;

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

+(TrueFalseCell *)resuableCellForTableView:(UITableView *)tableview withOwner:(UIViewController *)owner{

    static NSString *identifer= @"TrueFalseCell";
    
    TrueFalseCell *cell = (TrueFalseCell *)[CustomCellHelper tableView:tableview cellWithIdentifier:identifer owner:owner];
   
    cell.owner = owner;
   
    return cell;
}

-(void)updateCellWithData:(QuestionDTO *)question{

    self.question.text=question.question;
    
    if (question.isTrue) {
        
        [self.falseButton setImage:[UIImage imageNamed:@"friend_unselected"] forState:UIControlStateNormal];
        [self.trueButton setImage:[UIImage imageNamed:@"friend_selected"] forState: UIControlStateNormal];
    }
    else if (question.isFalse){
    
        [self.falseButton setImage:[UIImage imageNamed:@"friend_selected"] forState:UIControlStateNormal];
        [self.trueButton setImage:[UIImage imageNamed:@"friend_unselected"] forState: UIControlStateNormal];
    
    }
    else{
        [self.falseButton setImage:[UIImage imageNamed:@"friend_unselected"] forState:UIControlStateNormal];
        [self.trueButton setImage:[UIImage imageNamed:@"friend_unselected"] forState: UIControlStateNormal];
    }
    
    if ([question.questionAnswer isEqualToString:@"false"]) {
        [self.falseButton setImage:[UIImage imageNamed:@"friend_selected"] forState:UIControlStateNormal];
        [self.trueButton setImage:[UIImage imageNamed:@"friend_unselected"] forState: UIControlStateNormal];
    }
    else if ([question.questionAnswer isEqualToString:@"true"]){
        [self.falseButton setImage:[UIImage imageNamed:@"friend_unselected"] forState:UIControlStateNormal];
        [self.trueButton setImage:[UIImage imageNamed:@"friend_selected"] forState: UIControlStateNormal];
    }
    
    
}

- (IBAction)trueButtonPressed:(id)sender {
    
    [(ShowQuestionsVC *)owner trueButtonPressedAtIndexPath:indexPath];
}

- (IBAction)falseButtonPressed:(id)sender {
    
    [(ShowQuestionsVC *)owner falseButtonPressedAtIndexPath:indexPath];
}
- (void)dealloc {
    [_question release];
    [_trueButton release];
    [_falseButton release];
    [super dealloc];
}
@end
