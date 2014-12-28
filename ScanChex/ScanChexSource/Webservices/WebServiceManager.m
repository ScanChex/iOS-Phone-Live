//
//  WebServiceManager.m
//  VeriScanQR
//
//  Created by Adnan Ahmad on 15/12/2012.
//  Copyright (c) 2012 Adnan Ahmad. All rights reserved.
//

#import "WebServiceManager.h"
#import "ASIFormDataRequest.h"
#import "SBJSON.h"
#import "JSON.h"
#import "Constant.h"
#import "ASINetworkQueue.h"

#import "UserDTO.h"
#import "VSSharedManager.h"
#import "TicketDTO.h"
#import "DocumentDTO.h"
#import "HistoryDTO.h"
#import "QuestionDTO.h"
#import "ExtraTicketInfoDTO.h"
#import "AssetInfoDTO.h"
#import "ComponentDTO.h"

@implementation NSMutableArray (WeakReferences)
+ (id)mutableArrayUsingWeakReferences {
    return [self mutableArrayUsingWeakReferencesWithCapacity:0];
}

+ (id)mutableArrayUsingWeakReferencesWithCapacity:(NSUInteger)capacity {
    CFArrayCallBacks callbacks = {0, NULL, NULL, CFCopyDescription, CFEqual};
    // We create a weak reference array
    return (id)(CFArrayCreateMutable(0, capacity, &callbacks));
}
@end


@interface WebServiceManager()

- (id) init;
- (NSString*)generateCallId;

@property (atomic, retain) NSMutableArray *delegates;
@property (nonatomic, retain) NSMutableArray *delegatesToRemove;
@property(nonatomic,assign)int currentIndex;
- (ASIFormDataRequest *) createRequest:(NSURL *) url;
- (BOOL) checkForError:(NSDictionary *)responseDict;
- (BOOL) checkForErrorExceptDataKey:(NSDictionary *)responseDict;


@property (nonatomic, retain) ASINetworkQueue *queue;
/*if this is true we will bound calls with this delegate instead of let all user know, This is useful when many delegate impelemts same callbacks*/
@property (atomic, assign) id<WebServiceManagerDelegate> boundedCaller;
@property (atomic, retain) NSLock *lock;

- (void) informDelegatesOf:(SEL)selector withObject:(id)obj;
- (void) informDelegatesOf:(SEL)selector withObject:(id)obj boundedTo:(id)caller;
- (NSString *)cleanResponseString:(NSString *)responseString;

@end

@implementation WebServiceManager

@synthesize currentIndex=_currentIndex;
@synthesize delegates=_delegates;
@synthesize useQueue= _useQueue;
@synthesize queue=_queue;
@synthesize boundedCaller=_boundedCaller;
@synthesize lock=_lock;


static WebServiceManager *sharedInstance;


+ (WebServiceManager *) sharedManager{
    
    if(sharedInstance==nil)
    {
        
        sharedInstance= [[WebServiceManager alloc] init];
        sharedInstance.lock= [NSLock new];
    }
    
    return sharedInstance;
}

- (id) init
{
    self = [super init];
    if (self) {
        
        self.delegates = [NSMutableArray array];
        self.delegatesToRemove= [NSMutableArray array];
        self.queue= [[[ASINetworkQueue alloc] init] autorelease];
        [self.queue setMaxConcurrentOperationCount:1];
        [self.queue setShouldCancelAllRequestsOnFailure:NO];
        [self.queue go];
        
        self.useQueue= NO;
        
    }
    return self;
}

- (void)addDelegate:(id<WebServiceManagerDelegate>)aDelegate
{
    
    
    
    /*if we dont use blocks (seperate threads)  we can hit deadlocks as only main thread is involed atm*/
    
    void (^block)(void)=^{
        
        [self.lock lock];
        [self.delegates addObject:aDelegate];
        [self.lock unlock];
    };
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
    dispatch_async(queue,block);
    
}

- (void)removeDelegate:(id<WebServiceManagerDelegate>)aDelegate
{
    
    void (^block)(void)=^{
        
        [self.lock lock];
        [self.delegates removeObject:aDelegate];
        [self.lock unlock];
        
    };
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
    dispatch_async(queue,block);
    
    
}

- (void)cancelAllQueuedRequests{
    
    [self.queue cancelAllOperations];
}

- (void)boundCallsTo:(id<WebServiceManagerDelegate>) caller{
    
    if(_boundedCaller)
        ////DLog(@"WRONG TIMINGS FOR BOUNDING ..... ");
        
        self.boundedCaller= caller;
    
}
- (void)unboundCalls{
    
    _boundedCaller=nil;
}




- (BOOL) checkForError:(NSDictionary *)responseDict
{
    if(responseDict)
    {
        if([[responseDict objectForKey:STATUS] isKindOfClass:[NSString class]] && [[responseDict objectForKey:STATUS] isEqualToString:RESPONSE_FAIL])
            return YES;
        
        else if([[responseDict objectForKey:RESULT_KEY] isKindOfClass:[NSNull class]])
            return YES;
        
        else
            return NO;
    }
    
    else
        return YES;
}


- (BOOL) checkForErrorExceptDataKey:(NSDictionary *)responseDict
{
    if(responseDict)
    {
        if([[responseDict objectForKey:STATUS] isKindOfClass:[NSString class]] && [[responseDict objectForKey:STATUS] isEqualToString:RESPONSE_FAIL])
            return YES;
        
        else
            return NO;
    }
    
    else
        return YES;
}


- (void) informDelegatesOf:(SEL)selector withObject:(id)obj
{
    
    
    [self.lock lock];
    
    id delegate=nil;
    
    for(delegate in self.delegates)
    {
        if([delegate respondsToSelector:selector])
            [delegate performSelector:selector withObject:obj];
    }
    
    [self.lock unlock];

}


- (void) informDelegatesOf:(SEL)selector withObject:(id)obj boundedTo:(id)caller{
    
    if(caller){
        
        if([caller respondsToSelector:selector])
            [caller performSelector:selector withObject:obj];
    }
    
    else
        [self informDelegatesOf:selector withObject:obj];
    
}



- (ASIFormDataRequest *)createRequest:(NSURL *) url
{
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request addRequestHeader:@"charset" value:@"utf-8"];
    [request addRequestHeader:@"Data-Type" value:@"text"];
    
    return request;
}



- (NSString *)cleanResponseString:(NSString *)responseString{
    
    NSString *fixedString=nil;
    
    NSRange startIndex=[responseString rangeOfString:@"{"];
    
    if (startIndex.location!=NSNotFound) {
        
        fixedString = [responseString substringFromIndex:startIndex.location];
    }
    
    return fixedString;
}


- (NSString*)generateCallId {
    
    return [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
}



-(void)loginWithCustomerID:(NSString *)customerId userID:(NSString *)userID password:(NSString *)password withCompletionHandler:(CompletionHandler)block{
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/veriscanAPI.php",BASE_URL]];
    
    __block  ASIFormDataRequest *request = [self createRequest:url];
    
    [request setRequestMethod:@"POST"];
    [request setPostValue:customerId forKey:@"company_id"];
    [request setPostValue:userID forKey:@"username"];
    [request setPostValue:password forKey:@"password"];
    [request setPostValue:[[[UIDevice currentDevice] identifierForVendor] UUIDString] forKey:@"uuid"];
    NSString * tempString  =[[NSUserDefaults standardUserDefaults] objectForKey:@"apns_device_token"];
    [request setPostValue:tempString forKey:@"device_token"];
//    UIAlertView * tempAlert = [[UIAlertView alloc] initWithTitle:@"DeviceToken login" message:tempString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    [tempAlert show];
    
    [request setPostValue:@"iphone" forKey:@"device_type"];
    [request setPostValue:@"login" forKey:@"action"];
//    UIAlertView * tempAlert1 = [[UIAlertView alloc] initWithTitle:@"DeviceToken login" message:[request postData] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    [tempAlert1 show];
    [request setCompletionBlock:^{
        
        NSString *response =[request responseString];
//        UIAlertView * tempAlert = [[UIAlertView alloc] initWithTitle:@"DeviceToken login" message:response delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [tempAlert show];
        
        NSDictionary *rootDictionary = [response JSONValue];
        DLog(@"Response %@",response);
        
        
        if ([[[rootDictionary valueForKey:@"exist"] stringValue] isEqualToString:@"1"]) {
            
            //Populate UserIfo In UserDTO.
            [[VSSharedManager sharedManager] setCurrentUser:[UserDTO userWithDictionary:rootDictionary]];
            
            ///Block Calling
            dispatch_async(dispatch_get_main_queue(), ^{
                
                block(rootDictionary,NO);
            });
            
        }
        else if ([[[rootDictionary valueForKey:@"exist"] stringValue] isEqualToString:@"0"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                block([rootDictionary valueForKey:@"message"],YES);
            });
        }
        else{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                block(@"Enter valid credentials",YES);
            });
            
        }
        
        
    }];
    
    [request setFailedBlock:^{
        
        NSLog(@"Response String %@",[request responseString]);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            block(@"Check your internet connection",YES);
        });
        
        
    }];
    
    [request startAsynchronous];
}

