//
//  SharedManager.h
//
//  Created by Rajeel Amjad on 8/16/13.
//  Copyright (c) 2011 VeriTech. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface SharedManager : NSObject

+ (SharedManager*)getInstance;
+ (NSDate *)dateFromString:(NSString *)str withFormat:(NSString *)format;
+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)format;

+(UIImage*) drawImage:(UIImage*) fgImage
              inImage:(UIImage*) bgImage
              atPoint:(CGPoint)  point;

+(UIImage*)drawFront:(UIImage*)image text:(NSString*)text atPoint:(CGPoint)point;



-(UserDTO *)loadUserObjectWithKey:(NSString*)key;


@property (nonatomic, assign)BOOL isMessage;
@property (nonatomic,assign) BOOL isEditable;


@end
