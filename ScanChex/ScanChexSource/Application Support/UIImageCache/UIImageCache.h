//
//  UIImageCache.h
//  MiLifeMap
//
//  Created by Jameel Khan on 10/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImageCache : NSObject

{


}

// Methods
+ (void) cacheImage: (NSString *) ImageURLString image:(UIImage *)image;
+ (UIImage *) getCachedImage: (NSString *) ImageURLString;
+ (void) flushImageCache;

@end
