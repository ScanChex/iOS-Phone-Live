//
//  CheckPointDTO.m
//  VeriScanQR
//
//  Created by Rajeel Amjad on 02/05/2014.
//  Copyright (c) 2014 Adnan Ahmad. All rights reserved.
//

#import "CheckPointDTO.h"
@interface CheckPointDTO()


@end
@implementation CheckPointDTO
@synthesize checkpoint_id = _checkpoint_id;
@synthesize description = _description;
@synthesize qr_code = _qr_code;
@synthesize time = _time;
@synthesize alert_time = _alert_time;
+(id)initWithCheckPointInfo:(NSDictionary *)info{
    
    return [[[self alloc] initWithDictionary:info] autorelease];
}
-(void)updateWithDictionary:(NSDictionary *)dictionary{
    
    self.checkpoint_id=[dictionary valueForKey:@"checkpoint_id"];
    self.description=[dictionary valueForKey:@"description"];
    self.qr_code=[dictionary valueForKey:@"qr_code"];
    self.time=[dictionary valueForKey:@"time"];
    self.alert_time=[dictionary valueForKey:@"alert_time"];
}

-(void)dealloc{
    
    [_checkpoint_id release];
    [_description release];
    [_qr_code release];
    [_alert_time release];
    [_time release];
    [super dealloc];
}
@end
