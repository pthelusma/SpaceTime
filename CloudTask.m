//
//  CloudTask.m
//  ConsumeWSDL
//
//  Created by Pierre Thelusma on 11/16/13.
//  Copyright (c) 2013 Pierre Thelusma. All rights reserved.
//

#import "CloudTask.h"
#import "Context.h"
#import "Task+Cloud.h"


@implementation CloudTask

+ (NSArray *) fetchTasks
{
    
    NSString *query = @"http://pierrethelusma.com/Services/api/task/GetTasks/";
    NSData *jsonData = [[NSString stringWithContentsOfURL:[NSURL URLWithString:query] encoding:NSUTF8StringEncoding error:nil] dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSArray *results = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error] : nil;
    if (error)
        NSLog(@"[%@ %@] JSON error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), error.localizedDescription);
    
    return results;
    
}

@end
