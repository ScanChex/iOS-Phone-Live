//
//  CheckOutTodayViewController.m
//  ScanChex
//
//  Created by Ravi Kumar Bandaru on 10/24/14.
//  Copyright (c) 2014 Adnan Ahmad. All rights reserved.
//

#import "CheckOutTodayViewController.h"
#import "AsyncImageView.h"
#import "SharedManager.h"
#import "WebServiceManager.h"
#import "TicketCell.h"
#import "CheckInStepOneViewController.h"

@interface CheckOutTodayViewController ()

@end

@implementation CheckOutTodayViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}
+(id)initWithTickets{
  
  
  
  return [[[CheckOutTodayViewController alloc] initWithNibName:@"CheckOutTodayViewController" bundle:nil] autorelease];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self updateTickets];
  // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}
-(void)updateTickets{
  
  [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
  
  [self.tickets removeAllObjects];
  UserDTO*user=[[VSSharedManager sharedManager] currentUser];
  [[WebServiceManager sharedManager] checkoutCheckInTicketsWithMasterKey:[NSString stringWithFormat:@"%d",user.masterKey] userName:[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"] today:@"YES"  withCompletionHandler:^(id data,BOOL error){
    
    [SVProgressHUD dismiss];
    
    if (!error) {
      
      // self.ticketData=(TicketDTO*)data;
      NSMutableArray *alltickets =[NSMutableArray arrayWithArray:(NSMutableArray*)data];
      
      for (int i=0; i< alltickets.count;i++) {
        // do something with object
        TicketDTO *ticket=[alltickets objectAtIndex:i];
        for (int j=0;j < ticket.tickets.count;j++){
        TicketInfoDTO *info=[ticket.tickets objectAtIndex:j];
        if ([info.ticket_type isEqualToString:@"check_in"]) {
          [ticket.tickets removeObjectAtIndex:j];
        }
        }
        
        
      }
      self.tickets = alltickets;
      
     // self.tickets=[NSMutableArray arrayWithArray:(NSMutableArray*)data];
      [self.ticketsTable reloadData];
    }
    else {
      
    }
    //            [self initWithPromptTitle:@"Error" message:(NSString *)data];
    
  }];
  
  
}

#pragma mark Button Pressed Events
- (IBAction)backButtonPressed:(id)sender {
  
  [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark- TableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  
  return [self.tickets count]>0?[self.tickets count]:1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  
  
  if ([self.tickets count]==0)
    return 1;
  
  TicketDTO *ticket=[self.tickets objectAtIndex:section];
 if (!(ticket.tickets == (id)[NSNull null] || [ticket.tickets count]==0)){
  NSMutableArray *ticketsData=[NSMutableArray arrayWithArray:ticket.tickets];
    if ( [ticketsData count] == 0) {
    return 1;
  } else {
    return [ticketsData count];
  }
} else {
  return 1;
}



}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
  if ([self.tickets count]>0) {
    
    
    TicketCell *cell=[TicketCell resuableCellForTableViewCheckIn:self.ticketsTable withOwner:self];
    cell.indexPath=indexPath;
    
    [cell updateCellWithCheckTicket:[self.tickets objectAtIndex:indexPath.section]];
    
    //        [cell.callButton addTarget: self
    //                            action: @selector(callAccessoryButtonTapped:withEvent:)
    //                  forControlEvents: UIControlEventTouchUpInside];
    [cell.scanButton addTarget: self
                        action: @selector(scanAccessoryButtonTapped:withEvent:)
              forControlEvents: UIControlEventTouchUpInside];
    //        [cell.mapButton addTarget: self
    //                           action: @selector(accessoryButtonTapped:withEvent:)
    //                 forControlEvents: UIControlEventTouchUpInside];
    
    
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
  
  //
  //    NSIndexPath * indexPath = [self.ticketsTable indexPathForRowAtPoint: [[[event touchesForView: button] anyObject] locationInView: self.ticketsTable]];
  //    if ( indexPath == nil )
  //        return;
  //
  //
  //
  //
  //    //    self.isCurrentLocation=NO;
  //    RoutesViewController * tempRoute = [[RoutesViewController alloc] initWithNibName:@"RoutesViewController" bundle:[NSBundle mainBundle]];
  //    tempRoute.tickets = self.tickets;
  //    tempRoute.currentSelectedTicket = indexPath.row;
  //    tempRoute.currentSelectedSection = indexPath.section;
  //    [self.navigationController pushViewController:tempRoute animated:YES];
  //
  //    //    TicketDTO *ticket=[self.tickets objectAtIndex:indexPath.section];
  //    //
  //    //
  //    //    CLLocation *currentLocation = [[VSLocationManager sharedManager] currentLocation];
  //    //
  //    //    // 1
  //    //    CLLocationCoordinate2D zoomLocation;
  //    //    zoomLocation.latitude = [ticket.latitude doubleValue];
  //    //    zoomLocation.longitude= [ticket.longitude doubleValue];
  //    //
  //    //
  //    //    // 2
  //    //    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 1.0*METERS_PER_MILE, 1.0*METERS_PER_MILE);
  //    //    // 3
  //    //    MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
  //    //    // 4
  //    //    [self.mapView setRegion:adjustedRegion animated:YES];
  //    //
  //    //    [self drawRoute:currentLocation.coordinate desitnation:zoomLocation];
}

- (void)callAccessoryButtonTapped: (UIControl *) button withEvent: (UIEvent *) event{
  
  //    NSIndexPath * indexPath = [self.ticketsTable indexPathForRowAtPoint: [[[event touchesForView: button] anyObject] locationInView: self.ticketsTable]];
  //    if ( indexPath == nil )
  //        return;
  //
  //    TicketDTO *ticketDTO =[self.tickets objectAtIndex:indexPath.section];
  //
  //
  //    if ([ticketDTO.phoneNumber length] <= 0) {
  //
  //        return;
  //    }
  //
  //    NSString *telephoneString=[ticketDTO.phoneNumber stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
  //
  //    NSMutableString *phoneString=[[NSMutableString alloc] initWithString:telephoneString];
  //    [phoneString setString:[phoneString stringByReplacingOccurrencesOfString:@"(" withString:@""]];
  //    [phoneString setString:[phoneString stringByReplacingOccurrencesOfString:@")" withString:@""]];
  //    [phoneString setString:[phoneString stringByReplacingOccurrencesOfString:@"-" withString:@""]];
  //    [phoneString setString:[phoneString stringByReplacingOccurrencesOfString:@" " withString:@""]];
  //    telephoneString = [@"tel://" stringByAppendingString:phoneString];
  //    [phoneString release];
  //
  //    DLog(@"Phone Number is %@",telephoneString);
  //
  //    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telephoneString]];
}

- (void)scanAccessoryButtonTapped: (UIControl *) button withEvent: (UIEvent *) event{
  
  
  NSIndexPath * indexPath = [self.ticketsTable indexPathForRowAtPoint: [[[event touchesForView: button] anyObject] locationInView: self.ticketsTable]];
  if ( indexPath == nil )
    return;
  //
  [[VSSharedManager sharedManager] setCurrentSelectedIndex:indexPath.row];
  [[VSSharedManager sharedManager] setCurrentSelectedSection:indexPath.section];
  //    if ([self.tickets count]>0) {
  //
  [[VSSharedManager sharedManager]setSelectedTicket:[self.tickets objectAtIndex:indexPath.section]];
  [self.navigationController pushViewController:[CheckInStepOneViewController initWithData:nil assetData:nil selectedAsset:nil] animated:YES];
  //        TicketDTO *ticket=[self.tickets objectAtIndex:indexPath.section];
  //        NSMutableArray *array=[NSMutableArray arrayWithArray:ticket.tickets];
  //        TicketInfoDTO *ticketInfo =[array objectAtIndex:indexPath.row];
  //
  //        if ([[ticketInfo.ticketStatus lowercaseString] isEqualToString:@"complete"])
  //        {
  //
  //            //            [self initWithPromptTitle:@"Ticket Scanned already" message:@"You have finished this job already"];
  //            [[VSSharedManager sharedManager] setSelectedTicketInfo:[array objectAtIndex:indexPath.row]];
  //            [self.navigationController pushViewController:[[ScanVC initWithhiddenScan] autorelease] animated:YES];
  //
  //            //            return;
  //
  //        }
  //        else
  //        {
  //
  //            //For Testing Uncomment this
  //            /*
  //             [[VSSharedManager sharedManager] setSelectedTicketInfo:[array objectAtIndex:indexPath.row]];
  //             [self.navigationController pushViewController:[HomeVC initWithHome] animated:YES];
  //             return;
  //             */
  //
  //            ////Check the tolerance factor
  //
  //            if([ [ticketInfo.ticketStatus lowercaseString] isEqualToString:@"assigned"]){
  //
  //                if ([ticketInfo.overDue isEqualToString:@"0"]) {
  //
  //                    if ([ticket.tolerance integerValue] > 0) {
  //
  //
  //                        NSDate *serverDate =[WSUtils getDateFromString:ticketInfo.toleranceDate withFormat:@"dd-MM-yyyy HH:mm:ss"];
  //
  //                        /**
  //                         *	To Date conversion
  //                         */
  //
  //                        NSDate *currentDate = [NSDate date];
  //                        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
  //                        [dateFormat setDateFormat:@"dd-MM-yyyy HH:mm:ss"];
  //                        NSString *dateString = [dateFormat stringFromDate:currentDate];
  //
  //                        NSDate *today =[WSUtils getDateFromString:dateString withFormat:@"dd-MM-yyyy HH:mm:ss"];
  //
  //                        int differenceInSeconds = 0;
  //                        differenceInSeconds = [WSUtils secondsBetweenThisDate:serverDate andDate:today];
  //
  //                        ///If current date difference from server date is greater then 0 that means ticket is overdue
  //                        int currentDateDifference =0;
  //                        currentDateDifference = [WSUtils secondsBetweenThisDate:currentDate andDate:serverDate];
  //
  //                        if (currentDateDifference > 0) {
  //
  //                            [[VSSharedManager sharedManager] setSelectedTicketInfo:[array objectAtIndex:indexPath.row]];
  //                            [self.navigationController pushViewController:[[ScanVC initWithPreview] autorelease] animated:YES];
  //                            //                            [self.navigationController pushViewController:[HomeVC initWithHome] animated:YES];
  //
  //                        }
  //                        else if ((-differenceInSeconds >= -[ticket.tolerance integerValue]) || (differenceInSeconds <= [ticket.tolerance integerValue]))//Check the Tolerance factor here
  //                        {
  //                            [[VSSharedManager sharedManager] setSelectedTicketInfo:[array objectAtIndex:indexPath.row]];
  //                            [self.navigationController pushViewController:[[ScanVC initWithPreview] autorelease] animated:YES];
  //                            //                            [self.navigationController pushViewController:[HomeVC initWithHome] animated:YES];
  //
  //                        }
  //                        else
  //                        {
  //                            //                            [self initWithPromptTitle:@"Scan Warning" message:@"Ticket Not Yet Due"];
  //                            [[VSSharedManager sharedManager] setSelectedTicketInfo:[array objectAtIndex:indexPath.row]];
  //                            [self.navigationController pushViewController:[[ScanVC initWithhiddenScan] autorelease] animated:YES];
  //                        }
  //                    }
  //                    else{
  //
  //                        NSDate *serverDate =[WSUtils getDateFromString:ticketInfo.toleranceDate withFormat:@"dd-MM-yyyy HH:mm:ss"];
  //
  //                        serverDate = [WSUtils dateByAddingSystemTimeZoneToDate:serverDate];
  //                        NSDate *currentDate = [NSDate date];
  //
  //                        int differenceInSeconds = 0;
  //                        differenceInSeconds = [WSUtils secondsBetweenThisDate:serverDate andDate:currentDate];
  //
  //                        int currentDateDifference =0;
  //
  //                        currentDateDifference = [WSUtils secondsBetweenThisDate:currentDate andDate:serverDate];
  //
  //                        if (differenceInSeconds==0) {
  //
  //                            [[VSSharedManager sharedManager] setSelectedTicketInfo:[array objectAtIndex:indexPath.row]];
  //                            [self.navigationController pushViewController:[[ScanVC initWithPreview] autorelease] animated:YES];
  //                            //                            [self.navigationController pushViewController:[HomeVC initWithHome] animated:YES];
  //
  //                        }
  //                        else
  //                        {
  //                            if (currentDateDifference > 0) {
  //
  //                                [[VSSharedManager sharedManager] setSelectedTicketInfo:[array objectAtIndex:indexPath.row]];
  //                                [self.navigationController pushViewController:[[ScanVC initWithPreview] autorelease] animated:YES];
  //                                //                                [self.navigationController pushViewController:[HomeVC initWithHome] animated:YES];
  //
  //                            }
  //                            else
  //                            {
  //                                //                                [self initWithPromptTitle:@"Scan Warning" message:@"Please scan ticket on time"];
  //                                [[VSSharedManager sharedManager] setSelectedTicketInfo:[array objectAtIndex:indexPath.row]];
  //                                [self.navigationController pushViewController:[[ScanVC initWithhiddenScan] autorelease] animated:YES];
  //
  //                            }
  //                        }
  //                    }
  //
  //                }
  //                else{
  //
  //                    [[VSSharedManager sharedManager] setSelectedTicketInfo:[array objectAtIndex:indexPath.row]];
  //                    [self.navigationController pushViewController:[[ScanVC initWithPreview] autorelease] animated:YES];
  //                    //                    [self.navigationController pushViewController:[HomeVC initWithHome] animated:YES];
  //
  //                }
  //            }
  //            else
  //            {
  //
  //                [[VSSharedManager sharedManager] setSelectedTicketInfo:[array objectAtIndex:indexPath.row]];
  //                [self.navigationController pushViewController:[[ScanVC initWithPreview] autorelease] animated:YES];
  //                //                [self.navigationController pushViewController:[HomeVC initWithHome] animated:YES];
  //
  //            }
  //        }
  //    }
  
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  
  [self.ticketsTable deselectRowAtIndexPath:indexPath animated:YES];
  
}


@end
