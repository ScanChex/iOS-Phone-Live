//
//  ShowQuestionsVC.m
//  VeriScanQR
//
//  Created by Adnan Ahmad on 26/01/2013.
//  Copyright (c) 2013 Adnan Ahmad. All rights reserved.
//

#import "ShowQuestionsVC.h"
#import "FillBlankCell.h"
#import "WebServiceManager.h"
#import "TrueFalseCell.h"
#import "MultipleChoiceCell.h"
#import "QuestionDTO.h"
#import "WebServiceManager.h"
#import "VSSharedManager.h"
#import "TicketDTO.h"
#import "UserDTO.h"
#import "SVProgressHUD.h"
#import "TicketInfoDTO.h"
#import <QuartzCore/QuartzCore.h>
#import "SharedManager.h"
#import "HistoryDTO.h"

@interface ShowQuestionsVC ()

-(id)initWithData:(NSArray*)data;
-(void)updateGUI;
-(BOOL)isAllFilled;
-(NSMutableArray *)buildQuestionsArray;
-(NSMutableArray *)buildAnswersArray;
-(void)submitQuestion;

@end


@implementation ShowQuestionsVC

@synthesize questionArray=_questionArray;
@synthesize delegate=_delegate;
@synthesize isSubmited = _isSubmited;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

+(id)initWithQuesitons:(NSMutableArray *)questionsData history:(NSMutableArray*)historyData{

    return [[[ShowQuestionsVC alloc] initWithData:questionsData history:historyData] autorelease];
}

- (IBAction)notesButtonPressed:(id)sender {
//    if ([self.historyArray count]>0) {
//        HistoryDTO * ticket = [self.historyArray objectAtIndex:0];
//        [self.delegate showNotes:ticket.notes];
////         [self.navigationController pushViewController:[NotesVC initWithCompontentNotes:ticket.notes] animated:YES];
//    }
  
//    if (![[VSSharedManager sharedManager] isPreview]) {
//    
        [self.delegate notesButtonPressed];
//    }

}

- (IBAction)audioButtonPressed:(id)sender {
    if (![[VSSharedManager sharedManager] isPreview]) {
        [self.delegate audioButtonPressed];
    }

}

- (IBAction)videoButtonPressed:(id)sender {
    if (![[VSSharedManager sharedManager] isPreview]) {
        [self.delegate videoButtonPressed];
    }
}

- (IBAction)imageUploadButtonPressed:(id)sender{

    if (![[VSSharedManager sharedManager] isPreview]) {
        [self.delegate uploadImagePressed];
    }

}

-(IBAction)submitButtonPress:(id)sender
{

    if ([self isAllFilled]) {
        
        ///Call webservice
        [self submitQuestion];
    }
    else
    {
        [self initWithPromptTitle:@"Fill all questions" message:@"You need to fill all question"];
    }

}

