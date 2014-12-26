//
//  BWFUtils.m
//  BetWithFriends
//
//  Created by OSM LLC on 1/2/12.
//  Copyright (c) 2012 Organic Spread Media, LLC. All rights reserved.
//

#import "WSUtils.h"
#import "Constant.h"

#import "AppDelegate.h"



@implementation WSUtils

static NSString *pathTaken=@"";
static NSMutableArray *controllers=nil;

+ (BOOL)findIfWagerVCexistsInNavigationStack
{
   
  /*  pathTaken=@"";
    controllers= [[NSMutableArray array] retain];
    
    
    //construct the path taken
    [BWFUtils constructPathFromNavigationController:[AppDelegate sharedDelegate].navController];
    [controllers release];
    
    
    //decide if WagerVC exists in Navigation Stack
    if([BWFUtils ifString:@"WagerVC" isFoundInString:pathTaken]) 
    {
        return YES;
    }
    */
    return NO;
}

+ (BOOL)findIfGamesVCexistsInNavigationStack
{
    
   /* pathTaken=@"";
    controllers= [[NSMutableArray array] retain];
    
    
    //construct the path taken
    [BWFUtils constructPathFromNavigationController:[AppDelegate sharedDelegate].navController];
    [controllers release];
    
    
    //decide if WagerVC exists in Navigation Stack
    if([BWFUtils ifString:@"GamesVC" isFoundInString:pathTaken]) 
    {
        return YES;
    }
    */
    return NO;
}



+ (void)constructPathFromNavigationController:(UINavigationController *)navCrt
{
    id modelController=nil;
    id pushedViewController=nil;
    NSArray *viewControllers=[navCrt viewControllers];
    
    
    for(pushedViewController in viewControllers)
    {
        pathTaken= [pathTaken stringByAppendingFormat:@"%@->",NSStringFromClass([pushedViewController class])];
        [controllers addObject:pushedViewController];
        
        if(pushedViewController==[viewControllers lastObject]){//check for model view
            modelController= [pushedViewController modalViewController];
            
            if([modelController isKindOfClass:[UINavigationController class]]){
                
                [WSUtils constructPathFromNavigationController:(UINavigationController *)[pushedViewController modalViewController]];
            }
            
            
        }
        
    }
    
}

+ (NSInteger)totalNumberOfSecondsWithTheseSettings:(NSDictionary*)settings
{
    
    NSInteger hours = [[settings objectForKey:@"hour"] integerValue];
    NSInteger minutes = [[settings objectForKey:@"minute"] integerValue];
    NSInteger seconds = [[settings objectForKey:@"second"] integerValue];
    
    NSInteger totalSeconds = (hours * 60 * 60) + (minutes * 60) + seconds;
    
    //NSLog(@"totalSeconds: %i",totalSeconds);
    
    return totalSeconds;
    
}

+ (NSDictionary*)timeSettings
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
	
	NSDictionary *settings = nil;
	
	if([standardUserDefaults objectForKey:@"timeSettings"])
	{
		settings = [standardUserDefaults objectForKey:@"timeSettings"];
	}
    else
    {
        settings = [NSDictionary dictionaryWithObjectsAndKeys:@"01",@"hour",@"00",@"minute",@"00",@"second", nil];
        
        [standardUserDefaults setObject:settings forKey:@"timeSettings"];
        [standardUserDefaults synchronize];
    }
    
    return settings;
}


+ (NSString*)getStrindFromDate:(NSDate*)date 
{
	
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"HH:mm a"];//yyyy
	NSString *string = [formatter stringFromDate:date];
	[formatter release];
	
	return string;
    
    
}


+(NSString *)getStringFormCurrentDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];//yyyy
    NSString *string = [formatter stringFromDate:[NSDate date]];
    [formatter release];
    
    return string;
}

