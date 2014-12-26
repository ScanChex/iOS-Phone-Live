//
//  CheckInConfirmationViewController.m
//  ScanChex
//
//  Created by Rajeel Amjad on 13/08/2014.
//  Copyright (c) 2014 Adnan Ahmad. All rights reserved.
//

#import "CheckInConfirmationViewController.h"
#import "AsyncImageView.h"
#import "SharedManager.h"
@interface CheckInConfirmationViewController ()

@end

@implementation CheckInConfirmationViewController

+(id)initWithData:(NSDictionary*)data ticketID:(NSString *)ticketId {
    return [[[CheckInConfirmationViewController alloc]initselfWithData:data ticketID:ticketId] autorelease];
}
-(id)initselfWithData:(NSDictionary*)data ticketID:(NSString *)ticketId {
    self=[super initWithNibName:@"CheckInConfirmationViewController" bundle:nil];
    if (self) {
        self.initialData = [data mutableCopy];
        self.ticketID = [ticketId mutableCopy];
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
    NSString * tempStrinf = [self.initialData objectForKey:@"employee"];
    NSArray * tempArray = [tempStrinf componentsSeparatedByString:@"-"];
//    if ([tempArray count]>0) {
//        [self.employeeTextField setText:[tempArray objectAtIndex:1]];
//    }
//    else {
//        [self.employeeTextField setText:[tempArray objectAtIndex:0]];
//    }
    [self.employeeTextField setText:[self.initialData objectForKey:@"employee"]];
    [self.returnTextField setText:[SharedManager stringFromDate:[NSDate date] withFormat:@"dd/MM/yyyy hh:mm a"]];
    [self.ticketIDTextField setText:self.ticketID];
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
    [self.navigationController popToViewController:[viewControllers objectAtIndex:[viewControllers count]-4] animated:YES];
}
- (IBAction)backButtonPressed:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
