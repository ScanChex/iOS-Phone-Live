//
//  DocumentCell.h
//  VeriScanQR
//
//  Created by Adnan Ahmad on 09/01/2013.
//  Copyright (c) 2013 Adnan Ahmad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DocumentDTO.h"

@interface DocumentCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UILabel *subject;


+(DocumentCell *)resuableCellForTableView:(UITableView *)tableview withOwner:(UIViewController *)owner;
-(void)updateCellWithDocument:(DocumentDTO *)ticket;

@end