+(NSString*)getStrindFromDate:(NSDate*)date withFormat:(NSString*)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	
    
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [formatter setTimeZone:gmt];
    [formatter setDateFormat:format];//yyyy
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:kCFDateFormatterShortStyle];
    
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [formatter setLocale:usLocale];
	NSString *string = [formatter stringFromDate:date];
	[formatter release];
	
	return string;
}


+ (NSDate*)getDateFromString:(NSString*)stirng withFormat:(NSString*)format
{
    ////NSLog(@"string %@",stirng);
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [dateFormat setTimeZone:gmt];
    
	[dateFormat setDateFormat:format];
    NSDate *date = [dateFormat dateFromString:stirng];
    [dateFormat release];
    
    return date;
}

//check if a string literal is found in a string component
+ (BOOL)ifString:(NSString*)string isFoundInString:(NSString*)completeString
{
	NSRange range = [completeString rangeOfString:string];
	if (range.length > 0) 
	{
		return YES;
	}
	
	return NO;
}

+(BOOL)ifEmptyString:(NSString*)string
{
    NSString *tempString = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if([tempString length] == 0)
        return YES;
    
    return NO;
}

+ (BOOL)valueAlreadyExistsWithValue:(int)value withElements:(NSArray*)array
{
    BOOL found = NO;
	for(int i=0;i<[array count];i++)
	{
		if (value == [[array objectAtIndex:i] intValue]) 
		{
			found = YES;
			break;
		}
	}
	
	return found;
}

+ (NSDate*)nearestDateFromDay:(NSString*)theDay
{
    
    
  /*
    NSString *currentDay = [WSUtils getStrindFromDate:[NSDate date] withFormat:@"EEEE"];
    
    if([theDay isEqualToString:currentDay])
        return nil;
    
    
    NSInteger counter = 1;
    BOOL found = NO;
    
    NSInteger currentDayIndex = [WSUtils indexForThisDay:currentDay]+1;
    //NSLog(@"currentDayIndex: %i",currentDayIndex);
    
    for(int i=currentDayIndex; i<[DAY_TYPES count] && !found;i++)
    {
        //NSLog(@"i: %d",i);
        
        if([theDay isEqualToString:[DAY_TYPES objectAtIndex:i]])
        {
            found = YES;
            break;
        }
        
        
        counter ++;
        
        if((i == [DAY_TYPES count]-1) && !found)
        {
            i=-1;
            //NSLog(@"LOOP and counter: %i",counter);
        }
        
        
    }
    */
    //NSLog(@"counter: %i",counter);
    
    NSDate *theDate = nil ;//= [self dateByAddingDays:counter];
    ////NSLog(@"theDate: %@",theDate);
    
    return theDate;
    
}

+ (NSInteger)indexForThisDay:(NSString*)theDay
{
    NSInteger counter = 0;
   /* for(int i=0; i<[DAY_TYPES count];i++)
    {
        if([theDay isEqualToString:[DAY_TYPES objectAtIndex:i]])
        {
            break;
        }
        counter ++;
    }*/
    
    return counter;
}

+ (NSDate *)dateByAddingDays:(NSUInteger)days {
	NSDateComponents *c = [[[NSDateComponents alloc] init] autorelease];
	c.day = days;
	return [[NSCalendar currentCalendar] dateByAddingComponents:c toDate:[NSDate date] options:0];
}

+ (NSDate *)dateByAddingDays:(NSUInteger)days toDate:(NSDate*)date
{
	NSDateComponents *c = [[[NSDateComponents alloc] init] autorelease];
	c.day = days;
	return [[NSCalendar currentCalendar] dateByAddingComponents:c toDate:date options:0];
}

+ (NSDate *)dateByAddingMinutes:(NSUInteger)minutes toDate:(NSDate*)date
{
	NSDateComponents *c = [[[NSDateComponents alloc] init] autorelease];
	c.minute = minutes;
	return [[NSCalendar currentCalendar] dateByAddingComponents:c toDate:date options:0];
}

