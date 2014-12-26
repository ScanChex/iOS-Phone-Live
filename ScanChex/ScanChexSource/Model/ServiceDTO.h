//
//  ServiceDTO.h
//  VeriScanQR
//
//  Created by Adnan Ahmad on 30/04/2013.
//  Copyright (c) 2013 Adnan Ahmad. All rights reserved.
//

#import "BaseDTO.h"

@interface ServiceDTO : BaseDTO

@property(nonatomic,retain)NSString *serviceID;
@property(nonatomic,retain)NSString *model;
@property(nonatomic,retain)NSString *description;
@property(nonatomic,retain)NSString *checkStatus;
@property(nonatomic,retain)NSString *ticketServiceID;
@property(nonatomic,retain)NSString *estimated_time;
+(id)serviceWithDictionary:(NSDictionary *)dictionary;

@end
