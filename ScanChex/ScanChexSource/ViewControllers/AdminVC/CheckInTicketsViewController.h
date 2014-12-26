//
//  CheckInTicketsViewController.h
//  ScanChex
//
//  Created by Rajeel Amjad on 10/08/2014.
//  Copyright (c) 2014 Adnan Ahmad. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckInTicketsViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
@property (retain, nonatomic) IBOutlet UITableView *ticketsTable;
@property(nonatomic,retain)   NSMutableArray *tickets;
+ (id)initWithTickets;
- (IBAction)backButtonPressed:(id)sender;
@end
