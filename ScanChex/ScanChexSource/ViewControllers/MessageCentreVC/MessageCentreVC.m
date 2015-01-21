//
//  MessageCentreVC.m
//  VeriScanQR
//
//  Created by Adnan Ahmad on 07/01/2014.
//  Copyright (c) 2014 Adnan Ahmad. All rights reserved.
//

#import "MessageCentreVC.h"
#import "MessageCell.h"
#import "MessageDTO.h"
#import "UserDTO.h"
#import "SharedManager.h"
#import "SVProgressHUD.h"
#import <QuartzCore/QuartzCore.h>
#import "VSSharedManager.h"
#import "UIImageView+WebCache.h"

#define FONT_SIZE 13.0f
#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN 14.0f

@interface MessageCentreVC ()

@end

@implementation MessageCentreVC

@synthesize period = _period;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
         self.period = @"1";
        // Custom initialization
    }
    return self;
}

+(id)initWithMessageCentre
{

    return [[[MessageCentreVC alloc] initWithNibName:@"MessageCentreVC" bundle:nil] autorelease];
}

- (void)viewDidLoad
{
    [self.todayButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.todayLabel setBackgroundColor:[UIColor blackColor]];
    [self.weekButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.weekLabel setBackgroundColor:[UIColor lightGrayColor]];
    [self.monthButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.monthLabel setBackgroundColor:[UIColor lightGrayColor]];
    [self.twoMonthsButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.twoMonthsLabel setBackgroundColor:[UIColor lightGrayColor]];
    
    self.alertText =  [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 290, 200)];
     [self.view setBackgroundColor:[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"color"]]];
    [self.dateLabel setText:[SharedManager stringFromDate:[NSDate date] withFormat:@"MMM d,Y"]];
    [super viewDidLoad];
    for (UIView * v in [self.view subviews]) {
        if ([v isKindOfClass:[UIButton class]]) {
            if ([[[(UIButton*)v titleLabel] text] isEqualToString:@"RETURN"]) {
                v.layer.cornerRadius = 5.0f;
            }
        }
    }
    [self.messageTable.layer setCornerRadius:10.0f];
    UserDTO *user=[[VSSharedManager sharedManager] currentUser];
    
    
    UserDTO *userDTO = [[SharedManager getInstance] loadUserObjectWithKey:@"user"];
    
    if (!IsEmpty(userDTO.company_logo)) {
        
        [self.companyLogo sd_setImageWithURL:[NSURL URLWithString:userDTO.company_logo] placeholderImage:[UIImage imageNamed:@"logo.png"]];
    }

    
    self.name.text=user.name;
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIRefreshControl *refreshControl = [[[UIRefreshControl alloc] init] autorelease];
    refreshControl.tintColor = [UIColor lightGrayColor];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refresh Data"]; // I am not concentrating on the attributed string thing. This is just to show how the title would look like.
    [refreshControl addTarget:self action:@selector(refreshControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    [self.messageTable addSubview:refreshControl];
    for (UIView * v in [self.view subviews]) {
        if ([v isKindOfClass:[UIButton class]]) {
            if ([[[(UIButton*)v titleLabel] text] isEqualToString:@"NEW"]) {
                v.layer.cornerRadius = 5.0f;
            }
            
        }
    }
    // Do any additional setup after loading the view from its nib.
    
    [self fetchData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)onBackClick:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark- TableViewDelegate


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self.messagesArray count] == 0) {
        return 1;
    }
    else {
        return [self.messagesArray count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DSTableViewWithDynamicHeight *table = (DSTableViewWithDynamicHeight *)self.messageTable;
    
    if ([self.messagesArray count] > 0) {
        MessageDTO * tempMessage =[self.messagesArray objectAtIndex:indexPath.row];
        if ([[[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"] lowercaseString] isEqualToString:[tempMessage.sender_id lowercaseString]]) {
            MessageCell *cell=[MessageCell resuableCellForTableView2:table withOwner:self];
            [cell updateCellWithMessage:tempMessage];
            
            return cell;
        }
        else {
            MessageCell *cell=[MessageCell resuableCellForTableView:table withOwner:self];
            [cell updateCellWithMessage:tempMessage];
            
            return cell;
        }
        
    }
    else
    {
    
        static NSString *kCellIdentifier = @"MyIdentifier";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
        if (cell == nil)
        {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier] autorelease];
        }
        
        cell.textLabel.text = @"No Messages";
        [cell.textLabel setFont:[UIFont boldSystemFontOfSize:12.0f]];
        cell.textLabel.textColor=[UIColor blackColor];
        [cell setBackgroundColor:[UIColor clearColor]];
        [[cell contentView] setBackgroundColor:[UIColor clearColor]];
        return cell;
    }
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DSTableViewWithDynamicHeight *table = (DSTableViewWithDynamicHeight *)self.messageTable;

    if ([self.messagesArray count]>0) {
        MessageDTO *messageDTO = [self.messagesArray objectAtIndex:indexPath.row];
        CGFloat height = [table heightForCellWithDefaultStyleAndText:messageDTO.message font:[UIFont systemFontOfSize:FONT_SIZE]];
        return height+50.0F;
        
//
//        CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
//        
//        CGSize size = [messageDTO.message sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
//        
//        CGFloat height = MAX(size.height, 44.0f);
//        if ([[[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"] lowercaseString] isEqualToString:[messageDTO.sender_id lowercaseString]]) {
//            return height + (CELL_CONTENT_MARGIN * 2)+30;
//        }
//        else {
//            return height + (CELL_CONTENT_MARGIN * 2)+10;
//        }
    }
    else
        return 44.0f;
   

}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.tableHeader;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20.0f;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return self.tableFooter;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 20.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//     UserDTO*user=[[VSSharedManager sharedManager] currentUser];
    MessageDTO * tempMessage = [self.messagesArray objectAtIndex:indexPath.row];
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"] isEqualToString:tempMessage.sender_id]) {
//        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"You cannot reply to your own message" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alert show];
//        [alert release];
    }
    else {
        CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] init];
        [self.alertText setText:@""];
        // Add some custom content to the alert view
        [alertView setContainerView:[self createDemoView:@"Please enter your reply:"]];
        [alertView setTag:indexPath.row];
        // Modify the parameters
        [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"Cancel", @"Reply", nil]];
