//
//  ServiceDTO.m
//  VeriScanQR
//
//  Created by Adnan Ahmad on 30/04/2013.
//  Copyright (c) 2013 Adnan Ahmad. All rights reserved.
//

#import "ServiceDTO.h"

@implementation ServiceDTO
@synthesize serviceID=_serviceID,model=_model,description=_description,checkStatus=_checkStatus, ticketServiceID =_ticketServiceID,estimated_time = _estimated_time;

+(id)serviceWithDictionary:(NSDictionary *)dictionary
{
    return [[[self alloc] initWithDictionary:dictionary] autorelease];
}

-(void)updateWithDictionary:(NSDictionary *)dictionary
{

    self.serviceID =[dictionary valueForKey:@"service_id"];
    self.model =[dictionary valueForKey:@"model"];
    self.description =[dictionary valueForKey:@"description"];
    self.checkStatus =[[dictionary valueForKey:@"status"] description];
    self.ticketServiceID = [[dictionary valueForKey:@"ticket_service_id"] description];
    self.estimated_time = [dictionary valueForKey:@"estimated_time"];
}

-(void)dealloc
{
    [_ticketServiceID release];
    [_serviceID release];
    [_model release];
    [_description release];
    [_checkStatus release];
    [_estimated_time release];
    [super dealloc];
}
@end
