//
//  DocumentsVC.m
//  VeriScanQR
//
//  Created by Adnan Ahmad on 24/12/2012.
//  Copyright (c) 2012 Adnan Ahmad. All rights reserved.
//

#import "DocumentsVC.h"
#import "DocumentCell.h"
#import "DocumentDTO.h"
#import "TicketDTO.h"
#import "VSSharedManager.h"
#import "SharedManager.h"
@interface DocumentsVC ()

-(id)initWithData:(NSArray *)array andDelegate:(id<DocumentDelegate>)aDelegate;
-(void)updateGUI;
@end

@implementation DocumentsVC
@synthesize documents=_documents;
@synthesize delegate=_delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

+(id)initWithDocumentWithArray:(NSArray *)data andDelegate:(id<DocumentDelegate>)delegate{

    return [[[DocumentsVC alloc] initWithData:data andDelegate:delegate] autorelease];
}

-(id)initWithData:(NSArray *)array andDelegate:(id<DocumentDelegate>)aDelegate{

    if (IS_IPHONE5) {
        
        self=[super initWithNibName:@"DocumentsiPhone5VC" bundle:nil];

    }
    else
    {
        self=[super initWithNibName:@"DocumentsVC" bundle:nil];
    }
    
    if (self) {
        
        self.documents=[NSArray arrayWithArray:array];
        self.delegate=aDelegate;
    }
    return self;
}
- (void)viewDidLoad
{
    
     [self.view setBackgroundColor:[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"color"]]];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self updateGUI];
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

    self.totalCodes.text=[NSString stringWithFormat:@"%@", ticket.totalCodes];
    self.remainingCodes.text=[NSString stringWithFormat:@"%@",ticket.remainingCodes];
    self.scanningCodes.text=[NSString stringWithFormat:@"%@",ticket.scannedCodes];
    self.assetDescription.text= [NSString stringWithFormat:@"%@",ticket.description];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_documenTable release];
    [_assetID release];
    [_address release];
    [_totalCodes release];
    [_scanningCodes release];
    [_remainingCodes release];
    [_assetDescription release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setDocumenTable:nil];
    [self setAssetID:nil];
    [self setAddress:nil];
    [self setTotalCodes:nil];
    [self setScanningCodes:nil];
    [self setRemainingCodes:nil];
    [self setAssetDescription:nil];
    [super viewDidUnload];
}

#pragma TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [[self.documents objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    DocumentCell *cell=[DocumentCell resuableCellForTableView:self.documenTable withOwner:self];
    cell.backgroundColor = [UIColor clearColor];
    [cell updateCellWithDocument:[[self.documents objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
 
    if (indexPath.section == 0) {
        [SharedManager getInstance].isEditable = FALSE;
    }
    else {
        [SharedManager getInstance].isEditable = TRUE;
    }
    ///download pdf and show view them here
    if ([self.delegate respondsToSelector:@selector(selectedFileWithPath:)]) {
        DocumentDTO *document=[[self.documents objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        if (indexPath.section == 1 &&  ![[VSSharedManager sharedManager] isPreview]) {
            [self.delegate selectedFileWithPath:[document.link stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        }
        else if (indexPath.section ==0 ) {
            [self.delegate selectedFileWithPath:[document.link stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        }
        else {
            //[SharedManager getInstance].isEditable = FALSE;
            [self.delegate selectedFileWithPath:[document.link stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        }
        //[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
        
    }
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row%2==1) {
        
        cell.backgroundColor = [UIColor lightGrayColor];
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 26.0f;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section ==0) {
        return self.documentsHeader;
    }
    else {
        return self.editableDocumentsHeader;
    }
}
@end