//        [alertView setDelegate:self];
        
        // You may use a Block, rather than a delegate.
        [alertView setOnButtonTouchUpInside:^(CustomIOS7AlertView *alertView, int buttonIndex) {
            NSString* detailString = [self.alertText text];
            NSLog(@"String is: %@", detailString); //Put it on the debugger
            if ( buttonIndex == 0){
                return; //If cancel or 0 length string the string doesn't matter
            }
            if (buttonIndex == 1 && [detailString length]>0) {
                self.currentSelectedCell = alertView.tag;
                [self postReply:detailString];
                NSLog(@"Reply");
                
            }
            [alertView close];
        }];
        
        [alertView setUseMotionEffects:true];
        
        // And launch the dialog
        [alertView show];
        
        
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == -22) {
        NSString* detailString = [[alertView textFieldAtIndex:0] text];
        NSLog(@"String is: %@", detailString); //Put it on the debugger
        if ( buttonIndex == 0){
            return; //If cancel or 0 length string the string doesn't matter
        }
        if (buttonIndex == 1 && [detailString length]>0) {
            self.currentSelectedCell = alertView.tag;
            [self postReply:detailString];
            NSLog(@"Reply");
            
        }
    }
    else {
        NSString* detailString = [[alertView textFieldAtIndex:0] text];
        NSLog(@"String is: %@", detailString); //Put it on the debugger
        if ( buttonIndex == 0){
            return; //If cancel or 0 length string the string doesn't matter
        }
        if (buttonIndex == 1 && [detailString length]>0) {
            self.currentSelectedCell = alertView.tag;
            [self postReply:detailString];
            NSLog(@"Reply");
            
        }
    }
    
}
- (void)dealloc {
    [_messageTable release];
    [_companyLogo release];
    [super dealloc];
}

