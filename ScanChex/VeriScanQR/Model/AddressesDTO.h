//
//  AddressesDTO.h
//  VeriScanQR
//
//  Created by Adnan Ahmad on 24/12/2012.
//  Copyright (c) 2012 Adnan Ahmad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressesDTO : NSObject
@property(nonatomic,retain)NSString *location;
@property(nonatomic,retain)NSString *totalCode;
@property(nonatomic,retain)NSString * nextScan;
@property(nonatomic,retain)NSString * dateTime;
@property(nonatomic,retain)NSString *lat;
@property(nonatomic,retain)NSString *lon;
@property(nonatomic,retain)NSString *name;
@property(nonatomic,retain)NSString *assetId;
@property(nonatomic,retain)NSString *description;

+(id)addressesWithDictionary:(NSDictionary *)dictionary;
@end