-(void)resetPassword:(NSString *)companyID username:(NSString *)name withCompletionHandler:(CompletionHandler)block{
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/veriscanAPI.php",BASE_URL]];
    
    __block  ASIFormDataRequest *request = [self createRequest:url];
    
    [request setRequestMethod:@"POST"];
    [request setPostValue:companyID forKey:@"company_id"];
    [request setPostValue:name forKey:@"username"];
    [request setPostValue:@"reset_password" forKey:@"action"];
    [request setCompletionBlock:^{
        
        NSString *response = [request responseString];
        NSDictionary *rootDictionary = [response JSONValue];
        
        if ([[rootDictionary valueForKey:@"error"] length]>0) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                block([rootDictionary valueForKey:@"error"],YES);
            });
            
        }
        else
        {
            [[VSSharedManager sharedManager] setCurrentUser:[UserDTO userWithDictionary:rootDictionary]];
            
            ///Block Calling
            dispatch_async(dispatch_get_main_queue(), ^{
                block(@"Password reset successfully check your email",NO);
            });
            
        }
        
    }];
    
    [request setFailedBlock:^{
        
        NSString *response = [request responseString];
        NSDictionary *rootDictionary = [response JSONValue];
        
        ///Block Calling
        dispatch_async(dispatch_get_main_queue(), ^{
            
            block([rootDictionary objectForKey:@"error"],YES);
        });
        
    }];
    
    [request startAsynchronous];
}


-(void)scanTicket:(NSString *)ticketID
          assetID:(NSString *)assetId
         latitude:(NSString *)lat
        longitude:(NSString *)lon
        masterKey:(NSString *)masterKey
         userName:(NSString *)userName
      handsetMake:(NSString *)handset
               os:(NSString *)os
      modelNumber:(NSString *)modelNumber
     serialNumber:(NSString *)serialNumber
withCompletionHandler:(CompletionHandler)block
{
    
    
    

    //$_POST=array('action'=>'scan_ticket','ticket_id'=>'1','asset_id'=>0,'latitude'=>0,'longitude'=>0,'master_key'=>0,'username'=>0);
    
    //array('action'=>'scan_ticket','ticket_id'=>1,'asset_id'=>34,'latitude'=>'25.7554502','longitude'=>'-80.2583244','master_key'=>18,'username'=>'jbrown','handset_make'=>'Apple','os'=>'6.1','model_no'=>'iPhone Simulator','serial_number'=>'94741C06-1518-4385-BDD5-2B866C25949C');

    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/veriscanAPI.php",BASE_URL]];
    
    __block  ASIFormDataRequest *request = [self createRequest:url];
    
    [request setRequestMethod:@"POST"];
    [request setPostValue:ticketID forKey:@"ticket_id"];
    [request setPostValue:@"scan_ticket" forKey:@"action"];
    [request setPostValue:assetId forKey:@"asset_id"];
    [request setPostValue:lat forKey:@"latitude"];
    [request setPostValue:lon forKey:@"longitude"];
    [request setPostValue:handset forKey:@"handset_make"];
    [request setPostValue:os forKey:@"os"];
    [request setPostValue:modelNumber forKey:@"model_no"];
    [request setPostValue:serialNumber forKey:@"serial_number"];
    [request setPostValue:masterKey forKey:@"master_key"];
    [request setPostValue:userName forKey:@"username"];
    [request setCompletionBlock:^{
        
        NSString *response = [request responseString];
        NSDictionary *rootDictionary = [response JSONValue];
        
        DLog(@"Ticket response %@",response);
      
        if ([[rootDictionary valueForKey:@"error"] length]>0) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                block([rootDictionary valueForKey:@"error"],YES);
            });
            
        }
        else
        {
            ///Block Calling
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [[VSSharedManager sharedManager] setHistoryID:[NSString stringWithFormat:@"%@",[rootDictionary objectForKey:@"history_id"]]];
                block(rootDictionary,NO);
            });
        }
        
    }];
    
    [request setFailedBlock:^{
        
        NSString *response = [request responseString];
        NSDictionary *rootDictionary = [response JSONValue];
        ///Block Calling
        dispatch_async(dispatch_get_main_queue(), ^{
            
            block([rootDictionary objectForKey:@"error"],YES);
        });
    }];
    
    [request startAsynchronous];
    
    
}

-(void)scanCheckPointTicket:(NSString *)ticketID
                    assetID:(NSString *)assetId
                   latitude:(NSString *)lat
                  longitude:(NSString *)lon
                  masterKey:(NSString *)masterKey
                   userName:(NSString *)userName
               checkPointID:(NSString *)checkPointID
      withCompletionHandler:(CompletionHandler)block {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/veriscanAPI.php",BASE_URL]];
    
    __block  ASIFormDataRequest *request = [self createRequest:url];
    
    [request setRequestMethod:@"POST"];
    [request setPostValue:ticketID forKey:@"ticket_id"];
    [request setPostValue:@"scan_checkpoint" forKey:@"action"];
    [request setPostValue:assetId forKey:@"asset_id"];
    [request setPostValue:lat forKey:@"latitude"];
    [request setPostValue:lon forKey:@"longitude"];
    [request setPostValue:masterKey forKey:@"master_key"];
    [request setPostValue:userName forKey:@"username"];
    [request setPostValue:checkPointID forKey:@"checkpoint_id"];
    [request setCompletionBlock:^{
        
        NSString *response = [request responseString];
        NSDictionary *rootDictionary = [response JSONValue];
        
        DLog(@"Ticket response %@",response);
        
        if ([[rootDictionary valueForKey:@"error"] length]>0) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                block([rootDictionary valueForKey:@"error"],YES);
            });
            
        }
        else
        {
            ///Block Calling
            dispatch_async(dispatch_get_main_queue(), ^{
                
                block (rootDictionary,NO);
            });
        }
        
    }];
    
    [request setFailedBlock:^{
        
        NSString *response = [request responseString];
        NSDictionary *rootDictionary = [response JSONValue];
        ///Block Calling
        dispatch_async(dispatch_get_main_queue(), ^{
            
            block([rootDictionary objectForKey:@"error"],YES);
        });
    }];
    
    [request startAsynchronous];
}
-(void)getExtraTicketInformation:(NSString *)masterkey assetID:(NSString *)assetID withCompletionHandler:(CompletionHandler)block{
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/veriscanAPI.php",BASE_URL]];
    
    __block  ASIFormDataRequest *request = [self createRequest:url];
    
    [request setRequestMethod:@"POST"];
    [request setPostValue:masterkey forKey:@"master_key"];
    [request setPostValue:assetID forKey:@"asset_id"];
    [request setPostValue:@"extra_ticket_info" forKey:@"action"];
    [request setCompletionBlock:^{
        
        NSString *response = [request responseString];
        NSDictionary *rootDictionary = [response JSONValue];
        
        DLog(@"getExtraTicketInformation response %@",response);
        if ([[rootDictionary valueForKey:@"error"] length]>0) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                block([rootDictionary valueForKey:@"error"],YES);
            });
            
        }
        else
        {
            
            ///Block Calling
            dispatch_async(dispatch_get_main_queue(), ^{
                
                block([ExtraTicketInfoDTO initWithExtraTicketInfo:rootDictionary],NO);
            });
        }
        
        
    }];
    
    [request setFailedBlock:^{
        
        NSString *response = [request responseString];
        NSDictionary *rootDictionary = [response JSONValue];
        
        ///Block Calling
        dispatch_async(dispatch_get_main_queue(), ^{
            
            block([rootDictionary objectForKey:@"error"],YES);
        });
        
    }];
    
    [request startAsynchronous];
    
}


-(void)getTicketServices:(NSString *)masterkey ticketID:(NSString *)ticketID withCompletionHandler:(CompletionHandler)block
{


    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/veriscanAPI.php",BASE_URL]];
    
    __block  ASIFormDataRequest *request = [self createRequest:url];
    
    [request setRequestMethod:@"POST"];
    [request setPostValue:masterkey forKey:@"master_key"];
    [request setPostValue:ticketID forKey:@"ticket_id"];
    [request setPostValue:@"get_ticket_services" forKey:@"action"];
    [request setCompletionBlock:^{
        
        NSString *response = [request responseString];
        NSDictionary *rootDictionary = [response JSONValue];
        
        DLog(@"response %@",response);
        if ([[rootDictionary valueForKey:@"error"] length]>0) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                block([rootDictionary valueForKey:@"error"],YES);
            });
            
        }
        else
        {
            
            ///Block Calling
            dispatch_async(dispatch_get_main_queue(), ^{
                
                block([ExtraTicketInfoDTO initWithExtraTicketInfo:rootDictionary],NO);
            });
        }
        
        
    }];
    
    [request setFailedBlock:^{
        
        NSString *response = [request responseString];
        NSDictionary *rootDictionary = [response JSONValue];
        
        ///Block Calling
        dispatch_async(dispatch_get_main_queue(), ^{
            
            block([rootDictionary objectForKey:@"error"],YES);
        });
        
    }];
    
    [request startAsynchronous];


}

-(void)getQuetsions:(NSString *)masterkey assetID:(NSString *)assetID tikcetID:(NSString*)ticketID withCompletionHandler:(CompletionHandler)block{
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/veriscanAPI.php",BASE_URL]];
    
    __block  ASIFormDataRequest *request = [self createRequest:url];
    
    [request setRequestMethod:@"POST"];
    [request setPostValue:masterkey forKey:@"master_key"];
    [request setPostValue:assetID forKey:@"asset_id"];
    [request setPostValue:ticketID forKey:@"ticket_id"];
    [request setPostValue:@"show_questions1" forKey:@"action"];
    [request setCompletionBlock:^{
        
        NSString *response = [request responseString];
        DLog(@"Questions %@",response);
        NSMutableArray *rootDictionary = [response JSONValue];
        
        
        NSString *word=@"error";
        if ([response rangeOfString:word].location != NSNotFound) {
            
            NSMutableDictionary *rootDictionary1 = [response JSONValue];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                block([rootDictionary1 valueForKey:@"error"],YES);
            });
            
        }
        else{
            
           NSMutableArray *questions=[NSMutableArray array];
            for (NSDictionary *dict in rootDictionary)
               [questions addObject:[QuestionDTO initwithQuestion:dict]];
        
            ///Block Calling
            dispatch_async(dispatch_get_main_queue(), ^{
                block(questions,NO);
         });
        }
    }];
    
    [request setFailedBlock:^{
        
        NSString *response = [request responseString];
        NSDictionary *rootDictionary = [response JSONValue];
        
        ///Block Calling
        dispatch_async(dispatch_get_main_queue(), ^{
            
            block([rootDictionary objectForKey:@"error"],YES);
        });
        
    }];
    
    [request startAsynchronous];
    
}

