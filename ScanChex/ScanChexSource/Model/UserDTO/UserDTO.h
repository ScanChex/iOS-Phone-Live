//
//  UserDTO.h
//  VeriScanQR
//
//  Created by Adnan Ahmad on 16/12/2012.
//  Copyright (c) 2012 Adnan Ahmad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseDTO.h"

@interface UserDTO : BaseDTO

@property(nonatomic,retain)NSString *name;
@property(nonatomic,retain)NSString *logo;
@property(nonatomic,retain)NSString *levelID;
@property(nonatomic)NSInteger masterKey;
@property(nonatomic)NSInteger exist;
@property(nonatomic,retain)NSArray*messageList;
@property (nonatomic, retain) NSString * company_user;
@property (nonatomic, retain) NSString * employee_card_id;
@property (nonatomic, retain) NSString * session_id;

+(id)userWithDictionary:(NSDictionary *)dictionary;

@end
