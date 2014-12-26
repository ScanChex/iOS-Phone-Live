//
//  VoiceRecordViewController.m
//  VoiceRecord
//
//  Created by Avinash on 10/5/10.
//  Copyright PocketPpl 2010. All rights reserved.
//

#import "VoiceRecordViewController.h"
#import "WebServiceManager.h"
#import "SVProgressHUD.h"
#import "UserDTO.h"
#import "VSSharedManager.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <sys/xattr.h>
#import "lame.h"
#define DOCUMENTS_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]


@implementation VoiceRecordViewController
@synthesize recorder;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

+(id)initWithRecording{

    return [[[VoiceRecordViewController alloc] initWithNibName:@"VoiceRecordViewController" bundle:nil] autorelease];
}


- (void)viewDidLoad
{
     [self.view setBackgroundColor:[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"color"]]];
	[super viewDidLoad];
    self.progressView.hidden=YES;
    self.stopButton.userInteractionEnabled=NO;
}

-(void)recordingTimer:(NSTimer *)timer
{

    NSTimeInterval interval = [startDate timeIntervalSinceNow];
    NSUInteger seconds = ABS((int)interval);
    NSUInteger minutes = seconds/60;
    NSUInteger hours = minutes/60;
    lblStatusMsg.text = [NSString stringWithFormat:@"%02d:%02d:%02d", hours, minutes%60, seconds%60];
}
- (IBAction) startRecording
{
    
    [timer invalidate];
    startDate = [NSDate date];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:0.25 target:self selector:@selector(recordingTimer:) userInfo:startDate repeats:YES];
    
	AVAudioSession *audioSession = [AVAudioSession sharedInstance];
	NSError *err = nil;
	[audioSession setCategory :AVAudioSessionCategoryPlayAndRecord error:&err];
	if(err){
        DLog(@"audioSession: %@ %d %@", [err domain], [err code], [[err userInfo] description]);
        return;
	}
	[audioSession setActive:YES error:&err];
	err = nil;
	if(err){
        DLog(@"audioSession: %@ %d %@", [err domain], [err code], [[err userInfo] description]);
        return;
	}
    //录音设置
    recordSetting = [[NSMutableDictionary alloc] init];
    //录音格式 无法使用
    [recordSetting setValue :[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey: AVFormatIDKey];
    //采样率
    [recordSetting setValue :[NSNumber numberWithFloat:11025.0] forKey: AVSampleRateKey];//44100.0
    //通道数
    [recordSetting setValue :[NSNumber numberWithInt:2] forKey: AVNumberOfChannelsKey];
    //线性采样位数
    //[recordSettings setValue :[NSNumber numberWithInt:16] forKey: AVLinearPCMBitDepthKey];
    //音频质量,采样质量
    [recordSetting setValue:[NSNumber numberWithInt:AVAudioQualityMax] forKey:AVEncoderAudioQualityKey];
	
//	recordSetting = [[NSMutableDictionary alloc] init];
//	
//	// We can use kAudioFormatAppleIMA4 (4:1 compression) or kAudioFormatLinearPCM for nocompression
//	[recordSetting setValue :[NSNumber numberWithInt:kAudioFormatAppleIMA4] forKey:AVFormatIDKey];
//
//	// We can use 44100, 32000, 24000, 16000 or 12000 depending on sound quality
//	[recordSetting setValue:[NSNumber numberWithFloat:16000.0] forKey:AVSampleRateKey];
//	
//	// We can use 2(if using additional h/w) or 1 (iPhone only has one microphone)
//	[recordSetting setValue:[NSNumber numberWithInt: 1] forKey:AVNumberOfChannelsKey];
	
	
    recorderFilePath = [[NSString stringWithFormat:@"%@/MySound.caf", DOCUMENTS_FOLDER] retain];

	NSURL *url = [NSURL fileURLWithPath:recorderFilePath];
    
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:recorderFilePath]) {

        NSFileManager *fm = [NSFileManager defaultManager];
		[fm removeItemAtPath:[url path] error:&err];
    }
	
	err = nil;
	recorder = [[ AVAudioRecorder alloc] initWithURL:url settings:recordSetting error:&err];
	if(!recorder){
        DLog(@"recorder: %@ %d %@", [err domain], [err code], [[err userInfo] description]);
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle: @"Warning"
								   message: [err localizedDescription]
								  delegate: nil
						 cancelButtonTitle:@"OK"
						 otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
	}
	
	//prepare to record
	[recorder setDelegate:self];
	[recorder prepareToRecord];
	recorder.meteringEnabled = YES;
	
	BOOL audioHWAvailable = audioSession.inputIsAvailable;
	if (! audioHWAvailable) {
        UIAlertView *cantRecordAlert =
        [[UIAlertView alloc] initWithTitle: @"Warning"
								   message: @"Audio input hardware not available"
								  delegate: nil
						 cancelButtonTitle:@"OK"
						 otherButtonTitles:nil];
        [cantRecordAlert show];
        [cantRecordAlert release]; 
        return;
	}
	
    
	// start recording
	[recorder record];
	lblStatusMsg.text = @"Recording...";
    self.stopButton.userInteractionEnabled=YES;
}

