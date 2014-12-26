//
//  CheckOutInitialInformationViewController.m
//  ScanChex
//
//  Created by Rajeel Amjad on 26/07/2014.
//  Copyright (c) 2014 Adnan Ahmad. All rights reserved.
//

#import "CheckOutInitialInformationViewController.h"
#import "WebServiceManager.h"
#import "AsyncImageView.h"
#import "CheckOutStepTwoViewController.h"
#import "FTWCache.h"
#import "NSString+MD5.h"
#import "WebImageOperations.h"

@interface CheckOutInitialInformationViewController ()
-(id)initWithScan;
-(id)initWithManual;
@end

@implementation CheckOutInitialInformationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        // Custom initialization
    }
    return self;
}

+(id)initCheckWithScan {
    return [[[CheckOutInitialInformationViewController alloc]initWithScan] autorelease];
}
-(id)initWithScan {
    self=[super initWithNibName:@"CheckOutInitialInformationViewController" bundle:nil];
    if (self) {
        self.isScan = TRUE;
        // Custom initialization
    }
    return self;
}
+(id)initCheckWithManual {
    return [[[CheckOutInitialInformationViewController alloc]initWithManual] autorelease];
}
-(id)initWithManual {
    self=[super initWithNibName:@"CheckOutInitialInformationViewController" bundle:nil];
    if (self) {
        self.isScan = FALSE;
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    self.addressesArray = [[NSMutableArray alloc] initWithObjects:@"Empty", nil];
    [self.scrollView setContentSize:CGSizeMake(320, 490)];
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateScanner:) name:K_Update_ScanCode object:Nil];
    if (self.isScan) {
        [self.scanButton setTitle:@"SCAN MODE" forState:UIControlStateNormal];
        [self showQrScanner];
    }
    else {
        [self.scanButton setTitle:@"MANUAL LOOKUP" forState:UIControlStateNormal];
        [self fetchAllData];
    }
    // Do any additional setup after loading the view from its nib.
  
  self.assetImageView.layer.borderWidth=3.0;
  self.assetImageView.layer.borderColor=[UIColor lightGrayColor].CGColor;
  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark Button Pressed Events
