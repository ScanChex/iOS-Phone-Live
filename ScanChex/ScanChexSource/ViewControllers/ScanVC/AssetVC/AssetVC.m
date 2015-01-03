//
//  AssetVC.m
//  VeriScanQR
//
//  Created by Adnan Ahmad on 24/12/2012.
//  Copyright (c) 2012 Adnan Ahmad. All rights reserved.
//

#import "AssetVC.h"
#import "TicketDTO.h"
#import "VSSharedManager.h"
#import "WebServiceManager.h"
#import "ExtraTicketInfoDTO.h"
#import "ServiceDTO.h"
#import "ServiceCell.h"
#import "CheckPointCell.h"
#import "CheckPointDTO.h"
#import <QuartzCore/QuartzCore.h>

#define kOFFSET_FOR_Label 5.0

@interface AssetVC ()
{
    float nextY;
}
@property(nonatomic,retain) ExtraTicketInfoDTO *extraTicketInfo;
-(void)updateAsset;
-(void)updateExtraTicketInformation;

@end

@implementation AssetVC

@synthesize extraTicketInfo=_extraTicketInfo;
@synthesize delegate=_delegate;
@synthesize checkpointCheckArray = _checkpointCheckArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.isAssetScan = FALSE;
        self.checkpointCheckArray = [NSMutableArray array];
        for (int i = 0; i<[[[[VSSharedManager sharedManager] selectedTicket] checkPoints] count]; i++) {
            [self.checkpointCheckArray addObject:[NSString stringWithFormat:@"%@",[NSNumber numberWithBool:TRUE]]];
        }
        // Custom initialization
    }
    return self;
}

+(id)initWithAsset{

    if (IS_IPHONE5) {
   
        
        return [[AssetVC alloc] initWithNibName:@"AssetiPhone5VC" bundle:nil] ;
    }
    
    return [[AssetVC alloc] initWithNibName:@"AssetVC" bundle:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

     [self.view setBackgroundColor:[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"color"]]];
    // Do any additional setup after loading the view from its nib.
    self.scannedImage.layer.masksToBounds = YES;
    //imageView.layer.cornerRadius = 5.0;
    self.scannedImage.layer.borderWidth=3.0;
    self.scannedImage.layer.borderColor=[UIColor lightGrayColor].CGColor;
    [self.scannedImage setImage:[UIImage imageNamed:@"Photo_not_available.jpg"]];
//    [self.timeView.layer setCornerRadius:15.0f];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCode:) name:K_Update_ScanCode object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelTab:) name:K_Update_ScanCode_CANCEL object:nil];
    [self updateAsset];
    [self.serviceTable setBackgroundColor:[UIColor clearColor]];
}

-(void)updateAsset{

    TicketDTO *ticket =[[VSSharedManager sharedManager] selectedTicket];
           
    self.assetID.text=ticket.unEncryptedAssetID;
    
    TicketAddressDTO *address1 =ticket.address1;
    TicketAddressDTO *address2 =ticket.address2;
    
    self.address.text =[NSString stringWithFormat:@"%@ \n%@, %@ %@ \n",address1.street,address1.city,address1.state,address1.postalCode];
    
    if (address2) {
        
        self.address.text=[self.address.text stringByAppendingString:[NSString stringWithFormat:@"%@ \n%@, %@ %@ \n",address2.street,address2.city,address2.state,address2.postalCode]];
    }

    
    self.totalCodes.text=[NSString stringWithFormat:@"%@", ticket.totalCodes];
    self.remaining.text=[NSString stringWithFormat:@"%@",ticket.remainingCodes];
    self.scannedCodes.text=[NSString stringWithFormat:@"%@",ticket.scannedCodes];
    self.assetDescription.text =[NSString stringWithFormat:@"%@",ticket.description];
    
    
    if (![ticket.assetPhoto isKindOfClass:[NSNull class]])
    {
        [self.scannedImage setImage:[UIImage imageNamed:@"Photo_not_available.jpg"]];
        NSString * tempStrin = ticket.assetPhoto;
        tempStrin = [tempStrin stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        [self.scannedImage setImageURL:[NSURL URLWithString:tempStrin]];
        [tempStrin release];
    }
    [self updateExtraTicketInformation];
       
}

-(void)updateExtraTicketInformation{

    UserDTO*user =[[VSSharedManager sharedManager] currentUser];
    TicketInfoDTO *ticketInfo = [[VSSharedManager sharedManager] selectedTicketInfo];
    [self.timeInLabel setText:ticketInfo.ticket_start_time];
    [self.totalTimeLabel setText:ticketInfo.ticket_total_time];
    [self.timeCompletedLabel setText:ticketInfo.ticket_end_time];
    [[WebServiceManager sharedManager] getTicketServices:[NSString stringWithFormat:@"%d", user.masterKey] ticketID:ticketInfo.tblTicketID withCompletionHandler:^(id data ,BOOL error){
        
        if (!error) {
            
            self.extraTicketInfo =(ExtraTicketInfoDTO*)data;
            [self.serviceTable reloadData];
        }
        
    }];
    

}

#pragma TableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 42.0f;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section ==0) {
        return self.serviceHeader;
    }
    else {
        return self.checkpointHeader;
    }
}
//-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    if (section ==0) {
//        return @"SERVICES";
//    }
//    else {
//        return @"CHECKPOINTS";
//    }
//}

