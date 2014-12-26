//
//  MessageDTO.m
//  VeriScanQR
//
//  Created by Adnan Ahmad on 07/01/2014.
//  Copyright (c) 2014 Adnan Ahmad. All rights reserved.
//

#import "MessageDTO.h"

@implementation MessageDTO
//@synthesize imgURL = _imgURL;
@synthesize message = _message;
@synthesize height = _height;


@synthesize date_time = _date_time;
@synthesize message_id = _message_id;
@synthesize receiver_id = _receiver_id;
@synthesize receiver_name = _receiver_name;
@synthesize receiver_photo = _receiver_photo;
@synthesize sender_id = _sender_id;
@synthesize sender_name = _sender_name;
@synthesize sender_photo = _sender_photo;




+(id)initWithMessage:(NSDictionary *)dict
{
    return [[[self alloc] initWithDictionary:dict] autorelease];
    
}

-(void)updateWithDictionary:(NSDictionary *)dictionary
{
//    self.imgURL = [dictionary objectForKey:@"image_url"];
    self.message = [dictionary objectForKey:@"message"];
    self.height = [dictionary objectForKey:@"height"];
    self.message_id = [dictionary objectForKey:@"message_id"];
    self.receiver_id = [dictionary objectForKey:@"receiver_id"];
    self.receiver_name = [dictionary objectForKey:@"receiver_name"];
    self.receiver_photo = [dictionary objectForKey:@"receiver_photo"];
    self.sender_id = [dictionary objectForKey:@"sender_id"];
    self.sender_name = [dictionary objectForKey:@"sender_name"];
    self.sender_photo = [dictionary objectForKey:@"sender_photo"];
    self.date_time = [dictionary valueForKey:@"date_time"];
    
    
}

-(void)dealloc
{
//    [_imgURL release];
    [_message release];
    [_date_time release];
    [_message_id release];
    [_receiver_id release];
    [_receiver_name release];
    [_receiver_photo release];
    [_sender_id release];
    [_sender_name release];
//    [_sender_photo release];
    [super dealloc];
}

@end