-(void)getTickets:(NSString *)masterKey
         fromDate:(NSString *)fromData
           toDate:(NSString *)toDate
         userName:(NSString *)userName
withCompletionHandler:(CompletionHandler)block{
    
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/veriscanAPI.php",BASE_URL]];
    
    __block  ASIFormDataRequest *request = [self createRequest:url];
    
    [request setRequestMethod:@"POST"];
    [request setPostValue:masterKey forKey:@"master_key"];
    [request setPostValue:userName forKey:@"username"];
    [request setPostValue:@"show_tickets" forKey:@"action"];
    [request setCompletionBlock:^{
        
        
        NSString *response = [request responseString];
        NSMutableDictionary *ticketsArray = [response JSONValue];
        
        DLog(@"Ticekts Response %@",response);
        
        if ([[ticketsArray valueForKey:@"error"] length]>0) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                block([ticketsArray valueForKey:@"error"],YES);
            });
        }
        else
        {
            ////add Ticket Model
            NSMutableArray *ticketsData=[NSMutableArray array];
            
            NSArray *keys=[ticketsArray allKeys];
            
            DLog(@"%@",keys);
            
            for (int i=0; i<[keys count]; i++) {
                
                if ([[keys objectAtIndex:i] isEqualToString:@"route_order"] || [[keys objectAtIndex:i] isEqualToString:@"default_address"]) {
                    
                }
                else
                {
                    TicketDTO *ticketData=[TicketDTO initWithTicketDTO:[ticketsArray objectForKey:[keys objectAtIndex:i]]];
                    [ticketsData addObject:ticketData];
                }
            }
            [[VSSharedManager sharedManager] setTicketInfo:ticketsData];
            ///Block Calling
            dispatch_async(dispatch_get_main_queue(), ^{
                
                block(ticketsData,NO);
            });
        }
        
    }];
    
    [request setFailedBlock:^{
        
        ///Block Calling
        dispatch_async(dispatch_get_main_queue(), ^{
            block(@"Check your internet connection",YES);
        });
    }];
    
    [request startAsynchronous];
    
}

-(void)showDocuments:(NSString *)masterKey assetID:(NSString *)assetID withCompletionHandler:(CompletionHandler)block{
    
    
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/veriscanAPI.php",BASE_URL]];
    
    __block  ASIFormDataRequest *request = [self createRequest:url];
    
    [request setRequestMethod:@"POST"];
    [request setPostValue:masterKey forKey:@"master_key"];
    [request setPostValue:assetID forKey:@"asset_id"];
    [request setPostValue:@"show_documents1" forKey:@"action"];
    [request setCompletionBlock:^{
        
        NSString *response = [request responseString];
        NSDictionary *rootDictionary = [response JSONValue];
        NSMutableArray* array=[NSMutableArray array];
         NSMutableArray* array1=[NSMutableArray array];
        
        for (NSDictionary *dict in [rootDictionary objectForKey:@"non_fillable"]) {
            
            DocumentDTO *document=[DocumentDTO initWithDocument:dict];
            [array addObject:document];
        }
        for (NSDictionary *dict in [rootDictionary objectForKey:@"fillable"]) {
            
            DocumentDTO *document=[DocumentDTO initWithDocument:dict];
            [array1 addObject:document];
        }
        NSMutableArray* array2=[NSMutableArray array];
        [array2 addObject:array];
        [array2 addObject:array1];
        ///Block Calling
        dispatch_async(dispatch_get_main_queue(), ^{
            block(array2,NO);
        });
    }];
    
    [request setFailedBlock:^{
        
        NSString *response = [request responseString];
        NSDictionary *rootDictionary = [response JSONValue];
        ///Block Calling
        dispatch_async(dispatch_get_main_queue(), ^{
            
            block([rootDictionary objectForKey:@"error"],YES);
        });
    }];
    
    [request startAsynchronous];
    
    
}


-(void)showHistory:(NSString *)masterKey ticketID:(NSString *)ticketID withCompletionHandler:(CompletionHandler)handler{
    
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/veriscanAPI.php",BASE_URL]];
    
    __block  ASIFormDataRequest *request = [self createRequest:url];
    
    [request setRequestMethod:@"POST"];
    [request setPostValue:masterKey forKey:@"master_key"];
    [request setPostValue:ticketID forKey:@"asset_id"];
    [request setPostValue:@"show_history" forKey:@"action"];
    [request setCompletionBlock:^{
        
        NSString *response = [request responseString];
        
        
        DLog(@"Response String %@",response);
        NSMutableArray *rootDictionary = [response JSONValue];
        
                ///Block Calling
        dispatch_async(dispatch_get_main_queue(), ^{
         
            NSMutableArray* array=[NSMutableArray array];
    
            for (NSDictionary *dict in rootDictionary) {
                
                HistoryDTO *history=[HistoryDTO initWithHistoryData:dict];
                [array addObject:history];
            }
            
            handler(array,NO);
        });
    }];
    
    [request setFailedBlock:^{
        
        NSString *response = [request responseString];
        NSDictionary *rootDictionary = [response JSONValue];
        ///Block Calling
        dispatch_async(dispatch_get_main_queue(), ^{
            
            handler([rootDictionary objectForKey:@"error"],YES);
        });
    }];
    
    [request startAsynchronous];
    
    
}

-(void)updateLocation:(NSString *)username
            masterKey:(NSString *)masterKey
              assetId:(NSString *)assetID
           deviceMake:(NSString *)deviceMake
          deviceModel:(NSString *)model
             deviceOS:(NSString *)deviceOS
             deviceID:(NSString *)deviceID
             latitude:(NSString *)lat
            longitude:(NSString *)lon
                speed:(NSString *)speed
       batteryStatus:(NSString *)batteryStatus
withCompletionHandler:(CompletionHandler)block
{
    
    
    //$_POST=array('action'=>'update_user_location','username'=>'jim','master_key'=>136,'latitude'=>20,'longitude'=>-80,'device_make'=>'make','device_model'=>'model','device_os'=>'os','device_id'=>'id');

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/veriscanAPI.php",BASE_URL]];
    
    __block  ASIFormDataRequest *request = [self createRequest:url];
    
    [request setRequestMethod:@"POST"];
    [request setPostValue:masterKey forKey:@"master_key"];
    [request setPostValue:username forKey:@"username"];
    [request setPostValue:assetID forKey:@"asset_id"];
    [request setPostValue:lat forKey:@"latitude"];
    [request setPostValue:lon forKey:@"longitude"];
    [request setPostValue:deviceID forKey:@"device_id"];
    [request setPostValue:deviceMake forKey:@"device_make"];
    [request setPostValue:model forKey:@"device_model"];
    [request setPostValue:deviceOS forKey:@"device_os"];
    [request setPostValue:speed forKey:@"speed"];
    [request setPostValue:batteryStatus forKey:@"battery_status"];

    
    if ([[VSSharedManager sharedManager] selectedTicketInfo]) {
        [request setPostValue:[[VSSharedManager sharedManager] selectedTicketInfo].tblTicketID forKey:@"ticket_id"];
    }
    else {
        [request setPostValue:@"" forKey:@"ticket_id"];
    }
    [request setPostValue:[[VSSharedManager sharedManager] currentUser].session_id forKey:@"session_id"];
    [request setPostValue:@"iphone" forKey:@"handset_make"];
    

    [request setPostValue:@"update_user_location1" forKey:@"action"];
//    [request setPostValue:@"update_user_location" forKey:@"action"];
    
    [request setCompletionBlock:^{
        
        NSString *response = [request responseString];
        
      DLog(@"Response Update Location %@",response);
       
        NSDictionary *rootDictionary = [response JSONValue];
        ///Block Calling
        dispatch_async(dispatch_get_main_queue(), ^{
            block(rootDictionary,NO);
        });
    }];
    
    [request setFailedBlock:^{
        
        NSString *response = [request responseString];
        NSDictionary *rootDictionary = [response JSONValue];
        ///Block Calling
        dispatch_async(dispatch_get_main_queue(), ^{
            
            block([rootDictionary objectForKey:@"error"],YES);
        });
    }];
    
    [request startAsynchronous];
    
}

-(void)uploadVideo:(NSString *)masterKey
         historyID:(NSString *)historyID
       contentType:(NSString *)contentType
         videoData:(NSData*)video
       progressBar:(UIProgressView*)progress
withCompletionHandler:(CompletionHandler)handler