- (IBAction)backButtonPressed:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)checkOutAction:(id)sender {
    NSLog(@"Check Out");
    
    BOOL temp = FALSE;
    for (UIView * v in [self.scrollView subviews]) {
        if ([v isKindOfClass:[UITextField class]]) {
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
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
        UserDTO *user=[[VSSharedManager sharedManager] currentUser];
        [[WebServiceManager sharedManager] checkoutFirstStepWithMasterKey:[NSString stringWithFormat:@"%d",user.masterKey] description:[self.descriptionTextField text] serial_number:[self.serialNumberTextField text] address:[self.addressTextView text] department:[self.departmentTextField text] user_id:[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"] type:@"check_out" asset_id:self.currentSelectedAsset client:[self.clientTextField text] withCompletionHandler:^(id data, BOOL error)
         {
             
             
             [SVProgressHUD dismiss];
             if (!error) {
                 NSMutableArray * tempDict = [data mutableCopy];
                 NSLog(@"%@",tempDict);
                 [self.navigationController pushViewController:[CheckOutStepTwoViewController initWithData:[tempDict objectAtIndex:0] assetData:self.dataDict selectedAsset:self.currentSelectedAsset client:[self.clientTextField text] address:[self.addressTextView text] clientId:self.currentSelectedClientId]  animated:YES];
             }
             
             
             
         }];
    }
    
}

#pragma mark- NSNOTIFICATION CENTRE

-(void)updateScanner:(NSNotification *)info
{
    self.currentScannedCode = (NSString *)[info object];
    DLog(@"Current Scan %@",self.currentScannedCode);
    [self fetchAllData];
   
}

-(void)fetchAllData {
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    UserDTO *user=[[VSSharedManager sharedManager] currentUser];
    [[WebServiceManager sharedManager] getAllCheckOutDataWithMasterKey:[NSString stringWithFormat:@"%d",user.masterKey] withCompletionHandler:^(id data, BOOL error)
     {
         
         [SVProgressHUD dismiss];
         if (!error) {
             self.dataDict = [data mutableCopy];
             if (self.isScan) {
                 BOOL checkScan = FALSE;
                 for (int i  = 0; i<[[self.dataDict objectForKey:@"assets"] count]; i++) {
                     NSLog(@"%@",[self.currentScannedCode lowercaseString]);
                     NSLog(@"%@",[[[[self.dataDict objectForKey:@"assets"] objectAtIndex:i] objectForKey:@"asset_code"] lowercaseString]);
//                     count++;
                     if ([[[[[self.dataDict objectForKey:@"assets"] objectAtIndex:i] objectForKey:@"asset_code"] lowercaseString] isEqualToString:[self.currentScannedCode lowercaseString]]) {
                         checkScan = TRUE;
                         [self.descriptionTextField setText:[[[self.dataDict objectForKey:@"assets"] objectAtIndex:i] objectForKey:@"description"]];
                         [self.assetImageView setImageURL:[NSURL URLWithString:[[[self.dataDict objectForKey:@"assets"] objectAtIndex:i] objectForKey:@"asset_photo"]]];
                         [self.assetIDTextField setText:[[[self.dataDict objectForKey:@"assets"] objectAtIndex:i] objectForKey:@"asset_id"]];
                         self.currentSelectedAsset = [[[self.dataDict objectForKey:@"assets"] objectAtIndex:i] objectForKey:@"id"];
                         NSDictionary * tempDict = [[self.dataDict objectForKey:@"assets"] objectAtIndex:i];
                         self.addressTextView.text =  [NSString stringWithFormat:@"%@\n%@, %@, %@",[[tempDict objectForKey:@"address"] objectForKey:@"address1"],[[tempDict objectForKey:@"address"] objectForKey:@"city"],[[tempDict objectForKey:@"address"] objectForKey:@"state"],[[tempDict objectForKey:@"address"] objectForKey:@"zip_postal_code"]];
//                         [self.addressTextView setText:[[[self.dataDict objectForKey:@"assets"] objectAtIndex:i] objectForKey:@"address"]];
                         [self.descriptionTextField setText:[[[self.dataDict objectForKey:@"assets"] objectAtIndex:i] objectForKey:@"description"]];
                         [self.departmentTextField setText:[[[self.dataDict objectForKey:@"assets"] objectAtIndex:i] objectForKey:@"department"]];
                         [self.serialNumberTextField setText:[[[self.dataDict objectForKey:@"assets"] objectAtIndex:i] objectForKey:@"serial_number"]];
                         for (int j = 0; j<[[self.dataDict objectForKey:@"clients"] count]; j++) {
                             NSDictionary * tempDict = [[self.dataDict objectForKey:@"clients"]objectAtIndex:j];
                             if ([[tempDict objectForKey:@"id"] isEqualToString:[[[self.dataDict objectForKey:@"assets"] objectAtIndex:i] objectForKey:@"client_id"]]) {
                                 [self.clientTextField setText:[tempDict objectForKey:@"name"]];
                                 self.currentSelectedClientId = [tempDict objectForKey:@"id"];
                                  self.addressesArray = [[tempDict objectForKey:@"addresses"] mutableCopy];
                                 break;
                                 
                             }
                         }
                         break;
                     }
                 }
                 if (!checkScan) {
                     UIAlertView * tempAlert = [[[UIAlertView alloc] initWithTitle:@"Attention" message:@"No Assets match the scanned code" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] autorelease];
                     [tempAlert show];
                 }
             }
         }
         
         
         
     }];
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

    if ([textField isEqual:self.descriptionTextField]) {
        UIPickerView * tempPicker = [[UIPickerView alloc]init];
        [tempPicker setTag:0];
        [tempPicker setDataSource:self];
        [tempPicker setDelegate:self];
        [textField setInputView:tempPicker];
    }
    if ([textField isEqual:self.assetIDTextField]) {
        UIPickerView * tempPicker = [[UIPickerView alloc]init];
        [tempPicker setTag:1];
        [tempPicker setDataSource:self];
        [tempPicker setDelegate:self];
        [textField setInputView:tempPicker];
    }
    if ([textField isEqual:self.departmentTextField]) {
        if ([[self.dataDict objectForKey:@"departments"] count]>0) {
            UIPickerView * tempPicker = [[UIPickerView alloc]init];
            [tempPicker setTag:3];
            [tempPicker setDataSource:self];
            [tempPicker setDelegate:self];
            [textField setInputView:tempPicker];
        }
        else {
            UIAlertView * tempAlert = [[[UIAlertView alloc] initWithTitle:@"Attention" message:@"No Department Exists" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] autorelease];
            [tempAlert show];
        }
        
    }
    if ([textField isEqual:self.clientTextField]) {
        UIPickerView * tempPicker = [[UIPickerView alloc]init];
        [tempPicker setTag:4];
        [tempPicker setDataSource:self];
        [tempPicker setDelegate:self];
        [textField setInputView:tempPicker];
    }
}

-(void)textViewDidBeginEditing:(UITextView *)textView {
//    UIToolbar * keyboardToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
//    
//    keyboardToolBar.barStyle = UIBarStyleDefault;
//    [keyboardToolBar setItems: [NSArray arrayWithObjects:
//                                
//                                [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
//                                [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(resignKeyboard)],
//                                nil]];
//    textView.inputAccessoryView = keyboardToolBar;
    
    if ([[self.addressesArray objectAtIndex:0] isKindOfClass:[NSString class]]) {
        [textView resignFirstResponder];
        UIAlertView * tempAlert = [[[UIAlertView alloc] initWithTitle:@"Attention" message:@"Please Select Asset First" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] autorelease];
        [tempAlert show];
    }
    else {
        UIPickerView * tempPicker = [[UIPickerView alloc]init];
        [tempPicker setTag:2];
        [tempPicker setDataSource:self];
        [tempPicker setDelegate:self];
        [textView setInputView:tempPicker];
        [textView reloadInputViews];
    }
    
    
}

#pragma mark UIPIcker Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if ([pickerView tag] == 0) {
        return [[self.dataDict objectForKey:@"assets"] count];
    }
    if ([pickerView tag] == 1) {
        return [[self.dataDict objectForKey:@"assets"] count];
    }
    if ([pickerView tag] == 2) {
        return [self.addressesArray count];
    }
    if ([pickerView tag] == 3) {
        return [[self.dataDict objectForKey:@"departments"] count];
    }
    if ([pickerView tag] == 4) {
        return [[self.dataDict objectForKey:@"clients"] count];
    }
    else {
        return 0;
    }
    
    
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
  
  if ([pickerView tag] == 0) {
    UILabel *thisLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
        thisLabel.text = [[[self.dataDict objectForKey:@"assets"] objectAtIndex:row] objectForKey:@"description"];;
    
        return thisLabel;  }
  
  if ([pickerView tag] == 1) {
//    UILabel *thisLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 40)];
//    thisLabel.text = [[[self.dataDict objectForKey:@"assets"] objectAtIndex:row] objectForKey:@"asset_id"];;
//    
//    return thisLabel;
    
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
    
    NSString *photoURL = [[[self.dataDict objectForKey:@"assets"] objectAtIndex:row] objectForKey:@"asset_photo"];
    
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

    
    
    
    
    NSLog(@" photo %@",[[[self.dataDict objectForKey:@"assets"] objectAtIndex:row] objectForKey:@"asset_photo"]);
    //[UIImage imageNamed:@"01.png"]
   // NSURL *imageURL = [NSURL URLWithString:[[[self.dataDict objectForKey:@"assets"] objectAtIndex:row] objectForKey:@"asset_photo"]];
   // NSData * imageData = [NSData dataWithContentsOfURL:imageURL];  // pickerImageView.image = [UIImage imageWithData: imageData];
    //pickerImageView.image = [UIImage imageWithData:imageData];
    pickerViewLabel.backgroundColor = [UIColor clearColor];
    pickerViewLabel.text = [[[self.dataDict objectForKey:@"assets"] objectAtIndex:row] objectForKey:@"asset_id"]; // where therapyTypes[row] is a specific example from my code
    // pickerViewLabel.font = [UIFont fontWithName:@"avenir" size:14];
    return pickerCustomView;

  }
  if ([pickerView tag] == 2) {
    UILabel *thisLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 40)];
    thisLabel.text = [NSString stringWithFormat:@"%@, %@, %@, %@, %@",[[self.addressesArray objectAtIndex:row] objectForKey:@"address1"],[[self.addressesArray objectAtIndex:row] objectForKey:@"city"],[[self.addressesArray objectAtIndex:row] objectForKey:@"state"],[[self.addressesArray objectAtIndex:row] objectForKey:@"zip_postal_code"],[[self.addressesArray objectAtIndex:row] objectForKey:@"country"]];;
    
    return thisLabel;
  }
  if ([pickerView tag] == 3) {
    UILabel *thisLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 40)];
    thisLabel.text = [[[self.dataDict objectForKey:@"departments"] objectAtIndex:row] objectForKey:@"name"];
    
    return thisLabel;
    
  }
  if ([pickerView tag] == 4) {
    UILabel *thisLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 40)];
    thisLabel.text = [[[self.dataDict objectForKey:@"clients"] objectAtIndex:row] objectForKey:@"name"];
    
    return thisLabel;
    
  }

  else {
    return nil;
  }
  
  
}





//- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
//    if ([pickerView tag] == 0) {
//        return [[[self.dataDict objectForKey:@"assets"] objectAtIndex:row] objectForKey:@"description"];
//    }
//    if ([pickerView tag] == 1) {
//        return [[[self.dataDict objectForKey:@"assets"] objectAtIndex:row] objectForKey:@"asset_id"];
//    }
//    if ([pickerView tag] == 2) {
//        return [NSString stringWithFormat:@"%@, %@, %@, %@, %@",[[self.addressesArray objectAtIndex:row] objectForKey:@"address1"],[[self.addressesArray objectAtIndex:row] objectForKey:@"city"],[[self.addressesArray objectAtIndex:row] objectForKey:@"state"],[[self.addressesArray objectAtIndex:row] objectForKey:@"zip_postal_code"],[[self.addressesArray objectAtIndex:row] objectForKey:@"country"]];
//    }
//    if ([pickerView tag] == 3) {
//        return [[[self.dataDict objectForKey:@"departments"] objectAtIndex:row] objectForKey:@"name"];
//    }
//    if ([pickerView tag] == 4) {
//        return [[[self.dataDict objectForKey:@"clients"] objectAtIndex:row] objectForKey:@"name"];
//    }
//    else {
//        return nil;
//    }
//}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if ([pickerView tag] == 0) {
        self.descriptionTextField.text = [[[self.dataDict objectForKey:@"assets"] objectAtIndex:row] objectForKey:@"description"];
    }
    if ([pickerView tag] == 1) {
        if (![[[[self.dataDict objectForKey:@"assets"]objectAtIndex:row] objectForKey:@"asset_status"] isEqualToString:@"checked_out"]) {
            self.assetIDTextField.text =  [[[self.dataDict objectForKey:@"assets"] objectAtIndex:row] objectForKey:@"asset_id"];
            self.currentSelectedAsset =[[[self.dataDict objectForKey:@"assets"] objectAtIndex:row] objectForKey:@"id"];
            [self.assetImageView setImageURL:[NSURL URLWithString:[[[self.dataDict objectForKey:@"assets"] objectAtIndex:row] objectForKey:@"asset_photo"]]];
            [self.departmentTextField setText:[[[self.dataDict objectForKey:@"assets"] objectAtIndex:row] objectForKey:@"department"]];
            [self.serialNumberTextField setText:[[[self.dataDict objectForKey:@"assets"] objectAtIndex:row] objectForKey:@"serial_number"]];
            self.currentSelectedlientID =[[[self.dataDict objectForKey:@"assets"] objectAtIndex:row] objectForKey:@"client_id"];
            //        [self.addressTextView setText:[[[self.dataDict objectForKey:@"assets"] objectAtIndex:row] objectForKey:@"address"]];
            NSDictionary * tempDict = [[self.dataDict objectForKey:@"assets"] objectAtIndex:row];
            self.addressTextView.text =  [NSString stringWithFormat:@"%@\n%@, %@, %@",[[tempDict objectForKey:@"address"] objectForKey:@"address1"],[[tempDict objectForKey:@"address"] objectForKey:@"city"],[[tempDict objectForKey:@"address"] objectForKey:@"state"],[[tempDict objectForKey:@"address"] objectForKey:@"zip_postal_code"]];
            [self.descriptionTextField setText:[[[self.dataDict objectForKey:@"assets"] objectAtIndex:row] objectForKey:@"description"]];
            for (int i = 0; i< [[self.dataDict objectForKey:@"clients"] count]; i++) {
                NSMutableDictionary * tempDict = [[self.dataDict objectForKey:@"clients"] objectAtIndex:i];
                if ([[tempDict objectForKey:@"id"] isEqualToString:self.currentSelectedlientID]) {
                    [self.clientTextField setText:[tempDict objectForKey:@"name"]];
                    self.currentSelectedClientId =[tempDict objectForKey:@"id"];
                    if ([[tempDict objectForKey:@"addresses"] count]>0) {
                        self.addressesArray = [[tempDict objectForKey:@"addresses"] mutableCopy];
                    }
                }
            }

        }
        else {
            UIAlertView * tempAlert = [[[UIAlertView alloc] initWithTitle:@"Attention" message:@"Asset is not available already checked out" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] autorelease];
            [tempAlert show];
        }
    }
    if ([pickerView tag] == 2) {
        self.addressTextView.text =  [NSString stringWithFormat:@"%@\n%@, %@, %@",[[self.addressesArray objectAtIndex:row] objectForKey:@"address1"],[[self.addressesArray objectAtIndex:row] objectForKey:@"city"],[[self.addressesArray objectAtIndex:row] objectForKey:@"state"],[[self.addressesArray objectAtIndex:row] objectForKey:@"zip_postal_code"]];
    }
    if ([pickerView tag] == 3) {
        self.departmentTextField.text =  [[[self.dataDict objectForKey:@"departments"] objectAtIndex:row] objectForKey:@"name"];
    }
    if ([pickerView tag] == 4) {
        self.clientTextField.text =  [[[self.dataDict objectForKey:@"clients"] objectAtIndex:row] objectForKey:@"name"];
        self.currentSelectedClientId = [[[self.dataDict objectForKey:@"clients"] objectAtIndex:row] objectForKey:@"id"];
    }
    
}




@end
