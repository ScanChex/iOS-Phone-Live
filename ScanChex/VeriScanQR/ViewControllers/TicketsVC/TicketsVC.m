//
//  TicketsVC.m
//  VeriScanQR
//
//  Created by Adnan Ahmad on 22/12/2012.
//  Copyright (c) 2012 Adnan Ahmad. All rights reserved.
//

#import "TicketsVC.h"
#import "TicketCell.h"
#import "HomeVC.h"
#import "UserDTO.h"
#import "VSSharedManager.h"
#import "TicketInfoDTO.h"
#import "VSLocationManager.h"
#import "SVProgressHUD.h"
#import "WSUtils.h"
#import "ScanVC.h"
#import "RoutesViewController.h"
#import "SharedManager.h"
#import "MessageCentreVC.h"

@interface TicketsVC ()

@property(nonatomic,retain)NSString *messageString;

-(void)updateMessages;
-(void)updateUserLocation;
-(void)updateTickets;
-(void)updateMessagesFromServer;

@end

@implementation TicketsVC
@synthesize tickets=_tickets;
@synthesize messageString=_messageString;
@synthesize ticketData=_ticketData;
@synthesize timer=_timer;
@synthesize messagesArray=_messagesArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
+(id)initWithTickets{
    
    
    if (IS_IPHONE5)
    {
        return [[[TicketsVC alloc] initWithNibName:@"TicketsiPhone5VC" bundle:nil] autorelease];
    }
    
    return [[[TicketsVC alloc] initWithNibName:@"TicketsVC" bundle:nil] autorelease];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([[SharedManager getInstance] isMessage]) {
        [self.lblMessage setHidden:YES];
        [self.imgAlert setImage:[UIImage imageNamed:@"Chat.png"]];
    }
    else {
        [self.lblMessage setHidden:NO];
        [self.imgAlert setImage:nil];
    }
    [self updateTickets];
    [self updateMessagesFromServer];
}
- (void)viewDidLoad
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageNotification:) name:kPushReceived object:nil];
     [self.view setBackgroundColor:[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"color"]]];
    [super viewDidLoad];
    if ([[SharedManager getInstance] isMessage]) {
        [self.lblMessage setHidden:YES];
        [self.imgAlert setImage:[UIImage imageNamed:@"Chat.png"]];
    }
    else {
        [self.lblMessage setHidden:NO];
        [self.imgAlert setImage:nil];
         }
    // Do any additional setup after loading the view from its nib.
    
    
   // [[VSLocationManager sharedManager] startListening];
    [self performSelector:@selector(updateUserLocation) withObject:nil afterDelay:30];
    
    UIRefreshControl *refreshControl = [[[UIRefreshControl alloc] init] autorelease];
    refreshControl.tintColor = [UIColor lightGrayColor];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refresh Data"]; // I am not concentrating on the attributed string thing. This is just to show how the title would look like.
    [refreshControl addTarget:self action:@selector(refreshControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    [self.ticketsTable addSubview:refreshControl];

    
   // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserLocationNotification) name:UPDATE_LOCATION_NOTIFICATION object:nil];
    

}

//-(void)viewWillAppear:(BOOL)animated{
//
//    [super viewWillAppear:animated];
//    
//
//}

-(void)updateMessagesFromServer
{

    UserDTO*user=[[VSSharedManager sharedManager] currentUser];

    [[WebServiceManager sharedManager] updateMessages:[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"] masterkey:[NSString stringWithFormat:@"%d",user.masterKey] withCompletionHandler:^(id data ,BOOL error){
    
        if (!error) {
            
            if(data){
                
                self.messagesArray =[NSMutableArray arrayWithArray:(NSMutableArray *)data];
            }
        }
        [self updateMessages];
    }];
}


-(void) refreshControlValueChanged:(UIRefreshControl *) sender {
    
    sender.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing"];
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];

    [self.tickets removeAllObjects];
    UserDTO*user=[[VSSharedManager sharedManager] currentUser];
    
    [[WebServiceManager sharedManager] getTickets:[NSString stringWithFormat:@"%d",user.masterKey] fromDate:nil toDate:nil userName:[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"] withCompletionHandler:^(id data,BOOL error){
        
        [SVProgressHUD dismiss];
        
        if (!error) {
            
            // self.ticketData=(TicketDTO*)data;
            self.tickets=[NSMutableArray arrayWithArray:(NSMutableArray*)data];
            [self.ticketsTable reloadData];
            
        }
        else
        {
         
            [self initWithPromptTitle:@"Error" message:(NSString *)data];
        }
    
        NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
        [dateFormatter setDateStyle:NSDateFormatterShortStyle];
        [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
        
        sender.attributedTitle = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"Last updated: %@", [dateFormatter stringFromDate:[NSDate date]]]];
        
        [sender endRefreshing];
    }];

    
}