{
    
    DLog(@"Content Type %@",contentType);
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/veriscanAPI.php",BASE_URL]];
    __block  ASIFormDataRequest *request = [self createRequest:url];
    
    [request setRequestMethod:@"POST"];
    [request setPostValue:masterKey forKey:@"master_key"];
    [request setPostValue:historyID forKey:@"history_id"];
    [request setPostValue:@"upload" forKey:@"action"];
    [request setPostValue:@"video" forKey:@"type"];
    [request addData:video withFileName:[NSString stringWithFormat:@"video%@.mp4",[self generateCallId]] andContentType:contentType forKey:@"file"];
    [request setPostValue:[self generateCallId] forKey:@"file_name"];
    
    [request setUploadProgressDelegate:progress];
    [request setShowAccurateProgress:YES];
    
    [request setCompletionBlock:^{
        
        NSString *response = [request responseString];
        NSDictionary *rootDictionary = [response JSONValue];
        
        DLog(@"Response Success %@",response);
        ///Block Calling
        dispatch_async(dispatch_get_main_queue(), ^{
            handler(rootDictionary,NO);
        });
    }];
    
    [request setFailedBlock:^{
        
        NSString *response = [request responseString];
        NSDictionary *rootDictionary = [response JSONValue];
        
        DLog(@"Response Failed %@",response);

        if ([[rootDictionary valueForKey:@"error"] length]>0) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                handler([rootDictionary valueForKey:@"error"],YES);
            });
            
        }
        else
        {
            ///Block Calling
            dispatch_async(dispatch_get_main_queue(), ^{
            
                handler([rootDictionary objectForKey:@"error"],YES);
            });
        }
    }];
    
    [request startAsynchronous];
    
   
}


-(void)uploadAudio:(NSString *)masterKey
         historyID:(NSString *)historyID
       contentType:(NSString *)contentType
         audioData:(NSData*)audio
       progressBar:(UIProgressView*)progress
withCompletionHandler:(CompletionHandler)handler{
    
 
    DLog(@"Content Type %@",contentType);

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/veriscanAPI.php",BASE_URL]];
    
    __block  ASIFormDataRequest *request = [self createRequest:url];
    
    [request setRequestMethod:@"POST"];
    [request setPostValue:masterKey forKey:@"master_key"];
    [request setPostValue:historyID forKey:@"history_id"];
    [request setPostValue:@"upload" forKey:@"action"];
    [request setPostValue:@"voice" forKey:@"type"];
    [request addData:audio withFileName:[NSString stringWithFormat:@"audio%@.mp3",[self generateCallId]] andContentType:contentType forKey:@"file"];
    [request setPostValue:[self generateCallId] forKey:@"file_name"];
    
    [request setUploadProgressDelegate:progress];
    [request setShowAccurateProgress:YES];
    
    [request setCompletionBlock:^{
        
        NSString *response = [request responseString];
        NSDictionary *rootDictionary = [response JSONValue];
        
        DLog(@"response %@",response);
        
        if ([[rootDictionary valueForKey:@"error"] length]>0) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                handler([rootDictionary valueForKey:@"error"],YES);
            });
            
        }
        else
        {
            ///Block Calling
            dispatch_async(dispatch_get_main_queue(), ^{
                handler(rootDictionary,NO);
            });
        }
    }];
    
    [request setFailedBlock:^{
        
        NSString *response = [request responseString];
        NSDictionary *rootDictionary = [response JSONValue];
        ///Block Calling
        dispatch_async(dispatch_get_main_queue(), ^{
            
            handler([rootDictionary objectForKey:@"error"],YES);
        });
    }];
    
    [request startAsynchronous];
}

-(void)uploadImage:(NSString *)masterKey
         historyID:(NSString *)historyID
       contentType:(NSString *)contentType
         imageData:(NSData*)image
       progressBar:(UIProgressView*)progress
withCompletionHandler:(CompletionHandler)handler{
    
    DLog(@"Content Type %@",contentType);

    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/veriscanAPI.php",BASE_URL]];
    
    
    __block  ASIFormDataRequest *request = [self createRequest:url];
    
    [request setRequestMethod:@"POST"];
    [request setPostValue:masterKey forKey:@"master_key"];
    [request setPostValue:historyID forKey:@"history_id"];
    [request setPostValue:@"upload" forKey:@"action"];
    [request setPostValue:@"images" forKey:@"type"];
    [request addData:image withFileName:[NSString stringWithFormat:@"image%@.jpeg",[self generateCallId]] andContentType:contentType forKey:@"file"];
    [request setPostValue:[self generateCallId] forKey:@"file_name"];
    
    [request setUploadProgressDelegate:progress];
    [request setShowAccurateProgress:YES];
    
    [request setCompletionBlock:^{
        
        NSString *response = [request responseString];
        NSDictionary *rootDictionary = [response JSONValue];
        DLog(@"response %@",response);

        
        if ([[rootDictionary valueForKey:@"error"] length]>0) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                handler([rootDictionary valueForKey:@"error"],YES);
            });
            
        }
        else
        {

            ///Block Calling
            dispatch_async(dispatch_get_main_queue(), ^{
                handler(rootDictionary,NO);
            });
        }
    }];
    
    [request setFailedBlock:^{
        
        NSString *response = [request responseString];
        NSDictionary *rootDictionary = [response JSONValue];
        ///Block Calling
        dispatch_async(dispatch_get_main_queue(), ^{
            
            handler([rootDictionary objectForKey:@"error"],YES);
        });
    }];
    
    [request startAsynchronous];
}


-(void)uploadNotes:(NSString *)masterKey
         historyID:(NSString *)historyID
             notes:(NSString*)notes
withCompletionHandler:(CompletionHandler)handler

{
    
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/veriscanAPI.php",BASE_URL]];
        __block  ASIFormDataRequest *request = [self createRequest:url];
    
    [request setRequestMethod:@"POST"];
    [request setPostValue:masterKey forKey:@"master_key"];
    [request setPostValue:historyID forKey:@"history_id"];
    [request setPostValue:@"upload" forKey:@"action"];
    [request setPostValue:@"notes" forKey:@"type"];
    [request setPostValue:notes forKey:@"notes"];
   // [request addData:audio withFileName:[NSString stringWithFormat:@"audio%@.caf",[self generateCallId]] andContentType:@"multipart/form-data" forKey:@"file"];
    [request setPostValue:[self generateCallId] forKey:@"file_name"];
    
    [request setCompletionBlock:^{
        
        NSString *response = [request responseString];
        NSDictionary *rootDictionary = [response JSONValue];
        
        ///Block Calling
        dispatch_async(dispatch_get_main_queue(), ^{
            handler(rootDictionary,NO);
        });
    }];
    
    [request setFailedBlock:^{
        
        NSString *response = [request responseString];
        NSDictionary *rootDictionary = [response JSONValue];
        ///Block Calling
        dispatch_async(dispatch_get_main_queue(), ^{
            
            handler([rootDictionary objectForKey:@"error"],YES);
        });
    }];
    
    [request startAsynchronous];
}


-(void)uploadPdf:(NSString *)masterKey
       historyID:(NSString *)historyID
     contentType:(NSString *)contentType
         pdfData:(NSData*)pdf
     progressBar:(UIProgressView*)progress
withCompletionHandler:(CompletionHandler)handler {
    DLog(@"Content Type %@",contentType);
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/veriscanAPI.php",BASE_URL]];
    __block  ASIFormDataRequest *request = [self createRequest:url];
    
    [request setRequestMethod:@"POST"];
    [request setPostValue:masterKey forKey:@"master_key"];
    [request setPostValue:historyID forKey:@"history_id"];
    [request setPostValue:@"upload" forKey:@"action"];
    [request setPostValue:@"pdf" forKey:@"type"];
    [request addData:pdf withFileName:[NSString stringWithFormat:@"pdf%@.pdf",[self generateCallId]] andContentType:contentType forKey:@"file"];
    [request setPostValue:[self generateCallId] forKey:@"file_name"];
    
    [request setUploadProgressDelegate:progress];
    [request setShowAccurateProgress:YES];
    
    [request setCompletionBlock:^{
        
        NSString *response = [request responseString];
        NSDictionary *rootDictionary = [response JSONValue];
        
        DLog(@"Response Success %@",response);
        ///Block Calling
        dispatch_async(dispatch_get_main_queue(), ^{
            handler(rootDictionary,NO);
        });
    }];
    
    [request setFailedBlock:^{
        
        NSString *response = [request responseString];
        NSDictionary *rootDictionary = [response JSONValue];
        
        DLog(@"Response Failed %@",response);
        
        if ([[rootDictionary valueForKey:@"error"] length]>0) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                handler([rootDictionary valueForKey:@"error"],YES);
            });
            
        }
        else
        {
            ///Block Calling
            dispatch_async(dispatch_get_main_queue(), ^{
                
                handler([rootDictionary objectForKey:@"error"],YES);
            });
        }
    }];
    
    [request startAsynchronous];
}

-(void)upadteAnswers:(NSString *)masterKey
            questIDS:(NSMutableArray *)questIDS
             answers:(NSMutableArray *)answers
            ticketID:(NSString *)ticketID
withCompletionHandler:(CompletionHandler)handler

{

    
    NSString *questionIDS = [questIDS JSONRepresentation];
    NSString *selectedAnswers=[answers JSONRepresentation];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/veriscanAPI.php",BASE_URL]];
    __block  ASIFormDataRequest *request = [self createRequest:url];
    [request setRequestMethod:@"POST"];
    [request setPostValue:masterKey forKey:@"master_key"];
    [request setPostValue:questionIDS forKey:@"quest_id"];
    [request setPostValue:selectedAnswers forKey:@"answer"];
    [request setPostValue:ticketID forKey:@"ticket_id"];
    [request setPostValue:@"update_answer" forKey:@"action"];

    
    [request setCompletionBlock:^{
        
        
        NSString *response = [request responseString];
        NSDictionary *rootDictionary = [response JSONValue];
        ///Block Calling
        dispatch_async(dispatch_get_main_queue(), ^{
            handler(rootDictionary,NO);
        });
    }];
    
    [request setFailedBlock:^{
        
        NSString *response = [request responseString];
        NSDictionary *rootDictionary = [response JSONValue];
        ///Block Calling
        dispatch_async(dispatch_get_main_queue(), ^{
            handler([rootDictionary objectForKey:@"error"],YES);
        });
    }];
    
    [request startAsynchronous];
    
}

