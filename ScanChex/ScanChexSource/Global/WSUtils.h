//
//  BWFUtils.h
//  BetWithFriends
//
//  Created by OSM LLC on 1/2/12.
//  Copyright (c) 2012 Organic Spread Media, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WSUtils : NSObject


+ (BOOL)findIfWagerVCexistsInNavigationStack;
+ (void)constructPathFromNavigationController:(UINavigationController *)navCrt;


+ (NSInteger)totalNumberOfSecondsWithTheseSettings:(NSDictionary*)settings;
+ (NSDictionary*)timeSettings;


+ (NSString*)getStrindFromDate:(NSDate*)date;
+ (NSString*)getStrindFromDate:(NSDate*)date withFormat:(NSString*)format;
+(NSString *)getStringFormCurrentDate;

+ (NSDate*)getDateFromString:(NSString*)stirng withFormat:(NSString*)format;

+ (BOOL)ifString:(NSString*)string isFoundInString:(NSString*)completeString;
+ (BOOL)ifEmptyString:(NSString*)string;
+ (BOOL)valueAlreadyExistsWithValue:(int)value withElements:(NSArray*)array;
+ (NSInteger)indexForThisDay:(NSString*)theDay;
+ (NSDate*)nearestDateFromDay:(NSString*)theDay;
+ (NSDate *)dateByAddingDays:(NSUInteger)days;
+ (NSDate *)dateByAddingDays:(NSUInteger)days toDate:(NSDate*)date;
+ (NSDate *)dateByAddingMinutes:(NSUInteger)minutes toDate:(NSDate*)date;
+ (NSDate *)dateByAddingSeconds:(NSUInteger)seconds toDate:(NSDate*)date;
+ (NSDate *)dateByAddingSystemTimeZoneToDate:(NSDate*)date;
+ (NSDictionary*)updateTimerWithNumSeconds:(NSInteger)seconds;
+ (NSInteger)hoursBetweenDate:(NSDate*)d;
+ (NSInteger)minutesBetweenDate:(NSDate*)d;
+ (NSInteger)minutesBetweenThisDate:(NSDate*)d1 andDate:(NSDate*)d2;
+ (NSInteger)secondsBetweenThisDate:(NSDate*)d1 andDate:(NSDate*)d2;
+ (NSInteger)daysBetweenDate:(NSDate*)date;
+ (BOOL)findIfGamesVCexistsInNavigationStack;
+ (NSInteger)yearsBetweenCurrentDateAndDate:(NSDate*)date;





//JAMEEL METHODS ///

+(NSDate *)dateFromDateString:(NSString *)dateString;
+(NSString *)hourStringFromDate:(NSDate *)date;



@end
