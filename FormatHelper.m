//
//  FormatHelper.m
//  ConsumeWSDL
//
//  Created by Pierre Thelusma on 11/19/13.
//  Copyright (c) 2013 Pierre Thelusma. All rights reserved.
//

#import "FormatHelper.h"

@implementation FormatHelper

+ (NSString *) formatDate: (NSDate *) date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterFullStyle];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    
    return [formatter stringFromDate: date];
    
}

+ (NSDate *) jsonDateToLocalDate:(NSString *) jsonDate
{
    
    NSDate *date = nil;
    
    if(![jsonDate isKindOfClass:[NSNull class]])
    {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SS"];
        date = [df dateFromString:jsonDate];
    }
    
    return date;
    
}

+ (NSString *) localeDateToJsonDate: (NSDate *) nsDate
{
    NSString *date = nil;
    
    if(![nsDate isKindOfClass:[NSNull class]])
    {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SS"];
        
        date = [df stringFromDate:nsDate];
    }
    
    return date;
    
}

@end
