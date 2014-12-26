//
//  WebImageOperations.m
//  Squac
//
//  Created by HUB7 llc on 2/18/14.
//  Copyright (c) 2014 HUB7 llc. All rights reserved.
//


#import "WebImageOperations.h"
#import <QuartzCore/QuartzCore.h>

@implementation WebImageOperations
+ (void)processImageDataWithURLString:(NSString *)urlString andBlock:(void (^)(NSData *imageData))processImage
{
  NSURL *url = [NSURL URLWithString:urlString];
  
  dispatch_queue_t callerQueue = dispatch_get_current_queue();
  dispatch_queue_t downloadQueue = dispatch_queue_create("com.myapp.processsmagequeue", NULL);
  dispatch_async(downloadQueue, ^{
    NSData * imageData = [NSData dataWithContentsOfURL:url];
    
    dispatch_async(callerQueue, ^{
      processImage(imageData);
    });
  });
  //dispatch_release(downloadQueue);
}

@end