-(id)initWithData:(NSMutableArray*)data history:(NSMutableArray*)history{

    self.historyArray = [[NSMutableArray alloc] initWithObjects:nil];
    if (IS_IPHONE5) {
  
        self=[super initWithNibName:@"ShowQuestionsiPhone5VC" bundle:nil];

    }
    else
    {
        self=[super initWithNibName:@"ShowQuestionsVC" bundle:nil];
    }
    if (self) {
        
        self.questionArray=[NSMutableArray arrayWithArray:data];
        self.historyArray = [NSMutableArray arrayWithArray:history];
    }
    if (![[VSSharedManager sharedManager] isPreview]) {
        [self.submitButtonl setHidden:NO];
        
    }
    else {
        [self.submitButtonl setHidden:YES];
    }
  
  
    return self;
}
- (void)viewDidLoad
{
    for (UIView *v in [self.view subviews]) {
        if ([v isKindOfClass:[UIButton class]]) {
            if ([[[(UIButton*)v titleLabel] text] isEqualToString:@"SUBMIT"]) {
                 v.layer.cornerRadius = 5.0f;
            }
           
        }
    }
     [self.view setBackgroundColor:[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"color"]]];
    [super viewDidLoad];
     if (![[VSSharedManager sharedManager] isPreview]) {
         [self.submitButtonl setHidden:NO];
         
    }
     else {
         [self.submitButtonl setHidden:YES];
     }
    [self updateGUI];
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (![[VSSharedManager sharedManager] isPreview]) {
        [self.submitButtonl setHidden:NO];
        
    }
    else {
        [self.submitButtonl setHidden:YES];
    }
}
-(void)updateGUI{
//    if ([self.historyArray count]>0) {
//        HistoryDTO * ticket = [self.historyArray objectAtIndex:0];
//        if ([ticket.notes count]==0){ self.notesLabel.hidden = YES; }else{ self.notesLabel.hidden = NO;self.notesLabel.text = [NSString stringWithFormat:@"%d",[ticket.notes count]]; [self.notesLabel.layer setCornerRadius:5.0f];}
//        if ([ticket.voice count]==0){ self.voiceLabel.hidden = YES;}else{ self.voiceLabel.hidden = NO;self.voiceLabel.text = [NSString stringWithFormat:@"%d",[ticket.voice count]];[self.voiceLabel.layer setCornerRadius:5.0f];}
//        if ([ticket.video count]==0){ self.videoLabel.hidden = YES;}else{ self.videoLabel.hidden = NO;self.videoLabel.text = [NSString stringWithFormat:@"%d",[ticket.video count]];[self.videoLabel.layer setCornerRadius:5.0f];}
//        if ([ticket.imgURL count]==0){self.imageLabel.hidden = YES;}else{ self.imageLabel.hidden = NO;self.imageLabel.text = [NSString stringWithFormat:@"%d",[ticket.imgURL count]];[self.imageLabel.layer setCornerRadius:5.0f];}
//    }
  
    self.notesLabel.hidden = YES;
    self.voiceLabel.hidden = YES;
    self.videoLabel.hidden = YES;
    self.imageLabel.hidden = YES;
  
    self.imageLabel.layer.cornerRadius = 5.0;
    self.voiceLabel.layer.cornerRadius = 5.0;
    self.videoLabel.layer.cornerRadius = 5.0;
    self.notesLabel.layer.cornerRadius = 5.0;
    
     self.isSubmited =NO;
     TicketDTO *ticket =[[VSSharedManager sharedManager] selectedTicket];
     self.totalCodes.text=[NSString stringWithFormat:@"%@", ticket.totalCodes];
     self.remainingCodes.text=[NSString stringWithFormat:@"%@",ticket.remainingCodes];
     self.scannedCodes.text=[NSString stringWithFormat:@"%@",ticket.scannedCodes];
  
  if ([self isAllFilled]) {
    // if ([self.delegate respondsToSelector:@selector(allQuestionsAnswered)]) {
    [self.delegate allQuestionsAnswered];
     self.isSubmited =YES;
    //  }
  }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.questionArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    QuestionDTO *question=[self.questionArray objectAtIndex:indexPath.row];
    
    if(question.questionType ==1){
    
        TrueFalseCell *cell=[TrueFalseCell resuableCellForTableView:self.questionTable withOwner:self];
        cell.indexPath=indexPath;
        [cell updateCellWithData:question];
        [cell setBackgroundColor:[UIColor clearColor]];
        [cell.contentView setBackgroundColor:[UIColor clearColor]];
        return cell;
    }
    else if(question.questionType ==2){
    
        MultipleChoiceCell *cell=[MultipleChoiceCell resuableCellForTableView:self.questionTable withOwner:self];
        cell.indexPath=indexPath;
        [cell updateCellWithData:question];
        [cell setBackgroundColor:[UIColor clearColor]];
        [cell.contentView setBackgroundColor:[UIColor clearColor]];
        return cell;
    }
    else if (question.questionType ==3) {
        
        
        FillBlankCell *cell=[FillBlankCell resuableCellForTableView:self.questionTable withOwner:self];
        cell.indexPath=indexPath;
        cell.answer.tag=indexPath.row;
        cell.answer.delegate=self;
        [cell updateCellWithData:question];
        [cell setBackgroundColor:[UIColor clearColor]];
        [cell.contentView setBackgroundColor:[UIColor clearColor]];
        return cell;
        
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    QuestionDTO *question=[self.questionArray objectAtIndex:indexPath.row];
  
   if (question.questionType ==2) return 125.0;
    
    return 44.0;
}

#pragma tableView Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

  
    
}

