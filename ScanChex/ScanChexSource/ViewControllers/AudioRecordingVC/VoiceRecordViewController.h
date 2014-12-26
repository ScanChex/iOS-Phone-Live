//
//  VoiceRecordViewController.h
//  VoiceRecord
//
//  Created by Avinash on 10/5/10.
//  Copyright PocketPpl 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "BaseVC.h"
@interface VoiceRecordViewController : BaseVC <AVAudioRecorderDelegate>
{
	IBOutlet UILabel *lblStatusMsg;
	
	NSMutableDictionary *recordSetting;
	NSMutableDictionary *editedObject;
	NSString *recorderFilePath;
	AVAudioRecorder *recorder;
	SystemSoundID soundID;
    
    NSTimer *timer;
    NSDate *startDate;
}

@property (retain, nonatomic) IBOutlet UIProgressView *progressView;
@property (nonatomic,strong) 	AVAudioRecorder *recorder;

+(id)initWithRecording;
- (IBAction) startRecording;
- (IBAction) stopRecording;

- (IBAction)backButtonPressed:(id)sender;
@property (retain, nonatomic) IBOutlet UIButton *stopButton;

@end

