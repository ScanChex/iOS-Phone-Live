//
//  Macro.h
//  DDLOG
//
//  Created by Adnan Ahmad on 27/02/2013.
//  Copyright (c) 2013 Adnan Ahmad. All rights reserved.
//

#import <Foundation/Foundation.h>


#define kLogsEnable @"logsenable"
#define kLogsRedirect @"logsredirect"

//Debug Macros
#ifdef CONFIGURATION_DebugTest
#define DLog(...)
#define DInfo(...)
#define DError(...)
#else
#define DLog(...) if ([[[NSBundle mainBundle] objectForInfoDictionaryKey:kLogsEnable] boolValue]) NSLog(@"[%d]%s[L:%d] %@",[NSThread isMainThread], __PRETTY_FUNCTION__,__LINE__, [NSString stringWithFormat:__VA_ARGS__]);
#define DInfo(...) if ([[[NSBundle mainBundle] objectForInfoDictionaryKey:kLogsEnable] boolValue]) NSLog(@"[%d] = %s [L:%d]--- %@",[NSThread isMainThread], __PRETTY_FUNCTION__,__LINE__, [NSString stringWithFormat:__VA_ARGS__]);
#define DError(...) NSLog(@"[%d] = %s [L:%d]--- %@",[NSThread isMainThread], __PRETTY_FUNCTION__,__LINE__, [NSString stringWithFormat:__VA_ARGS__]);
#endif


