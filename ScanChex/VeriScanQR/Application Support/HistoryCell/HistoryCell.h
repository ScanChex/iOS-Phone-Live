//
//  HistoryCell.h
//  VeriScanQR
//
//  Created by Adnan Ahmad on 30/01/2013.
//  Copyright (c) 2013 Adnan Ahmad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HistoryDTO.h"
@interface HistoryCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UILabel *date;
@property (retain, nonatomic) IBOutlet UILabel *technician;
@property (retain, nonatomic) IBOutlet UILabel *service;
@property (retain, nonatomic) IBOutlet UIImageView *yes;
@property (retain, nonatomic) IBOutlet UIImageView *no;
@property (retain, nonatomic) IBOutlet UIButton *notes;
@property (retain, nonatomic) IBOutlet UIButton *voice;
@property (retain, nonatomic) IBOutlet UIButton *video;
@property (retain, nonatomic) IBOutlet UIButton *image;
@property (retain, nonatomic) IBOutlet UILabel *imageLabel;
@property (retain, nonatomic) IBOutlet UILabel *voiceLabel;
@property (retain, nonatomic) IBOutlet UILabel *videoLabel;
@property (retain, nonatomic) IBOutlet UILabel *notesLabel;
@property (retain, nonatomic) IBOutlet UILabel *ticketNoLabel;

+(HistoryCell *)resuableCellForTableView:(UITableView *)tableview withOwner:(UIViewController *)owner;
-(void)updateCellWithTicket:(HistoryDTO *)ticket;
@end