//-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    UILabel * tempLabel  = [[UILabel alloc]init];
//    [tempLabel setFont:[UIFont systemFontOfSize:11.0f]];
//    if (section ==0) {
//        [tempLabel setText:@"SERVICES"];
//        return tempLabel;
//    }
//    else {
//        [tempLabel setText:@"CHECKPOINTS"];
//        return tempLabel;
//    }
//}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        if ([self.extraTicketInfo.serviceList count]>0) {
            
            return [self.extraTicketInfo.serviceList count];
        }
        
        return 1;
    }
    else {
//        TicketDTO *ticketDTO = [[VSSharedManager sharedManager] selectedTicket];
        return [[[[VSSharedManager sharedManager] selectedTicket] checkPoints] count];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    if (indexPath.section == 0) {
        if ([self.extraTicketInfo.serviceList count]>0) {
            
            
            ServiceCell *cell=[ServiceCell resuableCellForTableView:self.serviceTable withOwner:self];
            [cell updateCellWithServices:[self.extraTicketInfo.serviceList objectAtIndex:indexPath.row]];
            //accesory view
            [cell.checkButton addTarget: self
                                 action: @selector(serviceAccessoryButtonTapped:withEvent:)
                       forControlEvents: UIControlEventTouchUpInside];
            [cell.contentView setBackgroundColor:[UIColor clearColor]];
            
            return cell;
        }
        else
        {
            
            static NSString *CellIdentifier = @"service";
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
            }
            
            cell.textLabel.text=@"NO SERVICE REQUIRED";
            cell.textLabel.textAlignment=NSTextAlignmentCenter;
            cell.textLabel.textColor=[UIColor lightGrayColor];
            [cell.textLabel setFont:[UIFont fontWithName:@"Helvetica" size:12.0f]];
            [cell.contentView setBackgroundColor:[UIColor clearColor]];
            [cell setBackgroundColor:[UIColor clearColor]];
            
            return cell;
            
        }
        
    }
    else {
        CheckPointCell * cell = [CheckPointCell resuableCellForTableView:self.serviceTable withOwner:self];
        [cell updateCellWithMessage:[[[[VSSharedManager sharedManager] selectedTicket] checkPoints] objectAtIndex:indexPath.row] :[self.checkpointCheckArray objectAtIndex:indexPath.row]];
        [cell.scanButton setTag:indexPath.row];
        [cell.scanButton addTarget:self action:@selector(checkPOintAccessoryButtonTapped:withEvent:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView setBackgroundColor:[UIColor clearColor]];
        [cell.descriptionTextView setBackgroundColor:[UIColor clearColor]];
        [cell.descriptionTextView setTextColor:[UIColor whiteColor]];
        return cell;
        
    }
    

    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (![[VSSharedManager sharedManager] isPreview]) {
    if ([self.delegate respondsToSelector:@selector(partButtonPressed:)]) {
        
        [self.delegate partButtonPressed:[self.extraTicketInfo.serviceList objectAtIndex:indexPath.row]];
    }
    }
}
- (void)serviceAccessoryButtonTapped: (UIControl *) button withEvent: (UIEvent *) event{
    if (![[VSSharedManager sharedManager] isPreview]) {
        NSIndexPath * indexPath = [self.serviceTable indexPathForRowAtPoint: [[[event touchesForView: button] anyObject] locationInView: self.serviceTable]];
        if ( indexPath == nil )
            return;
        
        
        ServiceDTO *service =[self.extraTicketInfo.serviceList objectAtIndex:indexPath.row];
        
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
        
        NSString *status = @"0";
        
        if ([service.checkStatus isEqualToString:@"0"]) {
            
            status = @"1";
        }
        
        
        [[WebServiceManager sharedManager] updateServiceStatus:service.ticketServiceID status:status withCompletionHandler:^(id data, BOOL error){
            
            [SVProgressHUD dismiss];
            
            if (!error) {
                
                [self updateExtraTicketInformation];
                
                DLog(@"Successfully Update ");
            }
            else
            {
                
                DLog(@"Error");
                
            }
            
        }];
    }
    
    
}
- (void)checkPOintAccessoryButtonTapped: (UIControl *) button withEvent: (UIEvent *) event{
    if (![[VSSharedManager sharedManager] isPreview]) {
        NSIndexPath * indexPath = [self.serviceTable indexPathForRowAtPoint: [[[event touchesForView: button] anyObject] locationInView: self.serviceTable]];
        if ( indexPath == nil )
            return;
        self.isAssetScan = TRUE;
        self.currentPressedScanTag = indexPath.row;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"assetScan" object:nil];
    }
   
//    self.scanCVPointer.scanQRManager = [[ScanQRManager alloc] init];
////    _scanQRManager = [[ScanQRManager alloc] init];
//    [self.scanCVPointer.view addSubview:self.scanQRManager.view];
//    [self.scanCVPointer.scanQRManager showQrScanner];
    
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//    if (indexPath.row%2==1) {
//        
//        cell.backgroundColor = [UIColor lightGrayColor];
//    }
//    else {
//        cell.backgroundColor = [UIColor whiteColor];
//    }
//    
//}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section ==0) {
        return 58.0f;
    }
    else {
        return 72.0f;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self setDelegate:nil];
}

@end
