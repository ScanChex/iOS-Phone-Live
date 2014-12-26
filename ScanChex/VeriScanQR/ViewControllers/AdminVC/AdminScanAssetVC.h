//
//  AdminScanAssetVC.h
//  VeriScanQR
//
//  Created by Adnan Ahmad on 12/04/2013.
//  Copyright (c) 2013 Adnan Ahmad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
#import "ScanQRManager.h"


@interface AdminScanAssetVC : ScanQRManager

@property (retain, nonatomic) IBOutlet AsyncImageView *logo;
@property (nonatomic,retain)UIImage *scannerImage;
@property (nonatomic, assign) BOOL isPicture;

- (IBAction)scannerButtonPressed:(id)sender;
- (IBAction)backButtonPressed:(id)sender;

+(id)initwithScannerImage:(UIImage *)image isPicture:(BOOL)isPic;
@end
