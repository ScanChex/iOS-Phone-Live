//
//  PDFAndMoviePlayerVC.m
//  MusicApplication
//
//  Created by Adnan Ahmad on 6/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDFAndMoviePlayerVC.h"

@implementation PDFAndMoviePlayerVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

+(PDFAndMoviePlayerVC *)initWithShared{
    
    return [[[PDFAndMoviePlayerVC alloc]init] autorelease];
}

-(void)openPDFWithPath:(NSString *)path{
    
    
    DLog(@"Path %@",path);
    NSString *phrase = nil; // Document password (for unlocking most encrypted PDF     
    
    assert(path != nil); // Path to last PDF file
    
    ReaderDocument *document = [ReaderDocument withDocumentFilePath:path password:phrase];
    
    if (document != nil) // Must have a valid ReaderDocument object in order to proceed with things
    {
        ReaderViewController *readerViewController = [[ReaderViewController alloc] initWithReaderDocument:document];
        readerViewController.delegate = self; // Set the ReaderViewController delegate to self
        readerViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        readerViewController.modalPresentationStyle = UIModalPresentationFullScreen;
        //[self presentModalViewController:readerViewController animated:YES];
        [self presentViewController:readerViewController animated:YES completion:nil];
    }
}

#pragma mark- ReaderViewControllerDelegate methods

- (void)dismissReaderViewController:(ReaderViewController *)viewController
{
#ifdef DEBUGX
	NSLog(@"%s", __FUNCTION__);
#endif
    
    
    //[self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)openVideoWithPath:(NSString *)path{
    
    if (player) 
        [player release];
    
    
    player = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL fileURLWithPath:path]];
    
    if ([player.moviePlayer respondsToSelector:@selector(loadState)]) {
        
        [player.moviePlayer prepareToPlay];
        player.moviePlayer.shouldAutoplay = YES;
       // player.moviePlayer.useApplicationAudioSession=NO;
        player.moviePlayer.view.frame = [[UIScreen mainScreen] applicationFrame];
        player.moviePlayer.view.transform = CGAffineTransformMakeRotation(1.57079633);
        player.moviePlayer.view.bounds = CGRectMake(0.0, 0.0, 480, 320);
        player.moviePlayer.controlStyle = MPMovieControlStyleFullscreen;        
        [self presentMoviePlayerViewControllerAnimated:player];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayerLoadStateChanged:) name:MPMoviePlayerLoadStateDidChangeNotification object:player];
        
    }
}

- (void) moviePlayerLoadStateChanged:(NSNotification*)notification 
{
    // Unless state is unknown, start playback
    switch ([player.moviePlayer loadState]) {
        case MPMovieLoadStateUnknown:
        {
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        }
        case MPMovieLoadStatePlayable:
        {
            // Remove observer
            [[NSNotificationCenter defaultCenter] 
             removeObserver:self
             name:MPMoviePlayerLoadStateDidChangeNotification 
             object:nil];
            
            
            
            [[NSNotificationCenter defaultCenter] 
             addObserver:self
             selector:@selector(playMediaFinished:)                                                 
             name:MPMoviePlayerPlaybackDidFinishNotification
             object:player];
            
            break;
        }
            
    }
}
#pragma mark- Video Notification
-(void)playMediaFinished:(NSNotification*)theNotification {
    
    [self.navigationController popViewControllerAnimated:YES];
	player = [theNotification object];
    [[NSNotificationCenter defaultCenter] 
	 removeObserver:self
	 name:MPMoviePlayerPlaybackDidFinishNotification
	 object:player];   
    [player.moviePlayer stop];
    [player release];
}



- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
