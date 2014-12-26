//
//  CheckPointDTO.h
//  VeriScanQR
//
//  Created by Rajeel Amjad on 02/05/2014.
//  Copyright (c) 2014 Adnan Ahmad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseDTO.h"
@interface CheckPointDTO : BaseDTO
@property(nonatomic, retain) NSString *checkpoint_id;
@property(nonatomic, retain) NSString *description;
@property(nonatomic, retain) NSString * qr_code;
@property(nonatomic, retain) NSString * time;
@property(nonatomic, retain) NSString * alert_time;
+(id)initWithCheckPointInfo:(NSDictionary *)info;
@end
