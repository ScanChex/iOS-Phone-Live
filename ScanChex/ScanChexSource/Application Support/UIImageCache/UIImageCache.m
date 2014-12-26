//
//  UIImageCache.m
//  MiLifeMap
//
//  Created by Jameel Khan on 10/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "UIImageCache.h"
#define TMP NSTemporaryDirectory()




@implementation UIImageCache

+ (void) cacheImage: (NSString *) ImageURLString image:(UIImage *)image
{
       
    // Generate a unique path to a resource representing the image you want
    NSString *filename = [ImageURLString lastPathComponent];
    NSString *uniquePath = [TMP stringByAppendingPathComponent: filename];
    
    // Check for file existence
    if(![[NSFileManager defaultManager] fileExistsAtPath: uniquePath])
    {
        // The file doesn't exist, we should get a copy of it
        
        // Fetch image
        //NSData *data = [[NSData alloc] initWithContentsOfURL: ImageURL];
        //UIImage *image = [[UIImage alloc] initWithData: data];
        
        // Do we want to round the corners?
        //image = [self roundCorners: image];
        
        // Is it PNG or JPG/JPEG?
        // Running the image representation function writes the data from the image to a file
        if([ImageURLString rangeOfString: @".png" options: NSCaseInsensitiveSearch].location != NSNotFound)
        {
            [UIImagePNGRepresentation(image) writeToFile: uniquePath atomically: YES];
        }
        else if(
                [ImageURLString rangeOfString: @".jpg" options: NSCaseInsensitiveSearch].location != NSNotFound || 
                [ImageURLString rangeOfString: @".jpeg" options: NSCaseInsensitiveSearch].location != NSNotFound
                )
        {
            
            
             NSLog(@"Cached a new image with name: %@",ImageURLString);
            
            [UIImageJPEGRepresentation(image, 100) writeToFile: uniquePath atomically: YES];
        }
    }
}

+ (UIImage *) getCachedImage: (NSString *) ImageURLString
{
    NSString *filename = [ImageURLString lastPathComponent];
    NSString *uniquePath = [TMP stringByAppendingPathComponent: filename];
    
    UIImage *image=nil;
    
    // Check for a cached version
    if([[NSFileManager defaultManager] fileExistsAtPath: uniquePath])
    {
       //NSLog(@"Loaded image with name: %@",ImageURLString);
        image = [UIImage imageWithContentsOfFile: uniquePath]; // this is the cached image
    }
        
    return image;
}

+ (void) flushImageCache
{
    NSFileManager* fm = [[[NSFileManager alloc] init] autorelease];
    NSDirectoryEnumerator* en = [fm enumeratorAtPath:TMP];    
    NSError* err = nil;
    BOOL res;
    
    NSString* file;
    while (file = [en nextObject]) {
        res = [fm removeItemAtPath:[TMP stringByAppendingPathComponent:file] error:&err];
        if (!res && err) {
            NSLog(@"oops: %@", err);
        }
    }
}


@end
