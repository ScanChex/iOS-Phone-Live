//
//  CheckOutStepTwoViewController.m
//  ScanChex
//
//  Created by Rajeel Amjad on 07/08/2014.
//  Copyright (c) 2014 Adnan Ahmad. All rights reserved.
//

#import "CheckOutStepTwoViewController.h"
#import "AsyncImageView.h"
#import "SharedManager.h"
#import "WebServiceManager.h"
#import "CheckOutConfirmationViewController.h"
#import "FTWCache.h"
#import "WebImageOperations.h"
#import "NSString+MD5.h"


@interface CheckOutStepTwoViewController ()

@end

@implementation CheckOutStepTwoViewController
+(id)initWithData:(NSDictionary*)data assetData:(NSMutableDictionary*)assetData selectedAsset:(NSString*)selectedAsset client:(NSString*)client address:(NSString*)address clientId:(NSString*)clientId  {
    return [[[CheckOutStepTwoViewController alloc]initselfWithData:data assetData:assetData selectedAsset:selectedAsset client:client address:address clientId:clientId ] autorelease];
}
-(id)initselfWithData:(NSDictionary*)data assetData:(NSMutableDictionary*)assetData selectedAsset:(NSString*)selectedAsset client:(NSString*)client address:(NSString*)address clientId:(NSString*)clientId  {
    self=[super initWithNibName:@"CheckOutStepTwoViewController" bundle:nil];
    if (self) {
        self.initialData = [data mutableCopy];
        self.assetData = [assetData mutableCopy];
        self.selectedAsset = [selectedAsset copy];
        self.currentSelectedClientName = [client mutableCopy];
        self.currentSelectedAddress = [address mutableCopy];
        self.currentSelectedClient = [clientId mutableCopy];
        // Custom initialization
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
//    <option value="">SELECT</option>
//    <option value='300' >5 Mins</option>
//    <option value='600' >10 Mins</option>
//    <option value='900' >15 Mins</option>
//    <option value='1800' >30 Mins</option>
//    <option value='300' >5 Mins</option>
//    <option value='600' >10 Mins</option>
//    <option value='900' >15 Mins</option>
//    <option value='1800' >30 Mins</option>
//    <option value='3600' >1 Hr</option>
//    <option value='7200' >2 Hr</option>
//    <option value='21600' >6 Hr</option>
//    <option value='43200' >12 Hr</option>
//    <option value='86400' >1 Day</option>
//    <option  value='604800' >1 Week</option>

    self.toleranceArray = [[NSMutableArray alloc]initWithObjects:@"SELECT",@"5 Mins",@"10 Mins",@"15 Mins",@"30 Mins",@"1 Hr",@"2 Hr",@"6 Hr",@"12 Hr",@"1 Day",@"1 Week", nil];
    self.toleranceValuesArray = [[NSMutableArray alloc]initWithObjects:@"",@"300",@"600",@"900",@"1800",@"3600",@"7200",@"21600",@"43200",@"86400",@"604800", nil];
    self.currentSelectedTolerance = @"";
    [self.scrollView setContentSize:CGSizeMake(320, 978)];
    self.signatureController = [[[SignatureViewController alloc] initWithNibName:@"SignatureView" bundle:nil] autorelease];
    self.signatureController.delegate = self;
    CGRect frame = self.signatureView.frame;
    frame.origin.y = frame.origin.y;
    self.signatureController.view.frame = frame;
    [self.scrollView insertSubview:self.signatureController.view belowSubview:self.signatureView];
    [self.signatureView removeFromSuperview];
    self.signatureView = self.signatureController.view;
    [self.signatureView setBackgroundColor:[UIColor whiteColor]];
    [super viewDidLoad];
    [self.signatureController.signatureView setUserInteractionEnabled:FALSE];
//    [self.descriptionLabel setText:[self.initialData objectForKey:@"description"]];
//    [self.serialNumberLabel setText:[self.initialData objectForKey:@"serial_number"]];
    [self.clientTextField setText:self.currentSelectedClientName];
//    [self.clientTextField setEnabled:NO];
    
    for (int i = 0; i<[[self.assetData objectForKey:@"assets"] count]; i++) {
        NSDictionary * tempDict = [[self.assetData objectForKey:@"assets"]objectAtIndex:i];
        if ([[tempDict objectForKey:@"id"] isEqualToString:self.selectedAsset]) {
            [self.assetIdLabel setText:[tempDict objectForKey:@"asset_id"]];
            self.assetImageView.layer.borderWidth=3.0;
            self.assetImageView.layer.borderColor=[UIColor lightGrayColor].CGColor;
            [self.assetImageView setImageURL:[NSURL URLWithString:[tempDict objectForKey:@"asset_photo"]]];
            self.currentSelectedAssetPhoto = [tempDict objectForKey:@"asset_photo"];
            self.currentSelectedAssetId = [tempDict objectForKey:@"id"];
            [self.descriptionLabel setText:[tempDict objectForKey:@"description"]];
            [self.serialNumberLabel setText:[tempDict objectForKey:@"serial_number"]];
            self.currentSelectedDateFormat = [tempDict objectForKey:@"datetime_format"];
            [self.departmentLabel setText:[tempDict objectForKey:@"department"]];
            [self.departmentTextField setText:[tempDict objectForKey:@"department"]];
            [self.departmentTextField setEnabled:FALSE];
            self.addressTextView.text =  [NSString stringWithFormat:@"%@, %@, %@, %@, %@",[[tempDict objectForKey:@"address"] objectForKey:@"address1"],[[tempDict objectForKey:@"address"] objectForKey:@"city"],[[tempDict objectForKey:@"address"] objectForKey:@"state"],[[tempDict objectForKey:@"address"] objectForKey:@"zip_postal_code"],[[tempDict objectForKey:@"address"] objectForKey:@"country"]];;
//            [self.addressTextView setText:[tempDict objectForKey:@"address"]];
//            [self.addressTextField setText:[tempDict objectForKey:@"address"]];
            self.addressTextField.text =  [NSString stringWithFormat:@"%@, %@, %@, %@, %@",[[tempDict objectForKey:@"address"] objectForKey:@"address1"],[[tempDict objectForKey:@"address"] objectForKey:@"city"],[[tempDict objectForKey:@"address"] objectForKey:@"state"],[[tempDict objectForKey:@"address"] objectForKey:@"zip_postal_code"],[[tempDict objectForKey:@"address"] objectForKey:@"country"]];;
//            [self.addressTextField setEnabled:NO];
//            [self.dateTextField setText:[self.initialData objectForKey:@"date_time_out"]];
            break;
        }
    }
    
   
    [self.dateTextField setText:[SharedManager stringFromDate:[NSDate date] withFormat:@"MM/dd/YY hh:mm a"]];
//    [self.dateTextField setText:[SharedManager stringFromDate:[NSDate date] withFormat:self.currentSelectedDateFormat]];
//    [self.dateTextField setText:[self.initialData objectForKey:@"date_time_out"]];
    
    
    [self.dateTextField setEnabled:NO];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Button Pressed Events
-(IBAction)checkButtonPressed:(id)sender {
    [self.checkButton setSelected:!self.checkButton.selected];
    if ([self.checkButton isSelected]) {
        [self.signatureController.signatureView setUserInteractionEnabled:TRUE];
    }
}
- (IBAction)backButtonPressed:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)checkOutPressed:(id)sender {
    BOOL temp = FALSE;
    for (UIView * v in [self.scrollView subviews]) {
        if ([v isKindOfClass:[UITextField class]] && ![(UITextField*)v isEqual:self.referenceTextField]) {
            if ([[(UITextField*)v text] length] == 0 ) {
                temp = TRUE;
                break;
            }
        }
    }
    if (temp) {
        UIAlertView * tempAlert = [[[UIAlertView alloc] initWithTitle:@"Attention" message:@"Please fill all fields" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] autorelease];
        [tempAlert show];
    }
    else {
//        if ([[self.notesTextView text] length] == 0) {
//            UIAlertView * tempAlert = [[[UIAlertView alloc] initWithTitle:@"Attention" message:@"Please fill all fields" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] autorelease];
//            [tempAlert show];
//        }
//        else {
            if (self.checkButton.isSelected) {
                if (self.uploadedSignaturePath) {
                    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
                    UserDTO *user=[[VSSharedManager sharedManager] currentUser];
                    [[WebServiceManager sharedManager]checkoutWithMasterKey:[NSString stringWithFormat:@"%d",user.masterKey] employee:self.currentSelectedEmployeeID department:[self.departmentTextField text] date_time_out:[self.dateTextField text] date_time_due_in:[self.dueTextField text] client_id:self.currentSelectedClient reference:[self.referenceTextField text] address:[self.addressTextField text] notes:[self.notesTextView text] signature:self.uploadedSignaturePath asset_id:self.currentSelectedAssetId user_id:[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"] tolerance:self.currentSelectedTolerance checkID:[self.initialData objectForKey:@"id"] withCompletionHandler:^(id data, BOOL error)
                     {
                         
                         
                         [SVProgressHUD dismiss];
                         if (!error) {
                             NSMutableDictionary * dict = [data mutableCopy];
                             NSMutableDictionary * tempDict = [NSMutableDictionary dictionary];
                             [tempDict setObject:[self.descriptionLabel text] forKey:@"desc"];
                             [tempDict setObject:[self.serialNumberLabel text] forKey:@"serial"];
                             [tempDict setObject:[self.assetIdLabel text] forKey:@"assetID"];
                             [tempDict setObject:[self.departmentLabel text] forKey:@"department"];
                             [tempDict setObject:[self.addressTextView text] forKey:@"address"];
                             [tempDict setObject:self.currentSelectedAssetPhoto forKey:@"photo"];
                             [tempDict setObject:[self.employeeTextField text] forKey:@"employee"];
                             NSString * temp = [NSString stringWithFormat:@"%@",[dict objectForKey:@"ticket_id"]];
                             [tempDict setObject:[self.dueTextField text] forKey:@"return"];
                             [tempDict setObject:temp forKey:@"ticket_id"];
                             [tempDict setObject:[dict objectForKey:@"ticket_number"] forKey:@"ticket_number"];
                             [self.navigationController pushViewController:[CheckOutConfirmationViewController initWithData:tempDict] animated:YES];
                             
                         }
                         
                         
                         
                     }];
                }
                else {
                    UIAlertView * tempAlert = [[[UIAlertView alloc] initWithTitle:@"Attention" message:@"Please sign and press submit" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] autorelease];
                    [tempAlert show];
                }
            }
            else {
            UIAlertView * tempAlert = [[[UIAlertView alloc] initWithTitle:@"Attention" message:@"CheckBox not checked" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] autorelease];
                [tempAlert show];
            }
            
//        }
    }
}

#pragma mark SignatureView Delegate

- (void) signatureViewController:(SignatureViewController *)viewController didSign:(NSData *)signature;
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    UserDTO *user=[[VSSharedManager sharedManager] currentUser];
    [[WebServiceManager sharedManager]uploadSignatureforCICOWithMasterKey:[NSString stringWithFormat:@"%d",user.masterKey] file:signature withCompletionHandler:^(id data, BOOL error)
     {
         
         
         [SVProgressHUD dismiss];
         if (!error) {
             self.uploadedSignaturePath = [data mutableCopy];
             [self.signatureController.signatureView erase];
             [self.signatureController.signatureView setUserInteractionEnabled:NO];
             UIAlertView * tempAlert = [[[UIAlertView alloc]initWithTitle:@"Signature" message:@"Signature Accepted" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
             [tempAlert show];
         }
         
         
         
     }];
//    UIImageWriteToSavedPhotosAlbum([UIImage imageWithData:thisSignature], nil, nil, nil);
//    self.signature = [UIImage imageWithData:thisSignature];
    //
    // Do something with thisSignature, like save it to a file or a database as binary data.
    //
}

#pragma mark UitextField Delegate
-(void)resignKeyboard {
    [self.view endEditing:YES];
}
-(void)textFieldDidBeginEditing:(UITextField *)textField {
//    UIToolbar * keyboardToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
//    
//    keyboardToolBar.barStyle = UIBarStyleDefault;
//    [keyboardToolBar setItems: [NSArray arrayWithObjects:
//                                
//                                [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
//                                [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(resignKeyboard)],
//                                nil]];
//    textField.inputAccessoryView = keyboardToolBar;
    
    if ([textField isEqual:self.employeeTextField]) {
        UIPickerView * tempPicker = [[UIPickerView alloc]init];
        [tempPicker setTag:0];
        [tempPicker setDataSource:self];
        [tempPicker setDelegate:self];
        [textField setInputView:tempPicker];
    }
    if ([textField isEqual:self.departmentTextField]) {
        UIPickerView * tempPicker = [[UIPickerView alloc]init];
        [tempPicker setTag:1];
        [tempPicker setDataSource:self];
        [tempPicker setDelegate:self];
        [textField setInputView:tempPicker];
    }
    if ([textField isEqual:self.addressTextField]) {
        UIPickerView * tempPicker = [[UIPickerView alloc]init];
        [tempPicker setTag:3];
        [tempPicker setDataSource:self];
        [tempPicker setDelegate:self];
        [textField setInputView:tempPicker];
    }
    if ([textField isEqual:self.clientTextField]) {
        UIPickerView * tempPicker = [[UIPickerView alloc]init];
        [tempPicker setTag:4];
        [tempPicker setDataSource:self];
        [tempPicker setDelegate:self];
        [textField setInputView:tempPicker];
    }
    if ([textField isEqual:self.toleranceTextField]) {
        UIPickerView * tempPicker = [[UIPickerView alloc]init];
        [tempPicker setTag:5];
        [tempPicker setDataSource:self];
        [tempPicker setDelegate:self];
        [textField setInputView:tempPicker];
    }
    if ([textField isEqual:self.dueTextField]) {
        UIDatePicker *datePicker = [[UIDatePicker alloc]init];
        datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        [datePicker addTarget:self action:@selector(updateDateField:) forControlEvents:UIControlEventValueChanged];
        [datePicker setMinimumDate: [NSDate date]];
//        [datePicker setTag:1];
        [textField setInputView:datePicker];
        NSDate * tempDate = datePicker.date;
        [textField setText:[SharedManager stringFromDate:tempDate withFormat:@"MM/dd/YY hh:mm a"]];
//        [textField setText:[SharedManager stringFromDate:tempDate withFormat:self.currentSelectedDateFormat]];

    }
}
- (void)updateDateField:(id)sender
{
    UIDatePicker *picker = (UIDatePicker*)sender;
    
    NSDate * tempDate = picker.date;
    
    [self.dueTextField setText:[SharedManager stringFromDate:tempDate withFormat:@"MM/dd/YY hh:mm a"]];
//     [self.dueTextField setText:[SharedManager stringFromDate:tempDate withFormat:self.currentSelectedDateFormat]];
    //    }
    
}
#pragma mark UIPIcker Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if ([pickerView tag] == 0) {
        return [[self.assetData objectForKey:@"employees"] count];
    }
    if ([pickerView tag] == 1) {
        return [[self.assetData objectForKey:@"departments"] count];
    }
    if ([pickerView tag] == 3) {
        return [[self.assetData objectForKey:@"addresses"] count];
    }
    if ([pickerView tag] == 4) {
        return [[self.assetData objectForKey:@"clients"] count];
    }
    if ([pickerView tag] == 5) {
        return [self.toleranceArray count];
    }
    else {
        return 0;
    }
    
    
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{

  if ([pickerView tag] == 0) {
    UIView *pickerCustomView = (id)view;
    UILabel *pickerViewLabel;
    UIImageView *pickerImageView;
    
 
  if (!pickerCustomView) {
    pickerCustomView= [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f,
                                                               [pickerView rowSizeForComponent:component].width - 10.0f, [pickerView rowSizeForComponent:component].height)];
    pickerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(90.0f, 0.0f, 35.0f, 35.0f)];
    pickerViewLabel= [[UILabel alloc] initWithFrame:CGRectMake(130.0f, -5.0f,
                                                               [pickerView rowSizeForComponent:component].width - 10.0f, [pickerView rowSizeForComponent:component].height)];
    // the values for x and y are specific for my example
    [pickerCustomView addSubview:pickerImageView];
    [pickerCustomView addSubview:pickerViewLabel];
  }
    
    
    NSString *photoURL = [[[self.assetData objectForKey:@"employees"] objectAtIndex:row] objectForKey:@"photo"];
    
    NSString *key = [photoURL MD5Hash];
    NSData *data = [FTWCache objectForKey:key];
    if (data) {
      UIImage *image = [UIImage imageWithData:data];
      pickerImageView.image = image;
      
    } else {
      
      [WebImageOperations processImageDataWithURLString:photoURL andBlock:^(NSData *imageData) {
        if (self.view.window) {
          [FTWCache setObject:imageData forKey:key];
          UIImage *image = [UIImage imageWithData:imageData];
          dispatch_async(dispatch_get_main_queue(), ^{
            
            pickerImageView.image = image;
          });
          
        }
        
      }];
    }
    

    
    NSLog(@" photo %@",[[[self.assetData objectForKey:@"employees"] objectAtIndex:row] objectForKey:@"photo"]);
  //[UIImage imageNamed:@"01.png"]
  //  NSURL *imageURL = [NSURL URLWithString:[[[self.assetData objectForKey:@"employees"] objectAtIndex:row] objectForKey:@"photo"]];
  //  NSData * imageData = [NSData dataWithContentsOfURL:imageURL];  // pickerImageView.image = [UIImage imageWithData: imageData];
   // pickerImageView.image = [UIImage imageWithData:imageData];
  pickerViewLabel.backgroundColor = [UIColor clearColor];
  pickerViewLabel.text = [[[self.assetData objectForKey:@"employees"] objectAtIndex:row] objectForKey:@"full_name"]; // where therapyTypes[row] is a specific example from my code
 // pickerViewLabel.font = [UIFont fontWithName:@"avenir" size:14];
    return pickerCustomView;
  }

  if ([pickerView tag] == 1) {
    UILabel *thisLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 40)];
    thisLabel.text = [[[self.assetData objectForKey:@"departments"] objectAtIndex:row] objectForKey:@"name"];
    
    return thisLabel;
  }
  if ([pickerView tag] == 3) {
    UILabel *thisLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 40)];
    thisLabel.text = [[[self.assetData objectForKey:@"addresses"] objectAtIndex:row] objectForKey:@"address1"];
    
    return thisLabel;
    
  }
  if ([pickerView tag] == 4) {
    UILabel *thisLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 40)];
    thisLabel.text = [[[self.assetData objectForKey:@"clients"] objectAtIndex:row] objectForKey:@"name"];
    
    return thisLabel;
    
  }
  if ([pickerView tag] == 5) {
    UILabel *thisLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 40)];
    thisLabel.text = [self.toleranceArray objectAtIndex:row];
    
    return thisLabel;
    
  }
  else {
    return nil;
  }

  
  }



- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
//    if ([pickerView tag] == 0) {
//        return [[[self.assetData objectForKey:@"employees"] objectAtIndex:row] objectForKey:@"full_name"];
//    }
    if ([pickerView tag] == 1) {
        return [[[self.assetData objectForKey:@"departments"] objectAtIndex:row] objectForKey:@"name"];
    }
    if ([pickerView tag] == 3) {
        return [[[self.assetData objectForKey:@"addresses"] objectAtIndex:row] objectForKey:@"address1"];
    }
    if ([pickerView tag] == 4) {
        return [[[self.assetData objectForKey:@"clients"] objectAtIndex:row] objectForKey:@"name"];
    }
    if ([pickerView tag] == 5) {
        return [self.toleranceArray objectAtIndex:row];
    }
    else {
        return nil;
    }
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if ([pickerView tag] == 0) {
        self.employeeTextField.text = [[[self.assetData objectForKey:@"employees"] objectAtIndex:row] objectForKey:@"full_name"];
        self.currentSelectedEmployeeID = [[[self.assetData objectForKey:@"employees"] objectAtIndex:row] objectForKey:@"user_id"];
    }
    if ([pickerView tag] == 1) {
        self.departmentTextField.text =  [[[self.assetData objectForKey:@"departments"] objectAtIndex:row] objectForKey:@"name"];   
    }
    if ([pickerView tag] == 3) {
        self.addressTextField.text =  [[[self.assetData objectForKey:@"addresses"] objectAtIndex:row] objectForKey:@"address1"];
    }
    if ([pickerView tag] == 4) {
        self.clientTextField.text =  [[[self.assetData objectForKey:@"clients"] objectAtIndex:row] objectForKey:@"name"];
        self.currentSelectedClient = [[[self.assetData objectForKey:@"clients"] objectAtIndex:row] objectForKey:@"id"];
    }
    if ([pickerView tag] == 5) {
        self.toleranceTextField.text =  [self.toleranceArray objectAtIndex:row];
        self.currentSelectedTolerance = [self.toleranceValuesArray objectAtIndex:row];
    }
    
}

