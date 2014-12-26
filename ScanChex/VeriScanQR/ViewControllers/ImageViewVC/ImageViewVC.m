//
//  ImageViewVC.m
//  VeriScanQR
//
//  Created by Adnan Ahmad on 23/06/2013.
//  Copyright (c) 2013 Adnan Ahmad. All rights reserved.
//

#import "ImageViewVC.h"

@interface ImageViewVC ()

-(id)iniWithURLString:(NSArray *)urlString;
@end

@implementation ImageViewVC

@synthesize imageView = _imageView;
@synthesize imageURL = _imageURL;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

+(id)initWithURL:(NSArray *)imageURLString
{

    return [[[ImageViewVC alloc] iniWithURLString:imageURLString] autorelease];
}


-(id)iniWithURLString:(NSArray *)urlString
{

    self = [super initWithNibName:@"ImageViewVC" bundle:nil];
    
    if (self) {
        
        self.imageURL = urlString;
    }

    return self;
}

- (void)viewDidLoad
{
     [self.view setBackgroundColor:[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"color"]]];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    DLog(@"URL %@",self.imageURL);
//    [self.imageView loadImageFromURLString:[[self.imageURL objectAtIndex:0] objectForKey:@"image"]];
    [self.imageView setHidden:YES];
    [self.carousel setType:iCarouselTypeLinear];
    [self.carousel setDelegate:self];
    [self.carousel reloadData];
    [self setCurrentSelectedIndex:0];
    [self.countLabel setText:[NSString stringWithFormat:@"Image %d of %d",self.currentSelectedIndex+1,[self.imageURL count]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)backButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark Icarousel Data Source Icarsousle Delegate
#pragma mark iCarousel methods

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    //return the total number of items in the carousel
    return [self.imageURL count];
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
        view = [[AsynchRoundedUIImageView alloc] initWithFrame:CGRectMake(0, 0, carousel.bounds.size.width, carousel.bounds.size.height)];
        //        ((UIImageView *)view).image = [UIImage imageNamed:@"page.png"];
        //        view.contentMode = UIViewContentModeCenter;
        //
        //        label = [[UILabel alloc] initWithFrame:view.bounds];
        //        label.backgroundColor = [UIColor clearColor];
        //        label.textAlignment = NSTextAlignmentCenter;
        //        label.font = [label.font fontWithSize:50];
        //        label.tag = 1;
//        [(AsynchRoundedUIImageView*)view setDelegate:self];
//        [(NoteView*)view setEditable:NO];
        [view setTag:index];
        //        [(NoteView*)view setText:[[self.notesString objectAtIndex:0] objectForKey:@"note"] ];
        //        [view addSubview:label];
    }
    else
    {
        view = (AsynchRoundedUIImageView*)view;
        //get a reference to the label in the recycled view
        //        label = (UILabel *)[view viewWithTag:1];
    }
    [(AsynchRoundedUIImageView*)view loadImageFromURLString:[[self.imageURL objectAtIndex:index] objectForKey:@"image"] ];
    
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
    [self.countLabel setText:[NSString stringWithFormat:@"Image %d of %d",self.currentSelectedIndex+1,[self.imageURL count]]];
}

#pragma mark Button Pressed Events
-(IBAction)nextButtonAction:(id)sender {
    if (self.currentSelectedIndex<[self.imageURL count]-1) {
        
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
@end
