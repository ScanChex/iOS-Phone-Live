//
//  BaseVC.h
//  VeriScanQR
//
//  Created by Adnan Ahmad on 13/12/2012.
//  Copyright (c) 2012 Adnan Ahmad. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ok)(void);

@interface BaseVC : UIViewController<UIAlertViewDelegate>

@property(nonatomic,copy)ok okAction;

-(void)initWithPromptTitle:(NSString *)title message:(NSString *)message;
@end
