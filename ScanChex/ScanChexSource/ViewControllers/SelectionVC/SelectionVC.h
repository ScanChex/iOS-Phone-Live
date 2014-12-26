//
//  SelectionVC.h
//  VeriScanQR
//
//  Created by Adnan Ahmad on 02/04/2013.
//  Copyright (c) 2013 Adnan Ahmad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
#import "MessageCentreVC.h"
#import "InfColorPickerController.h"
@interface SelectionVC : BaseVC <InfColorPickerControllerDelegate>

@property (retain, nonatomic) IBOutlet UILabel *name;
@property (retain, nonatomic) IBOutlet AsyncImageView *logo;
@property (retain, nonatomic) IBOutlet UIView *messageView;
@property (retain, nonatomic) IBOutlet UIImageView *imgAlert;
@property (retain, nonatomic) IBOutlet UILabel *lblMessage;
@property (retain, nonatomic) IBOutlet UIButton *btnMessage;

+(id)initWithSelection;
-(IBAction)ticketsButtonPressed:(id)sender;
-(IBAction)viewMapButtonPressed:(id)sender;
-(IBAction)logoutButtonPressed:(id)sender;
-(IBAction)messageButtonPressed:(id)sender;
-(IBAction)customizeButtonPressed:(id)sender;
-(void)messageNotification:(NSNotification*)notif;
-(IBAction)idButtonPressed:(id)sender;

@end
