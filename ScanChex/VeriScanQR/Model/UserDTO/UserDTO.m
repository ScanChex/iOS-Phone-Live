//
//  UserDTO.m
//  VeriScanQR
//
//  Created by Adnan Ahmad on 16/12/2012.
//  Copyright (c) 2012 Adnan Ahmad. All rights reserved.
//

#import "UserDTO.h"

@implementation UserDTO


@synthesize name=_name;
@synthesize logo=_logo;
@synthesize masterKey=_masterKey;
@synthesize exist=_exist;
@synthesize messageList=_messageList;
@synthesize levelID=_levelID;
@synthesize company_user = _company_user;
@synthesize employee_card_id = _employee_card_id;
@synthesize session_id = _session_id;
+(id)userWithDictionary:(NSDictionary *)dictionary{

    return [[[self alloc] initWithDictionary:dictionary] autorelease];
}
-(void)updateWithDictionary:(NSDictionary *)dict{

    self.name=[dict valueForKey:@"full_name"];
    self.logo=[dict valueForKey:@"logo"];
    self.masterKey=[[dict valueForKey:@"master_key"] intValue];
    self.exist=[[dict valueForKey:@"exist"] intValue];
    self.messageList=[NSArray arrayWithArray:[dict valueForKey:@"msg"]];
    self.levelID=[dict valueForKey:@"level_id"];
    self.company_user = [dict valueForKey:@"company_user"];
    self.employee_card_id = [dict valueForKey:@"employee_card_id"];
    self.session_id = [dict valueForKey:@"session_id"];
    
}

/* This code has been added to support encoding and decoding my objecst */

-(void)encodeWithCoder:(NSCoder *)encoder
{
  //Encode the properties of the object
  [encoder encodeObject:self.name forKey:@"name"];
  [encoder encodeObject:self.logo forKey:@"logo"];
  [encoder encodeObject:[NSString stringWithFormat:@"%d",  self.masterKey] forKey:@"master_key"];
  [encoder encodeObject:[NSString stringWithFormat:@"%d",  self.exist] forKey:@"exist"];
  [encoder encodeObject:self.messageList forKey:@"messageList"];
  [encoder encodeObject:self.levelID forKey:@"levelID"];
  [encoder encodeObject:self.company_user forKey:@"company_user"];
  [encoder encodeObject:self.employee_card_id forKey:@"employee_card_id"];
  [encoder encodeObject:self.session_id forKey:@"session_id"];
  
}

-(id)initWithCoder:(NSCoder *)decoder
{
  self = [super init];
  if ( self != nil )
  {
    //decode the properties
    self.name = [decoder decodeObjectForKey:@"name"];
    self.logo = [decoder decodeObjectForKey:@"logo"];
    self.masterKey = [[decoder decodeObjectForKey:@"master_key"] integerValue];
    self.exist = [[decoder decodeObjectForKey:@"exist"] integerValue];
    self.messageList = [decoder decodeObjectForKey:@"messageList"];
    self.levelID = [decoder decodeObjectForKey:@"levelID"];
    self.company_user = [decoder decodeObjectForKey:@"company_user"];
    self.employee_card_id = [decoder decodeObjectForKey:@"employee_card_id"];
    self.session_id = [decoder decodeObjectForKey:@"session_id"];
    
  
  }
  return self;
}

-(void)dealloc{

    [self.name release];
    [self.logo release];
    [self.messageList release];
    [self.company_user release];
    
    [super dealloc];
}
@end
