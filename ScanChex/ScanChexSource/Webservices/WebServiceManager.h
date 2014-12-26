//
//  WebServiceManager.h
//  VeriScanQR
//
//  Created by Adnan Ahmad on 15/12/2012.
//  Copyright (c) 2012 Adnan Ahmad. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface NSMutableArray (WeakReferences)

@end

@protocol WebServiceManagerDelegate <NSObject>
@optional

@end

///Defining block
typedef void (^CompletionHandler)(id,BOOL);

@interface WebServiceManager : NSObject


@property (nonatomic) BOOL useQueue;


-  (void)cancelAllQueuedRequests;
-  (void)boundCallsTo:(id<WebServiceManagerDelegate>) caller;
-  (void)unboundCalls;

+ (WebServiceManager *) sharedManager;
- (void)addDelegate:(id<WebServiceManagerDelegate>)aDelegate;
- (void)removeDelegate:(id<WebServiceManagerDelegate>)aDelegate;


#pragma -Adnan Code

-(void)loginWithCustomerID:(NSString *)customerId
                    userID:(NSString *)userID
                  password:(NSString *)password
     withCompletionHandler:(CompletionHandler)block;

-(void)resetPassword:(NSString *)companyID username:(NSString *)name withCompletionHandler:(CompletionHandler)block;

//$_POST=array('action'=>'scan_ticket','ticket_id'=>'1','asset_id'=>0,'latitude'=>0,'longitude'=>0,'master_key'=>0,'username'=>0);


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
withCompletionHandler:(CompletionHandler)block;

-(void)scanCheckPointTicket:(NSString *)ticketID
          assetID:(NSString *)assetId
         latitude:(NSString *)lat
        longitude:(NSString *)lon
        masterKey:(NSString *)masterKey
         userName:(NSString *)userName
      checkPointID:(NSString *)checkPointID
withCompletionHandler:(CompletionHandler)block;


-(void)getExtraTicketInformation:(NSString *)masterkey assetID:(NSString *)assetID withCompletionHandler:(CompletionHandler)block;

-(void)getTicketServices:(NSString *)masterkey ticketID:(NSString *)ticketID withCompletionHandler:(CompletionHandler)block;

-(void)getQuetsions:(NSString *)masterkey assetID:(NSString *)assetID tikcetID:(NSString*)ticketID withCompletionHandler:(CompletionHandler)block;


-(void)getTickets:(NSString *)masterKey
         fromDate:(NSString *)fromData
           toDate:(NSString *)toDate
         userName:(NSString *)userName
withCompletionHandler:(CompletionHandler)block;


-(void)showDocuments:(NSString *)masterKey assetID:(NSString *)assetID withCompletionHandler:(CompletionHandler)handler;

-(void)showHistory:(NSString *)masterKey ticketID:(NSString *)ticketID withCompletionHandler:(CompletionHandler)handler;

//$_POST=array('action'=>'update_user_location','username'=>'jim','master_key'=>136,'latitude'=>20,'longitude'=>-80,'device_make'=>'make','device_model'=>'model','device_os'=>'os','device_id'=>'id');

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
withCompletionHandler:(CompletionHandler)block;


-(void)uploadVideo:(NSString *)masterKey
         historyID:(NSString *)historyID
       contentType:(NSString *)contentType
         videoData:(NSData*)video
       progressBar:(UIProgressView*)progress
withCompletionHandler:(CompletionHandler)handler;


-(void)uploadAudio:(NSString *)masterKey
         historyID:(NSString *)historyID
       contentType:(NSString *)contentType
         audioData:(NSData*)audio
       progressBar:(UIProgressView*)progress
withCompletionHandler:(CompletionHandler)handler;


-(void)uploadImage:(NSString *)masterKey
         historyID:(NSString *)historyID
       contentType:(NSString *)contentType

         imageData:(NSData*)image
       progressBar:(UIProgressView*)progress
withCompletionHandler:(CompletionHandler)handler;

-(void)uploadPdf:(NSString *)masterKey
         historyID:(NSString *)historyID
       contentType:(NSString *)contentType
         pdfData:(NSData*)pdf
       progressBar:(UIProgressView*)progress
withCompletionHandler:(CompletionHandler)handler;

-(void)uploadNotes:(NSString *)masterKey historyID:(NSString *)historyID notes:(NSString*)notes withCompletionHandler:(CompletionHandler)handler;

-(void)upadteAnswers:(NSString *)masterKey
            questIDS:(NSMutableArray *)questIDS
             answers:(NSMutableArray *)answers
            ticketID:(NSString *)ticketID
