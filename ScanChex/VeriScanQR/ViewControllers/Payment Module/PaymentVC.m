//
//  PaymentVC.m
//  VeriScanQR
//
//  Created by Adnan Ahmad on 02/03/2014.
//  Copyright (c) 2014 Adnan Ahmad. All rights reserved.
//

#import "PaymentVC.h"
#import "VSSharedManager.h"
#import "TicketCell.h"
#import <QuartzCore/QuartzCore.h>
#import "CustomIOS7AlertView.h"
#import "SharedManager.h"
#import "WebServiceManager.h"
#warning "Enter your credentials"
#define kPayPalClientId @"YOUR CLIENT ID HERE"
#define kPayPalReceiverEmail @"YOUR_PAYPAL_EMAIL@yourdomain.com"

@interface PaymentVC ()

@end

@implementation PaymentVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

+(id)initWithPayment
{
    return [[PaymentVC alloc] initWithNibName:@"PaymentVC" bundle:nil];
}

- (void) signatureViewController:(SignatureViewController *)viewController didSign:(NSData *)signature;
{
    NSData *thisSignature = signature;
//    UIImageWriteToSavedPhotosAlbum([UIImage imageWithData:thisSignature], nil, nil, nil);
    self.signature = [UIImage imageWithData:thisSignature];
    [self.signatureController.signatureView erase];
    [self.signatureController.signatureView setUserInteractionEnabled:NO];
//    [self.signatureController.signatureTextField setText:@"SIGNATURE ACCEPTED"];
    UIAlertView * tempAlert = [[[UIAlertView alloc]initWithTitle:@"Signature" message:@"Signature Accepted" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
    [tempAlert show];
    
    //
    // Do something with thisSignature, like save it to a file or a database as binary data.
    //
}
- (void)viewDidLoad
{
    TicketDTO *ticket =[[VSSharedManager sharedManager] selectedTicket];
    self.signature = nil;
    self.assetID.text=ticket.unEncryptedAssetID;
    self.ticketID.text = [[[VSSharedManager sharedManager] selectedTicketInfo] ticketID];
    [self.date setText:[SharedManager stringFromDate:[NSDate date] withFormat:@"dd/MM/yyyy"]];
    [self.amountDue setText:@"$999.99"];
    self.alertText =  [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 290, 200)];
    self.additionalCommentString = @"";
    [self.payNowButton.layer setBorderColor:[UIColor blackColor].CGColor];
    [self.payNowButton.layer setBorderWidth:1.0f];
    [self.returnButton.layer setCornerRadius:5.0f];
    self.signatureController = [[[SignatureViewController alloc] initWithNibName:@"SignatureView" bundle:nil] autorelease];
    self.signatureController.delegate = self;
    CGRect frame = self.signatureView.frame;
    frame.origin.y = frame.origin.y-35;
    self.signatureController.view.frame = frame;
    [self.view insertSubview:self.signatureController.view belowSubview:self.signatureView];
    [self.signatureView removeFromSuperview];
    self.signatureView = self.signatureController.view;
     [self.view setBackgroundColor:[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"color"]]];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    [self.paymentScrollView setFrame:self.view.frame];
    self.paymentScrollView.contentSize = CGSizeMake(320 , 489);
    [self.additionalPaymentView setHidden:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    
    // Start out working with the test environment! When you are ready, remove this line to switch to live.
    [PayPalPaymentViewController setEnvironment:PayPalEnvironmentNoNetwork];
    [PayPalPaymentViewController prepareForPaymentUsingClientId:@"YOUR_CLIENT_ID"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_paymentScrollView release];
    [super dealloc];
}
- (IBAction)onClickPayNow:(id)sender {
    if ([[self.customerTextView text] length]==0) {
        [self initWithPromptTitle:@"Error" message:@"Please Enter your comments"];
        return;
    }
    if (!self.signature) {
        [self initWithPromptTitle:@"Error" message:@"Please Enter your signature and press submit button"];
        return;
    }
    [self.additionalPaymentView setHidden:NO];
    
    // Remove our last completed payment, just for demo purposes.
}

- (IBAction)onClickReturn:(id)sender {
    if (![self.additionalPaymentView isHidden]) {
        [self.additionalPaymentView setHidden:YES];
    }
    else {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
    }
    
}

#pragma mark - PayPalPaymentDelegate methods

- (void)payPalPaymentDidComplete:(PayPalPayment *)completedPayment {
    // Payment was processed successfully; send to server for verification and fulfillment.
    [self verifyCompletedPayment:completedPayment];
    
    // Dismiss the PayPalPaymentViewController.
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)payPalPaymentDidCancel {
    // The payment was canceled; dismiss the PayPalPaymentViewController.
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)verifyCompletedPayment:(PayPalPayment *)completedPayment {
    // Send the entire confirmation dictionary
    NSData *confirmation = [NSJSONSerialization dataWithJSONObject:completedPayment.confirmation
                                                           options:0
                                                             error:nil];
    
    // Send confirmation to your server; your server should verify the proof of payment
    // and give the user their goods or services. If the server is not reachable, save
    // the confirmation and try again later.
}
#pragma mark- TableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //    if ([self.tickets count]>0) {
    
    
    TicketCell *cell=[TicketCell resuableCellForTableView2:self.tableView withOwner:self];
    cell.indexPath=indexPath;
    VSSharedManager * temp = [VSSharedManager sharedManager];
    NSInteger tempint = [[VSSharedManager sharedManager] CurrentSelectedIndex];
    [cell updateCellWithTicket:[[VSSharedManager sharedManager] selectedTicket] index:tempint];
    [cell.mapButton setHidden:YES];
//    [cell. mapButton addTarget:self action:@selector(showDirections) forControlEvents:UIControlEventTouchUpInside];
    //        [cell.mapButton addTarget: self
    //                           action: @selector(accessoryButtonTapped:withEvent:)
    //                 forControlEvents: UIControlEventTouchUpInside];
    //
    //        [cell.scanButton addTarget: self
    //                            action: @selector(accessoryButtonTapped:withEvent:)
    //                  forControlEvents: UIControlEventTouchUpInside];
    
    cell.callButton.hidden = YES;
    cell.scanButton.hidden = YES;
    //        cell.mapButton.hidden = YES;
    
    return cell;
    //    }else{
    //
    //        static NSString *kCellIdentifier = @"MyIdentifier";
    //
    //        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    //        if (cell == nil)
    //        {
    //            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier] autorelease];
    //        }
    //
    //        cell.textLabel.text = @"No ticket found";
    //        cell.textLabel.textColor=[UIColor whiteColor];
    //        return cell;
    //    }
    
    //    return nil;
    
}
- (UIView *)createDemoView:(NSString*)text
{
    UIView *demoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 290, 200)];
    [self.alertText setFrame:CGRectMake(0, 50, 290,150)];
    UILabel *imageView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 290, 50)];
    [imageView setTextAlignment:NSTextAlignmentCenter];
    [imageView setText:text];
    [imageView setNumberOfLines:2];
    [imageView setLineBreakMode:NSLineBreakByWordWrapping];
    [demoView addSubview:self.alertText];
    [demoView addSubview:imageView];
    
    return demoView;
}
-(IBAction)onCLickAdditionalComments:(id)sender {
    CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] init];
    [self.alertText setText:@""];
    // Add some custom content to the alert view
    [alertView setContainerView:[self createDemoView:@"Please enter any additional comments:"]];