-(void)updateAdminLocation:(NSString *)assetID
                 masterKey:(NSString *)masterKey
                  latitude:(NSString *)lat
                 longitude:(NSString *)lon
     withCompletionHandler:(CompletionHandler)block
{
    
    //$_POST=array('action'=>'update_asset_location','latitude'=>'18.0023201','longitude'=>'-76.7881499','master_key'=>'136','asset_id'=>229);

    // NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/veriscanAPI.php",BASE_URL]];

    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/veriscanAPI.php",BASE_URL]];
    
    __block  ASIFormDataRequest *request = [self createRequest:url];
    
    [request setRequestMethod:@"POST"];
    [request setPostValue:masterKey forKey:@"master_key"];
    [request setPostValue:assetID forKey:@"asset_id"];
    [request setPostValue:lat forKey:@"latitude"];
    [request setPostValue:lon forKey:@"longitude"];
    [request setPostValue:@"update_asset_location" forKey:@"action"];
    [request setCompletionBlock:^{
        
        NSString *response = [request responseString];
        NSDictionary *rootDictionary = [response JSONValue];
        ///Block Calling
        dispatch_async(dispatch_get_main_queue(), ^{
            block(rootDictionary,NO);
        });
    }];
    
    [request setFailedBlock:^{
        
        NSString *response = [request responseString];
        NSDictionary *rootDictionary = [response JSONValue];
        ///Block Calling
        dispatch_async(dispatch_get_main_queue(), ^{
            
            block([rootDictionary objectForKey:@"error"],YES);
        });
    }];
    
    [request startAsynchronous];
    
}

-(void)updateAdminLocationORImage:(NSString *)latitude
                        longitude:(NSString *)longitude
                        masterKey:(NSString *)masterKey
                          assetID:(NSString *)assetID
                        imageData:(NSData *)imageData
                        companyID:(NSString *)companyID
                             type:(NSString*)type
                      progressBar:(UIProgressView *)progressView
            withCompletionHandler:(CompletionHandler)handler
{
    
    //$_POST=array('action'=>'update_asset_location_photo','latitude'=>'18.0023203','longitude'=>'-76.7881499','master_key'=>'136','asset_id'=>229,'upload_array'=>$_FILES['image'],'company_id'=>'US-0989864','type'=>'both OR location');
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/veriscanAPI.php",BASE_URL]];
    
    __block  ASIFormDataRequest *request = [self createRequest:url];
    
    [request setRequestMethod:@"POST"];
    [request setPostValue:masterKey forKey:@"master_key"];
    [request setPostValue:assetID forKey:@"asset_id"];
    [request setPostValue:latitude forKey:@"latitude"];
    [request setPostValue:longitude forKey:@"longitude"];
    [request setPostValue:type forKey:@"type"];
    [request setPostValue:@"update_asset_location_photo" forKey:@"action"];
    [request setPostValue:companyID forKey:@"company_id"];
    
    if ([[type lowercaseString] isEqualToString:@"both"]) {
        
        [request addData:imageData withFileName:[NSString stringWithFormat:@"image%@.jpeg",[self generateCallId]] andContentType:@"multipart/form-data" forKey:@"file"];
        [request setUploadProgressDelegate:progressView];
        [request setShowAccurateProgress:YES];
        
    }
    
    [request setCompletionBlock:^{
        
        NSString *response = [request responseString];
        NSDictionary *rootDictionary = [response JSONValue];
        ///Block Calling
        dispatch_async(dispatch_get_main_queue(), ^{
            handler(rootDictionary,NO);
        });
    }];
    
    [request setFailedBlock:^{
        
        NSString *response = [request responseString];
        NSDictionary *rootDictionary = [response JSONValue];
        ///Block Calling
        dispatch_async(dispatch_get_main_queue(), ^{
            
            handler([rootDictionary objectForKey:@"error"],YES);
        });
    }];
    
    [request startAsynchronous];
    
    
    
    
}


-(void)closeTicket:(NSString *)historyID ticketID:(NSString *)ticketID technician:(NSString*)technician employer:(NSInteger)master_id withCompletionHandler:(CompletionHandler)handler{


    ////$_POST=array('action'=>'close_scan_ticket','history_id'=>'5');

    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/veriscanAPI.php",BASE_URL]];
    
    __block  ASIFormDataRequest *request = [self createRequest:url];
    
    [request setRequestMethod:@"POST"];
       [request setPostValue:historyID forKey:@"history_id"];
    [request setPostValue:ticketID forKey:@"ticket_id"];
    [request setPostValue:technician forKey:@"employee"];
    [request setPostValue:[NSString stringWithFormat:@"%d",master_id] forKey:@"master_id"];

    [request setPostValue:@"close_scan_ticket" forKey:@"action"];
    [request setCompletionBlock:^{
        
        NSString *response = [request responseString];
        NSDictionary *rootDictionary = [response JSONValue];
        ///Block Calling
        dispatch_async(dispatch_get_main_queue(), ^{
            handler(rootDictionary,NO);
        });
    }];
    
    [request setFailedBlock:^{
        
        NSString *response = [request responseString];
        NSDictionary *rootDictionary = [response JSONValue];
        ///Block Calling
        dispatch_async(dispatch_get_main_queue(), ^{
            
            handler([rootDictionary objectForKey:@"error"],YES);
        });
    }];
    
    [request startAsynchronous];


}

//$_POST=array('action'=>'get_asset_info','master_key'=>'136','asset_id'=>229);

-(void)getAssetInfo:(NSString *)masterKey assetID:(NSString *)assetID withCompletionHandler:(CompletionHandler)handler{


    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/veriscanAPI.php",BASE_URL]];
    
    __block  ASIFormDataRequest *request = [self createRequest:url];
    
    [request setRequestMethod:@"POST"];
    [request setPostValue:masterKey forKey:@"master_key"];
    [request setPostValue:assetID forKey:@"asset_id"];
    [request setPostValue:@"get_asset_info" forKey:@"action"];
    [request setCompletionBlock:^{
        
        NSString *response = [request responseString];
        NSDictionary *rootDictionary = [response JSONValue];
        ///Block Calling
        dispatch_async(dispatch_get_main_queue(), ^{
            
            AssetInfoDTO *assetInfo =[AssetInfoDTO initWithAsset:rootDictionary];
            handler(assetInfo,NO);
            
        });
    }];
    
    [request setFailedBlock:^{
        
        NSString *response = [request responseString];
        NSDictionary *rootDictionary = [response JSONValue];
        ///Block Calling
        dispatch_async(dispatch_get_main_queue(), ^{
            
            handler([rootDictionary objectForKey:@"error"],YES);
        });
    }];
    
    [request startAsynchronous];



}

-(void)getComponents:(NSString *)masterKey serviceID:(NSString *)serviceID withCompletionHandler:(CompletionHandler)handler
{
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/veriscanAPI.php",BASE_URL]];
    
    __block  ASIFormDataRequest *request = [self createRequest:url];
    
    [request setRequestMethod:@"POST"];
    [request setPostValue:masterKey forKey:@"master_key"];
    [request setPostValue:serviceID forKey:@"service_id"];
    [request setPostValue:@"get_service_components" forKey:@"action"];
    [request setCompletionBlock:^{
        
        NSString *response = [request responseString];
        NSMutableDictionary *rootDictionary = [response JSONValue];
        
        NSMutableArray *components=[NSMutableArray array];
        ///Block Calling
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            for (NSDictionary *dict in [rootDictionary objectForKey:@"components"])
            {
                [components addObject:[ComponentDTO initWithComponent:dict]];
            }
            
            handler(components,NO);
        });
    }];
    
    [request setFailedBlock:^{
        
        NSString *response = [request responseString];
        NSDictionary *rootDictionary = [response JSONValue];
        ///Block Calling
        dispatch_async(dispatch_get_main_queue(), ^{
            
            handler([rootDictionary objectForKey:@"error"],YES);
        });
    }];
    
    [request startAsynchronous];


}
-(void)updateServiceStatus:(NSString *)serviceID status:(NSString *)status withCompletionHandler:(CompletionHandler)handler
{


    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/veriscanAPI.php",BASE_URL]];
    
    __block  ASIFormDataRequest *request = [self createRequest:url];
    
    [request setRequestMethod:@"POST"];
    [request setPostValue:status forKey:@"status"];
    [request setPostValue:serviceID forKey:@"service_id"];
    [request setPostValue:@"update_service_status" forKey:@"action"];
    [request setCompletionBlock:^{
        
        NSString *response = [request responseString];
        NSMutableDictionary *rootDictionary = [response JSONValue];
       
        if ([[rootDictionary valueForKey:@"error"] length]>0) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                handler([rootDictionary valueForKey:@"error"],YES);
            });
            
        }
        else
        {
            
            ///Block Calling
            dispatch_async(dispatch_get_main_queue(), ^{
                handler(rootDictionary,NO);
            });
        }
    
    }];
    
    [request setFailedBlock:^{
        
        NSString *response = [request responseString];
        NSDictionary *rootDictionary = [response JSONValue];
        ///Block Calling
        dispatch_async(dispatch_get_main_queue(), ^{
            
            handler([rootDictionary objectForKey:@"error"],YES);
        });
    }];
    
    [request startAsynchronous];
    

}

