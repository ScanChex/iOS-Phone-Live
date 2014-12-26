//
//  DownloadVC.m
//  VeriScanQR
//
//  Created by Adnan Ahmad on 09/01/2013.
//  Copyright (c) 2013 Adnan Ahmad. All rights reserved.
//

#import "DownloadVC.h"
#import "DownloadHelper.h"
#import <sys/xattr.h>

@interface DownloadVC ()

@property (retain) NSString *savePath;
- (BOOL) addSkipBackupAttributeToItemAtURL:(NSURL *)URL;

@end

@implementation DownloadVC

@synthesize downloadingURL=_downloadingURL;
@synthesize savePath;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

+(id)initWithDownloadPath:(NSString *)url andDelegate:(id<DownloadVCDelegate>)delegate{

    return [[[DownloadVC alloc] initWithData:url andDelegate:delegate] autorelease];
}
-(id)initWithData:(NSString *)url andDelegate:(id<DownloadVCDelegate>)aDelegate{

    self = [super initWithNibName:@"DownloadVC" bundle:[NSBundle mainBundle]];
    if (self) {
     
        
        self.downloadingURL= url;
        self.delegate=aDelegate;
    }

    return self;
}
- (void)viewDidLoad
{
     [self.view setBackgroundColor:[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"color"]]];
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)showInViewController:(UIViewController *)controller{
    
    self.view.transform= CGAffineTransformMakeScale(0,0);
    [controller.view addSubview:self.view];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.view.transform= CGAffineTransformIdentity;
        // Set up the Download Helper and start download
        [DownloadHelper sharedInstance].delegate = self;
        [DownloadHelper download:self.downloadingURL];
    }];

}

- (void) dataDownloadAtPercent: (NSNumber *) aPercent
{
	[self.progressView setHidden:NO];
	[self.progressView setProgress:[aPercent floatValue]];
}

- (void) dataDownloadFailed: (NSString *) reason
{
	if (reason) [self initWithPromptTitle:@"Downloading failed" message:reason];
    [self.view removeFromSuperview];
}

- (void) didReceiveFilename: (NSString *) aName
{
	self.savePath = [DEST_PATH stringByAppendingString:aName];
}

- (void) didReceiveData: (NSData *) theData
{
    
    NSString *path;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    path = [[paths objectAtIndex:0] stringByAppendingPathComponent:[self.downloadingURL lastPathComponent]];
    
    
    NSError *error;
    //if file already exist on that path remove that file and then save new on that path
    [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
    [[NSFileManager defaultManager] createFileAtPath:path
                                            contents:theData
                                          attributes:nil];
    
    
    ///////////Tell os not to back up /////////////////////////////////
    [self addSkipBackupAttributeToItemAtURL:[NSURL URLWithString:path]];
    ///////////////////////////////////////////////////////////////////

    [self dismiss];
	[theData release];
	
}

- (void)dismiss{
    
    [UIView animateWithDuration:0.3 animations:^{
        
       // self.view.transform= CGAffineTransformMakeScale(0,0);
        
        self.view.alpha=0.5;
    } completion:^(BOOL finished){

        
        if ([self.delegate respondsToSelector:@selector(fileDownloadedSuccessfullyWithPath:)]) {
            
            [self.delegate fileDownloadedSuccessfullyWithPath:[self.downloadingURL lastPathComponent]];
        }

        [self.view removeFromSuperview];
    }];
   
}

- (BOOL) addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    const char* filePath = [[URL path] fileSystemRepresentation];
    const char* attrName = "com.apple.MobileBackup";
    
    u_int8_t attrValue = 1;
    int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
    
    return result == 0;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_progressView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setProgressView:nil];
    [super viewDidUnload];
}
@end