//    [alertView setTag:indexPath.row];
    // Modify the parameters
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"Cancel", @"Add", nil]];
    //        [alertView setDelegate:self];
    
    // You may use a Block, rather than a delegate.
    [alertView setOnButtonTouchUpInside:^(CustomIOS7AlertView *alertView, int buttonIndex) {
//        NSString* detailString = [self.alertText text];
//        NSLog(@"String is: %@", detailString); //Put it on the debugger
//        if ( buttonIndex == 0){
//            return; //If cancel or 0 length string the string doesn't matter
//        }
//        if (buttonIndex == 1 && [detailString length]>0) {
//            self.currentSelectedCell = alertView.tag;
////            [self postReply:detailString];
//            NSLog(@"Reply");
//            
//        }
        [alertView close];
    }];
    
    [alertView setUseMotionEffects:true];
    
    // And launch the dialog
    [alertView show];
}

-(IBAction)payPalBUttonClicked:(id)sender {
    [self sendPaymentInformationtoServer:@"paypal"];
    
//    self.completedPayment = nil;
//    
//    PayPalPayment *payment = [[PayPalPayment alloc] init];
//    payment.amount = [[NSDecimalNumber alloc] initWithString:@"9.95"];
//    payment.currencyCode = @"USD";
//    payment.shortDescription = @"Hipster t-shirt";
//    
//    if (!payment.processable) {
//        // This particular payment will always be processable. If, for
//        // example, the amount was negative or the shortDescription was
//        // empty, this payment wouldn't be processable, and you'd want
//        // to handle that here.
//    }
//    
//    // Any customer identifier that you have will work here. Do NOT use a device- or
//    // hardware-based identifier.
//    NSString *customerId = @"user-11723";
//    
//    // Set the environment:
//    // - For live charges, use PayPalEnvironmentProduction (default).
//    // - To use the PayPal sandbox, use PayPalEnvironmentSandbox.
//    // - For testing, use PayPalEnvironmentNoNetwork.
//    [PayPalPaymentViewController setEnvironment:self.environment];
//    
//    PayPalPaymentViewController *paymentViewController = [[PayPalPaymentViewController alloc] initWithClientId:kPayPalClientId
//                                                                                                 receiverEmail:kPayPalReceiverEmail
//                                                                                                       payerId:customerId
//                                                                                                       payment:payment
//                                                                                                      delegate:self];
//    paymentViewController.hideCreditCardButton = !self.acceptCreditCards;
//    
//    // Setting the languageOrLocale property is optional.
//    //
//    // If you do not set languageOrLocale, then the PayPalPaymentViewController will present
//    // its user interface according to the device's current language setting.
//    //
//    // Setting languageOrLocale to a particular language (e.g., @"es" for Spanish) or
//    // locale (e.g., @"es_MX" for Mexican Spanish) forces the PayPalPaymentViewController
//    // to use that language/locale.
//    //
//    // For full details, including a list of available languages and locales, see PayPalPaymentViewController.h.
//    paymentViewController.languageOrLocale = @"en";
//    
//    [self presentViewController:paymentViewController animated:YES completion:nil];

}
-(IBAction)paymentButtonsCLicked:(id)sender {
    switch ([sender tag]) {
        case 0:
            [self sendPaymentInformationtoServer:@"cheque"];
            break;
        case 1:
            [self sendPaymentInformationtoServer:@"cash"];
            break;
        case 2:
            [self sendPaymentInformationtoServer:@"credit_card"];
            break;
            
        default:
            break;
    }
}

-(void)sendPaymentInformationtoServer: (NSString*)type {
    [SVProgressHUD show];
    UserDTO*user=[[VSSharedManager sharedManager] currentUser];
    TicketInfoDTO* ticketInfo = [[VSSharedManager sharedManager] selectedTicketInfo];
    [[WebServiceManager sharedManager] paymentUpload:[NSString stringWithFormat:@"%d",user.masterKey] ticket_id:ticketInfo.ticketID comments:[self.customerTextView text] addiotnal_comments:[self.alertText text] imageData:UIImageJPEGRepresentation(self.signature, 0.5f) payment_type:type withCompletionHandler:^(id data,BOOL error){
        [SVProgressHUD dismiss];
        if (!error) {
            [self initWithPromptTitle:@"Success" message:@"Data uploaded to server"];
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
           
        }
        else
            [self initWithPromptTitle:@"Error" message:(NSString*)data];
        
    }];
}
@end
