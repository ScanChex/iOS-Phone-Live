//
//  AboutUsLinksVC.m
//  VeriScanQR
//
//  Created by Adnan Ahmad on 14/04/2013.
//  Copyright (c) 2013 Adnan Ahmad. All rights reserved.
//

#import "AboutUsLinksVC.h"
#import "SVProgressHUD.h"
#import <QuartzCore/QuartzCore.h>

@interface AboutUsLinksVC ()

@end

@implementation AboutUsLinksVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
+(id)initWithAboutUS:(NSString *)url{

    return [[[AboutUsLinksVC alloc] initWithAboutUSURL:url] autorelease];
}
-(id)initWithAboutUSURL:(NSString* )url{

    self=[super initWithNibName:@"AboutUsLinksVC" bundle:nil];
    
    if (self) {
        self.isFile = FALSE;
        self.isID = FALSE;
        self.urlString=[NSString stringWithFormat:@"%@",url];
    }
    
    return self;
}

+(id)initWithFile:(NSString *)url {
    return [[[AboutUsLinksVC alloc] initWithFile:url] autorelease];
}
-(id)initWithFile:(NSString* )url {
    self=[super initWithNibName:@"AboutUsLinksVC" bundle:nil];
    
    if (self) {
        
        self.isFile = TRUE;
        self.isID = FALSE;
        self.urlString=[NSString stringWithFormat:@"%@",url];
    }
    
    return self;
}
+(id)initWithID:(NSString *)url {
    return [[[AboutUsLinksVC alloc] initWithID:url] autorelease];
}
-(id)initWithID:(NSString* )url {
    self=[super initWithNibName:@"View" bundle:nil];
    
    if (self) {
        
        self.isFile = FALSE;
        self.isID = TRUE;
        self.urlString=[NSString stringWithFormat:@"%@",url];
    }
    
    return self;
}
- (void)viewDidLoad
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.webView setFrame:CGRectMake(0, 63, 320, self.view.bounds.size.height-63)];
     [self.view setBackgroundColor:[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"color"]]];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    if (self.isFile) {
        NSLog(@"URL %@", self.urlString);
        NSURL * tempURL = [NSURL URLWithString:self.urlString];
        self.urlString =  [self.urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"URL %@", self.urlString);
        tempURL = [NSURL URLWithString:self.urlString];
        
         [self.webView loadRequest:[NSURLRequest requestWithURL:tempURL]];
        NSString *jsCommand = [NSString stringWithFormat:@"document.body.style.zoom = 1.5;"];
        [self.webView stringByEvaluatingJavaScriptFromString:jsCommand];
        [self.webView sizeToFit];
//        NSString *jsCommand = [NSString stringWithFormat:@"document.body.style.zoom = 1.5;"];
//        [self.webView stringByEvaluatingJavaScriptFromString:jsCommand];
//        [self.webView sizeToFit];
    }
    else if (self.isID) {
        CGRect frame = self.webView.frame;
        frame.origin.x = 15;
        frame.origin.y = 70;
        frame.size.width = 290;
        frame.size.height = frame.size.height-30;
        [self.webView setFrame:frame];
        [self.webView loadHTMLString:self.urlString baseURL:nil];
//        [self.webView setScalesPageToFit:YES];
        NSString *jsCommand = [NSString stringWithFormat:@"document.body.style.zoom = 1.5;"];
        [self.webView stringByEvaluatingJavaScriptFromString:jsCommand];
//        [self.webView sizeToFit];
        self.webView.opaque=NO;
        self.webView.backgroundColor = [UIColor clearColor];
        

        [self.webView.layer setCornerRadius:15.0f];
        [self.webView setFrame:frame];
    }
    else {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];
        NSString *jsCommand = [NSString stringWithFormat:@"document.body.style.zoom = 1.5;"];
        [self.webView stringByEvaluatingJavaScriptFromString:jsCommand];
        [self.webView sizeToFit];
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backbuttonPressed:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)dealloc {
    [_webView release];
    [super dealloc];
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

#pragma mark UIwebView Delegate
-(void)webViewDidStartLoad:(UIWebView *)webView{
    [SVProgressHUD showWithStatus:@"Loading"];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    //KILL HUD
    [SVProgressHUD dismiss];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    if ([webView respondsToSelector:@selector(scrollView)])
    {
        UIScrollView *scroll=[webView scrollView];
        
        float zoom=webView.bounds.size.width/scroll.contentSize.width;
        [scroll setZoomScale:zoom animated:YES];
    }

    if(!webView.loading){
        //KILL HUD
        [SVProgressHUD dismiss];
    }
}
@end
