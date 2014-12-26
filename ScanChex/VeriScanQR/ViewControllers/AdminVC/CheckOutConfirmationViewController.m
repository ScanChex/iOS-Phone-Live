//
//  CheckOutConfirmationViewController.m
//  ScanChex
//
//  Created by Rajeel Amjad on 10/08/2014.
//  Copyright (c) 2014 Adnan Ahmad. All rights reserved.
//

#import "CheckOutConfirmationViewController.h"
#import "AsyncImageView.h"
@interface CheckOutConfirmationViewController ()

@end

@implementation CheckOutConfirmationViewController
+(id)initWithData:(NSDictionary*)data {
    return [[[CheckOutConfirmationViewController alloc]initselfWithData:data] autorelease];
}
-(id)initselfWithData:(NSDictionary*)data {
    self=[super initWithNibName:@"CheckOutConfirmationViewController" bundle:nil];
    if (self) {
        self.initialData = [data mutableCopy];
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
    [super viewDidLoad];
    [self.scrollView setContentSize:CGSizeMake(320, 571)];
    self.assetImageView.layer.borderWidth=3.0;
    self.assetImageView.layer.borderColor=[UIColor lightGrayColor].CGColor;
    [self.assetImageView setImageURL:[NSURL URLWithString:[self.initialData objectForKey:@"photo"]]];
    [self.descriptionLabel setText:[self.initialData objectForKey:@"desc"]];
    [self.serialNumberLabel setText:[self.initialData objectForKey:@"serial"]];
    [self.assetIdLabel setText:[self.initialData objectForKey:@"assetID"]];
    [self.departmentLabel setText:[self.initialData objectForKey:@"department"]];
    [self.addressTextView setText:[self.initialData objectForKey:@"address"]];
    [self.employeeTextField setText:[self.initialData objectForKey:@"employee"]];
    [self.returnTextField setText:[self.initialData objectForKey:@"return"]];
    [self.ticketIDTextField setText:[self.initialData objectForKey:@"ticket_number"]];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Button Pressed Events
- (IBAction)closeButtonPressed:(id)sender {
    NSArray * viewControllers = [self.navigationController viewControllers];
    [self.navigationController popToViewController:[viewControllers objectAtIndex:[viewControllers count]-5] animated:YES];
}
- (IBAction)backButtonPressed:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
