//
//  DocumentDTO.m
//  VeriScanQR
//
//  Created by Adnan Ahmad on 09/01/2013.
//  Copyright (c) 2013 Adnan Ahmad. All rights reserved.
//

#import "DocumentDTO.h"

@implementation DocumentDTO

@synthesize subject=_subject;
@synthesize link=_link;

+(id)initWithDocument:(NSDictionary *)document{

    return [[[self alloc] initWithDictionary:document] autorelease];
}

-(void)updateWithDictionary:(NSDictionary *)dictionary{

    self.subject=[dictionary objectForKey:@"subject"];
    self.link=[dictionary objectForKey:@"link"];

}
-(void)dealloc{

    [_subject release];
    [_link release];
    [super dealloc];
}
@end
