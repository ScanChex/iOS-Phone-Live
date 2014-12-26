//
//  ComponentDTO.h
//  VeriScanQR
//
//  Created by Adnan Ahmad on 09/04/2013.
//  Copyright (c) 2013 Adnan Ahmad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ComponentDTO : BaseDTO

@property(nonatomic,retain)NSString *compID;
@property(nonatomic,retain)NSString *itemID;
@property(nonatomic,retain)NSString *description;
@property(nonatomic,retain)NSString *qty;
@property(nonatomic,retain)NSString *price;
@property(nonatomic,retain)NSString *totalPrice;
@property(nonatomic,retain)NSString *notes;

+(id)initWithComponent:(NSDictionary *)dict;

@end