-(BOOL)isAllFilled{

   // if (![[VSSharedManager sharedManager] isPreview]) {
    ///check all data is uploaded or not
    for (QuestionDTO *question in self.questionArray) {
        
        if(question.questionType ==1){
        
            if (question.isTrue || question.isFalse || !([question.questionAnswer isKindOfClass:[NSNull class]])) {
                
                //do nothing 
            }
            else
                return NO;
            
        }
        else if(question.questionType ==2){
        
            if ((question.selectedOption!=0)  || !([question.questionAnswer isKindOfClass:[NSNull class]])) {
                
                //do nothing
            }
            else
                return NO;
        }
        else if(question.questionType ==3){
        
            if (([question.fieldValue length]>0) || !([question.questionAnswer isKindOfClass:[NSNull class]])) {
                
                // do nothing
            }
            else
                return NO;
        }
        
    }
  //  }
    return YES;
}


-(NSMutableArray *)buildQuestionsArray{

    NSMutableArray *questions=[NSMutableArray array];
    for (QuestionDTO *question in self.questionArray) {
    
        [questions addObject:question.questionID];
    }

    return questions;
}

-(NSMutableArray *)buildAnswersArray{

    
    NSMutableArray *answers=[NSMutableArray array];
    
    ///check all data is uploaded or not
    for (QuestionDTO *question in self.questionArray) {
        
        if(question.questionType ==1){
            
            if (question.isTrue)
                [answers addObject:@"true"];
            else
                [answers addObject:@"false"];
                
        }
        else if(question.questionType ==2)
            [answers addObject:[question.answers objectAtIndex:question.selectedOption-1]];
        else if(question.questionType ==3)
            [answers addObject:question.fieldValue];
    
    }
    
    return answers;
}

/////True False button Pressed
-(void)trueButtonPressedAtIndexPath:(NSIndexPath *)indexPath{

    if (![[VSSharedManager sharedManager] isPreview]) {
        QuestionDTO *question=[self.questionArray objectAtIndex:indexPath.row];
        question.isTrue=YES;
        question.isFalse=NO;
        [self.questionArray replaceObjectAtIndex:indexPath.row withObject:question];
        [self.questionTable reloadData];
    }
    
    
   
}
-(void)falseButtonPressedAtIndexPath:(NSIndexPath *)indexpath{

    if (![[VSSharedManager sharedManager] isPreview]) {
    QuestionDTO *question=[self.questionArray objectAtIndex:indexpath.row];
    question.isTrue=NO;
    question.isFalse=YES;
    [self.questionArray replaceObjectAtIndex:indexpath.row withObject:question];
            [self.questionTable reloadData];
        }
    
}


////Multiple Choice Button Pressed

-(void)multipleChoiceOptionSelected:(int)option withIndexPath:(NSIndexPath *)indexPath{

    if (![[VSSharedManager sharedManager] isPreview]) {
        QuestionDTO *question=[self.questionArray objectAtIndex:indexPath.row];
        question.selectedOption=option;
        [self.questionArray replaceObjectAtIndex:indexPath.row withObject:question];
        [self.questionTable reloadData];
    }
    
}

