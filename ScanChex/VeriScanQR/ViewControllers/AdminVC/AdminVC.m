//
//  AdminVC.m
//  VeriScanQR
//
//  Created by Adnan Ahmad on 21/02/2013.
//  Copyright (c) 2013 Adnan Ahmad. All rights reserved.
//

#import "AdminVC.h"
#import "UIImage+UIImage_Extra.h"
#import "VSLocationManager.h"
#import "UserDTO.h"
#import "VSSharedManager.h"
#import "TicketDTO.h"
#import "SVProgressHUD.h"
#import "AdminScanAssetVC.h"
#import "CheckInCheckOutViewController.h"
@interface AdminVC ()
{
    UIImagePickerController *imagePickerController;
    
}
@end

@implementation AdminVC
@synthesize name=_name;
@synthesize logo=_logo;
@synthesize imagePath=_imagePath;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.employeeArray = [NSMutableArray array];
        // Custom initialization
    }
    return self;
}

+(id)initWithAdmin{
    
    return [[[AdminVC alloc] initWithNibName:@"AdminVC" bundle:nil] autorelease];
}

- (void)viewDidLoad
{
    UITapGestureRecognizer* gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pickerViewTapGestureRecognized:)];
    gestureRecognizer.cancelsTouchesInView = NO;
    [gestureRecognizer setDelegate:self];
    
    [self.pickerView addGestureRecognizer:gestureRecognizer];
