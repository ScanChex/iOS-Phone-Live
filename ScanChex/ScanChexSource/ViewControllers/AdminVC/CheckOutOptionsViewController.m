//
//  CheckOutOptionsViewController.m
//  ScanChex
//
//  Created by Rajeel Amjad on 26/07/2014.
//  Copyright (c) 2014 Adnan Ahmad. All rights reserved.
//

#import "CheckOutOptionsViewController.h"
#import "CheckOutInitialInformationViewController.h"
#import "CheckOutTodayViewController.h"

@interface CheckOutOptionsViewController ()

@end

@implementation CheckOutOptionsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

+(id)initCheckOutOptions {
    return [[[CheckOutOptionsViewController alloc] initWithNibName:@"CheckOutOptionsViewController" bundle:[NSBundle mainBundle]] autorelease];
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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

- (IBAction)scanCode:(id)sender {
    [self.navigationController pushViewController:[CheckOutInitialInformationViewController initCheckWithScan] animated:YES];
}
- (IBAction)manualLookUp:(id)sender {
    [self.navigationController pushViewController:[CheckOutInitialInformationViewController initCheckWithManual] animated:YES];
}
- (IBAction)checkedOutToday:(id)sender {
  NSLog(@"Checkout out today");
  [self.navigationController pushViewController:[CheckOutTodayViewController initWithTickets] animated:YES];
}

@end