+ (NSDate *)dateByAddingSeconds:(NSUInteger)seconds toDate:(NSDate*)date
{
    NSDateComponents *c = [[[NSDateComponents alloc] init] autorelease];
	c.second = seconds;
	return [[NSCalendar currentCalendar] dateByAddingComponents:c toDate:date options:0];
}

+ (NSDate *)dateByAddingSystemTimeZoneToDate:(NSDate*)sourceDate
{
    
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
    
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:sourceDate];
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:sourceDate];
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    
    NSDate* destinationDate = [NSDate dateWithTimeInterval:interval sinceDate:sourceDate];
    
    
    return destinationDate;
}

+ (NSInteger)hoursBetweenDate:(NSDate*)d
{
	NSTimeInterval time = [[NSDate date] timeIntervalSinceDate:d];
	return abs(time / 60 / 60);
}

+ (NSInteger)minutesBetweenDate:(NSDate*)d
{
    NSTimeInterval time = [d timeIntervalSinceDate:[NSDate date]];
	return (NSInteger)time / 60;
}

+ (NSInteger)minutesBetweenThisDate:(NSDate*)d1 andDate:(NSDate*)d2
{
    NSTimeInterval time = [d1 timeIntervalSinceDate:d2];
	return (NSInteger)time / 60;
}

+ (NSInteger)secondsBetweenThisDate:(NSDate*)d1 andDate:(NSDate*)d2
{
    NSTimeInterval time = [d1 timeIntervalSinceDate:d2];
	return (NSInteger)time;
}

+ (NSInteger)daysBetweenDate:(NSDate*)date
{
    NSTimeInterval time = [date timeIntervalSince1970];
	return abs(time / 60 / 60 / 24);
}

+ (NSDictionary*)updateTimerWithNumSeconds:(NSInteger)seconds
{
//    if(seconds > 0)
//        seconds --;
    
	NSInteger hours = (NSInteger)seconds / 3600;
	NSInteger remainder = (NSInteger)seconds % 3600;
	NSInteger minutes = (NSInteger)(remainder / 60);
	NSInteger _seconds = (NSInteger)(remainder % 60);
	
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setValue:[NSNumber numberWithInteger:hours] forKey:@"hours"];
    [dictionary setValue:[NSNumber numberWithInteger:minutes] forKey:@"minutes"];
    [dictionary setValue:[NSNumber numberWithInteger:_seconds] forKey:@"seconds"];
    
    return dictionary;
}
+ (NSInteger)yearsBetweenCurrentDateAndDate:(NSDate*)date
{
    NSInteger years;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents *dateComponentsNow = [calendar components:unitFlags fromDate:[NSDate date]];
    NSDateComponents *dateComponentsBirth = [calendar components:unitFlags fromDate:date];
    
    if (([dateComponentsNow month] < [dateComponentsBirth month]) ||
           (([dateComponentsNow month] == [dateComponentsBirth month]) && ([dateComponentsNow day] < [dateComponentsBirth day]))) {
        years = [dateComponentsNow year] - [dateComponentsBirth year] - 1;
        } else {
            years = [dateComponentsNow year] - [dateComponentsBirth year];
            }
    
    //NSLog(@"years:%d", years);
    return years;
}




//Jameel methods


+(NSDate *)dateFromDateString:(NSString *)dateString{


    NSDateFormatter *dateFormat = [[[NSDateFormatter alloc] init] autorelease];
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [dateFormat setTimeZone:gmt];
	[dateFormat setDateFormat:@"MM/dd/yyyy h:mm:ss a"];
    NSDate *date = [dateFormat dateFromString:dateString];
    
    return date;

    
}

+(NSString *)hourStringFromDate:(NSDate *)date{
    
    
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    //dateFormatter.dateFormat = @"MM/dd/yyyy h:mm:ss a";
    dateFormatter.dateFormat = @"h a";
    NSTimeZone *gmt = [NSTimeZone localTimeZone];
    [dateFormatter setTimeZone:gmt];
    NSString *timeStamp = [dateFormatter stringFromDate:date];

    return timeStamp;
}


@end
