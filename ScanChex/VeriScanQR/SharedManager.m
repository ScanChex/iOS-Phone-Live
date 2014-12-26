//
//  SharedManager.m
//
//  Created by Rajeel Amjad on 8/16/13.
//  Copyright (c) 2011 VeriTech. All rights reserved.
//

#import "SharedManager.h"

@implementation SharedManager



static SharedManager *sharedInstance;

+ (SharedManager*)getInstance{
	@synchronized(self){
		if(sharedInstance ==  nil){			
			sharedInstance = [[SharedManager alloc] init];
            sharedInstance.isEditable = FALSE;
            
            
		}
	}
	return sharedInstance;
}


#pragma mark - NSDate Functions

+ (NSDate *)dateFromString:(NSString *)str withFormat:(NSString *)format {
    NSString *dateString = str;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSDate *dateFromString = [[NSDate alloc] init];
    dateFromString = [dateFormatter dateFromString:dateString];
    
    return dateFromString;
}

+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)format {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSString *strDate = [dateFormatter stringFromDate:date];
    
    return strDate;
}



@end
