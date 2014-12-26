//
//  TicketInfoDTO.m
//  VeriScanQR
//
//  Created by Adnan Ahmad on 09/01/2013.
//  Copyright (c) 2013 Adnan Ahmad. All rights reserved.
//

#import "TicketInfoDTO.h"

@implementation TicketInfoDTO

@synthesize startTime=_startTime;
@synthesize tblTicketID=_tblTicketID;
@synthesize technicain=_technicain;
@synthesize ticketID=_ticketID;
@synthesize ticketStatus=_ticketStatus;
@synthesize overDue=_overDue;
@synthesize startDate=_startDate;
@synthesize toleranceDate = _toleranceDate;
@synthesize isService = _isService;
@synthesize numberOfScans = _numberOfScans;
@synthesize photoUrl = _photoUrl;
@synthesize notes = _notes;
@synthesize ticket_start_time = _ticket_start_time;
@synthesize ticket_end_time = _ticket_end_time;
@synthesize ticket_total_time = _ticket_total_time;
@synthesize ticket_type = _ticket_type;
@synthesize employee = _employee;
@synthesize is_questions = _is_questions;
@synthesize suspended_by = _suspended_by;


+(id)initWithTicketInfo:(NSDictionary *)info{

    return [[[self alloc] initWithDictionary:info] autorelease];
}

-(void)updateWithDictionary:(NSDictionary *)dictionary{

    self.startTime=[dictionary valueForKey:@"start_time"];
    self.tblTicketID=[dictionary valueForKey:@"tbl_ticket_id"];
    self.technicain=[dictionary valueForKey:@"technician"];
    self.ticketID=[dictionary valueForKey:@"ticket_id"];
    self.ticketStatus=[dictionary valueForKey:@"ticket_status"];
    self.overDue=[NSString stringWithFormat:@"%@", [dictionary valueForKey:@"over_due"]];
    self.notes = [NSString stringWithFormat:@"%@", [dictionary valueForKey:@"notes"]];
    self.startDate =[dictionary valueForKey:@"start_date"];
    self.startTime =[dictionary valueForKey:@"start_time"];
    self.toleranceDate = [dictionary valueForKey:@"ticket_start_date"];
    self.isService = [dictionary valueForKey:@"is_service"];
    self.numberOfScans = [NSString stringWithFormat:@"%@",[dictionary valueForKey:@"no_of_scans"]];
    self.photoUrl = [dictionary valueForKey:@"photo"];
    self.ticket_start_time = [dictionary valueForKey:@"ticket_start_time"];
    self.ticket_end_time = [dictionary valueForKey:@"ticket_end_time"];
    self.ticket_total_time = [dictionary valueForKey:@"ticket_total_time"];
    self.employee = [dictionary valueForKey:@"employee"];
    
    if ([[dictionary valueForKey:@"allow_id_card_scan"] isEqualToString:@"Yes"]) {
        self.allow_id_card_scan = TRUE;
    }
    else {
        self.allow_id_card_scan = FALSE;
    }
    if ([dictionary valueForKey:@"ticket_type"]) {
        self.ticket_type = [dictionary valueForKey:@"ticket_type"];
    }
    self.is_questions = [dictionary valueForKey:@"is_questions"];
    self.suspended_by = [dictionary valueForKey:@"suspended_by"];
    
}

-(void)dealloc{

    [_numberOfScans release];
    [_startTime release];
    [_tblTicketID release];
    [_technicain release];
    [_ticketID release];
    [_ticketStatus release];
    [_overDue release];
    [_photoUrl release];
    [super dealloc];
}
@end
