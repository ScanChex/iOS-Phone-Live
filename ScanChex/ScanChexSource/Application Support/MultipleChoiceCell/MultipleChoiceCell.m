//
//  MultipleChoiceCell.m
//  VeriScanQR
//
//  Created by Adnan Ahmad on 28/01/2013.
//  Copyright (c) 2013 Adnan Ahmad. All rights reserved.
//

#import "MultipleChoiceCell.h"
#import "CustomCellHelper.h"
#import "ShowQuestionsVC.h"
#import "VSSharedManager.h"
@implementation MultipleChoiceCell

@synthesize owner;
@synthesize indexPath;
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


+(MultipleChoiceCell *)resuableCellForTableView:(UITableView *)tableview withOwner:(UIViewController *)owner{
    
    static NSString *identifer= @"MultipleChoiceCell";
    
    MultipleChoiceCell *cell = (MultipleChoiceCell *)[CustomCellHelper tableView:tableview cellWithIdentifier:identifer owner:owner];
    
    cell.owner = owner;
    
    return cell;
}

-(void)updateCellWithData:(QuestionDTO *)ticket{
    
    self.question.text=ticket.question;
    
    [self showAnswers:ticket.answers];
    
    switch (ticket.selectedOption) {
        case 1:
        {
            [self.btn1 setImage:[UIImage imageNamed:@"friend_selected"] forState:UIControlStateNormal];
            [self.btn2 setImage:[UIImage imageNamed:@"friend_unselected"] forState:UIControlStateNormal];
            [self.btn3 setImage:[UIImage imageNamed:@"friend_unselected"] forState:UIControlStateNormal];
            [self.btn4 setImage:[UIImage imageNamed:@"friend_unselected"] forState:UIControlStateNormal];
            
            break;
        }
        case 2:
        {
            
            [self.btn1 setImage:[UIImage imageNamed:@"friend_unselected"] forState:UIControlStateNormal];
            [self.btn2 setImage:[UIImage imageNamed:@"friend_selected"] forState:UIControlStateNormal];
            [self.btn3 setImage:[UIImage imageNamed:@"friend_unselected"] forState:UIControlStateNormal];
            [self.btn4 setImage:[UIImage imageNamed:@"friend_unselected"] forState:UIControlStateNormal];
            
            break;
        }
        case 3:
        {
            
            [self.btn1 setImage:[UIImage imageNamed:@"friend_unselected"] forState:UIControlStateNormal];
            [self.btn2 setImage:[UIImage imageNamed:@"friend_unselected"] forState:UIControlStateNormal];
            [self.btn3 setImage:[UIImage imageNamed:@"friend_selected"] forState:UIControlStateNormal];
            [self.btn4 setImage:[UIImage imageNamed:@"friend_unselected"] forState:UIControlStateNormal];
            
            break;
        }
        case 4:
        {
            [self.btn1 setImage:[UIImage imageNamed:@"friend_unselected"] forState:UIControlStateNormal];
            [self.btn2 setImage:[UIImage imageNamed:@"friend_unselected"] forState:UIControlStateNormal];
            [self.btn3 setImage:[UIImage imageNamed:@"friend_unselected"] forState:UIControlStateNormal];
            [self.btn4 setImage:[UIImage imageNamed:@"friend_selected"] forState:UIControlStateNormal];

            break;
        }
            
        default:{
         
            [self.btn1 setImage:[UIImage imageNamed:@"friend_unselected"] forState:UIControlStateNormal];
            [self.btn2 setImage:[UIImage imageNamed:@"friend_unselected"] forState:UIControlStateNormal];
            [self.btn3 setImage:[UIImage imageNamed:@"friend_unselected"] forState:UIControlStateNormal];
            [self.btn4 setImage:[UIImage imageNamed:@"friend_unselected"] forState:UIControlStateNormal];

            break;
        }
    }
    
    for (int i = 0; i<[ticket.answers count]; i++) {
        
        NSString * tempString = [ticket.answers objectAtIndex:i];
        if ([tempString isEqualToString:ticket.questionAnswer]) {
            switch (i) {
                case 0:
                {
                    [self.btn1 setImage:[UIImage imageNamed:@"friend_selected"] forState:UIControlStateNormal];
                    [self.btn2 setImage:[UIImage imageNamed:@"friend_unselected"] forState:UIControlStateNormal];
                    [self.btn3 setImage:[UIImage imageNamed:@"friend_unselected"] forState:UIControlStateNormal];
                    [self.btn4 setImage:[UIImage imageNamed:@"friend_unselected"] forState:UIControlStateNormal];
                    
                    break;
                }
                case 1:
                {
                    
                    [self.btn1 setImage:[UIImage imageNamed:@"friend_unselected"] forState:UIControlStateNormal];
                    [self.btn2 setImage:[UIImage imageNamed:@"friend_selected"] forState:UIControlStateNormal];
                    [self.btn3 setImage:[UIImage imageNamed:@"friend_unselected"] forState:UIControlStateNormal];
                    [self.btn4 setImage:[UIImage imageNamed:@"friend_unselected"] forState:UIControlStateNormal];
                    
                    break;
                }
                case 2:
                {
                    
                    [self.btn1 setImage:[UIImage imageNamed:@"friend_unselected"] forState:UIControlStateNormal];
                    [self.btn2 setImage:[UIImage imageNamed:@"friend_unselected"] forState:UIControlStateNormal];
                    [self.btn3 setImage:[UIImage imageNamed:@"friend_selected"] forState:UIControlStateNormal];
                    [self.btn4 setImage:[UIImage imageNamed:@"friend_unselected"] forState:UIControlStateNormal];
                    
                    break;
                }
                case 3:
                {
                    [self.btn1 setImage:[UIImage imageNamed:@"friend_unselected"] forState:UIControlStateNormal];
                    [self.btn2 setImage:[UIImage imageNamed:@"friend_unselected"] forState:UIControlStateNormal];
                    [self.btn3 setImage:[UIImage imageNamed:@"friend_unselected"] forState:UIControlStateNormal];
                    [self.btn4 setImage:[UIImage imageNamed:@"friend_selected"] forState:UIControlStateNormal];
                    
                    break;
                }
                    
                default:{
                    
                    [self.btn1 setImage:[UIImage imageNamed:@"friend_unselected"] forState:UIControlStateNormal];
                    [self.btn2 setImage:[UIImage imageNamed:@"friend_unselected"] forState:UIControlStateNormal];
                    [self.btn3 setImage:[UIImage imageNamed:@"friend_unselected"] forState:UIControlStateNormal];
                    [self.btn4 setImage:[UIImage imageNamed:@"friend_unselected"] forState:UIControlStateNormal];
                    
                    break;
                }
            }
            
        }
    }
    
    
}

