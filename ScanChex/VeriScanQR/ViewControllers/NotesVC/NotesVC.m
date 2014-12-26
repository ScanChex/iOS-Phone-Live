//
//  NotesVC.m
//  VeriScanQR
//
//  Created by Adnan Ahmad on 09/02/2013.
//  Copyright (c) 2013 Adnan Ahmad. All rights reserved.
//

#import "NotesVC.h"
#import <QuartzCore/QuartzCore.h>
#import "WebServiceManager.h"
#import "SVProgressHUD.h"
#import "UserDTO.h"
#import "VSSharedManager.h"
@interface NotesVC ()

@property(nonatomic,retain) NSArray *notesString;
-(id)initWithData:(NSArray *)notes;

@end

@implementation NotesVC

@synthesize notesString=_notesString;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

+(id)initWithCompontentNotes:(NSArray *)notes
{

    return [[NotesVC alloc] initWithData:notes];
}

-(id)initWithData:(NSArray *)notes{

    self=[super initWithNibName:@"NotesVC" bundle:nil];
    if (self) {
        
        self.notesString=notes;
    }

    return self;
}

+(id)initWithNotes{

    return [[[NotesVC alloc] initWithNibName:@"NotesVC" bundle:nil] autorelease];
}
- (void)viewDidLoad
{
     [self.view setBackgroundColor:[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"color"]]];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
  
//    [self.notes becomeFirstResponder];
//    
    if ([self.notesString count]>0) {
        [self.notes setHidden:YES];
        [self.carousel setType:iCarouselTypeLinear];
        [self.carousel setDelegate:self];
        [self.carousel reloadData];
        [self setCurrentSelectedIndex:0];
        [self.countLabel setText:[NSString stringWithFormat:@"Note %d of %d",self.currentSelectedIndex+1,[self.notesString count]]];
//
        self.doneButton.hidden=YES;
        self.submitButton.hidden=YES;
//        self.notes.text=[[self.notesString objectAtIndex:0] objectForKey:@"note"];
//        self.notes.editable=NO;
    }
    else {
        [self.addNoteButton setTitle:@"View Notes" forState:UIControlStateNormal];
        [self.carousel setHidden:YES];
        [self.nextButton setHidden:YES];
        [self.prevButton setHidden:YES];
        [self.countLabel setHidden:YES];
        self.submitButton.hidden=NO;
        [self.notes setHidden:NO];
    }
    
    
     if ([[VSSharedManager sharedManager] isPreview] || [[VSSharedManager sharedManager] isHistoryTab]  ) {
         [self.addNoteButton setHidden:YES];
    }

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    // to update NoteView
    [self.notes setNeedsDisplay];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_doneButton release];
    [_submitButton release];
    [_notes release];
    [super dealloc];
}
- (void)viewDidUnload {
    [super viewDidUnload];
}
- (IBAction)submitButtonPressed:(id)sender {
    
    if (![[VSSharedManager sharedManager] isPreview]) {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
        
        UserDTO*user =[[VSSharedManager sharedManager] currentUser];
        [[WebServiceManager sharedManager] uploadNotes:[NSString stringWithFormat:@"%d",user.masterKey] historyID:[[VSSharedManager sharedManager] historyID] notes:self.notes.text withCompletionHandler:^(id data,BOOL error){
            
            [SVProgressHUD dismiss];
            
            if(!error){
                
                [self initWithPromptTitle:@"Notes Uploaded" message:@"Notes uploaded successfully"];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else{
                
                [self initWithPromptTitle:@"Error" message:@"Check your internet connection"];
                
            }
            
        }];
    }
    
}

- (IBAction)backButtonPressed:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)doneButtonPressed:(id)sender {
    
    //[self.notes resignFirstResponder];
}

