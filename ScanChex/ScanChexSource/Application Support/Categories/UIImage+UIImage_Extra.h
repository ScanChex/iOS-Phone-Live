//
//  UIImage+UIImage_Extra.h
//  BetWithFriends
//
//  Created by OSM Invention on 6/21/12.
//  Copyright (c) 2012 Organic Spread Media, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (UIImage_Extra)
- (UIImage *)fixOrientation;
- (UIImage *)cropImage:(UIImage *)image to:(CGRect)cropRect andScaleTo:(CGSize)size;
- (UIImage *)clipImage:(UIImage *)image topCut:(float)topCut bottomCut:(float)bottomCut;
- (UIImage *)cropImageTransparentcy:(UIImage *)image;
- (UIImage *)grayScaleImage;
-(UIImage *)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;

@end
