//
//  VSSharedManager.h
//  VeriScanQR
//
//  Created by Adnan Ahmad on 16/12/2012.
//  Copyright (c) 2012 Adnan Ahmad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserDTO.h"
#import "TicketDTO.h"
#import "TicketInfoDTO.h"
@interface VSSharedManager : NSObject

@property (nonatomic, retain) UserDTO *currentUser;
@property (nonatomic,retain) NSMutableArray *ticketInfo;
@property (nonatomic,retain) TicketDTO *selectedTicket;
@property (nonatomic,retain) TicketInfoDTO *selectedTicketInfo;
@property (nonatomic,retain) NSString *userName;
@property (nonatomic, retain) NSString *historyID;
@property (nonatomic, assign) BOOL isPreview;
@property (nonatomic, assign) NSInteger CurrentSelectedSection;
@property (nonatomic,assign) NSInteger CurrentSelectedIndex;
@property (nonatomic, assign) BOOL isHistoryTab;

+(id)sharedManager;

-(void)openMapWithLocation:(TicketDTO *)address;

@end
