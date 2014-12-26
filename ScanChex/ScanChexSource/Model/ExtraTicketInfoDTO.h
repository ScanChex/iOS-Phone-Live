//
//  ExtraTicketInfoDTO.h
//  VeriScanQR
//
//  Created by Adnan Ahmad on 09/04/2013.
//  Copyright (c) 2013 Adnan Ahmad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExtraTicketInfoDTO : BaseDTO

@property (nonatomic ,retain)NSString *customerName;
@property (nonatomic ,retain)NSString *contactName;
@property (nonatomic ,retain)NSString *modelNumber;
@property (nonatomic ,retain)NSString *description;
@property (nonatomic ,retain)NSString *serialNumber;
@property (nonatomic ,retain)NSString *address;
@property (nonatomic ,retain)NSString *telephone;
@property (nonatomic ,retain)NSString *questionAmount;
@property (nonatomic ,retain)NSString *documentAmount;
@property (nonatomic ,retain)NSMutableArray *serviceList;
@property (nonatomic ,retain)NSMutableArray *componentsList;

+(id)initWithExtraTicketInfo:(NSDictionary *)dict;

@end
