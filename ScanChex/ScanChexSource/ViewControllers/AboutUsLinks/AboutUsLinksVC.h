//
//  AboutUsLinksVC.h
//  VeriScanQR
//
//  Created by Adnan Ahmad on 14/04/2013.
//  Copyright (c) 2013 Adnan Ahmad. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface AboutUsLinksVC : UIViewController <UIWebViewDelegate>
- (IBAction)backbuttonPressed:(id)sender;
@property (nonatomic,retain)NSString *urlString;
@property (retain, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic, assign) BOOL isFile;
@property (nonatomic, assign) BOOL isID;

+(id)initWithAboutUS:(NSString *)url;
-(id)initWithAboutUSURL:(NSString* )url;
+(id)initWithFile:(NSString *)url;
-(id)initWithFile:(NSString* )url;
+(id)initWithID:(NSString *)url;
-(id)initWithID:(NSString* )url;
@end
