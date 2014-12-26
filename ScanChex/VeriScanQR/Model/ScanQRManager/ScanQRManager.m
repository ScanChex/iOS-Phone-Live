//
//  ScanQRManager.m
//  VeriScanQR
//
//  Created by Adnan Ahmad on 13/12/2012.
//  Copyright (c) 2012 Adnan Ahmad. All rights reserved.
//

#import "ScanQRManager.h"
#import "Constant.h"


@implementation ScanQRManager

@synthesize currentScannedCode=_currentScannedCode;


-(void)showQrScanner{
    
    
    AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"LASER" ofType:@"WAV"]], &tickSound);
    
    // self.hidesBottomBarWhenPushed = YES;
    
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    //  reader.hidesBottomBarWhenPushed=YES;
    ZBarImageScanner *scanner = reader.scanner;
    // TODO: (optional) additional reader configuration here
    
    // EXAMPLE: disable rarely used I2/5 to improve performance
    [scanner setSymbology: ZBAR_SYMBOL
                   config: ZBAR_CFG_ENABLE
                       to: 1];
    reader.readerView.zoom = 1.0;
    
    // reader.readerView.showsFPS=YES;
    // [self.navigationController pushViewController:reader animated:YES];
   
    float currentVersion = 5.1;
    float sysVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    
    UIView * cancelButton;
    if (sysVersion > currentVersion)
        cancelButton = [[[[[reader.view.subviews objectAtIndex:1] subviews] objectAtIndex:0] subviews] objectAtIndex:2];
    else
        cancelButton = [[[[[reader.view.subviews objectAtIndex:1] subviews] objectAtIndex:0] subviews] objectAtIndex:1];
    
    
    [((UIButton *)cancelButton) addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    
    [self presentViewController:reader animated:YES completion:nil];

    
    //[self presentModalViewController:reader animated:YES];
    
    [reader release];
    
    [UIApplication sharedApplication].statusBarHidden = NO;
    
}

#pragma Scanner delegate method code


////Scanner code here


-(void)readerControllerDidFailToRead:(ZBarReaderController *)reader withRetry:(BOOL)retry
{
    [self initWithPromptTitle:@"Bar Code Reading Failed" message:@"Unable to read this barCode"];
}

- (void) imagePickerController: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    
    [UIApplication sharedApplication].statusBarHidden = NO;
    
    // ADD: get the decode results
    id<NSFastEnumeration> results =
    [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        // EXAMPLE: just grab the first barcode
        break;
    
    NSString * productCode=[NSString stringWithFormat:@"%@",symbol.data];
    self.currentScannedCode=[NSString stringWithFormat:@"%@",productCode];
    ///Fire Notification
     [[NSNotificationCenter defaultCenter] postNotificationName:K_Update_ScanCode object:self.currentScannedCode];

    AudioServicesPlaySystemSound(tickSound);
  //  [reader dismissModalViewControllerAnimated:YES];
    [reader dismissViewControllerAnimated:YES completion:nil];
   
    
  }

-(void)cancel{
#if TARGET_IPHONE_SIMULATOR
    
    NSLog(@"Running in Simulator - no app store or giro");
//    self.currentScannedCode=[NSString stringWithFormat:@"uestnju1mta0mi0wmdaxltawmdetmdawmq=="];
//    self.currentScannedCode=[NSString stringWithFormat:@"UEstNjU1MTA0Mi0wMDAxLTAwMDEtMDAwMg=="];
//    self.currentScannedCode = [NSString stringWithFormat:@"vvmtmzy2mjkzmi0wmdaxltawmdetmdawmg=="];
//    self.currentScannedCode=[NSString stringWithFormat:@"UEstMTIzNC0wMDAxLTAwMDEtMDAwMQ=="];
    self.currentScannedCode=[NSString stringWithFormat:@"uestmtiznc0wmdaxltawmdetmdaxmg=="];
    [[NSNotificationCenter defaultCenter] postNotificationName:K_Update_ScanCode object:self.currentScannedCode];
    

#else
    
    NSLog(@"Running on the Device");
    [[NSNotificationCenter defaultCenter] postNotificationName:K_Update_ScanCode_CANCEL object:nil];
    
#endif
    
    
    
}

@end
