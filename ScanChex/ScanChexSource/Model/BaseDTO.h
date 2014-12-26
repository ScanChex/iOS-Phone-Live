//
//  BaseDTO.h
//  VeriScanQR
//
//  Created by Adnan Ahmad on 16/12/2012.
//  Copyright (c) 2012 Adnan Ahmad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseDTO : NSObject

-(id)initWithDictionary:(NSDictionary *)dictionary;
-(void)updateWithDictionary:(NSDictionary *)dictionary;

@end
