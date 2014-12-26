//
//  FillBlankCell.m
//  VeriScanQR
//
//  Created by Adnan Ahmad on 09/01/2013.
//  Copyright (c) 2013 Adnan Ahmad. All rights reserved.
//

#import "FillBlankCell.h"
#import "CustomCellHelper.h"

@interface FillBlankCell()

@end

@implementation FillBlankCell
@synthesize owner,indexPath;
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
+(FillBlankCell *)resuableCellForTableView:(UITableView *)tableview withOwner:(UIViewController *)owner{
    
    static NSString *identifer= @"FillBlankCell";
    
    FillBlankCell *cell = (FillBlankCell *)[CustomCellHelper tableView:tableview cellWithIdentifier:identifer owner:owner];
    
    cell.owner = owner;
    
    return cell;
}
-(void)updateCellWithData:(QuestionDTO *)question{

    self.question.text=question.question;
    if ([question.fieldValue length]>0) self.answer.text=question.fieldValue;
    else self.answer.text=@"";
    
    if ([question.questionAnswer isKindOfClass:[NSString class]] && [question.questionAnswer length]>0) {
        [self.answer setText:question.questionAnswer];
    }
}

- (void)dealloc {
    [_question release];
    [_answer release];
    [super dealloc];
}

@end
