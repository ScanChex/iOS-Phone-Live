//
//  ImageViewVC.h
//  VeriScanQR
//
//  Created by Adnan Ahmad on 23/06/2013.
//  Copyright (c) 2013 Adnan Ahmad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsynchRoundedUIImageView.h"
#import "iCarousel.h"
#import "AsyncImageView.h"

@interface ImageViewVC : BaseVC<iCarouselDataSource,iCarouselDelegate>

@property(retain, nonatomic) IBOutlet AsynchRoundedUIImageView *imageView;
@property(retain, nonatomic) NSArray *imageURL;
@property (retain, nonatomic) IBOutlet iCarousel * carousel;
@property (retain , nonatomic) IBOutlet UIButton * nextButton;
@property (retain , nonatomic) IBOutlet UIButton * prevButton;
@property (retain , nonatomic) IBOutlet UILabel * countLabel;
@property (assign) NSInteger currentSelectedIndex;

@property (retain, nonatomic) IBOutlet AsyncImageView *companyLogo;
+(id)initWithURL:(NSArray *)imageURLString;

-(IBAction)backButtonPressed:(id)sender;
-(IBAction)nextButtonAction:(id)sender;
-(IBAction)prevButtonAction:(id)sender;
@end
