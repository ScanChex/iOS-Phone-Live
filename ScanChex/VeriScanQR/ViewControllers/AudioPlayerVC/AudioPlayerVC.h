//
//  AudioPlayerVC.h
//  VeriScanQR
//
//  Created by Adnan Ahmad on 27/04/2013.
//  Copyright (c) 2013 Adnan Ahmad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface AudioPlayerVC : UIViewController
{
    AVAudioPlayer *audioPlayer;
    NSURL *fileURl;

}

@property (retain, nonatomic) IBOutlet UILabel *currentTimeLabel;
@property (retain, nonatomic) IBOutlet UILabel *remainingTimeLabel;
@property(nonatomic,retain) NSArray * audioPath;
@property (retain, nonatomic) IBOutlet UIProgressView *progressView;
@property (retain , nonatomic) IBOutlet UIButton * nextButton;
@property (retain , nonatomic) IBOutlet UIButton * prevButton;
@property (retain , nonatomic) IBOutlet UILabel * countLabel;
@property (assign) NSInteger currentSelectedIndex;

+(id)initWithAudioPlayer:(NSArray *)urlString;
-(id)initWithData:(NSArray *)url;
- (void)setCurrentAudioProgress:(NSTimeInterval)time duration:(NSTimeInterval)duration;
- (void)updatePreviewingProgress:(NSTimer *)timer;
- (IBAction)playAudioButtonPressed:(id)sender;
- (IBAction)stopAudioButtonPressed:(id)sender;
- (IBAction)backButtonPressed:(id)sender;
-(IBAction)nextButtonAction:(id)sender;
-(IBAction)prevButtonAction:(id)sender;

@end