- (IBAction) stopRecording
{
    [timer invalidate];
    timer = nil;
    startDate= nil;
    [recorder stop];
//    NSURL *url = [NSURL fileURLWithPath:recorderFilePath];
//	NSError* err = nil;
//	NSData *audioData = [NSData dataWithContentsOfFile:[url path] options: 0 error:&err];

    
  
    
    NSString *path;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"audio.mp3"];
    NSFileManager* fileManager=[NSFileManager defaultManager];
    if([fileManager removeItemAtPath:path error:nil])
    {
        NSLog(@"删除");
    }
    
    @try {
        int read, write;
        
        FILE *pcm = fopen([recorderFilePath cStringUsingEncoding:1], "rb");  //source 被转换的音频文件位置
        fseek(pcm, 4*1024, SEEK_CUR);                                   //skip file header
        FILE *mp3 = fopen([path cStringUsingEncoding:1], "wb");  //output 输出生成的Mp3文件位置
        
        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE*2];
        unsigned char mp3_buffer[MP3_SIZE];
        
        lame_t lame = lame_init();
        lame_set_in_samplerate(lame, 11025.0);
        lame_set_VBR(lame, vbr_default);
        lame_init_params(lame);
        
        do {
            read = fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
            if (read == 0)
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            else
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
            
            fwrite(mp3_buffer, write, 1, mp3);
            
        } while (read != 0);
        
        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception description]);
    }
    @finally {
        
//        [playButton setEnabled:YES];
//        NSError *playerError;
//        AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[[[NSURL alloc] initFileURLWithPath:mp3FilePath] autorelease] error:&playerError];
//        self.player = audioPlayer;
//        player.volume = 1.0f;
//        if (player == nil)
//        {
//            NSLog(@"ERror creating player: %@", [playerError description]);
//        }
//        [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategorySoloAmbient error: nil];
//        player.delegate = self;
//        [audioPlayer release];
    }
    
    //if file already exist on that path remove that file and then save new on that path
//    [[NSFileManager defaultManager] createFileAtPath:path
//                                            contents:audioData
//                                          attributes:nil];
    
    
    NSURL *url = [NSURL fileURLWithPath:path];
	NSError* err = nil;
	NSData *audioData = [NSData dataWithContentsOfFile:[url path] options: 0 error:&err];
    ///////////Tell os not to back up /////////////////////////////////
    [self addSkipBackupAttributeToItemAtURL:[NSURL URLWithString:path]];
    ///////////////////////////////////////////////////////////////////

   
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];

    UserDTO*user=[[VSSharedManager sharedManager] currentUser];
    [[WebServiceManager sharedManager] uploadAudio:[NSString stringWithFormat:@"%d",user.masterKey]
                                         historyID:[[VSSharedManager sharedManager] historyID]
                                       contentType:[self fileMIMEType:path]
                                         audioData:audioData
                                       progressBar:self.progressView
                             withCompletionHandler:^(id data,BOOL error){
        
                                    [SVProgressHUD dismiss];
                                    if (!error){
        
                                        [self initWithPromptTitle:@"Audio Uploaded" message:@"Audio uploaded successfully"];
                                        [self.navigationController popViewControllerAnimated:YES];
                                    }
                                    else{
                                        [self initWithPromptTitle:@"Error" message:(NSString *)data];
                                    }
                                
                                  NSError *fileError;
                                 [[NSFileManager defaultManager] removeItemAtPath:path error:&fileError];
//                                 [[NSFileManager defaultManager] removeItemAtPath:recorderFilePath error:&fileError];

                            }];

}

- (IBAction)backButtonPressed:(id)sender {
    
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *) aRecorder successfully:(BOOL)flag
{
	DLog (@"audioRecorderDidFinishRecording:successfully:");
	//lblStatusMsg.text = @"Stopped";
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (BOOL) addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    const char* filePath = [[URL path] fileSystemRepresentation];
    const char* attrName = "com.apple.MobileBackup";
    
    u_int8_t attrValue = 1;
    int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
    
    return result == 0;
    
}
- (NSString*) fileMIMEType:(NSString*) file {
    CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (CFStringRef)[file pathExtension], NULL);
    CFStringRef MIMEType = UTTypeCopyPreferredTagWithClass (UTI, kUTTagClassMIMEType);
    CFRelease(UTI);
    return [(NSString *)MIMEType autorelease];
}
- (void)viewDidUnload {
    [self setStopButton:nil];
   // [self setProgressView:nil];
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [_progressView release];
    [_stopButton release];
    [super dealloc];
}

@end
