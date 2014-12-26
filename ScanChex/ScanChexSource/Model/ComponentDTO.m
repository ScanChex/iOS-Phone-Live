//
//  ComponentDTO.m
//  VeriScanQR
//
//  Created by Adnan Ahmad on 09/04/2013.
//  Copyright (c) 2013 Adnan Ahmad. All rights reserved.
//

#import "ComponentDTO.h"

@implementation ComponentDTO

@synthesize compID=_compID;
@synthesize itemID=_itemID;
@synthesize description=_description;
@synthesize qty=_qty;
@synthesize price=_price;
@synthesize totalPrice=_totalPrice;
@synthesize notes=_notes;


+(id)initWithComponent:(NSDictionary *)dict{

    return [[[self alloc] initWithDictionary:dict] autorelease];
}

-(void)updateWithDictionary:(NSDictionary *)dictionary{
    
    self.compID=[dictionary objectForKey:@"comp_id"];
    self.itemID=[dictionary objectForKey:@"item_id"];
    self.description=[dictionary objectForKey:@"comp_desc"];
    self.qty=[dictionary objectForKey:@"qty"];
    self.price=[dictionary objectForKey:@"price"];
    self.totalPrice=[dictionary objectForKey:@"comp_cost"];
    self.notes=[dictionary objectForKey:@"notes"];
    
}
@end
