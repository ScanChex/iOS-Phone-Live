//
//  CheckInCheckOutViewController.m
//  ScanChex
//
//  Created by Rajeel Amjad on 26/07/2014.
//  Copyright (c) 2014 Adnan Ahmad. All rights reserved.
//

#import "CheckInCheckOutViewController.h"
#import "CheckOutOptionsViewController.h"
#import "CheckInTicketsViewController.h"

@interface CheckInCheckOutViewController ()

@end

@implementation CheckInCheckOutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
+(id)initCheckInOutVC {
    return [[[CheckInCheckOutViewController alloc] initWithNibName:@"CheckInCheckOutViewController" bundle:[NSBundle mainBundle]] autorelease];
}

- (void)viewDidLoad
{
    [self.view setBackgroundColor:[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"color"]]];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)checkOut:(id)sender {
     [self.navigationController pushViewController:[CheckOutOptionsViewController initCheckOutOptions] animated:YES];
}
-(IBAction)checkIn:(id)sender {
    [self.navigationController pushViewController:[CheckInTicketsViewController initWithTickets] animated:YES];
}

- (IBAction)backButtonPressed:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