withCompletionHandler:(CompletionHandler)handler;

//$_POST=array('action'=>'update_asset_location_photo','latitude'=>'18.0023203','longitude'=>'-76.7881499','master_key'=>'136','asset_id'=>229,'upload_array'=>$_FILES['image'],'company_id'=>'US-0989864','type'=>'both OR location');


-(void)updateAdminLocation:(NSString *)assetID
                 masterKey:(NSString *)masterKey
                  latitude:(NSString *)lat
                 longitude:(NSString *)lon
     withCompletionHandler:(CompletionHandler)block;


-(void)updateAdminLocationORImage:(NSString *)latitude
                        longitude:(NSString *)longitude
                        masterKey:(NSString *)masterKey
                          assetID:(NSString *)assetID
                        imageData:(NSData *)imageData
                        companyID:(NSString *)userName
                             type:(NSString*)type
                      progressBar:(UIProgressView *)progressView
            withCompletionHandler:(CompletionHandler)handler;

-(void)closeTicket:(NSString *)historyID ticketID:(NSString *)ticketID technician:(NSString*)technician employer:(NSInteger)master_id withCompletionHandler:(CompletionHandler)handler;

-(void)getAssetInfo:(NSString *)masterKey assetID:(NSString *)assetID withCompletionHandler:(CompletionHandler)handler;

-(void)getComponents:(NSString *)masterKey serviceID:(NSString *)serviceID withCompletionHandler:(CompletionHandler)handler;

-(void)updateServiceStatus:(NSString *)serviceID status:(NSString *)status withCompletionHandler:(CompletionHandler)handler;

-(void)updateMessages:(NSString *)userName masterkey:(NSString *)masterKey withCompletionHandler:(CompletionHandler)handler;

-(void)getMessages:(NSString *)userName masterkey:(NSString *)masterKey period:(NSString*)period withCompletionHandler:(CompletionHandler)handler;

-(void)getID:(NSString *)userName masterkey:(NSString *)masterKey withCompletionHandler:(CompletionHandler)handler;

-(void)sendMessage:(NSString *)sender_id masterkey:(NSString *)masterKey receiver_id:(NSString *)receiver_id message:(NSString *)message withCompletionHandler:(CompletionHandler)handler;
-(void)deviceRegister:(NSString *)userName masterkey:(NSString *)masterKey currentUser:(NSString*)currentUser withCompletionHandler:(CompletionHandler)handler;
-(void)paymentUpload:(NSString *)masterKey
           ticket_id:(NSString *)ticket_id
            comments:(NSString *)comments
  addiotnal_comments:(NSString *)addiotnal_comments
           imageData:(NSData*)image
        payment_type:(NSString*)payment_type
withCompletionHandler:(CompletionHandler)handler;

-(void)getEmployeesWithMasterKey:(NSString *)masterKey withCompletionHandler:(CompletionHandler)handler;

-(void)getAllCheckOutDataWithMasterKey:(NSString *)masterKey withCompletionHandler:(CompletionHandler)handler;

-(void)checkoutFirstStepWithMasterKey:(NSString *)masterKey
                            description:(NSString *)description
                             serial_number:(NSString *)serial_number
                            address:(NSString*)address
                         department:(NSString*)department
                user_id:(NSString*)user_id
                type:(NSString*)type
                asset_id:(NSString*)asset_id
                client:(NSString*)client
                withCompletionHandler:(CompletionHandler)handler;

-(void)uploadSignatureforCICOWithMasterKey:(NSString *)masterKey
                                      file:(NSData*)file
                     withCompletionHandler:(CompletionHandler)handler;

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
                withCompletionHandler:(CompletionHandler)handler;
-(void)checkoutCheckInTicketsWithMasterKey:(NSString *)masterKey userName:(NSString *)userName today:(NSString *)today withCompletionHandler:(CompletionHandler)handler;

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
       withCompletionHandler:(CompletionHandler)handler;

-(void)logoutWithMasterKey:(NSString *)masterKey
                   username:(NSString *)username
                 session_id:(NSString *)session_id
      withCompletionHandler:(CompletionHandler)handler;


-(void)suspendTicket:(NSString *)masterKey
            ticketID:(NSString *)ticketID
            stopTime:(NSString *)stopTime
          StopReason:(NSString *)stopReason
              userID:(NSString *)userID
withCompletionHandler:(CompletionHandler)handler;



-(void)restartTicket:(NSString *)masterKey
            ticketID:(NSString *)ticketID
            restartTime:(NSString *)restartTime
              userID:(NSString *)userID
withCompletionHandler:(CompletionHandler)handler;


@end
