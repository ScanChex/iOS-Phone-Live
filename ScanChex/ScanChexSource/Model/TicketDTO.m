//
//  TicketDTO.m
//  VeriScanQR
//
//  Created by Adnan Ahmad on 22/12/2012.
//  Copyright (c) 2012 Adnan Ahmad. All rights reserved.
//

#import "TicketDTO.h"
#import "TicketInfoDTO.h"
#import "CheckPointDTO.h"
@interface TicketInfoDTO()

-(void)updateTicketInfo:(NSMutableArray *)data;
-(void)updateCheckPoint:(NSMutableArray *)data;
@end

@implementation TicketDTO

@synthesize address1=_address1;
@synthesize address2=_address2;
@synthesize assetID=_assetID;
@synthesize latitude=_latitude;
@synthesize longitude=_longitude;
@synthesize scannedCodes=_scannedCodes;
@synthesize totalCodes=_totalCodes;
@synthesize remainingCodes=_remainingCodes;
@synthesize tickets=_tickets;
@synthesize assetPhoto=_assetPhoto;
@synthesize assetType=_assetType;
@synthesize description=_description;
@synthesize assetCode=_assetCode;
@synthesize clientName = _clientName;
@synthesize unEncryptedAssetID =_unEncryptedAssetID;
@synthesize phoneNumber= _phoneNumber;
@synthesize tolerance = _tolerance;
@synthesize totalCheckpoints = _totalCheckpoints;
@synthesize checkPoints = _checkPoints;
@synthesize check_point_ids = _check_point_ids;
@synthesize technician = _technician;



+(id)initWithTicketDTO:(NSDictionary *)data{


    return [[[self alloc] initWithDictionary:data] autorelease];
}

-(void)updateWithDictionary:(NSDictionary *)dictionary{
   
    self.assetID            = [dictionary valueForKey:@"asset_id"];
    self.latitude           = [[dictionary valueForKey:@"latitude"] description];
    self.longitude          = [[dictionary valueForKey:@"longitude"] description];
    self.totalCodes         = [dictionary valueForKey:@"total_codes"];
    self.remainingCodes     = [dictionary valueForKey:@"remained_codes"];
    self.scannedCodes       = [dictionary valueForKey:@"scanned_codes"];
    self.assetPhoto         = [[dictionary valueForKey:@"asset_photo"] description];
    self.assetType          = [dictionary valueForKey:@"asset_type"];
    self.description        = [dictionary valueForKey:@"description"];
    self.assetCode          = [dictionary valueForKey:@"asset_code"];
    self.clientName         = [[dictionary valueForKey:@"client_name"] description];
    self.unEncryptedAssetID =[[dictionary valueForKey:@"un_asset_id"] description];
    self.phoneNumber= [[dictionary valueForKey:@"phone"] description];
    self.tolerance = [[dictionary valueForKey:@"tolerance"] description];
//    self.photo = [[dictionary valueForKey:@"photo"] description];
    self.address1=[TicketAddressDTO initWithTicketAdderss:[dictionary valueForKey:@"address1"]];
    self.totalCheckpoints = [dictionary valueForKey:@"total_checkpoints"];
    self.check_point_ids = [dictionary valueForKey:@"check_point_ids"];
    self.technician = [dictionary valueForKey:@"technician"];
    if (![[dictionary valueForKey:@"address2"] isKindOfClass:[NSNull class]]) {
        
     //   self.address2=[TicketAddressDTO initWithTicketAdderss:[dictionary valueForKey:@"address2"]];
    }
    
    [self updateTicketInfo:[dictionary valueForKey:@"ticket_info"]];
    [self updateCheckPoint:[dictionary valueForKey:@"checkpoints"]];
}

-(void)updateTicketInfo:(NSMutableArray *)data{

    self.tickets=[NSMutableArray array];
    
    for (NSDictionary *info in data) {
        
        [self.tickets addObject:[TicketInfoDTO initWithTicketInfo:info]];
    }
    
    NSSortDescriptor *sortByName = [NSSortDescriptor sortDescriptorWithKey:@"ticket_end_time"                                                                 ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortByName];
    NSArray *sortedArray = [self.tickets sortedArrayUsingDescriptors:sortDescriptors];
    [self.tickets removeAllObjects];
    self.tickets = [NSMutableArray arrayWithArray:sortedArray];

}
-(void)updateCheckPoint:(NSMutableArray *)data {
    self.checkPoints = [NSMutableArray array];
    for (NSDictionary * info in data) {
        [self.checkPoints addObject:[CheckPointDTO initWithCheckPointInfo:info]];
    }
}

-(void)dealloc{
    
    [_address1 release];
    [_address2 release];
    [_assetID release];
    [_latitude release];
    [_longitude release];
    [_tickets release];
    [_checkPoints release];
    [super dealloc];
}
@end