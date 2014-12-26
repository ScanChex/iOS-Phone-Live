//
//  AssetInfoDTO.m
//  VeriScanQR
//
//  Created by Adnan Ahmad on 13/04/2013.
//  Copyright (c) 2013 Adnan Ahmad. All rights reserved.
//

#import "AssetInfoDTO.h"

@implementation AssetInfoDTO

@synthesize photo=_photo;
@synthesize description=_description;
@synthesize scannedDate=_scannedDate;
@synthesize empID=_empID;
@synthesize serialNumber=_serialNumber;
@synthesize street=_street;
@synthesize city=_city;
@synthesize state=_state;
@synthesize postalCode=_postalCode;
@synthesize country=_country;
@synthesize assetID=_assetID;
@synthesize latitude=_latitude;
@synthesize longitude=_longitude;
@synthesize fullName =_fullName;

+(id)initWithAsset:(NSDictionary *)dict
{
    
    return [[[self alloc] initWithDictionary:dict] autorelease];
}

-(void)updateWithDictionary:(NSDictionary *)dictionary
{
    self.photo =[[dictionary valueForKey:@"asset_photo"] description];
    self.description = [[dictionary valueForKey:@"description"] description];
    self.scannedDate = [[dictionary valueForKey:@"last_scanned_date"] description];
    self.empID = [[dictionary valueForKey:@"emp_id"] description];
    self.serialNumber = [[dictionary valueForKey:@"serial_number"] description];
    self.state = [[dictionary valueForKey:@"state"] description];
    self.street = [[dictionary valueForKey:@"street"] description];
    self.city = [[dictionary valueForKey:@"city"] description];
    self.postalCode = [[dictionary valueForKey:@"postal_code"] description];
    self.country = [[dictionary valueForKey:@"country"] description];
    self.assetID = [[dictionary valueForKey:@"asset_id"] description];
    self.latitude = [[dictionary valueForKey:@"ltitude"] description];
    self.longitude = [[dictionary valueForKey:@"lngitude"] description];
    self.fullName = [[dictionary valueForKey:@"full_name"] description];
}

-(void)dealloc
{
    [_fullName release];
    [_latitude release];
    [_longitude release];
    [_photo release];
    [_description release];
    [_scannedDate release];
    [_empID release];
    [_serialNumber release];
    [_state release];
    [_street release];
    [_city release];
    [_postalCode release];
    [_country release];
    [super dealloc];
}
@end