-(void)updateMessages:(NSString *)userName masterkey:(NSString *)masterKey withCompletionHandler:(CompletionHandler)handler
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/veriscanAPI.php",BASE_URL]];
    
    __block  ASIFormDataRequest *request = [self createRequest:url];
    
    [request setRequestMethod:@"POST"];
    [request setPostValue:masterKey forKey:@"master_key"];
    [request setPostValue:userName forKey:@"username"];
    [request setPostValue:@"get_updated_msg" forKey:@"action"];
    [request setCompletionBlock:^{
        
        NSString *response = [request responseString];

        NSMutableDictionary *messagesArray = [response JSONValue];
        
        ///Block Calling
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if ([[messagesArray valueForKey:@"msg"] isKindOfClass:[NSString class]]) {
                
                
                NSMutableArray *message =[NSMutableArray array];
                [message addObject:[messagesArray valueForKey:@"msg"]];
             
                handler(message,NO);

            }
            else
            {
            
                handler([messagesArray valueForKey:@"msg"],NO);
            }
        });
    }];
    
    [request setFailedBlock:^{
        
        NSString *response = [request responseString];
        NSDictionary *rootDictionary = [response JSONValue];
        ///Block Calling
        dispatch_async(dispatch_get_main_queue(), ^{
            
            handler([rootDictionary objectForKey:@"error"],YES);
        });
    }];
    
    [request startAsynchronous];

}

-(void)getMessages:(NSString *)userName masterkey:(NSString *)masterKey period:(NSString*)period withCompletionHandler:(CompletionHandler)handler
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/veriscanAPI.php",BASE_URL]];
    
    __block  ASIFormDataRequest *request = [self createRequest:url];
    
    [request setRequestMethod:@"POST"];
    [request setPostValue:masterKey forKey:@"master_key"];
    [request setPostValue:userName forKey:@"username"];
    [request setPostValue:@"messages" forKey:@"action"];
    [request setPostValue:period forKey:@"period"];
    [request setCompletionBlock:^{
        
        NSString *response = [request responseString];
        
        NSMutableDictionary *messagesArray = [response JSONValue];
        
        ///Block Calling
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if ([[messagesArray valueForKey:@"msg"] isKindOfClass:[NSString class]]) {
                
                
                NSMutableArray *message =[NSMutableArray array];
                [message addObject:[messagesArray valueForKey:@"msg"]];
                
                handler(message,NO);
                
            }
            else
            {
                
                handler([messagesArray valueForKey:@"msg"],NO);
            }
        });
    }];
    
    [request setFailedBlock:^{
        
        NSString *response = [request responseString];
        NSDictionary *rootDictionary = [response JSONValue];
        ///Block Calling
        dispatch_async(dispatch_get_main_queue(), ^{
            
            handler([rootDictionary objectForKey:@"error"],YES);
        });
    }];
    
    [request startAsynchronous];
    
}

-(void)sendMessage:(NSString *)sender_id masterkey:(NSString *)masterKey receiver_id:(NSString *)receiver_id message:(NSString *)message withCompletionHandler:(CompletionHandler)handler {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/veriscanAPI.php",BASE_URL]];
    
    __block  ASIFormDataRequest *request = [self createRequest:url];
    
    [request setRequestMethod:@"POST"];
    [request setPostValue:masterKey forKey:@"master_key"];
    [request setPostValue:sender_id forKey:@"sender_id"];
    [request setPostValue:receiver_id forKey:@"receiver_id"];
    [request setPostValue:message forKey:@"message"];
    [request setPostValue:@"send_message" forKey:@"action"];
    [request setCompletionBlock:^{
        
        NSString *response = [request responseString];
        
        NSMutableDictionary *messagesArray = [response JSONValue];
        
        ///Block Calling
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if ([[messagesArray valueForKey:@"msg"] isKindOfClass:[NSString class]]) {
                
                
                NSMutableArray *message =[NSMutableArray array];
                [message addObject:[messagesArray valueForKey:@"msg"]];
                
                handler(message,NO);
                
            }
            else
            {
                
                handler([messagesArray valueForKey:@"msg"],NO);
            }
        });
    }];
    
    [request setFailedBlock:^{
        
        NSString *response = [request responseString];
        NSDictionary *rootDictionary = [response JSONValue];
        ///Block Calling
        dispatch_async(dispatch_get_main_queue(), ^{
            
            handler([rootDictionary objectForKey:@"error"],YES);
        });
    }];
    
    [request startAsynchronous];
}
-(void)getEmployeesWithMasterKey:(NSString *)masterKey withCompletionHandler:(CompletionHandler)handler {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/veriscanAPI.php",BASE_URL]];
    
    __block  ASIFormDataRequest *request = [self createRequest:url];
    
    [request setRequestMethod:@"POST"];
    [request setPostValue:masterKey forKey:@"master_key"];
    [request setPostValue:@"employees_list" forKey:@"action"];
    [request setPostValue:[[[UIDevice currentDevice] identifierForVendor] UUIDString] forKey:@"udid"];
    [request setCompletionBlock:^{
        
        NSString *response = [request responseString];
//        UIAlertView * tempAlert1 = [[UIAlertView alloc] initWithTitle:@"Employee" message:response delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [tempAlert1 show];

        NSMutableDictionary *messagesArray = [response JSONValue];
        
        ///Block Calling
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if ([[messagesArray valueForKey:@"employees"] isKindOfClass:[NSArray class]]) {
                
                
//                NSString *message =[messagesArray objectForKey:@"status"];
                //                [message addObject:[messagesArray valueForKey:@"msg"]];
                
                handler([messagesArray objectForKey:@"employees"],NO);
                
            }
            else
            {
                NSString *message =[messagesArray objectForKey:@"status"];
                //                [message addObject:[messagesArray valueForKey:@"msg"]];
                
                handler(message,NO);
                
                handler(message,NO);
            }
        });
    }];
    
    [request setFailedBlock:^{
        
        NSString *response = [request responseString];
        NSDictionary *rootDictionary = [response JSONValue];
        ///Block Calling
        dispatch_async(dispatch_get_main_queue(), ^{
            
            handler([rootDictionary objectForKey:@"error"],YES);
        });
    }];
    
    [request startAsynchronous];
    
}
-(void)deviceRegister:(NSString *)userName masterkey:(NSString *)masterKey currentUser:(NSString*)currentUser withCompletionHandler:(CompletionHandler)handler{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/veriscanAPI.php",BASE_URL]];
    
    __block  ASIFormDataRequest *request = [self createRequest:url];
    
    [request setRequestMethod:@"POST"];
    [request setPostValue:masterKey forKey:@"master_key"];
    [request setPostValue:userName forKey:@"username"];
    [request setPostValue:currentUser forKey:@"created_by"];
    [request setPostValue:@"iphone" forKey:@"device_type"];
    [request setPostValue:@"model" forKey:@"model"];
    [request setPostValue:@"12123101234" forKey:@"phone"];
    
   
    NSString * deviceTokenString  =[[NSUserDefaults standardUserDefaults] objectForKey:@"apns_device_token"];
    
    //[request setPostValue:[[[UIDevice currentDevice] identifierForVendor] UUIDString] forKey:@"uuid"];
    [request setPostValue:deviceTokenString forKey:@"uuid"];
    
    
    [request setPostValue:@"device" forKey:@"action"];
    [request setCompletionBlock:^{
        
        NSString *response = [request responseString];
        
        NSMutableDictionary *messagesArray = [response JSONValue];
        
        ///Block Calling
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if ([[messagesArray valueForKey:@"status"] isKindOfClass:[NSString class]]) {
                
                
                NSString *message =[messagesArray objectForKey:@"status"];
//                [message addObject:[messagesArray valueForKey:@"msg"]];
                
                handler(message,NO);
                
            }
            else
            {
                NSString *message =[messagesArray objectForKey:@"status"];
                //                [message addObject:[messagesArray valueForKey:@"msg"]];
                
                handler(message,NO);
                
                handler(message,NO);
            }
        });
    }];
    
    [request setFailedBlock:^{
        
        NSString *response = [request responseString];
        NSDictionary *rootDictionary = [response JSONValue];
        ///Block Calling
        dispatch_async(dispatch_get_main_queue(), ^{
            
            handler([rootDictionary objectForKey:@"error"],YES);
        });
    }];
    
    [request startAsynchronous];
}


-(void)paymentUpload:(NSString *)masterKey
         ticket_id:(NSString *)ticket_id
       comments:(NSString *)comments
        addiotnal_comments:(NSString *)addiotnal_comments
         imageData:(NSData*)image
       payment_type:(NSString*)payment_type
