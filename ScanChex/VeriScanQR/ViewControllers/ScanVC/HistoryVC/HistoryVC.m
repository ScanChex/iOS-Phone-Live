//
//  HistoryVC.m
//  VeriScanQR
//
//  Created by Adnan Ahmad on 24/12/2012.
//  Copyright (c) 2012 Adnan Ahmad. All rights reserved.
//

#import "HistoryVC.h"
#import "VSSharedManager.h"
#import "TicketDTO.h"
#import "WebServiceManager.h"
#import "HistoryDTO.h"
#import "HistoryCell.h"
#import "SVProgressHUD.h"
#import "UserDTO.h"
#import "TicketInfoDTO.h"
@interface HistoryVC ()

-(void)updateGUI;
-(void)updateHeader;

@end

@implementation HistoryVC

@synthesize historyArray=_historyArray;

@synthesize delegate=_delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        // Custom initialization
    }
    return self;
}

+(id)initWithHistory{

    if (IS_IPHONE5) {
     
        return [[[HistoryVC alloc] initWithNibName:@"HistoryiPhone5VC" bundle:nil] autorelease];
    }
    return [[[HistoryVC alloc] initWithNibName:@"HistoryVC" bundle:nil] autorelease];
}

- (void)viewDidLoad
{
     [self.view setBackgroundColor:[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"color"]]];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self updateGUI];
  
}
-(void)viewWillAppear:(BOOL)animated {
    [self getHistory];
    [self updateGUI];
}

-(void)getHistory{

    //[SVProgressHUD show];
    
    TicketDTO *ticketAsset =[[VSSharedManager sharedManager] selectedTicket];

    UserDTO *user=[[VSSharedManager sharedManager] currentUser];
    //TicketInfoDTO *ticket=[[VSSharedManager sharedManager] selectedTicketInfo];
    //show_history','master_key'=>136,'tbl_ticket_id'=>1
   
    [[WebServiceManager sharedManager] showHistory:[NSString stringWithFormat:@"%d",user.masterKey] ticketID:ticketAsset.assetID withCompletionHandler:^(id data, BOOL error){
        
      //  [SVProgressHUD dismiss];
        if (!error) {
            
            [self.historyArray removeAllObjects];
            self.historyArray=[NSMutableArray arrayWithArray:(NSMutableArray*)data];
            [self updateHeader];
            [self.historyTable reloadData];
            
        }
        else
            [self initWithPromptTitle:@"Error" message:(NSString *)data];
        
    }];
}


-(void)updateHeader{

    HistoryDTO *history;
    if ([self.historyArray count]>0)
    {
        history=[self.historyArray objectAtIndex:0];
        self.model.text=history.model;
        TicketInfoDTO * tempTicketInfo = [[VSSharedManager sharedManager] selectedTicketInfo];
//        [self.ticketNoLabel setText:tempTicketInfo.ticketID];
        self.serial.text=tempTicketInfo.ticketID;
        self.technician.text=history.last_serviced_by;
        self.name.text=history.asset_description;
        self.installed.text=history.date_in_service;
        self.lastservicedLabel.text = history.last_service_date;
    }
}
-(void)updateGUI{
    
    TicketDTO *ticket =[[VSSharedManager sharedManager] selectedTicket];
    self.assetID.text=ticket.unEncryptedAssetID;
 
    TicketAddressDTO *address1 =ticket.address1;
    TicketAddressDTO *address2 =ticket.address2;
    
    self.address.text =[NSString stringWithFormat:@"%@ \n%@, %@ %@ \n",address1.street,address1.city,address1.state,address1.postalCode];
    
    if (address2) {
        
        self.address.text=[self.address.text stringByAppendingString:[NSString stringWithFormat:@"%@ \n%@, %@ %@ \n",address2.street,address2.city,address2.state,address2.postalCode]];
    }
    self.assetDescription.text=[NSString stringWithFormat:@"%@",ticket.description];
}


