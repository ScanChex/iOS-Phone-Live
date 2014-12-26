//
//  WebImageOperations.h
//  Squac
//
//  Created by HUB7 llc on 2/18/14.
//  Copyright (c) 2014 HUB7 llc. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface WebImageOperations : NSObject
// This takes in a string and imagedata object and returns imagedata processed on a background thread
+ (void)processImageDataWithURLString:(NSString *)urlString andBlock:(void (^)(NSData *imageData))processImage;


@end
