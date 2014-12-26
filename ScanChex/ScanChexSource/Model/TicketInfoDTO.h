//
//  TicketInfoDTO.h
//  VeriScanQR
//
//  Created by Adnan Ahmad on 09/01/2013.
//  Copyright (c) 2013 Adnan Ahmad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseDTO.h"
@interface TicketInfoDTO : BaseDTO

@property (nonatomic,retain) NSString *startTime;
@property (nonatomic,retain) NSString *tblTicketID;
@property (nonatomic,retain) NSString *technicain;
@property (nonatomic,retain) NSString *ticketID;
@property (nonatomic,retain) NSString *ticketStatus;
@property (nonatomic,retain) NSString *overDue;
@property (nonatomic,retain) NSString *startDate;
@property (nonatomic,retain) NSString *toleranceDate;
@property (nonatomic,retain) NSString *isService;
@property (nonatomic,retain) NSString *numberOfScans;
@property (nonatomic,retain) NSString * photoUrl;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSString * ticket_start_time;
@property (nonatomic, retain) NSString * ticket_end_time;
@property (nonatomic, retain) NSString * ticket_total_time;
@property (nonatomic, assign) BOOL allow_id_card_scan;
@property (nonatomic, retain) NSString * ticket_type;
@property (nonatomic, retain) NSString * employee;
@property (nonatomic, retain) NSString *is_questions;
@property (nonatomic, retain) NSString *suspended_by;

+(id)initWithTicketInfo:(NSDictionary *)info;
@end
