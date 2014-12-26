//
//  ComponentsVC.m
//  VeriScanQR
//
//  Created by Adnan Ahmad on 10/04/2013.
//  Copyright (c) 2013 Adnan Ahmad. All rights reserved.
//

#import "ComponentsVC.h"
#import "ExtraInfoCell.h"
#import "ComponentDTO.h"
#import "NotesVC.h"
#import "ServiceDTO.h"
#import "SVProgressHUD.h"
#import "WebServiceManager.h"
#import "UserDTO.h"
#import "VSSharedManager.h"
@interface ComponentsVC ()
-(void)updateComponents;

@end

@implementation ComponentsVC

@synthesize components=_components;
@synthesize service=_service;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

+(id)initWithComponents:(ServiceDTO *)array{

    return [[[ComponentsVC alloc] initwithData:array] autorelease];
}
-(id)initwithData:(ServiceDTO*)array{

    self=[super initWithNibName:@"ComponentsVC" bundle:nil];
    if (self) {
        
        self.service=array;
        
        //self.components=[NSMutableArray arrayWithArray:array];
    }

    return self;
}

- (IBAction)backButtonPressed:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad
{
     [self.view setBackgroundColor:[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"color"]]];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.extraInfoTable.backgroundColor = [UIColor clearColor];
    
}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    
    [self updateComponents];

}
-(void)updateComponents
{

    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];

    UserDTO *user =[[VSSharedManager sharedManager] currentUser];
    
    [[WebServiceManager sharedManager] getComponents:[NSString stringWithFormat:@"%d",user.masterKey] serviceID:self.service.serviceID withCompletionHandler:^(id data, BOOL error){
    
        [SVProgressHUD dismiss];
        
        if (!error) {
            
            self.components=[NSMutableArray arrayWithArray:(NSArray*)data];
            [self.extraInfoTable reloadData];
        }
        else
        {
        
            [self initWithPromptTitle:@"Error" message:(NSString *)data];
        }
        
    }];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma TableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.components count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ExtraInfoCell *cell=[ExtraInfoCell resuableCellForTableView:self.extraInfoTable withOwner:self];
    [cell updateCellWithComponents:[self.components objectAtIndex:indexPath.row]];
    //accesory view
    [cell.notes addTarget: self
                     action: @selector(accessoryButtonTapped:withEvent:)
           forControlEvents: UIControlEventTouchUpInside];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
- (void) accessoryButtonTapped: (UIControl *) button withEvent: (UIEvent *) event{
    
    NSIndexPath * indexPath = [self.extraInfoTable indexPathForRowAtPoint: [[[event touchesForView: button] anyObject] locationInView: self.extraInfoTable]];
    
    if ( indexPath == nil )
        return;

    
    ComponentDTO *componentDTO =[self.components objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:[NotesVC initWithCompontentNotes:componentDTO.notes] animated:YES];
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
//    if (indexPath.row%2==1) {
//        
//        cell.backgroundColor = [UIColor lightGrayColor];
//    }
    
}
- (void)dealloc {
    [_extraInfoTable release];
    [_imageView release];
    [super dealloc];
}
@end
