//
//  QuestionDTO.h
//  VeriScanQR
//
//  Created by Adnan Ahmad on 26/01/2013.
//  Copyright (c) 2013 Adnan Ahmad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseDTO.h"
@interface QuestionDTO : BaseDTO

@property(nonatomic,retain)NSString *questionID;
@property(nonatomic,assign)NSInteger questionType;
@property(nonatomic,retain)NSString *question;
@property(nonatomic,retain)NSString *questionAnswer;
@property(nonatomic,retain)NSMutableArray *answers;

////For True False/////
@property(nonatomic,assign)BOOL isFalse;
@property(nonatomic,assign)BOOL isTrue;
///////For Fill In the Blanks//////////
@property(nonatomic,retain)NSString *fieldValue;
//////For MultipleChoice Questions/////
@property(nonatomic,assign) NSInteger selectedOption;

 
+(id)initwithQuestion:(NSDictionary *)dictionary;
@end
