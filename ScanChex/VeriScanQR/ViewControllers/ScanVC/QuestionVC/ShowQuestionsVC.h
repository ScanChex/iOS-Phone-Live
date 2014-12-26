//
//  ShowQuestionsVC.h
//  VeriScanQR
//
//  Created by Adnan Ahmad on 26/01/2013.
//  Copyright (c) 2013 Adnan Ahmad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseVC.h"
#import "NotesVC.h"

@protocol showQuestionDelegate <NSObject>

@optional
-(void)videoButtonPressed;
-(void)audioButtonPressed;
-(void)notesButtonPressed;
-(void)uploadImagePressed;
-(void)showNotes:(NSArray *)notes;
-(void)allQuestionsAnswered;
@end

@interface ShowQuestionsVC : BaseVC<UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
  id<showQuestionDelegate>_delegate;
}

@property (retain, nonatomic) IBOutlet UILabel *totalCodes;
@property (retain, nonatomic) IBOutlet UILabel *scannedCodes;
@property (retain, nonatomic) IBOutlet UILabel *remainingCodes;
@property (retain, nonatomic) IBOutlet UITableView *questionTable;
@property (nonatomic,retain)NSMutableArray *questionArray;
@property (nonatomic, retain) IBOutlet UIButton * submitButtonl;
@property (retain, nonatomic) IBOutlet UILabel *imageLabel;
@property (retain, nonatomic) IBOutlet UILabel *voiceLabel;
@property (retain, nonatomic) IBOutlet UILabel *videoLabel;
@property (retain, nonatomic) IBOutlet UILabel *notesLabel;

@property (nonatomic,assign)id<showQuestionDelegate>delegate;
@property (nonatomic,assign) BOOL isSubmited;
-(void)trueButtonPressedAtIndexPath:(NSIndexPath *)indexPath;
-(void)falseButtonPressedAtIndexPath:(NSIndexPath *)indexpath;
-(void)multipleChoiceOptionSelected:(int)option withIndexPath:(NSIndexPath *)indexPath;
@property (nonatomic, retain) NSMutableArray * historyArray;

+(id)initWithQuesitons:(NSMutableArray *)questionsData history:(NSMutableArray*)historyData;

- (IBAction)notesButtonPressed:(id)sender;
- (IBAction)audioButtonPressed:(id)sender;
- (IBAction)videoButtonPressed:(id)sender;
- (IBAction)imageUploadButtonPressed:(id)sender;
- (IBAction)submitButtonPress:(id)sender;

@end
