//
//  TicketDTO.h
//  VeriScanQR
//
//  Created by Adnan Ahmad on 22/12/2012.
//  Copyright (c) 2012 Adnan Ahmad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseDTO.h"
#import "TicketAddressDTO.h"

@interface TicketDTO : BaseDTO

//@property(nonatomic,retain)NSString *address1;
//@property(nonatomic,retain)NSString *address2;
@property(nonatomic, retain) NSString *assetID;
@property(nonatomic, retain) NSString *latitude;
@property(nonatomic, retain) NSString * longitude;
@property(nonatomic, retain) NSString *totalCodes;
@property(nonatomic, retain) NSString * remainingCodes;
@property(nonatomic, retain) NSString *scannedCodes;
@property(nonatomic, retain) NSMutableArray *tickets;
@property(nonatomic, retain) NSString *assetPhoto;
@property(nonatomic, retain) NSString *assetType;
@property(nonatomic, retain) NSString *description;
@property(nonatomic, retain) NSString *assetCode;
@property(nonatomic, retain) NSString *clientName;
@property(nonatomic, retain) TicketAddressDTO *address1;
@property(nonatomic, retain) TicketAddressDTO *address2;
@property(nonatomic, retain) NSString *unEncryptedAssetID;
@property(nonatomic, retain) NSString *phoneNumber;
@property(nonatomic, retain) NSString *tolerance;
@property (nonatomic, retain) NSString * totalCheckpoints;
@property (nonatomic ,retain) NSMutableArray * checkPoints;
@property (nonatomic ,retain) NSString * check_point_ids;
@property (nonatomic, retain) NSString * technician;

//@property (nonatomic, retain) NSString * photo;

+(id)initWithTicketDTO:(NSDictionary *)data;
@end
