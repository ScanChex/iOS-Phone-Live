//
//  PDFAndMoviePlayerVC.h
//  MusicApplication
//
//  Created by Adnan Ahmad on 6/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseVC.h"
#import <MediaPlayer/MediaPlayer.h>
#import "ReaderViewController.h"
#import "ScanQRManager.h"

@interface PDFAndMoviePlayerVC:ScanQRManager<ReaderViewControllerDelegate>{

    MPMoviePlayerViewController*player;
}

+(PDFAndMoviePlayerVC *)initWithShared;
-(void)openPDFWithPath:(NSString *)path;
-(void)openVideoWithPath:(NSString *)path;
@end
