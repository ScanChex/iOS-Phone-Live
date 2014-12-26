//
//  ScanQRManager.h
//  VeriScanQR
//
//  Created by Adnan Ahmad on 13/12/2012.
//  Copyright (c) 2012 Adnan Ahmad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZBarSDK.h"
#import <AudioToolbox/AudioToolbox.h>
#import "BaseVC.h"

@interface ScanQRManager : BaseVC<ZBarReaderDelegate>{

    SystemSoundID tickSound;
}

@property(nonatomic,retain)NSString *currentScannedCode;
-(void)showQrScanner;

@end
