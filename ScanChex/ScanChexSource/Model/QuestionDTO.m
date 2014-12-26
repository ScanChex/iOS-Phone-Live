//
//  QuestionDTO.m
//  VeriScanQR
//
//  Created by Adnan Ahmad on 26/01/2013.
//  Copyright (c) 2013 Adnan Ahmad. All rights reserved.
//

#import "QuestionDTO.h"

@implementation QuestionDTO

@synthesize questionID=_questionID;
@synthesize questionType=_questionType;
@synthesize question=_question;
@synthesize questionAnswer=_questionAnswer;
@synthesize  answers=_answers;

@synthesize isFalse=_isFalse;
@synthesize isTrue=_isTrue;
@synthesize selectedOption=_selectedOption;
@synthesize fieldValue=_fieldValue;

+(id)initwithQuestion:(NSDictionary *)dictionary{

    return [[[self alloc] initWithDictionary:dictionary] autorelease];
}

-(void)updateWithDictionary:(NSDictionary *)dictionary{

    self.question=[NSString stringWithFormat:@"%@",[dictionary valueForKey:@"question"]];
    self.questionID=[NSString stringWithFormat:@"%@",[dictionary valueForKey:@"quest_id"]];
    self.questionType=[[NSString stringWithFormat:@"%@",[dictionary valueForKey:@"quest_type_id"]] integerValue];
    self.questionAnswer = [NSString stringWithFormat:@"%@",[dictionary valueForKey:@"q_answer"]];
    if (self.questionType==2)
        self.answers =[NSMutableArray arrayWithArray:[dictionary valueForKey:@"answers"]];
        
    
}
@end
