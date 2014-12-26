//
//  RoundedUIImageView.m
//  WinSomeThing
//
//  Created by Jameel Khan on 14/11/2012.
//  Copyright (c) 2012 Mobile Media Partners. All rights reserved.
//

#import "AsynchRoundedUIImageView.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageCache.h"
#import "UIImage+UIImage_Extra.h"


@interface AsynchRoundedUIImageView()


@property (nonatomic, retain) NSURLConnection *connection;
@property (nonatomic, retain) NSMutableData *data;
@property (nonatomic, retain) NSString *originalUrlString;




-(void)showSpinner;
-(void)hiderSpinner;


@end


@implementation AsynchRoundedUIImageView
@synthesize connection;
@synthesize data;
@synthesize originalUrlString;
@synthesize delegate;
@synthesize makeGrey;



-(void)awakeFromNib{
    [super awakeFromNib];
    
    //self.layer.cornerRadius = 7.0;
    self.layer.masksToBounds = YES;
    self.userInteractionEnabled=YES;
    
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        
        //self.layer.cornerRadius = 5.0;
        self.layer.masksToBounds = YES;
        self.userInteractionEnabled=YES;
        
        
        
    }
    return self;
}

- (void)loadImageFromURLString:(NSString *)theUrlString
{
   
    [self resetImageView];
    
    
    self.originalUrlString=theUrlString;
    
    if(self.image)
    {
        self.image = nil;
    }
    
    ////Remove cache 
    //self.image= [UIImageCache getCachedImage:self.originalUrlString];
    
    if(self.image){
        [self hiderSpinner];
        return ;
    }
    
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.originalUrlString]
											 cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
										 timeoutInterval:30.0];
	
	self.connection = [[[NSURLConnection alloc] initWithRequest:request delegate:self] autorelease];
    [self showSpinner];
}

- (void)connection:(NSURLConnection *)theConnection
	didReceiveData:(NSData *)incrementalData
{
    if (self.data == nil)
        self.data = [[[NSMutableData alloc] initWithCapacity:2048] autorelease];
	
    [self.data appendData:incrementalData];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)theConnection
{
    self.image = [UIImage imageWithData:data];
    
    ////Removing cache
   // [UIImageCache cacheImage: self.originalUrlString   image: self.image];
    
    [data release], data = nil;
	[connection release], connection = nil;
    
    [self hiderSpinner];
    
    
}


- (void)connection:(NSURLConnection *)aConnection didFailWithError:(NSError *)error
{

    self.image = [UIImage imageNamed:@"Photo_not_available.jpg"];
    [data release], data = nil;
	[connection release], connection = nil;
    [self hiderSpinner];

}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    if([self.delegate respondsToSelector:@selector(asynchRoundedUIImageViewTapped:)]){
        
        [self.delegate asynchRoundedUIImageViewTapped:self];
    }
    
}


-(void)showSpinner{
    
    
    //set up indicators
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    UIActivityIndicatorView *spinner= [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    spinner.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    spinner.tag= 111;
    [spinner startAnimating];
    [self addSubview:spinner];
    
}
-(void)hiderSpinner{

    
    //set up indicators
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    UIActivityIndicatorView *spinner=  (UIActivityIndicatorView *)[self viewWithTag:111];
    if([spinner isKindOfClass:[UIActivityIndicatorView class]]){
        
        [spinner stopAnimating];
        [spinner removeFromSuperview];
        
    }
    
    
    
    if(makeGrey){
        self.image= [self.image grayScaleImage];
    }
    
}

- (void)resetImageView
{
    [[self viewWithTag:111] removeFromSuperview];
    self.image = nil;
    [data release];
    data=nil;
    [connection cancel];
    [connection release];
    connection=nil;

}


- (void)dealloc {

    [delegate release];
	[data release];
    [connection cancel];
	[connection release];
    [super dealloc];
}

@end