#pragma Textfield delegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (![[VSSharedManager sharedManager] isPreview]) {
        return YES;
    }
    else {
        return NO;
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    // Dismisses the keyboard when the "Done" button is clicked
    
    int z = textField.tag;
    
//    if (!IS_IPHONE5) {
//        
//        self.questionTable.frame = CGRectMake(0.0,0.0,310.0,218.0);
//    }
//    else
//    {
//       // CGFloat tableHeight  = self.questionTable.frame.size.height;
//    
//        self.questionTable.frame = CGRectMake(0.0,0.0,320.0,250);
//    }
//    
//    if (z > 0) {
//        
//        // Undo the contentInset
//        self.questionTable.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
//        
//    }
//    
     CGPoint pnt = [self.questionTable convertPoint:textField.bounds.origin fromView:textField];
     NSIndexPath* path = [self.questionTable indexPathForRowAtPoint:pnt];
    //save the answer thier////
    QuestionDTO *question=[self.questionArray objectAtIndex:path.row];
    question.fieldValue=textField.text;
    [self.questionArray replaceObjectAtIndex:path.row withObject:question];
    [self.questionTable  reloadData];

  
    [textField resignFirstResponder];
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField {
    int z = textField.tag;
    
//    if (!IS_IPHONE5) {
//        
//        self.questionTable.frame = CGRectMake(0.0,0.0,310.0,218.0);
//    }
//    else
//    {
//        // CGFloat tableHeight  = self.questionTable.frame.size.height;
//        
//        self.questionTable.frame = CGRectMake(0.0,0.0,320.0,250);
//    }
//    
//    if (z > 0) {
//        
//        // Undo the contentInset
//        self.questionTable.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
//        
//    }
    
    CGPoint pnt = [self.questionTable convertPoint:textField.bounds.origin fromView:textField];
    NSIndexPath* path = [self.questionTable indexPathForRowAtPoint:pnt];
    //save the answer thier////
    QuestionDTO *question=[self.questionArray objectAtIndex:path.row];
    question.fieldValue=textField.text;
    [self.questionArray replaceObjectAtIndex:path.row withObject:question];
    [self.questionTable  reloadData];
    
    
    [textField resignFirstResponder];
}

-(void) textFieldDidBeginEditing:(UITextField *)textField {
    
    int z = textField.tag;
    
    CGPoint pnt = [self.questionTable convertPoint:textField.bounds.origin fromView:textField];
    NSIndexPath* path = [self.questionTable indexPathForRowAtPoint:pnt];
    
    
//    if (!IS_IPHONE5) {
//        
//        self.questionTable.frame = CGRectMake(0.0,0.0,320.0,218.0-70);
//    }
//    else
//    {
//     
//      //  CGFloat tableHeight  = self.questionTable.frame.size.height;
//
//        self.questionTable.frame = CGRectMake(0.0,0.0,320.0,258.0);
//        
//    }
//    if (z > 0) {
//        
//        // Only deal with the table row if the row index is 5
//        // or greater since the first five rows are already
//        // visible above the keyboard
//        // adjust the contentInset
//        
//        self.questionTable.contentInset = UIEdgeInsetsMake(0, 0, 20, 0);
//        // Scroll to the current text field
//        [self.questionTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:z inSection:path.section] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
//        
//    }
}


-(void)submitQuestion{

    if (![[VSSharedManager sharedManager] isPreview]) {
    
    
    UserDTO*user=[[VSSharedManager sharedManager] currentUser];
    TicketInfoDTO *ticket =[[VSSharedManager sharedManager] selectedTicketInfo];
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];

    [[WebServiceManager sharedManager] upadteAnswers:[NSString stringWithFormat:@"%d",user.masterKey]
                                            questIDS:[self buildQuestionsArray]
                                             answers:[self buildAnswersArray]
                                            ticketID:ticket.tblTicketID
                               withCompletionHandler:^(id data,BOOL error){
                            
                                   self.isSubmited = YES;
                                   [SVProgressHUD dismiss];
                                   if (!error)
                                       [self initWithPromptTitle:@"Data Uploaded" message:@"Data uploaded successfully"];
                                   [self.delegate allQuestionsAnswered];
                                 
                               }];
    }
}

-(void)dealloc{

    [_questionArray release];
    [_questionTable release];
    [_totalCodes release];
    [_scannedCodes release];
    [_remainingCodes release];
    [super dealloc];
}

- (void)viewDidUnload {
    [self setQuestionTable:nil];
    [self setTotalCodes:nil];
    [self setScannedCodes:nil];
    [self setRemainingCodes:nil];
    [super viewDidUnload];
}
@end
