//
//  ExtraTicketInfoDTO.m
//  VeriScanQR
//
//  Created by Adnan Ahmad on 09/04/2013.
//  Copyright (c) 2013 Adnan Ahmad. All rights reserved.
//

#import "ExtraTicketInfoDTO.h"
#import "ComponentDTO.h"
#import "ServiceDTO.h"
@interface ExtraTicketInfoDTO ()

-(void)updateComponents:(NSMutableArray *)array;
-(void)updateServices:(NSMutableArray *)array;
@end

@implementation ExtraTicketInfoDTO

@synthesize customerName =_customerName;
@synthesize contactName=_contactName;
@synthesize modelNumber=_modelNumber;
@synthesize description=_description;
@synthesize serialNumber=_serialNumber;
@synthesize address=_address;
@synthesize telephone=_telephone;
@synthesize questionAmount=_questionAmount;
@synthesize documentAmount=_documentAmount;
@synthesize serviceList=_serviceList;
@synthesize componentsList=_componentsList;

+(id)initWithExtraTicketInfo:(NSDictionary *)dict{


    return [[[self alloc] initWithDictionary:dict] autorelease];
}


-(void)updateWithDictionary:(NSDictionary *)dictionary{

    
    self.customerName=[dictionary objectForKey:@"customer_name"];
    self.contactName=[dictionary objectForKey:@"contact_name"];
    self.modelNumber=[dictionary objectForKey:@"model_number"];
    self.description=[dictionary objectForKey:@"description"];
    self.serialNumber=[dictionary objectForKey:@"serial_number"];
    self.address=[dictionary objectForKey:@"address"];
    self.telephone=[dictionary objectForKey:@"telephone"];
    self.questionAmount=[dictionary objectForKey:@"question_amount"];
    self.documentAmount=[dictionary objectForKey:@"document_amount"];
    
    [self updateServices:[dictionary objectForKey:@"services"]];
   // [self updateComponents:[dictionary objectForKey:@"components"]];
   
}

-(void)updateComponents:(NSMutableArray *)array{

    self.componentsList=[NSMutableArray array];
    
    for (NSDictionary *dic in array) {
        
        [self.componentsList addObject:[ComponentDTO initWithComponent:dic]];
    }
}
-(void)updateServices:(NSMutableArray *)array{

    self.serviceList=[NSMutableArray array];
    for (NSDictionary* dic in array) {
        
        [self.serviceList addObject:[ServiceDTO serviceWithDictionary:dic]];
    }
}

-(void)dealloc{
    
    [_customerName release];
    [_contactName release];
    [_modelNumber release];
    [_description release];
    [_serialNumber release];
    [_address release];
    [_telephone release];
    [_questionAmount release];
    [_documentAmount release];
    [_serviceList release];
    [_componentsList release];
    [super dealloc];
}

@end
/*
 {
 "customer_name": "fname lname",
 "contact_name": "contact name",
 "model_number": null,
 "description": "des",
 "serial_number": "SER-34964",
 "address": "1343242 nw 7th street",
 "telephone": "9328948293432",
 "question_amount": "3",
 "document_amount": "1",
 "service": [
 "104-3243 - des",
 "3523-353 - des123"
 ],
 "components": [
 {
 "comp_id": "10",
 "itemid": "item2",
 "description": "des2",
 "qty": "2",
 "price": "47.00",
 "total_price": "94.00",
 "notes": "N\/A"
 },
 {
 "comp_id": "9",
 "itemid": "comp1",
 "description": "des1",
 "qty": "1",
 "price": "353.00",
 "total_price": "353.00",
 "notes": "hello worldss"
 },
 {
 "comp_id": "9",
 "itemid": "comp1",
 "description": "des1",
 "qty": "2",
 "price": "353.00",
 "total_price": "706.00",
 "notes": "hello worldss"
 }
 ]
 }

*/