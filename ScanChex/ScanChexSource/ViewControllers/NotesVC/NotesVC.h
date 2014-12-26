//
//  NotesVC.h
//  VeriScanQR
//
//  Created by Adnan Ahmad on 09/02/2013.
//  Copyright (c) 2013 Adnan Ahmad. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseVC.h"
#import "NoteView.h"
#import "iCarousel.h"
@interface NotesVC : BaseVC <UITextViewDelegate,iCarouselDataSource,iCarouselDelegate>
@property (retain, nonatomic) IBOutlet UIButton *doneButton;
@property (retain, nonatomic) IBOutlet UIButton *submitButton;
@property (retain, nonatomic) IBOutlet iCarousel * carousel;
@property (retain , nonatomic) IBOutlet UIButton * nextButton;
@property (retain , nonatomic) IBOutlet UIButton * prevButton;
@property (retain , nonatomic) IBOutlet UILabel * countLabel;
@property (retain , nonatomic) IBOutlet UIButton * addNoteButton;
@property (assign) NSInteger currentSelectedIndex;
- (IBAction)submitButtonPressed:(id)sender;
- (IBAction)backButtonPressed:(id)sender;
- (IBAction)doneButtonPressed:(id)sender;
@property (retain, nonatomic) IBOutlet NoteView *notes;

+(id)initWithNotes;

+(id)initWithCompontentNotes:(NSArray *)notes;
-(IBAction)nextButtonAction:(id)sender;
-(IBAction)prevButtonAction:(id)sender;
-(IBAction)addNoteButtonAction:(id)sender;

@end
