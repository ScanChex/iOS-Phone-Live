//
//  HomeVC.h
//  VeriScanQR
//
//  Created by Adnan Ahmad on 13/12/2012.
//  Copyright (c) 2012 Adnan Ahmad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseVC.h"
#import "ScanQRManager.h"
#import "WebServiceManager.h"
#import "AsyncImageView.h"

@interface HomeVC :ScanQRManager


+(id)initWithHome;

@property (retain, nonatomic) IBOutlet UILabel *name;
@property (retain, nonatomic) IBOutlet AsyncImageView *logo;
@property (retain, nonatomic) IBOutlet AsyncImageView *logoImage;

- (IBAction)scanTagButtonPressed:(id)sender;
- (IBAction)scannedScheduleButtonPressed:(id)sender;
- (IBAction)backButtonPressed:(id)sender;

@end
