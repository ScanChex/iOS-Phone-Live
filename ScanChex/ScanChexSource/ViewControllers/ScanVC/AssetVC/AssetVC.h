//
//  AssetVC.h
//  VeriScanQR
//
//  Created by Adnan Ahmad on 24/12/2012.
//  Copyright (c) 2012 Adnan Ahmad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
#import "ServiceDTO.h"
#import "BaseVC.h"
#import "AsynchRoundedUIImageView.h"
#import "ScanQRManager.h"
#import "ScanVC.h"
@protocol assetDelegate <NSObject>
-(void)partButtonPressed:(ServiceDTO *)components;
@end

@interface AssetVC : BaseVC<UITableViewDelegate,UITableViewDataSource>


@property (retain, nonatomic) IBOutlet AsynchRoundedUIImageView *scannedImage;
@property (retain, nonatomic) IBOutlet UILabel *assetID;
@property (retain, nonatomic) IBOutlet UITextView *address;
@property (retain, nonatomic) IBOutlet UILabel *totalCodes;
@property (retain, nonatomic) IBOutlet UILabel *scannedCodes;
@property (retain, nonatomic) IBOutlet UILabel *remaining;
@property (retain, nonatomic) IBOutlet UILabel *assetDescription;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) IBOutlet UITableView *serviceTable;
@property (retain, nonatomic) NSMutableArray * checkpointCheckArray;
@property (nonatomic, assign) NSInteger currentPressedScanTag;
@property (nonatomic, retain) ScanQRManager *scanQRManager;
@property (nonatomic, assign) BOOL isAssetScan;
@property (nonatomic,assign)id<assetDelegate>delegate;
@property (retain , nonatomic) ScanVC * scanCVPointer;

@property (retain, nonatomic) IBOutlet UIView * serviceHeader;
@property (retain, nonatomic) IBOutlet UIView * checkpointHeader;
@property (retain, nonatomic) IBOutlet UIView * timeView;
@property (retain, nonatomic) IBOutlet UILabel * timeInLabel;
@property (retain, nonatomic) IBOutlet UILabel * totalTimeLabel;
@property (retain, nonatomic) IBOutlet UILabel * timeCompletedLabel;


+(id)initWithAsset;
-(void)updateAsset;
//- (NSString *)elapsedTimeSince:(NSDate *)date;
@end
