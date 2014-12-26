//
//  TicketAddressDTO.h
//  VeriScanQR
//
//  Created by Adnan Ahmad on 15/05/2013.
//  Copyright (c) 2013 Adnan Ahmad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TicketAddressDTO : BaseDTO

@property (nonatomic,retain) NSString *street;
@property (nonatomic,retain) NSString *city;
@property (nonatomic,retain) NSString *state;
@property (nonatomic,retain) NSString *postalCode;
@property (nonatomic,retain) NSString *country;

+(id)initWithTicketAdderss:(NSDictionary *)dict;

@end