#pragma mark UiscrollView Delegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    CGPoint locationPoint = [scrollView.panGestureRecognizer locationInView:scrollView];
    CGPoint viewPoint = [self.signatureView convertPoint:locationPoint fromView:self.scrollView];
    if ([self.signatureView pointInside:viewPoint withEvent:nil]) {
        self.scrollView.scrollEnabled = NO;
        self.scrollView.scrollEnabled = YES;
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint locationPoint = [[touches anyObject] locationInView:self.view];
    CGPoint viewPoint = [self.signatureView convertPoint:locationPoint fromView:self.view];
    if ([self.signatureView pointInside:viewPoint withEvent:event]) {
        self.scrollView.scrollEnabled = NO;
        self.scrollView.scrollEnabled = YES;
                    }
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint locationPoint = [[touches anyObject] locationInView:self.view];
    CGPoint viewPoint = [self.signatureView convertPoint:locationPoint fromView:self.view];
    if ([self.signatureView pointInside:viewPoint withEvent:event]) {
        self.scrollView.scrollEnabled = NO;
        self.scrollView.scrollEnabled = YES;
    }
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint locationPoint = [[touches anyObject] locationInView:self.view];
    CGPoint viewPoint = [self.signatureView convertPoint:locationPoint fromView:self.view];
    if ([self.signatureView pointInside:viewPoint withEvent:event]) {
        self.scrollView.scrollEnabled = NO;
        self.scrollView.scrollEnabled = YES;
    }
}

@end
