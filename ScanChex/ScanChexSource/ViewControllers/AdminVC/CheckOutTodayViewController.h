//
//  CheckOutTodayViewController.h
//  ScanChex
//
//  Created by Ravi Kumar Bandaru on 10/24/14.
//  Copyright (c) 2014 Adnan Ahmad. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckOutTodayViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
@property (retain, nonatomic) IBOutlet UITableView *ticketsTable;
@property(nonatomic,retain)   NSMutableArray *tickets;
+ (id)initWithTickets;
- (IBAction)backButtonPressed:(id)sender;

@end
