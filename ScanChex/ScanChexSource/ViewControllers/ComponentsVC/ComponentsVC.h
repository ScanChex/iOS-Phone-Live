//
//  ComponentsVC.h
//  VeriScanQR
//
//  Created by Adnan Ahmad on 10/04/2013.
//  Copyright (c) 2013 Adnan Ahmad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
#import "ServiceDTO.h"
#import "BaseVC.h"
@interface ComponentsVC : BaseVC
@property (retain, nonatomic) IBOutlet UITableView *extraInfoTable;
@property(nonatomic,retain) NSMutableArray *components;
@property (retain, nonatomic) IBOutlet AsyncImageView *imageView;
@property (retain, nonatomic)ServiceDTO *service;
+(id)initWithComponents:(ServiceDTO *)array;
-(id)initwithData:(ServiceDTO*)array;

- (IBAction)backButtonPressed:(id)sender;
@end
