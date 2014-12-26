//
//  MessageDTO.h
//  VeriScanQR
//
//  Created by Adnan Ahmad on 07/01/2014.
//  Copyright (c) 2014 Adnan Ahmad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageDTO : BaseDTO

//@property (retain, nonatomic) NSString *imgURL;

@property (assign, nonatomic) int height;

@property (retain, nonatomic) NSString *date_time;
@property (retain, nonatomic) NSString *message;
@property (retain, nonatomic) NSString *message_id;
@property (retain, nonatomic) NSString *receiver_id;
@property (retain, nonatomic) NSString *receiver_name;
@property (retain, nonatomic) NSString *receiver_photo;
@property (retain, nonatomic) NSString *sender_id;
@property (retain, nonatomic) NSString *sender_name;
@property (retain, nonatomic) NSString *sender_photo;


+(id)initWithMessage:(NSDictionary *)dict;

@end
