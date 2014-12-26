//
//  HistoryDTO.m
//  VeriScanQR
//
//  Created by Adnan Ahmad on 29/01/2013.
//  Copyright (c) 2013 Adnan Ahmad. All rights reserved.
//

#import "HistoryDTO.h"

@implementation HistoryDTO
@synthesize date=_date;
@synthesize technician=_technician;
@synthesize serialNumber=_serialNumber;
//@synthesize service=_service;
@synthesize warranty=_warranty;
@synthesize imgURL=_imgURL;
@synthesize notes=_notes;
@synthesize video=_video;
@synthesize voice=_voice;
@synthesize model=_model;
@synthesize fullName = _fullName;
@synthesize last_service_date = _last_service_date;
@synthesize last_serviced_by = _last_serviced_by;
@synthesize date_in_service = _date_in_service;
@synthesize manufacturer = _manufacturer;
@synthesize asset_description = _asset_description;
@synthesize ticketID = _ticketID;
@synthesize is_questions = _is_questions;

+(id)initWithHistoryData:(NSDictionary *)dict{


    return [[self alloc] initWithDictionary:dict];
}

-(void)updateWithDictionary:(NSDictionary *)dictionary{

    self.date=[dictionary objectForKey:@"date"];
    self.technician=[dictionary objectForKey:@"technician"];
    self.warranty=[dictionary objectForKey:@"warranty"];
    self.imgURL=[dictionary objectForKey:@"images"];
    self.notes=[dictionary objectForKey:@"notes"];
    self.video=[dictionary objectForKey:@"videos"];
    self.voice=[dictionary objectForKey:@"voices"];
    self.serialNumber=[dictionary objectForKey:@"serial_number"];
    self.model=[dictionary objectForKey:@"model_number"];
    self.fullName = [dictionary objectForKey:@"full_name"];
    self.last_service_date = [dictionary valueForKey:@"last_service_date"];
    self.last_serviced_by = [dictionary valueForKey:@"last_serviced_by"];
    self.date_in_service = [dictionary valueForKey:@"date_in_service"];
    self.manufacturer = [dictionary valueForKey:@"manufacturer"];
    self.asset_description = [dictionary valueForKey:@"asset_description"];
    self.ticketID = [dictionary valueForKey:@"ticket_id"];
    self.is_questions = [dictionary valueForKey:@"is_questions"];
}
-(void)dealloc{

    [_date release];
    [_technician release];
    [_last_service_date release];
    [_warranty release];
    [_imgURL release];
    [_notes release];
    [_video release];
    [_voice release];
    [_serialNumber release];
    [_last_serviced_by release];
    [_date_in_service release];
    [_manufacturer release];
    [_asset_description release];
    [_is_questions release];
    [super dealloc];
}
@end
