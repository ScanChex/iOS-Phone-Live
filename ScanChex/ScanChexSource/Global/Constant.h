//
//  Constant.h
//  VeriScanQR
//
//  Created by Adnan Ahmad on 13/12/2012.
//  Copyright (c) 2012 Adnan Ahmad. All rights reserved.
//

//////For MapView
#define METERS_PER_MILE 1609.344


#define K_Update_ScanCode @"Scanned"
#define K_Update_ScanCode_CANCEL @"Cancel"
//http://scanchex.net/modules/cron
//#define BASE_URL @"http://demo.scanchex.net/modules/cron"
//#define BASE_URL_NEW @"http://demo.scanchex.net/dev/api/asset/"
#define BASE_URL @"http://www.scanchex.net/modules/cron"
#define BASE_URL_NEW @"http://scanchex.net/dev/api/asset/"


#define STATUS @"Status"
#define RESULT_KEY @"Data"
#define RESPONSE_FAIL @"Error"
#define RESPONSE_SUCCESS @"Success"
#define MESSAGE_KEY @"Message"
#define kUPDATE_INTERVAL 300

#define PushNotificationPermissionPopup @"PushNotificationPermissionPopup"


#define IPHONE_5_HEIGHT_DIFFERENCE 88

#define DEST_PATH [NSHomeDirectory() stringByAppendingString:@"/Documents/"]

#define UPDATE_LOCATION_NOTIFICATION @"Update Location"
#define kLastLocationUpdateTimestamp @"UpdateInterval"

#define kPushReceived @"pushReceived"

#define IS_IPHONE5 (([[UIScreen mainScreen] bounds].size.height-568)?NO:YES)
#define K_SECOND_SCAN "Second Scan"

#define PDF_FILE_SHARE @"PDF_FILE_SHARE"

static inline BOOL IsEmpty(id thing) {
    return thing == nil
    || ([thing respondsToSelector:@selector(length)]
        && [(NSData *)thing length] == 0)
    || ([thing respondsToSelector:@selector(count)]
        && [(NSArray *)thing count] == 0);
}
