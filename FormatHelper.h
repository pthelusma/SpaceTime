//
//  FormatHelper.h
//  ConsumeWSDL
//
//  Created by Pierre Thelusma on 11/19/13.
//  Copyright (c) 2013 Pierre Thelusma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FormatHelper : NSObject

+ (NSString *) formatDate: (NSDate *) date;
+ (NSDate *) jsonDateToLocalDate:(NSString *) jsonDate;
+ (NSString *) localeDateToJsonDate: (NSDate *) nsDate;

@end
