//
//  DownloadVC.h
//  VeriScanQR
//
//  Created by Adnan Ahmad on 09/01/2013.
//  Copyright (c) 2013 Adnan Ahmad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseVC.h"
#import "Constant.h"
#import "DownloadHelper.h"

@protocol DownloadVCDelegate <NSObject>
-(void)fileDownloadedSuccessfullyWithPath:(NSString *)savedPath;
@end

@interface DownloadVC : BaseVC<DownloadHelperDelegate>
@property (retain, nonatomic) IBOutlet UIProgressView *progressView;
@property(retain, nonatomic) NSString *downloadingURL;
@property(assign, nonatomic) id<DownloadVCDelegate>delegate;

+(id)initWithDownloadPath:(NSString *)url andDelegate:(id<DownloadVCDelegate>)delegate;
-(id)initWithData:(NSString *)url andDelegate:(id<DownloadVCDelegate>)aDelegate;

- (void)showInViewController:(UIViewController *)controller;
- (void)dismiss;

@end