-(void)showAnswers:(NSMutableArray*)answers{

    switch ([answers count]) {
        case 1:{
            
            self.btn1.hidden=NO;
            self.answer1.hidden=NO;
            self.answer1.text=[answers objectAtIndex:0];

            self.btn2.hidden=YES;
            self.answer2.hidden=YES;

            self.btn3.hidden=YES;
            self.answer3.hidden=YES;
            
            self.btn4.hidden=YES;
            self.answer4.hidden=YES;
            

            break;
        }
        case 2:{
            
            self.btn1.hidden=NO;
            self.answer1.hidden=NO;
            self.answer1.text=[answers objectAtIndex:0];
            
            self.btn2.hidden=NO;
            self.answer2.hidden=NO;
            self.answer2.text=[answers objectAtIndex:1];

            self.btn3.hidden=YES;
            self.answer3.hidden=YES;
            
            self.btn4.hidden=YES;
            self.answer4.hidden=YES;
            

            break;
        }
        case 3:
        {
            self.btn1.hidden=NO;
            self.answer1.hidden=NO;
            self.answer1.text=[answers objectAtIndex:0];
            
            self.btn2.hidden=NO;
            self.answer2.hidden=NO;
            self.answer2.text=[answers objectAtIndex:1];

            self.btn3.hidden=NO;
            self.answer3.hidden=NO;
            self.answer3.text=[answers objectAtIndex:2];

            self.btn4.hidden=YES;
            self.answer4.hidden=YES;
            

            break;
        }
        case 4:
        {
            self.btn1.hidden=NO;
            self.answer1.hidden=NO;
            self.answer1.text=[answers objectAtIndex:0];
            
            self.btn2.hidden=NO;
            self.answer2.hidden=NO;
            self.answer2.text=[answers objectAtIndex:1];

            self.btn3.hidden=NO;
            self.answer3.hidden=NO;
            self.answer3.text=[answers objectAtIndex:2];

            self.btn4.hidden=NO;
            self.answer4.hidden=NO;
            self.answer4.text=[answers objectAtIndex:3];

            break;
        }
            
        default:
            break;
    }


}
-(IBAction)answerSelected:(id)sender{

        if (self.btn1==sender)
            [(ShowQuestionsVC *)owner multipleChoiceOptionSelected:1 withIndexPath:indexPath];
        else if (self.btn2==sender)
            [(ShowQuestionsVC *)owner multipleChoiceOptionSelected:2 withIndexPath:indexPath];
        else if (self.btn3==sender)
            [(ShowQuestionsVC *)owner multipleChoiceOptionSelected:3 withIndexPath:indexPath];
        else if (self.btn4==sender)
            [(ShowQuestionsVC *)owner multipleChoiceOptionSelected:4 withIndexPath:indexPath];
}


- (void)dealloc {
    [_question release];
    [_answer1 release];
    [_answer2 release];
    [_answer3 release];
    [_answer4 release];
    [_btn1 release];
    [_btn2 release];
    [_btn3 release];
    [_btn4 release];
    [super dealloc];
}

@end
