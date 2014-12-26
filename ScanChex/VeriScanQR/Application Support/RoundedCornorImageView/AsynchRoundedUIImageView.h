//
//  RoundedUIImageView.h
//  WinSomeThing
//
//  Created by Jameel Khan on 14/11/2012.
//  Copyright (c) 2012 Mobile Media Partners. All rights reserved.
//

#import <UIKit/UIKit.h>



@class AsynchRoundedUIImageView;
@protocol AsynchRoundedUIImageViewDelegate <NSObject>

-(void)asynchRoundedUIImageViewTapped:(AsynchRoundedUIImageView *)imageView;

@end




@interface AsynchRoundedUIImageView : UIImageView




@property (nonatomic, retain) id<AsynchRoundedUIImageViewDelegate> delegate;
@property (nonatomic) BOOL makeGrey;

- (void)loadImageFromURLString:(NSString *)theUrlString;
- (void)resetImageView;


@end