//    [self.logo setImage:[UIImage imageNamed:@"Photo_not_available"]];
    [self.pickerUIVIew setHidden:YES];
     [self.view setBackgroundColor:[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"color"]]];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    UserDTO *user=[[VSSharedManager sharedManager] currentUser];
    self.name.text=user.name;
    self.logo.layer.borderWidth=3.0;
    self.logo.layer.borderColor=[UIColor lightGrayColor].CGColor;
  
  
    if (![user.logo isKindOfClass:[NSNull class]])
        [self.logo setImageURL:[NSURL URLWithString:user.logo]];
    
    [[VSLocationManager sharedManager] startListening];
    for (UIView * v in [self.view subviews]) {
        if ([v isKindOfClass:[UIButton class]]) {
            if ([[[(UIButton*)v titleLabel] text] isEqualToString:@"LOG OUT"]) {
                v.layer.cornerRadius = 5.0f;
            }
            
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)updateImageAndLockLocatoin:(id)sender {
    
    
    [self.navigationController pushViewController:[AdminScanAssetVC initwithScannerImage:nil isPicture:YES] animated:YES];

}
- (IBAction)lockLocation:(id)sender {
    
    [self.navigationController pushViewController:[AdminScanAssetVC initwithScannerImage:nil isPicture:NO] animated:YES];
}

- (IBAction)backButtonPressed:(id)sender {
    
    [[VSLocationManager sharedManager] stopListening];
    UserDTO * user = [[VSSharedManager sharedManager] currentUser];
    [[WebServiceManager sharedManager] logoutWithMasterKey:[NSString stringWithFormat:@"%d",user.masterKey] username:[[VSSharedManager sharedManager] currentUser].name session_id:[[VSSharedManager sharedManager] currentUser].session_id withCompletionHandler:^(id data,BOOL error){
        
    }];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(IBAction)registerEmployeeDevice:(id)sender {
    [SVProgressHUD show];
    UserDTO*user=[[VSSharedManager sharedManager] currentUser];
    [[WebServiceManager sharedManager] getEmployeesWithMasterKey:[NSString stringWithFormat:@"%d",user.masterKey] withCompletionHandler:^(id data ,BOOL error){
        [SVProgressHUD dismiss];
        NSLog(@"EMployees %@",data);
        NSMutableArray * tempArray = [data mutableCopy];
        for (int i = 0; i<[tempArray count]; i++) {
            NSMutableDictionary * tempDict = [tempArray objectAtIndex:i];
            [tempDict setObject:[NSString stringWithFormat:@"%@",[tempDict objectForKey:@"is_registered"]] forKey:@"is_registered"];
            if ([[tempDict objectForKey:@"is_registered"] isEqualToString:@"0"]) {
                 [tempDict setObject:@"false" forKey:@"is_registered"];
            }
            else {
                [tempDict setObject:@"true" forKey:@"is_registered"];
            }
            [tempArray replaceObjectAtIndex:i withObject:tempDict];
            
        }
        self.employeeArray = [tempArray mutableCopy];
        NSLog(@"%@",self.employeeArray);
        [self.pickerView reloadAllComponents];
        [self.employeeTable reloadData];
        [self.pickerUIVIew setHidden:NO];
        if ([self.employeeArray count]>0) {
            self.currentSelectedEmployeeID = [[self.employeeArray objectAtIndex:0] objectForKey:@"user_id"];
        }
    }];
//    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Register" message:@"Please enter employee user id" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Register",nil];
////    [alert setTag:indexPath.row];
//    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
//    UITextField * alertTextField = [alert textFieldAtIndex:0];
//    alertTextField.placeholder = @"Enter your user id";
//    [alert show];
//    [alert release];
}

-(IBAction)checkInCheckOut:(id)sender {
    [self.navigationController pushViewController:[CheckInCheckOutViewController initCheckInOutVC] animated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString* detailString = [[alertView textFieldAtIndex:0] text];
    NSLog(@"String is: %@", detailString); //Put it on the debugger
    if ( buttonIndex == 0){
        return; //If cancel or 0 length string the string doesn't matter
    }
    if (buttonIndex == 1 && [detailString length]>0) {
//        self.currentSelectedCell = alertView.tag;
        [self postDeviceRegistration:detailString];
        NSLog(@"Register");
        
    }
}
-(void)postDeviceRegistration:(NSString*)user_id {
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    UserDTO*user=[[VSSharedManager sharedManager] currentUser];
    [[WebServiceManager sharedManager] deviceRegister:user_id masterkey:[NSString stringWithFormat:@"%d",user.masterKey] currentUser:user.company_user withCompletionHandler:^(id data ,BOOL error){
        [SVProgressHUD dismiss];
        if (!error) {
            
            if(data){
                
                NSString * response = (NSString*)data;
                UIAlertView * tempAlert = [[[UIAlertView alloc] initWithTitle:@"Registration" message:response delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] autorelease];
                [tempAlert show];
                                   //                self.messagesArray =[NSMutableArray arrayWithArray:(NSMutableArray *)data];
                
                }
                
            
        }
        //        [self updateMessages];
    }];
}


-(IBAction)donePressed:(id)sender {
    [self.pickerUIVIew setHidden:YES];
    NSString * tempString = @"";
    for (int i = 0; i<[self.employeeArray count]; i++) {
        if ([[[self.employeeArray objectAtIndex:i] objectForKey:@"is_registered"] isEqualToString:@"true"]) {
            tempString = [NSString stringWithFormat:@"%@,%@",tempString, [[self.employeeArray objectAtIndex:i] objectForKey:@"user_id"]];
        }
    }
    [self postDeviceRegistration:tempString];
//    [self postDeviceRegistration:self.currentSelectedEmployeeID];
}

#pragma mark UIPIcker Delegate
//- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
//    return 1;
//}
//-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
//    return [self.employeeArray count];
//}
//
//- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
//    
//    UIImageView *temp = [[UIImageView alloc] init];
//    [temp setImage:[UIImage imageNamed:@"Photo_not_available"]];
//    temp.frame = CGRectMake(-70, 0, 60, 60);
//    [temp setImageURL:[NSURL URLWithString:[[self.employeeArray objectAtIndex:row] objectForKey:@"photo"]]];
//    
//    UILabel *channelLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 200, 60)];
//    channelLabel.text = [NSString stringWithFormat:@"%@", [[self.employeeArray  objectAtIndex:row] objectForKey:@"full_name"]];
//    channelLabel.textAlignment = NSTextAlignmentLeft;
//    channelLabel.backgroundColor = [UIColor clearColor];
//    
//    UIButton * tempBUtton = [[UIButton alloc] initWithFrame:CGRectMake(200, 0, 60, 60)];
//    [tempBUtton setImage:[UIImage imageNamed:@"cb_green_off.png"] forState:UIControlStateNormal];
//    [tempBUtton setImage:[UIImage imageNamed:@"cb_green_on.png"] forState:UIControlStateSelected];
//    [tempBUtton setTag:row];
//    if ([[self.employeeArray  objectAtIndex:row] objectForKey:@"is_registered"] == 1) {
//        [tempBUtton setSelected:1];
//        
//    }
//    else {
//        [tempBUtton setSelected:@"0"];
//    }
//    [tempBUtton addTarget:self action:@selector(employeeCheckPressed:) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIView *tmpView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 60)];
//    [tmpView insertSubview:temp atIndex:0];
//    [tmpView insertSubview:channelLabel atIndex:1];
//    [tmpView insertSubview:tempBUtton atIndex:2];
//    
//    return tmpView;
//}
//- (void)pickerViewTapGestureRecognized:(UITapGestureRecognizer*)gestureRecognizer
//{
//    CGPoint touchPoint = [gestureRecognizer locationInView:gestureRecognizer.view.superview];
//    
//    CGRect frame = self.pickerView.frame;
//    CGRect selectorFrame = CGRectInset( frame, 0.0, self.pickerView.bounds.size.height * 0.85 / 2.0 );
//    
//    if( CGRectContainsPoint( selectorFrame, touchPoint) )
//    {
//        NSLog( @"Selected Row: %i", [self.employeeArray objectAtIndex:[self.pickerView selectedRowInComponent:0]] );
//    }
//}

-(IBAction)employeeCheckPressed:(id)sender {
    UIButton * temp = (UIButton*)sender;
    temp.selected = !temp.selected;
    
        NSMutableDictionary * tempDict = [self.employeeArray  objectAtIndex:[temp tag]];
        [tempDict setObject:[NSDecimalNumber numberWithBool:temp.selected] forKey:@"is_registered"];
    
    
}

//-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
//    self.currentSelectedEmployeeID = [[self.employeeArray objectAtIndex:row] objectForKey:@"user_id"];
//}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 60.0f;
}

#pragma mark Uitableview Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.employeeArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
   UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DefaultCell"];
    UIImageView *temp = [[UIImageView alloc] init];
    [temp setImage:[UIImage imageNamed:@"Photo_not_available"]];
    temp.layer.borderWidth=3.0;
    temp.layer.borderColor=[UIColor lightGrayColor].CGColor;
  
    temp.frame = CGRectMake(0, 0, 60, 60);
    [temp setImageURL:[NSURL URLWithString:[[self.employeeArray objectAtIndex:indexPath.row] objectForKey:@"photo"]]];
    
    UILabel *channelLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, 200, 60)];
    channelLabel.text = [NSString stringWithFormat:@"%@", [[self.employeeArray  objectAtIndex:indexPath.row] objectForKey:@"full_name"]];
    channelLabel.textAlignment = NSTextAlignmentLeft;
    channelLabel.backgroundColor = [UIColor clearColor];
    
    UIButton * tempBUtton = [[UIButton alloc] initWithFrame:CGRectMake(260, 0, 60, 60)];
    [tempBUtton setImage:[UIImage imageNamed:@"cb_green_off.png"] forState:UIControlStateNormal];
    [tempBUtton setImage:[UIImage imageNamed:@"cb_green_on.png"] forState:UIControlStateSelected];
    [tempBUtton setTag:indexPath.row];
    if ([[[self.employeeArray  objectAtIndex:indexPath.row] objectForKey:@"is_registered"] isEqualToString:@"true"]) {
        [tempBUtton setSelected:TRUE];
        
    }
    else {
        [tempBUtton setSelected:FALSE];
    }
    [tempBUtton addTarget:self action:@selector(employeeCheckPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *tmpView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 60)];
    [tmpView insertSubview:temp atIndex:0];
    [tmpView insertSubview:channelLabel atIndex:1];
    [tmpView addSubview:tempBUtton];
//    [tmpView insertSubview:tempBUtton atIndex:2];
    
    [[cell contentView] addSubview:tmpView];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableDictionary * tempDict = [self.employeeArray  objectAtIndex:indexPath.row];
    if ([[[self.employeeArray  objectAtIndex:indexPath.row] objectForKey:@"is_registered"] isEqualToString:@"true"]) {
        [tempDict setObject:@"false" forKey:@"is_registered"];
    }
    else {
        [tempDict setObject:@"true" forKey:@"is_registered"];
    }
    [self.employeeArray replaceObjectAtIndex:indexPath.row withObject:tempDict];
    NSLog(@"%@",self.employeeArray);
    [tableView reloadData];
}


@end