-(void)updateTickets{

    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
  
    [self.tickets removeAllObjects];
    UserDTO*user=[[VSSharedManager sharedManager] currentUser];
    
    [[WebServiceManager sharedManager] getTickets:[NSString stringWithFormat:@"%d",user.masterKey] fromDate:nil toDate:nil userName:[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"] withCompletionHandler:^(id data,BOOL error){
        
        [SVProgressHUD dismiss];
        
        if (!error) {
            
            // self.ticketData=(TicketDTO*)data;
            self.tickets=[NSMutableArray arrayWithArray:(NSMutableArray*)data];
            [self.ticketsTable reloadData];
        }
        else
            [self initWithPromptTitle:@"Error" message:(NSString *)data];
        
    }];


}

-(void)updateUserLocation{

    CLLocation *lasKnownLocation=[[VSLocationManager sharedManager] lastKnownLocation];
    UserDTO *user=[[VSSharedManager sharedManager] currentUser];
    
    [[WebServiceManager sharedManager] updateLocation:[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"]
                                            masterKey:[NSString stringWithFormat:@"%d", user.masterKey]
                                              assetId:[[VSLocationManager sharedManager] assetID]
                                           deviceMake:@"Apple"
                                          deviceModel:[[UIDevice currentDevice] platformString]
                                             deviceOS:[[UIDevice currentDevice] systemVersion]
                                             deviceID:[[[UIDevice currentDevice] identifierForVendor] UUIDString]
                                             latitude:[NSString stringWithFormat:@"%.7f",lasKnownLocation.coordinate.latitude]
                                            longitude:[NSString stringWithFormat:@"%.7f",lasKnownLocation.coordinate.longitude]
                                                speed:[NSString stringWithFormat:@"%.2f",lasKnownLocation.speed]
                                        batteryStatus:[NSString stringWithFormat:@"%.2f",[[UIDevice currentDevice] batteryLevel]]

                                withCompletionHandler:^(id data, BOOL error){
                                    
                                    if (!error) {
                                        
                                        DLog(@"%@",@"Location Updated");
                                    }else{
                                        
                                        DLog(@"%@",@"Failed");
                                    }
                                    
                                }];
}
-(void)updateMessages{
    
    
    self.messageString =@"";
    
    for (NSString *data in self.messagesArray) {
        
        if (!self.messageString)
            self.messageString=[NSString stringWithString:data];
        else
            self.messageString=[self.messageString stringByAppendingString:data];
        
        self.messageString=[self.messageString stringByAppendingString:@"\n"];
    }
    
    if ([self.messageString length]>0)
        self.messages.text=self.messageString;
    else{
    
        //self.messageLbl.hidden=YES;
        self.messageImage.hidden=YES;
        self.messages.text=@"No messages available";
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.tickets release];
    [_logo release];
    [_ticketsTable release];
    [_messages release];
    [_messageLbl release];
    [_messageImage release];
    [super dealloc];
}
- (void)viewDidUnload {
    
    self.tickets=nil;
    [self setLogo:nil];
    [self setTicketsTable:nil];
    [self setMessages:nil];
    [self setMessageLbl:nil];
    [self setMessageImage:nil];
    [super viewDidUnload];
}


#pragma mark- TableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return [self.tickets count]>0?[self.tickets count]:1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    if ([self.tickets count]==0)
        return 1;
    
    TicketDTO *ticket=[self.tickets objectAtIndex:section];
    NSMutableArray *ticketsData=[NSMutableArray arrayWithArray:ticket.tickets];
    return [ticketsData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([self.tickets count]>0) {
         
    
        TicketCell *cell=[TicketCell resuableCellForTableView:self.ticketsTable withOwner:self];
        cell.indexPath=indexPath;
        [cell updateCellWithTicket:[self.tickets objectAtIndex:indexPath.section]];
    
        [cell.callButton addTarget: self
                       action: @selector(callAccessoryButtonTapped:withEvent:)
             forControlEvents: UIControlEventTouchUpInside];
        
        [cell.scanButton addTarget: self
                            action: @selector(scanAccessoryButtonTapped:withEvent:)
                  forControlEvents: UIControlEventTouchUpInside];
        [cell.mapButton addTarget: self
                           action: @selector(accessoryButtonTapped:withEvent:)
                 forControlEvents: UIControlEventTouchUpInside];
        

        return cell;
    }else{
    
        static NSString *kCellIdentifier = @"MyIdentifier";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
        if (cell == nil)
        {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier] autorelease];
        }
        
        cell.textLabel.text = @"No ticket found";
        cell.textLabel.textColor=[UIColor whiteColor];
        return cell;
    }
 
    return nil;
}
- (void)accessoryButtonTapped: (UIControl *) button withEvent: (UIEvent *) event{
    
    
    NSIndexPath * indexPath = [self.ticketsTable indexPathForRowAtPoint: [[[event touchesForView: button] anyObject] locationInView: self.ticketsTable]];
    if ( indexPath == nil )
        return;
    
    [[VSSharedManager sharedManager] openMapWithLocation:[self.tickets objectAtIndex:indexPath.section]];
    
    /*
    
//    self.isCurrentLocation=NO;
    RoutesViewController * tempRoute = [[RoutesViewController alloc] initWithNibName:@"RoutesViewController" bundle:[NSBundle mainBundle]];
    tempRoute.tickets = self.tickets;
    tempRoute.currentSelectedTicket = indexPath.row;
    tempRoute.currentSelectedSection = indexPath.section;
    [self.navigationController pushViewController:tempRoute animated:YES];
     
     */
    
    //    TicketDTO *ticket=[self.tickets objectAtIndex:indexPath.section];
    //
    //
    //    CLLocation *currentLocation = [[VSLocationManager sharedManager] currentLocation];
    //
    //    // 1
    //    CLLocationCoordinate2D zoomLocation;
    //    zoomLocation.latitude = [ticket.latitude doubleValue];
    //    zoomLocation.longitude= [ticket.longitude doubleValue];
    //
    //
    //    // 2
    //    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 1.0*METERS_PER_MILE, 1.0*METERS_PER_MILE);
    //    // 3
    //    MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
    //    // 4
    //    [self.mapView setRegion:adjustedRegion animated:YES];
    //
    //    [self drawRoute:currentLocation.coordinate desitnation:zoomLocation];
}

