//
//  AudioPlayerVC.m
//  VeriScanQR
//
//  Created by Adnan Ahmad on 27/04/2013.
//  Copyright (c) 2013 Adnan Ahmad. All rights reserved.
//

#import "AudioPlayerVC.h"

@interface AudioPlayerVC ()

@end

@implementation AudioPlayerVC
@synthesize audioPath=_audioPath;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

+(id)initWithAudioPlayer:(NSArray *)urlString
{
    return [[[AudioPlayerVC alloc] initWithData:urlString] autorelease];
}
-(id)initWithData:(NSArray *)url
{
    self=[super initWithNibName:@"AudioPlayerVC" bundle:nil];
 
    if (self) {
        
        self.audioPath=url;
    }
    
    return self;
}
- (void)viewDidLoad
{
     [self.view setBackgroundColor:[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"color"]]];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.currentSelectedIndex = 0;
    [self.countLabel setText:[NSString stringWithFormat:@"Audio %d of %d",self.currentSelectedIndex+1,[self.audioPath count]]];
    fileURl = [[NSURL alloc] initFileURLWithPath:[self.audioPath objectAtIndex:self.currentSelectedIndex]];
    NSLog(@"File url %@",fileURl);
    NSError *error ;
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURl error:&error];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive: YES error: nil];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
    [audioPlayer release];
    [_currentTimeLabel release];
    [_remainingTimeLabel release];
    [_progressView release];
    [super dealloc];
}

#pragma mark -Functions
- (void)setCurrentAudioProgress:(NSTimeInterval)time duration:(NSTimeInterval)duration
{

    float  progress            = time/duration;
	long   currentPlaybackTime = audioPlayer.currentTime;
    long   remainingTime       = (duration-time);
    int    remainingHours      = (remainingTime /3600);
    int    remainingMinutes    = ((remainingTime /60 -remainingHours*60));
    int    remainingSeconds    = (remainingTime %60);
    int    currentHours        = (currentPlaybackTime / 3600);
    int    currentMinutes      = ((currentPlaybackTime / 60) - currentHours*60);
    int    currentSeconds       = (currentPlaybackTime % 60);
    self.currentTimeLabel.text = [NSString stringWithFormat:@"%02d:%02d", currentMinutes, currentSeconds];
	self.remainingTimeLabel.text = [NSString stringWithFormat:@"%02d:%02d" , remainingMinutes, remainingSeconds];
    [self.progressView setProgress:progress];
    //show lyrics when time matched
}
//update progress view with timer
- (void)updatePreviewingProgress:(NSTimer *)timer {
	if([audioPlayer isPlaying]) {
		NSTimeInterval duration = [audioPlayer duration];
		NSTimeInterval time = [audioPlayer currentTime];
		[self setCurrentAudioProgress:time duration:duration];
        
    }else {
        [timer invalidate];
       
	}
}


- (IBAction)playAudioButtonPressed:(id)sender {
    if (audioPlayer) {
        [audioPlayer prepareToPlay];
        [audioPlayer play];
        NSTimeInterval duration = [audioPlayer currentTime];
        
        [self setCurrentAudioProgress:0.0 duration:duration];
        
        //schedule timer here
        [NSTimer scheduledTimerWithTimeInterval:1
                                         target:self
                                       selector:@selector(updatePreviewingProgress:)
                                       userInfo:nil
                                        repeats:YES];
    }

}

- (IBAction)stopAudioButtonPressed:(id)sender {
    
    [audioPlayer stop];
    
}

- (IBAction)backButtonPressed:(id)sender {
    
    [audioPlayer stop];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark Button Pressed Events
-(IBAction)nextButtonAction:(id)sender {
    if (self.currentSelectedIndex<[self.audioPath count]-1) {
        if ([audioPlayer isPlaying]) {
            [audioPlayer stop];
            [audioPlayer release];
            audioPlayer = nil ;
        }
        fileURl = [[NSURL alloc] initFileURLWithPath:[self.audioPath objectAtIndex:self.currentSelectedIndex+1]];
        NSLog(@"File url %@",fileURl);
        NSError *error ;
        audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURl error:&error];
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        [[AVAudioSession sharedInstance] setActive: YES error: nil];
        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
        self.currentSelectedIndex++;
        [self.countLabel setText:[NSString stringWithFormat:@"Audio %d of %d",self.currentSelectedIndex+1,[self.audioPath count]]];
//        [self.carousel scrollToItemAtIndex:self.currentSelectedIndex+1 animated:YES];
        //                self.currentSelectedIndex++;
    }
    //    [self.countLabel setText:[NSString stringWithFormat:@"Note %d of %d",self.currentSelectedIndex+1,[self.notesString count]]];
    //    [self.countLabel setText:[NSString stringWithFormat:@"Note %d of %d",self.currentSelectedIndex+1,[self.notesString count]]];
    
}
-(IBAction)prevButtonAction:(id)sender {
    if (self.currentSelectedIndex >0) {
        if ([audioPlayer isPlaying]) {
            [audioPlayer stop];
            [audioPlayer release];
            audioPlayer = nil ;
        }
        fileURl = [[NSURL alloc] initFileURLWithPath:[self.audioPath objectAtIndex:self.currentSelectedIndex-1]];
        NSLog(@"File url %@",fileURl);
        NSError *error ;
        audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURl error:&error];
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        [[AVAudioSession sharedInstance] setActive: YES error: nil];
        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
        self.currentSelectedIndex--;
        [self.countLabel setText:[NSString stringWithFormat:@"Audio %d of %d",self.currentSelectedIndex+1,[self.audioPath count]]];
        
//        [self.carousel scrollToItemAtIndex:self.currentSelectedIndex-1 animated:YES];
        //        self.currentSelectedIndex--;
    }
    //    [self.countLabel setText:[NSString stringWithFormat:@"Note %d of %d",self.currentSelectedIndex+1,[self.notesString count]]];
    
}


@end
