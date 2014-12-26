//
//  TicketAddressDTO.m
//  VeriScanQR
//
//  Created by Adnan Ahmad on 15/05/2013.
//  Copyright (c) 2013 Adnan Ahmad. All rights reserved.
//

#import "TicketAddressDTO.h"

@implementation TicketAddressDTO

@synthesize street=_street;
@synthesize city=_city;
@synthesize state=_state;
@synthesize postalCode=_postalCode;
@synthesize country=_country;

+(id)initWithTicketAdderss:(NSDictionary *)dict
{
    return [[[self alloc] initWithDictionary:dict] autorelease];

}

-(void)updateWithDictionary:(NSDictionary *)dictionary
{
    
    self.state=[[dictionary valueForKey:@"state"] description];
    self.street=[[dictionary valueForKey:@"street"] description];
    self.city=[[dictionary valueForKey:@"city"] description];
    self.postalCode=[[dictionary valueForKey:@"postal_code"] description];
    self.country=[[dictionary valueForKey:@"country"] description];
}

-(void)dealloc
{
   
    [_state release];
    [_street release];
    [_city release];
    [_postalCode release];
    [_country release];
    [super dealloc];
}

@end