- (void)callAccessoryButtonTapped: (UIControl *) button withEvent: (UIEvent *) event{
    
    NSIndexPath * indexPath = [self.ticketsTable indexPathForRowAtPoint: [[[event touchesForView: button] anyObject] locationInView: self.ticketsTable]];
    if ( indexPath == nil )
        return;
    
    TicketDTO *ticketDTO =[self.tickets objectAtIndex:indexPath.section];
    
    
    if ([ticketDTO.phoneNumber length] <= 0) {
        
        return;
    }
    
    NSString *telephoneString=[ticketDTO.phoneNumber stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSMutableString *phoneString=[[NSMutableString alloc] initWithString:telephoneString];
    [phoneString setString:[phoneString stringByReplacingOccurrencesOfString:@"(" withString:@""]];
    [phoneString setString:[phoneString stringByReplacingOccurrencesOfString:@")" withString:@""]];
    [phoneString setString:[phoneString stringByReplacingOccurrencesOfString:@"-" withString:@""]];
    [phoneString setString:[phoneString stringByReplacingOccurrencesOfString:@" " withString:@""]];
    telephoneString = [@"tel://" stringByAppendingString:phoneString];
    [phoneString release];
    
    DLog(@"Phone Number is %@",telephoneString);

    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telephoneString]];
}