#pragma TableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
        
    return [self.historyArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    HistoryCell *cell=[HistoryCell resuableCellForTableView:self.historyTable withOwner:self];
    
    [cell updateCellWithTicket:[self.historyArray objectAtIndex:indexPath.row]];
    
    //accesory view
    [cell.notes addTarget: self
                     action: @selector(notesAccessoryButtonTapped:withEvent:)
           forControlEvents: UIControlEventTouchUpInside];
    [cell.voice addTarget: self
                   action: @selector(voiceAccessoryButtonTapped:withEvent:)
         forControlEvents: UIControlEventTouchUpInside];
    [cell.video addTarget: self
                   action: @selector(videoAccessoryButtonTapped:withEvent:)
         forControlEvents: UIControlEventTouchUpInside];

    [cell.image addTarget: self
                   action: @selector(imageAccessoryButtonTapped:withEvent:)
         forControlEvents: UIControlEventTouchUpInside];

    
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row%2==1) {
        
        cell.backgroundColor = [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:226.0f/255.0f alpha:255.0f];
//        cell.backgroundColor = [UIColor lightGrayColor];
    }
    else {
         cell.backgroundColor = [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:255.0f];
//        cell.backgroundColor = [UIColor whiteColor];
    }
    
}
- (void)notesAccessoryButtonTapped: (UIControl *) button withEvent: (UIEvent *) event{
//    if (![[VSSharedManager sharedManager] isPreview]) {
        NSIndexPath * indexPath = [self.historyTable indexPathForRowAtPoint: [[[event touchesForView: button] anyObject] locationInView: self.historyTable]];
        if ( indexPath == nil )
            return;
        
        if ([self.delegate respondsToSelector:@selector(showNotes:)]) {
            HistoryDTO *historyData=[self.historyArray objectAtIndex:indexPath.row];
            [self.delegate showNotes:historyData.notes];
        }
//    }
    
    
    
}

- (void)voiceAccessoryButtonTapped: (UIControl *) button withEvent: (UIEvent *) event{
//    if (![[VSSharedManager sharedManager] isPreview]) {
    NSIndexPath * indexPath = [self.historyTable indexPathForRowAtPoint: [[[event touchesForView: button] anyObject] locationInView: self.historyTable]];
    if ( indexPath == nil )
        return;
    
    if ([self.delegate respondsToSelector:@selector(downloadAudioWithURL:)]) {
        HistoryDTO *historyData=[self.historyArray objectAtIndex:indexPath.row];
        [self.delegate downloadAudioWithURL:historyData.voice];
    }
//    }
}
- (void)videoAccessoryButtonTapped: (UIControl *) button withEvent: (UIEvent *) event{
//    if (![[VSSharedManager sharedManager] isPreview]) {
    NSIndexPath * indexPath = [self.historyTable indexPathForRowAtPoint: [[[event touchesForView: button] anyObject] locationInView: self.historyTable]];
    if ( indexPath == nil )
        return;
    
    if ([self.delegate respondsToSelector:@selector(downloadVideoWithURL:)]) {
        HistoryDTO *historyData=[self.historyArray objectAtIndex:indexPath.row];
        [self.delegate downloadVideoWithURL:historyData.video];
    }
//    }
}

- (void)imageAccessoryButtonTapped: (UIControl *) button withEvent: (UIEvent *) event{
//    if (![[VSSharedManager sharedManager] isPreview]) {
    NSIndexPath * indexPath = [self.historyTable indexPathForRowAtPoint: [[[event touchesForView: button] anyObject] locationInView: self.historyTable]];
    if ( indexPath == nil )
        return;
    
    if ([self.delegate respondsToSelector:@selector(downloadImageWithURL:)]) {
        HistoryDTO *historyData=[self.historyArray objectAtIndex:indexPath.row];
        [self.delegate downloadImageWithURL:historyData.imgURL];
    }
//    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
    [_model release];
    [_serial release];
    [_installed release];
    [_technician release];
    [_historyTable release];
    [_assetID release];
    [_address release];
    [_totalCodes release];
    [_scannedCodes release];
    [_remainingCodes release];
    [_name release];
    [_assetDescription release];
    [_assetImage release];
    
    [super dealloc];
}
- (void)viewDidUnload {
    
    [self setModel:nil];
    [self setSerial:nil];
    [self setInstalled:nil];
    [self setTechnician:nil];
    [self setHistoryTable:nil];
    [self setAssetID:nil];
    [self setAddress:nil];
    [self setTotalCodes:nil];
    [self setScannedCodes:nil];
    [self setRemainingCodes:nil];
    [self setName:nil];
    [self setAssetDescription:nil];
    [super viewDidUnload];
}
@end
