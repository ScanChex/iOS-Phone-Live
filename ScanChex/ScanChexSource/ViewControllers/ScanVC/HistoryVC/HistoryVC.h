//
//  HistoryVC.h
//  VeriScanQR
//
//  Created by Adnan Ahmad on 24/12/2012.
//  Copyright (c) 2012 Adnan Ahmad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseVC.h"
#import "AsyncImageView.h"
@protocol HistoryVCDelegate <NSObject>

-(void)downloadVideoWithURL:(NSArray *)path;
-(void)downloadAudioWithURL:(NSArray *)path;
-(void)showNotes:(NSArray *)notes;
-(void)downloadImageWithURL:(NSArray *)path;

@end

@interface HistoryVC : BaseVC

@property (retain, nonatomic) IBOutlet UILabel *name;

@property (retain, nonatomic) IBOutlet UILabel *model;
@property (retain, nonatomic) IBOutlet UILabel *serial;
@property (retain, nonatomic) IBOutlet UILabel *installed;
@property (retain, nonatomic) IBOutlet UILabel *technician;
@property (retain, nonatomic) IBOutlet UITableView *historyTable;
@property (retain, nonatomic) IBOutlet UILabel *assetID;
@property (retain, nonatomic) IBOutlet UITextView *address;

@property (retain, nonatomic) IBOutlet UILabel *totalCodes;
@property (retain, nonatomic) IBOutlet UILabel *scannedCodes;
@property (retain, nonatomic) IBOutlet UILabel *remainingCodes;
@property (retain, nonatomic) IBOutlet UILabel *assetDescription;
@property (retain, nonatomic) IBOutlet AsyncImageView *assetImage;
@property (retain, nonatomic) IBOutlet UILabel * lastservicedLabel;

@property (retain, nonatomic) NSMutableArray *historyArray;

@property (nonatomic, assign) id<HistoryVCDelegate>delegate;
+(id)initWithHistory;
-(void)getHistory;


//103 66 179
@end