- (void)scanAccessoryButtonTapped: (UIControl *) button withEvent: (UIEvent *) event{
    
 
    NSIndexPath * indexPath = [self.ticketsTable indexPathForRowAtPoint: [[[event touchesForView: button] anyObject] locationInView: self.ticketsTable]];
    if ( indexPath == nil )
        return;
    
    [[VSSharedManager sharedManager] setCurrentSelectedIndex:indexPath.row];
    [[VSSharedManager sharedManager] setCurrentSelectedSection:indexPath.section];
    if ([self.tickets count]>0) {
        
        [[VSSharedManager sharedManager]setSelectedTicket:[self.tickets objectAtIndex:indexPath.section]];
        TicketDTO *ticket=[self.tickets objectAtIndex:indexPath.section];
        NSMutableArray *array=[NSMutableArray arrayWithArray:ticket.tickets];
        TicketInfoDTO *ticketInfo =[array objectAtIndex:indexPath.row];
        
        
        
        if ([[ticketInfo.ticketStatus lowercaseString] isEqualToString:@"suspended"]){
            
            
            //+(NSString *)getStringFormCurrentDate
            
            [[VSSharedManager sharedManager] setSelectedTicketInfo:[array objectAtIndex:indexPath.row]];
            [self.navigationController pushViewController:[ScanVC initWithPreview] animated:YES];
            
        }
       else if ([[ticketInfo.ticketStatus lowercaseString] isEqualToString:@"complete"])
        {
            
//            [self initWithPromptTitle:@"Ticket Scanned already" message:@"You have finished this job already"];
            [[VSSharedManager sharedManager] setSelectedTicketInfo:[array objectAtIndex:indexPath.row]];
            [self.navigationController pushViewController:[ScanVC initWithhiddenScan] animated:YES];
            
//            return;
            
        }
        else
        {
         
        //For Testing Uncomment this
        /*
           [[VSSharedManager sharedManager] setSelectedTicketInfo:[array objectAtIndex:indexPath.row]];
           [self.navigationController pushViewController:[HomeVC initWithHome] animated:YES];
            return;
        */
            
            ////Check the tolerance factor
        
            if([ [ticketInfo.ticketStatus lowercaseString] isEqualToString:@"assigned"]){

                if ([ticketInfo.overDue isEqualToString:@"0"]) {
            
                    if ([ticket.tolerance integerValue] > 0) {
                    
                        
                        NSDate *serverDate =[WSUtils getDateFromString:ticketInfo.toleranceDate withFormat:@"dd-MM-yyyy HH:mm:ss"];
                        
                        /**
                         *	To Date conversion
                         */
                        
                        NSDate *currentDate = [NSDate date];
                        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                        [dateFormat setDateFormat:@"dd-MM-yyyy HH:mm:ss"];
                        NSString *dateString = [dateFormat stringFromDate:currentDate];                        
                        
                        NSDate *today =[WSUtils getDateFromString:dateString withFormat:@"dd-MM-yyyy HH:mm:ss"];
                        
                        int differenceInSeconds = 0;
                        differenceInSeconds = [WSUtils secondsBetweenThisDate:serverDate andDate:today];
                        
                        ///If current date difference from server date is greater then 0 that means ticket is overdue
                        int currentDateDifference =0;
                        currentDateDifference = [WSUtils secondsBetweenThisDate:currentDate andDate:serverDate];
                        
                        if (currentDateDifference > 0) {
                            
                            [[VSSharedManager sharedManager] setSelectedTicketInfo:[array objectAtIndex:indexPath.row]];
                            [self.navigationController pushViewController:[ScanVC initWithPreview] animated:YES];
//                            [self.navigationController pushViewController:[HomeVC initWithHome] animated:YES];
                            
                        }
                       else if ((-differenceInSeconds >= -[ticket.tolerance integerValue]) || (differenceInSeconds <= [ticket.tolerance integerValue]))//Check the Tolerance factor here
                       {
                            [[VSSharedManager sharedManager] setSelectedTicketInfo:[array objectAtIndex:indexPath.row]];
                           [self.navigationController pushViewController:[ScanVC initWithPreview]  animated:YES];
//                            [self.navigationController pushViewController:[HomeVC initWithHome] animated:YES];

                        }
                        else
                        {
                            [self initWithPromptTitle:@"Scan Warning" message:@"Ticket Not Yet Due"];
                            [[VSSharedManager sharedManager] setSelectedTicketInfo:[array objectAtIndex:indexPath.row]];
                            [self.navigationController pushViewController:[ScanVC initWithhiddenScan]  animated:YES];
                        }
                    }
                    else{
                    
                        NSDate *serverDate =[WSUtils getDateFromString:ticketInfo.toleranceDate withFormat:@"dd-MM-yyyy HH:mm:ss"];
                        
                        serverDate = [WSUtils dateByAddingSystemTimeZoneToDate:serverDate];
                        NSDate *currentDate = [NSDate date];
                        
                        int differenceInSeconds = 0;
                        differenceInSeconds = [WSUtils secondsBetweenThisDate:serverDate andDate:currentDate];
                     
                        int currentDateDifference =0;
                        
                        currentDateDifference = [WSUtils secondsBetweenThisDate:currentDate andDate:serverDate];
                        
                        if (differenceInSeconds==0) {
                            
                            [[VSSharedManager sharedManager] setSelectedTicketInfo:[array objectAtIndex:indexPath.row]];
                            [self.navigationController pushViewController:[ScanVC initWithPreview] animated:YES];
//                            [self.navigationController pushViewController:[HomeVC initWithHome] animated:YES];

                        }
                        else
                        {
                            if (currentDateDifference > 0) {
                                
                                [[VSSharedManager sharedManager] setSelectedTicketInfo:[array objectAtIndex:indexPath.row]];
                                [self.navigationController pushViewController:[ScanVC initWithPreview]  animated:YES];
//                                [self.navigationController pushViewController:[HomeVC initWithHome] animated:YES];
                                
                            }
                            else
                            {
                                [self initWithPromptTitle:@"Scan Warning" message:@"Please scan ticket on time"];
                                [[VSSharedManager sharedManager] setSelectedTicketInfo:[array objectAtIndex:indexPath.row]];
                                [self.navigationController pushViewController:[ScanVC initWithhiddenScan] animated:YES];
                                
                            }
                        }
                    }

                }
                else{
                
                    [[VSSharedManager sharedManager] setSelectedTicketInfo:[array objectAtIndex:indexPath.row]];
                    [self.navigationController pushViewController:[ScanVC initWithPreview] animated:YES];
//                    [self.navigationController pushViewController:[HomeVC initWithHome] animated:YES];

                }
            }
            else
            {
                
                [[VSSharedManager sharedManager] setSelectedTicketInfo:[array objectAtIndex:indexPath.row]];
                [self.navigationController pushViewController:[ScanVC initWithPreview] animated:YES];
//                [self.navigationController pushViewController:[HomeVC initWithHome] animated:YES];
                
            }
        }
    }

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.ticketsTable deselectRowAtIndexPath:indexPath animated:YES];

}
- (IBAction)logoutButtonPressed:(id)sender {
    
    [self.timer invalidate];
    //[[VSLocationManager sharedManager] stopListening];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)messageNotification:(NSNotification*)notif {
    [self.lblMessage setHidden:YES];
    [self.imgAlert setImage:[UIImage imageNamed:@"Chat.png"]];
}
- (IBAction)messageButtonPressed:(id)sender {
    [[SharedManager getInstance] setIsMessage:FALSE];
    [self.imgAlert setImage:nil];
    [self.lblMessage setHidden:NO];
    
    [self.navigationController pushViewController:[MessageCentreVC initWithMessageCentre] animated:YES];
}
@end
