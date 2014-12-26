//
//  AddressesDTO.m
//  VeriScanQR
//
//  Created by Adnan Ahmad on 24/12/2012.
//  Copyright (c) 2012 Adnan Ahmad. All rights reserved.
//

#import "AddressesDTO.h"

@implementation AddressesDTO

@synthesize  location;
@synthesize  totalCode;
@synthesize  nextScan;
@synthesize  dateTime;
@synthesize name;
@synthesize lat;
@synthesize lon;
@synthesize assetId;
@synthesize description;

+(id)addressesWithDictionary:(NSDictionary *)dictionary{
    
    return [[[self alloc] initWithDictionary:dictionary] autorelease];
}

-(void)updateWithDictionary:(NSDictionary *)dictionary{
    
    self.location =  [dictionary valueForKey:@"address"];
    self.totalCode=  [dictionary valueForKey:@"asset_count"];
    self.nextScan =  [dictionary valueForKey:@"next_scan_date"];
    self.dateTime =  [dictionary valueForKey:@"dateTime"];
    self.lat      =  [dictionary valueForKey:@"latitude"];
    self.lon      =  [dictionary valueForKey:@"longitude"];
    self.name     =  [dictionary valueForKey:@"emp_id"];
    self.assetId  =  [dictionary valueForKey:@""];
    self.description=[dictionary valueForKey:@"description"];
    
}

-(void)dealloc{
    
    [self.location release];
    [self.totalCode release];
    [self.nextScan release];
    [self.dateTime release];
    [self.lat release];
    [self.lon release];
    [self.name release];
    [self.assetId release];
    [self.description release];
    [super dealloc];
}
@end
