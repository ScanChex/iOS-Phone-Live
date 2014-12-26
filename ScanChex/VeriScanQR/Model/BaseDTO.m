//
//  BaseDTO.m
//  VeriScanQR
//
//  Created by Adnan Ahmad on 16/12/2012.
//  Copyright (c) 2012 Adnan Ahmad. All rights reserved.
//

#import "BaseDTO.h"

@implementation BaseDTO


-(id)initWithDictionary:(NSDictionary *)dictionary{
    
    self= [super init];
    if(self){
        
        [self updateWithDictionary:dictionary];
    }
    return self;
    
}
-(void)updateWithDictionary:(NSDictionary *)dictionary{

}
@end