withCompletionHandler:(CompletionHandler)handler{
    
//    DLog(@"Content Type %@",contentType);
    
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/veriscanAPI.php",BASE_URL]];
    
    
    __block  ASIFormDataRequest *request = [self createRequest:url];
    
    [request setRequestMethod:@"POST"];
    [request setPostValue:masterKey forKey:@"master_key"];
    [request setPostValue:ticket_id forKey:@"ticket_id"];
    [request setPostValue:comments forKey:@"comments"];
    [request setPostValue:addiotnal_comments forKey:@"addiotnal_comments"];
    [request setPostValue:payment_type forKey:@"payment_type"];
    [request setPostValue:@"save_signature" forKey:@"action"];
    [request setPostValue:@"" forKey:@"upload_array"];
//    [request addData:image withFileName:[NSString stringWithFormat:@"image%@.jpeg",[self generateCallId]] andContentType:@"image/jpeg" forKey:@"upload_array"];
    [request addData:image withFileName:[NSString stringWithFormat:@"image%@.jpeg",[self generateCallId]] andContentType:@"image/jpeg" forKey:@"file"];
//    [request setShowAccurateProgress:YES];
    
    [request setCompletionBlock:^{
        
        NSString *response = [request responseString];
        NSDictionary *rootDictionary = [response JSONValue];
        DLog(@"response %@",response);
        
        
        if ([[rootDictionary valueForKey:@"error"] length]>0) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                handler([rootDictionary valueForKey:@"error"],YES);
            });
            
        }
        else
        {
            
            ///Block Calling
            dispatch_async(dispatch_get_main_queue(), ^{
                handler(rootDictionary,NO);
            });
        }
    }];
    
    [request setFailedBlock:^{
        
        NSString *response = [request responseString];
        NSDictionary *rootDictionary = [response JSONValue];
        ///Block Calling
        dispatch_async(dispatch_get_main_queue(), ^{
            
            handler([rootDictionary objectForKey:@"error"],YES);
        });
    }];
    
    [request startAsynchronous];
}
-(void)getID:(NSString *)userName masterkey:(NSString *)masterKey withCompletionHandler:(CompletionHandler)handler {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/veriscanAPI.php",BASE_URL]];
    
    __block  ASIFormDataRequest *request = [self createRequest:url];
    
    [request setRequestMethod:@"POST"];
    [request setPostValue:masterKey forKey:@"master_key"];
    [request setPostValue:userName forKey:@"username"];
    [request setPostValue:@"card" forKey:@"action"];
    [request setCompletionBlock:^{
        
        NSString *response = [request responseString];
        
        NSMutableDictionary *messagesArray = [response JSONValue];
        
        ///Block Calling
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if ([[messagesArray valueForKey:@"msg"] isKindOfClass:[NSString class]]) {
                
                
                NSString *message =[messagesArray valueForKey:@"msg"];
//                [message addObject:[messagesArray valueForKey:@"msg"]];
                
                handler(message,NO);
                
            }
            else
            {
                
                handler([messagesArray valueForKey:@"msg"],NO);
            }
        });
    }];
    
    [request setFailedBlock:^{
        
        NSString *response = [request responseString];
        NSDictionary *rootDictionary = [response JSONValue];
        ///Block Calling
        dispatch_async(dispatch_get_main_queue(), ^{
            
            handler([rootDictionary objectForKey:@"error"],YES);
        });
    }];
    
    [request startAsynchronous];
}

-(void)getAllCheckOutDataWithMasterKey:(NSString *)masterKey withCompletionHandler:(CompletionHandler)handler {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@all",BASE_URL_NEW]];
    
    __block  ASIFormDataRequest *request = [self createRequest:url];
    
    [request setRequestMethod:@"POST"];
    [request setPostValue:masterKey forKey:@"master_key"];
//    [request setPostValue:@"all" forKey:@"action"];
    [request setCompletionBlock:^{
        
        NSString *response = [request responseString];
//        UIAlertView * tempAlert1 = [[UIAlertView alloc] initWithTitle:@"Manual Lookup" message:response delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [tempAlert1 show];
        NSMutableDictionary *messagesArray = [response JSONValue];
      
        ///Block Calling
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([messagesArray objectForKey:@"meta"]) {
                if ([[[messagesArray objectForKey:@"meta"] objectForKey:@"status"] isEqualToString:@"200"]  &&  [[[messagesArray objectForKey:@"meta"] objectForKey:@"msg"] isEqualToString:@"OK"]) {
                    handler([messagesArray valueForKey:@"data"],NO);
                }
            }
            else {
                handler(@"error",YES);
            }
        });
    }];
    
    [request setFailedBlock:^{
        
        NSString *response = [request responseString];
        NSDictionary *rootDictionary = [response JSONValue];
        ///Block Calling
        dispatch_async(dispatch_get_main_queue(), ^{
            
            handler([rootDictionary objectForKey:@"error"],YES);
        });
    }];
    
    [request startAsynchronous];
}

-(void)checkoutFirstStepWithMasterKey:(NSString *)masterKey
                          description:(NSString *)description
                        serial_number:(NSString *)serial_number
                              address:(NSString*)address
                           department:(NSString*)department
                              user_id:(NSString*)user_id
                                 type:(NSString*)type
                             asset_id:(NSString*)asset_id
                               client:(NSString*)client
                withCompletionHandler:(CompletionHandler)handler {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@manual_lookup",BASE_URL_NEW]];
    
    __block  ASIFormDataRequest *request = [self createRequest:url];
    
    [request setRequestMethod:@"POST"];
    [request setPostValue:masterKey forKey:@"master_key"];
    [request setPostValue:description forKey:@"description"];
    [request setPostValue:serial_number forKey:@"serial_number"];
    [request setPostValue:address forKey:@"address"];
    [request setPostValue:department forKey:@"department"];
    [request setPostValue:user_id forKey:@"user_id"];
    [request setPostValue:type forKey:@"type"];
    [request setPostValue:asset_id forKey:@"asset_id"];
    [request setPostValue:client forKey:@"client"];
    [request setCompletionBlock:^{
        
        NSString *response = [request responseString];
        
        NSMutableDictionary *messagesArray = [response JSONValue];
        
        ///Block Calling
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([messagesArray objectForKey:@"meta"]) {
                if ([[[messagesArray objectForKey:@"meta"] objectForKey:@"status"] isEqualToString:@"200"]  &&  [[[messagesArray objectForKey:@"meta"] objectForKey:@"msg"] isEqualToString:@"OK"]) {
                    handler([[messagesArray objectForKey:@"data"]objectForKey:@"checkout"],NO);
                }
            }
            else {
                handler(@"error",YES);
            }
        });
    }];
    
    [request setFailedBlock:^{
        
        NSString *response = [request responseString];
        NSDictionary *rootDictionary = [response JSONValue];
        ///Block Calling
        dispatch_async(dispatch_get_main_queue(), ^{
            
            handler([rootDictionary objectForKey:@"error"],YES);
        });
    }];
    
    [request startAsynchronous];
    
}

-(void)uploadSignatureforCICOWithMasterKey:(NSString *)masterKey
                                      file:(NSData*)file
                     withCompletionHandler:(CompletionHandler)handler {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/veriscanAPI.php",BASE_URL]];
    
    
    __block  ASIFormDataRequest *request = [self createRequest:url];
    
    [request setRequestMethod:@"POST"];
    [request setPostValue:masterKey forKey:@"master_key"];
    [request setPostValue:@"signature" forKey:@"action"];
    [request setPostValue:@"" forKey:@"upload_array"];
    [request addData:file withFileName:[NSString stringWithFormat:@"image%@.jpeg",[self generateCallId]] andContentType:@"image/jpeg" forKey:@"file"];
    
    [request setCompletionBlock:^{
        
        NSString *response = [request responseString];
        NSDictionary *rootDictionary = [response JSONValue];
        DLog(@"response %@",response);
        
        
        if ([[rootDictionary valueForKey:@"error"] length]>0) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                handler([rootDictionary valueForKey:@"error"],YES);
            });
            
        }
        else
        {
            
            ///Block Calling
            dispatch_async(dispatch_get_main_queue(), ^{
                handler([rootDictionary objectForKey:@"path"],NO);
            });
        }
    }];
    
    [request setFailedBlock:^{
        
        NSString *response = [request responseString];
        NSDictionary *rootDictionary = [response JSONValue];
        ///Block Calling
        dispatch_async(dispatch_get_main_queue(), ^{
            
            handler([rootDictionary objectForKey:@"error"],YES);
        });
    }];
    
    [request startAsynchronous];
}

-(void)checkoutWithMasterKey:(NSString *)masterKey
                    employee:(NSString *)employee
                  department:(NSString *)department
               date_time_out:(NSString*)date_time_out
            date_time_due_in:(NSString*)date_time_due_in
                   client_id:(NSString*)client_id
                   reference:(NSString*)reference
                     address:(NSString*)address
                       notes:(NSString*)notes
                   signature:(NSString*)signature
                    asset_id:(NSString*)asset_id
                     user_id:(NSString*)user_id
                   tolerance:(NSString*)tolerance
                     checkID:(NSString*)checkID
       withCompletionHandler:(CompletionHandler)handler {
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@checkout",BASE_URL_NEW]];
    
    __block  ASIFormDataRequest *request = [self createRequest:url];
    
    [request setRequestMethod:@"POST"];
    [request setPostValue:masterKey forKey:@"master_key"];
    [request setPostValue:employee forKey:@"employee"];
    [request setPostValue:department forKey:@"department"];
    [request setPostValue:date_time_out forKey:@"date_time_out"];
    [request setPostValue:date_time_due_in forKey:@"date_time_due_in"];
    [request setPostValue:client_id forKey:@"client_id"];
    [request setPostValue:reference forKey:@"reference"];
    [request setPostValue:address forKey:@"address"];
    [request setPostValue:notes forKey:@"notes"];
    [request setPostValue:signature forKey:@"signature"];
    [request setPostValue:asset_id forKey:@"asset_id"];
    [request setPostValue:user_id forKey:@"user_id"];
    [request setPostValue:tolerance forKey:@"tolerance"];
    [request setPostValue:checkID forKey:@"check_out_id"];
    [request setPostValue:@"1" forKey:@"received_condition"];
    [request setPostValue:@"1" forKey:@"latitude"];
    [request setPostValue:@"1" forKey:@"longitude"];
    [request setCompletionBlock:^{
        
        NSString *response = [request responseString];
        
        NSMutableDictionary *messagesArray = [response JSONValue];
        
        ///Block Calling
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([messagesArray objectForKey:@"meta"]) {
                if ([[[messagesArray objectForKey:@"meta"] objectForKey:@"status"] isEqualToString:@"200"]  &&  [[[messagesArray objectForKey:@"meta"] objectForKey:@"msg"] isEqualToString:@"OK"]) {
                    handler([messagesArray objectForKey:@"data"],NO);
                }
            }
            else {
                handler(@"error",YES);
            }
        });
    }];
    
    [request setFailedBlock:^{
        
        NSString *response = [request responseString];
        NSDictionary *rootDictionary = [response JSONValue];
        ///Block Calling
        dispatch_async(dispatch_get_main_queue(), ^{
            
            handler([rootDictionary objectForKey:@"error"],YES);
        });
    }];
    
    [request startAsynchronous];
}

