//
//  HistoryDTO.h
//  VeriScanQR
//
//  Created by Adnan Ahmad on 29/01/2013.
//  Copyright (c) 2013 Adnan Ahmad. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BaseDTO.h"
@interface HistoryDTO : BaseDTO

@property(nonatomic,retain)NSString * date;
@property(nonatomic,retain)NSString *technician;
//@property(nonatomic,retain)NSString *service;
@property(nonatomic,retain)NSString *warranty;
@property(nonatomic,retain)NSArray *imgURL;
@property(nonatomic,retain)NSArray *notes;
@property(nonatomic,retain)NSArray *video;
@property(nonatomic,retain)NSArray *voice;
@property(nonatomic,retain)NSString *serialNumber;
@property(nonatomic,retain)NSString *model;
@property(nonatomic,retain)NSString *fullName;
@property(nonatomic,retain)NSString *last_service_date;
@property(nonatomic,retain)NSString *last_serviced_by;
@property(nonatomic,retain)NSString *date_in_service;
@property(nonatomic,retain)NSString *manufacturer;
@property(nonatomic,retain)NSString *asset_description;
@property (nonatomic, retain) NSString * ticketID;
@property(nonatomic,retain) NSString *is_questions;

+(id)initWithHistoryData:(NSDictionary *)dict;
@end