#pragma mark Fetch WebServices Data
-(void) refreshControlValueChanged:(UIRefreshControl *) sender {
    sender.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing"];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    UserDTO*user=[[VSSharedManager sharedManager] currentUser];
    [[WebServiceManager sharedManager] getMessages:[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"] masterkey:[NSString stringWithFormat:@"%d",user.masterKey] period:self.period withCompletionHandler:^(id data ,BOOL error){
        [SVProgressHUD dismiss];
        if (!error) {
            
            if(data){
                NSMutableArray *tempArray = [NSMutableArray arrayWithArray:(NSMutableArray *)data];
                if ([tempArray isKindOfClass:[NSMutableArray class]] && tempArray && [tempArray count]>0 && [[tempArray objectAtIndex:0] isKindOfClass:[NSDictionary class]]) {
                    self.messagesArray = [NSMutableArray array];
                    for (int i = 0; i<[tempArray count]; i++) {
                        NSMutableDictionary * tempDict = [[tempArray objectAtIndex:i] mutableCopy];
                        CGSize renderedSize = [[tempDict objectForKey:@"message"] sizeWithFont:[UIFont fontWithName:@"Helvetica" size:12] constrainedToSize:CGSizeMake(320, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
                        
                        
                        [tempDict setValue:[NSNumber numberWithInteger:renderedSize.height] forKey:@"height"];
                        
                        [self.messagesArray addObject:[MessageDTO initWithMessage:tempDict]];
                    }
                    //                self.messagesArray =[NSMutableArray arrayWithArray:(NSMutableArray *)data];
                    NSLog(@"Data");
                    [self.messageTable reloadData];
                }
                
            }
        }
        NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
        [dateFormatter setDateStyle:NSDateFormatterShortStyle];
        [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
        
        sender.attributedTitle = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"Last updated: %@", [dateFormatter stringFromDate:[NSDate date]]]];
        
        [sender endRefreshing];
        //        [self updateMessages];
    }];
    
}
-(void)fetchData {
     [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    UserDTO*user=[[VSSharedManager sharedManager] currentUser];
    [[WebServiceManager sharedManager] getMessages:[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"] masterkey:[NSString stringWithFormat:@"%d",user.masterKey] period:self.period withCompletionHandler:^(id data ,BOOL error){
        [SVProgressHUD dismiss];
        if (!error) {
            
            if(data){
                NSMutableArray *tempArray = [NSMutableArray arrayWithArray:(NSMutableArray *)data];
                self.messagesArray = [NSMutableArray array];
                if ([tempArray isKindOfClass:[NSMutableArray class]] && tempArray && [tempArray count]>0 && [[tempArray objectAtIndex:0] isKindOfClass:[NSDictionary class]]) {
                    self.messagesArray = [NSMutableArray array];
                    for (int i = 0; i<[tempArray count]; i++) {
                        NSMutableDictionary * tempDict = [[tempArray objectAtIndex:i] mutableCopy];
                        CGSize renderedSize = [[tempDict objectForKey:@"message"] sizeWithFont:[UIFont fontWithName:@"Helvetica" size:12] constrainedToSize:CGSizeMake(320, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
                        
                        
                        [tempDict setValue:[NSNumber numberWithInteger:renderedSize.height] forKey:@"height"];
                        
                        [self.messagesArray addObject:[MessageDTO initWithMessage:tempDict]];
                    }
                    //                self.messagesArray =[NSMutableArray arrayWithArray:(NSMutableArray *)data];
                    NSLog(@"Data");
                   
                }
                 [self.messageTable reloadData];
                
            }
        }
//        [self updateMessages];
    }];
}

-(void)postReply:(NSString*) detailstring {
    if (self.currentSelectedCell == -22) {
//        MessageDTO * tempMessage = [self.messagesArray objectAtIndex:self.currentSelectedCell];
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
        UserDTO*user=[[VSSharedManager sharedManager] currentUser];
        [[WebServiceManager sharedManager] sendMessage:[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"] masterkey:[NSString stringWithFormat:@"%d",user.masterKey] receiver_id:user.company_user message:detailstring withCompletionHandler:^(id data ,BOOL error){
            [SVProgressHUD dismiss];
            if (!error) {
                [self fetchData];
                
            }
            //        [self updateMessages];
        }];
    }
    else {
        MessageDTO * tempMessage = [self.messagesArray objectAtIndex:self.currentSelectedCell];
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
        UserDTO*user=[[VSSharedManager sharedManager] currentUser];
        [[WebServiceManager sharedManager] sendMessage:[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"] masterkey:[NSString stringWithFormat:@"%d",user.masterKey] receiver_id:tempMessage.sender_id message:detailstring withCompletionHandler:^(id data ,BOOL error){
            [SVProgressHUD dismiss];
            if (!error) {
                [self fetchData];
                
            }
            //        [self updateMessages];
        }];
    }
    
    
}

-(IBAction)newButtonPressed:(id)sender {
    CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] init];
    [self.alertText setText:@""];
    // Add some custom content to the alert view
    [alertView setContainerView:[self createDemoView:@"Please enter a new message for Admin"]];
    [alertView setTag:-22];
    // Modify the parameters
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"Cancel", @"Send", nil]];
    //        [alertView setDelegate:self];
    
    // You may use a Block, rather than a delegate.
    [alertView setOnButtonTouchUpInside:^(CustomIOS7AlertView *alertView, int buttonIndex) {
        NSString* detailString = [self.alertText text];
//        NSString* detailString = [[alertView textFieldAtIndex:0] text];
        NSLog(@"String is: %@", detailString); //Put it on the debugger
        if ( buttonIndex == 0){
            return; //If cancel or 0 length string the string doesn't matter
        }
        if (buttonIndex == 1 && [detailString length]>0) {
            self.currentSelectedCell = alertView.tag;
            [self postReply:detailString];
            NSLog(@"Reply");
            
        }
        [alertView close];
    }];
    
    [alertView setUseMotionEffects:true];
    
    // And launch the dialog
    [alertView show];
//    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"New Message" message:@"Please enter a new message for Admin" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Send",nil];
//    [alert setTag:-22];
//    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
//    UITextField * alertTextField = [alert textFieldAtIndex:0];
//    alertTextField.placeholder = @"Enter your Message";
//    [alert show];
//    [alert release];
    
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

-(IBAction)changePeriod:(id)sender {
    switch ([sender tag]) {
        case 0:
            [self.todayButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.todayLabel setBackgroundColor:[UIColor blackColor]];
            [self.weekButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [self.weekLabel setBackgroundColor:[UIColor lightGrayColor]];
            [self.monthButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [self.monthLabel setBackgroundColor:[UIColor lightGrayColor]];
            [self.twoMonthsButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [self.twoMonthsLabel setBackgroundColor:[UIColor lightGrayColor]];
            self.period = @"1";
            [self fetchData];
            break;
        case 1:
            [self.todayButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [self.todayLabel setBackgroundColor:[UIColor lightGrayColor]];
            [self.weekButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.weekLabel setBackgroundColor:[UIColor blackColor]];
            [self.monthButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [self.monthLabel setBackgroundColor:[UIColor lightGrayColor]];
            [self.twoMonthsButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [self.twoMonthsLabel setBackgroundColor:[UIColor lightGrayColor]];
            self.period = @"7";
            [self fetchData];
            break;
        case 2:
            [self.todayButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [self.todayLabel setBackgroundColor:[UIColor lightGrayColor]];
            [self.weekButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [self.weekLabel setBackgroundColor:[UIColor lightGrayColor]];
            [self.monthButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.monthLabel setBackgroundColor:[UIColor blackColor]];
            [self.twoMonthsButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [self.twoMonthsLabel setBackgroundColor:[UIColor lightGrayColor]];
            self.period = @"30";
            [self fetchData];
            break;
        case 3:
            [self.todayButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [self.todayLabel setBackgroundColor:[UIColor lightGrayColor]];
            [self.weekButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [self.weekLabel setBackgroundColor:[UIColor lightGrayColor]];
            [self.monthButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [self.monthLabel setBackgroundColor:[UIColor lightGrayColor]];
            [self.twoMonthsButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.twoMonthsLabel setBackgroundColor:[UIColor blackColor]];
            self.period = @"60";
            [self fetchData];
            break;
            
        default:
            break;
    }
}

@end