-(void)checkinWithMasterKey:(NSString *)masterKey
                   employee:(NSString *)employee
                 department:(NSString *)department
              date_time_out:(NSString*)date_time_out
           date_time_due_in:(NSString*)date_time_due_in
                  client_id:(NSString*)client_id
                  reference:(NSString*)reference
                    address:(NSString*)address
                      notes:(NSString*)notes
                  signature:(NSString*)signature
                   asset_id:(NSString*)asset_id
                    user_id:(NSString*)user_id
                  tolerance:(NSString*)tolerance
                     ticket:(NSString*)ticket
               serialNumber:(NSString*)serialNumber
                description:(NSString*)description
      withCompletionHandler:(CompletionHandler)handler {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@checkin",BASE_URL_NEW]];
    
    __block  ASIFormDataRequest *request = [self createRequest:url];
    
    [request setRequestMethod:@"POST"];
    [request setPostValue:masterKey forKey:@"master_key"];
    [request setPostValue:employee forKey:@"employee"];
    [request setPostValue:department forKey:@"department"];
    [request setPostValue:date_time_out forKey:@"date_time_out"];
    [request setPostValue:date_time_due_in forKey:@"date_time_due_in"];
    [request setPostValue:client_id forKey:@"client_id"];
    [request setPostValue:reference forKey:@"reference"];
    [request setPostValue:address forKey:@"address"];
    [request setPostValue:notes forKey:@"notes"];
    [request setPostValue:signature forKey:@"signature"];
    [request setPostValue:asset_id forKey:@"asset_id"];
    [request setPostValue:user_id forKey:@"user_id"];
    [request setPostValue:tolerance forKey:@"tolerance"];
    [request setPostValue:@"1" forKey:@"check_out_id"];
    [request setPostValue:@"1" forKey:@"received_condition"];
    [request setPostValue:@"1" forKey:@"latitude"];
    [request setPostValue:@"1" forKey:@"longitude"];
    [request setPostValue:ticket forKey:@"ticket_id"];
    [request setPostValue:serialNumber forKey:@"serial_number"];
    [request setPostValue:description forKey:@"description"];
    [request setCompletionBlock:^{
        
        NSString *response = [request responseString];
        
        NSMutableDictionary *messagesArray = [response JSONValue];
        
        ///Block Calling
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([messagesArray objectForKey:@"meta"]) {
                if ([[[messagesArray objectForKey:@"meta"] objectForKey:@"status"] isEqualToString:@"200"]  &&  [[[messagesArray objectForKey:@"meta"] objectForKey:@"msg"] isEqualToString:@"OK"]) {
                    handler([messagesArray objectForKey:@"data"],NO);
                }
            }
            else {
                handler(@"error",YES);
            }
        });
    }];
    
    [request setFailedBlock:^{
        
        NSString *response = [request responseString];
        NSDictionary *rootDictionary = [response JSONValue];
        ///Block Calling
        dispatch_async(dispatch_get_main_queue(), ^{
            
            handler([rootDictionary objectForKey:@"error"],YES);
        });
    }];
    
    [request startAsynchronous];
}

-(void)checkoutCheckInTicketsWithMasterKey:(NSString *)masterKey userName:(NSString *)userName   today:(NSString *)today withCompletionHandler:(CompletionHandler)handler {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/veriscanAPI.php",BASE_URL]];
    
    __block  ASIFormDataRequest *request = [self createRequest:url];
    
    [request setRequestMethod:@"POST"];
    [request setPostValue:masterKey forKey:@"master_key"];
//    [request setPostValue:@"1" forKey:@"master_key"];
//    [request setPostValue:@"javed" forKey:@"username"];
    [request setPostValue:today forKey:@"username"];
    [request setPostValue:@"NO" forKey:@"today"];
  
    [request setPostValue:@"show_checkin_out_tickets" forKey:@"action"];
    [request setCompletionBlock:^{
        
        NSString *response = [request responseString];
        NSMutableDictionary *ticketsArray = [response JSONValue];
        
        DLog(@"Ticekts Response %@",response);
        
        if ([[ticketsArray valueForKey:@"error"] length]>0) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                handler([ticketsArray valueForKey:@"error"],YES);
            });
        }
        else
        {
            ////add Ticket Model
            NSMutableArray *ticketsData=[NSMutableArray array];
            
            NSArray *keys=[ticketsArray allKeys];
            
            DLog(@"%@",keys);
            
            for (int i=0; i<[keys count]; i++) {
                
                if ([[keys objectAtIndex:i] isEqualToString:@"route_order"] || [[keys objectAtIndex:i] isEqualToString:@"default_address"]) {
                    
                }
                else
                {
                    TicketDTO *ticketData=[TicketDTO initWithTicketDTO:[ticketsArray objectForKey:[keys objectAtIndex:i]]];
                    [ticketsData addObject:ticketData];
                }
            }
            [[VSSharedManager sharedManager] setTicketInfo:ticketsData];
            ///Block Calling
            dispatch_async(dispatch_get_main_queue(), ^{
                
                handler(ticketsData,NO);
            });
        }
        
    }];
    
    [request setFailedBlock:^{
        
        ///Block Calling
        dispatch_async(dispatch_get_main_queue(), ^{
            handler(@"Check your internet connection",YES);
        });
    }];
    
    [request startAsynchronous];
}

-(void)logoutWithMasterKey:(NSString *)masterKey
                  username:(NSString *)username
                session_id:(NSString *)session_id
     withCompletionHandler:(CompletionHandler)handler {
   
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/veriscanAPI.php",BASE_URL]];
    
    __block  ASIFormDataRequest *request = [self createRequest:url];
    
    [request setRequestMethod:@"POST"];
    [request setPostValue:masterKey forKey:@"master_key"];
    [request setPostValue:session_id forKey:@"session_id"];
    [request setPostValue:username forKey:@"username"];
    [request setPostValue:@"logout" forKey:@"action"];
    [request setCompletionBlock:^{
        
        NSString *response = [request responseString];
        NSMutableDictionary *ticketsArray = [response JSONValue];
        
        DLog(@"Ticekts Response %@",response);
        
                    ///Block Calling
            dispatch_async(dispatch_get_main_queue(), ^{
                
                handler(@"Yes",NO);
            });
        
        
    }];
    
    [request setFailedBlock:^{
        
        ///Block Calling
        dispatch_async(dispatch_get_main_queue(), ^{
            handler(@"Check your internet connection",YES);
        });
    }];
    
    [request startAsynchronous];
}

-(void)suspendTicket:(NSString *)masterKey
            ticketID:(NSString *)ticketID
            stopTime:(NSString *)stopTime
          StopReason:(NSString *)stopReason
              userID:(NSString *)userID
withCompletionHandler:(CompletionHandler)handler{

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/veriscanAPI.php",BASE_URL]];
    
    __block  ASIFormDataRequest *request = [self createRequest:url];
    
    [request setRequestMethod:@"POST"];
    [request setPostValue:masterKey forKey:@"master_key"];
    [request setPostValue:ticketID forKey:@"ticket_id"];
    [request setPostValue:stopTime forKey:@"stop_time"];
    [request setPostValue:stopReason forKey:@"stop_reason"];
    [request setPostValue:userID forKey:@"user_id"];
    [request setPostValue:@"suspend_ticket" forKey:@"action"];
    [request setCompletionBlock:^{
        
        NSString *response = [request responseString];
        NSMutableDictionary *suspendTicketDictionary = [response JSONValue];
        
        DLog(@"Suspend Ticket Response %@",response);
        
        ///Block Calling
        dispatch_async(dispatch_get_main_queue(), ^{
            handler(suspendTicketDictionary,NO);
        });
        
        
    }];
    
    [request setFailedBlock:^{
        
        ///Block Calling
        dispatch_async(dispatch_get_main_queue(), ^{
            handler(@"Check your internet connection",YES);
        });
    }];
    
    [request startAsynchronous];
    
}


-(void)restartTicket:(NSString *)masterKey
            ticketID:(NSString *)ticketID
         restartTime:(NSString *)restartTime
              userID:(NSString *)userID
withCompletionHandler:(CompletionHandler)handler{

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/veriscanAPI.php",BASE_URL]];
    
    __block  ASIFormDataRequest *request = [self createRequest:url];
    
    [request setRequestMethod:@"POST"];
    [request setPostValue:masterKey forKey:@"master_key"];
    [request setPostValue:ticketID forKey:@"ticket_id"];
    [request setPostValue:restartTime forKey:@"restart_time"];
    [request setPostValue:userID forKey:@"user_id"];
    [request setPostValue:@"restart_ticket" forKey:@"action"];
    [request setCompletionBlock:^{
        
        NSString *response = [request responseString];
        NSMutableDictionary *restartTicketDictionary = [response JSONValue];
        
        DLog(@"Restart Ticket Response %@",response);
        
        ///Block Calling
        dispatch_async(dispatch_get_main_queue(), ^{
            handler(restartTicketDictionary,NO);
        });
        
        
    }];
    
    [request setFailedBlock:^{
        
        ///Block Calling
        dispatch_async(dispatch_get_main_queue(), ^{
            handler(@"Check your internet connection",YES);
        });
    }];
    
    [request startAsynchronous];


}

@end