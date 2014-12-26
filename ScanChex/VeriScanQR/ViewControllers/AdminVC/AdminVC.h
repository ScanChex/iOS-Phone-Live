//
//  AdminVC.h
//  VeriScanQR
//
//  Created by Adnan Ahmad on 21/02/2013.
//  Copyright (c) 2013 Adnan Ahmad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebServiceManager.h"
#import "AsyncImageView.h"
#import "BaseVC.h"
@interface AdminVC : BaseVC<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UIAlertViewDelegate,UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate>

@property (retain, nonatomic) IBOutlet UILabel *name;
@property (retain, nonatomic) IBOutlet AsyncImageView *logo;
@property (retain, nonatomic) NSString *imagePath;
@property (retain, nonatomic) IBOutlet UIView * pickerUIVIew;
@property (retain, nonatomic) IBOutlet UIPickerView * pickerView;
@property (retain, nonatomic) NSMutableArray * employeeArray;

@property (retain ,nonatomic) IBOutlet UITableView * employeeTable;

@property (retain, nonatomic) NSString * currentSelectedEmployeeID;
+(id)initWithAdmin;
- (IBAction)updateImageAndLockLocatoin:(id)sender;
- (IBAction)lockLocation:(id)sender;
- (IBAction)backButtonPressed:(id)sender;
-(IBAction)registerEmployeeDevice:(id)sender;
-(IBAction)checkInCheckOut:(id)sender;
-(void)postDeviceRegistration:(NSString*)user_id;
-(IBAction)donePressed:(id)sender;
-(IBAction)employeeCheckPressed:(id)sender;
@end
