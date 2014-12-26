//
//  DocumentsVC.h
//  VeriScanQR
//
//  Created by Adnan Ahmad on 24/12/2012.
//  Copyright (c) 2012 Adnan Ahmad. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DocumentDelegate <NSObject>

-(void)selectedFileWithPath:(NSString *)filePath;

@end
@interface DocumentsVC : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (retain, nonatomic) IBOutlet UITableView *documenTable;
@property(retain, nonatomic) NSArray *documents;
@property (retain, nonatomic) IBOutlet UILabel *assetID;
@property (retain, nonatomic) IBOutlet UITextView *address;
@property (retain, nonatomic) IBOutlet UILabel *totalCodes;
@property (retain, nonatomic) IBOutlet UILabel *scanningCodes;
@property (retain, nonatomic) IBOutlet UILabel *remainingCodes;
@property (retain, nonatomic) IBOutlet UILabel *assetDescription;
@property (assign, nonatomic) id<DocumentDelegate>delegate;
@property (retain, nonatomic) IBOutlet UIView * documentsHeader;
@property (retain, nonatomic) IBOutlet UIView * editableDocumentsHeader;
+(id)initWithDocumentWithArray:(NSArray *)data andDelegate:(id<DocumentDelegate>)delegate;
@end