#pragma mark Icarousel Data Source Icarsousle Delegate
#pragma mark iCarousel methods

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    //return the total number of items in the carousel
    return [self.notesString count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
//    UILabel *label = nil;
    
    //create new view if no view is available for recycling
    if (view == nil)
    {
        //don't do anything specific to the index within
        //this `if (view == nil) {...}` statement because the view will be
        //recycled and used with other index values later
        view = [[NoteView alloc] initWithFrame:CGRectMake(0, 0, carousel.bounds.size.width, carousel.bounds.size.height)];
//        ((UIImageView *)view).image = [UIImage imageNamed:@"page.png"];
//        view.contentMode = UIViewContentModeCenter;
//        
//        label = [[UILabel alloc] initWithFrame:view.bounds];
//        label.backgroundColor = [UIColor clearColor];
//        label.textAlignment = NSTextAlignmentCenter;
//        label.font = [label.font fontWithSize:50];
//        label.tag = 1;
        [(NoteView*)view setDelegate:self];
        [(NoteView*)view setEditable:NO];
        [view setTag:index];
//        [(NoteView*)view setText:[[self.notesString objectAtIndex:0] objectForKey:@"note"] ];
//        [view addSubview:label];
    }
    else
    {
        view = (NoteView*)view;
        //get a reference to the label in the recycled view
//        label = (UILabel *)[view viewWithTag:1];
    }
    [(NoteView*)view setText:[[self.notesString objectAtIndex:index] objectForKey:@"note"] ];
    
    //set item label
    //remember to always set any properties of your carousel item
    //views outside of the `if (view == nil) {...}` check otherwise
    //you'll get weird issues with carousel item content appearing
    //in the wrong place in the carousel
//    label.text = [_items[index] stringValue];
    
    return view;
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    if (option == iCarouselOptionSpacing)
    {
        return value * 1.1f;
    }
    return value;
}
//- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index {
//    self.currentSelectedIndex = index;
//    [self.countLabel setText:[NSString stringWithFormat:@"Note %d of %d",self.currentSelectedIndex+1,[self.notesString count]]];
//
//}
- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel {
    self.currentSelectedIndex = carousel.currentItemIndex;
    [self.countLabel setText:[NSString stringWithFormat:@"Note %d of %d",self.currentSelectedIndex+1,[self.notesString count]]];
}

#pragma mark Button Pressed Events
-(IBAction)nextButtonAction:(id)sender {
    if (self.currentSelectedIndex<[self.notesString count]-1) {

        [self.carousel scrollToItemAtIndex:self.currentSelectedIndex+1 animated:YES];
//                self.currentSelectedIndex++;
    }
//    [self.countLabel setText:[NSString stringWithFormat:@"Note %d of %d",self.currentSelectedIndex+1,[self.notesString count]]];
//    [self.countLabel setText:[NSString stringWithFormat:@"Note %d of %d",self.currentSelectedIndex+1,[self.notesString count]]];
    
}
-(IBAction)prevButtonAction:(id)sender {
    if (self.currentSelectedIndex >0) {
        
        [self.carousel scrollToItemAtIndex:self.currentSelectedIndex-1 animated:YES];
//        self.currentSelectedIndex--;
    }
//    [self.countLabel setText:[NSString stringWithFormat:@"Note %d of %d",self.currentSelectedIndex+1,[self.notesString count]]];
    
}

-(IBAction)addNoteButtonAction:(id)sender {
    
    if ([[[self.addNoteButton titleLabel] text] isEqualToString:@"Add Note"]) {
        [self.addNoteButton setTitle:@"View Notes" forState:UIControlStateNormal];
        [self.carousel setHidden:YES];
        [self.nextButton setHidden:YES];
        [self.prevButton setHidden:YES];
        [self.countLabel setHidden:YES];
        self.submitButton.hidden=NO;
        [self.notes setHidden:NO];
    }
    else {
        [self.addNoteButton setTitle:@"Add Note" forState:UIControlStateNormal];
        [self.carousel setHidden:NO];
        [self.nextButton setHidden:NO];
        [self.prevButton setHidden:NO];
        [self.countLabel setHidden:NO];
        self.submitButton.hidden=YES;
        [self.notes setHidden:YES];
    }
}




@end
