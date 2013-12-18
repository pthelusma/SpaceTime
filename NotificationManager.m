//
//  NotificationManager.m
//  ConsumeWSDL
//
//  Created by Pierre Thelusma on 12/18/13.
//  Copyright (c) 2013 Pierre Thelusma. All rights reserved.
//

#import "NotificationManager.h"
#import "Context.h"
#import "Task.h"
#import "Task+Cloud.h"

@implementation NotificationManager

+ (instancetype)sharedNotificationManager
{
    static NotificationManager *_sharedNotificationManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedNotificationManager= [[NotificationManager alloc] init];
    });
    
    return _sharedNotificationManager;
}

- (id) init
{
    self = [super init];
    
    if(!self.context)
    {
        [Context createContext:^(NSManagedObjectContext *context){
            self.context = context;
        } refresh:^{
            nil;
        }];
    }
    
    return self;
    
}

+ (void)scheduleLocalNotification:(NSString *)message fireDate:(NSDate *) fireDate
{
    UILocalNotification *localNotification = [UILocalNotification new];
    localNotification.alertBody = message;
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    
    if(fireDate)
    {
        localNotification.fireDate = fireDate;
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    } else
    {
        [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
    }
}

- (void) registerNotifications
{
    
    [self.context performBlock:^{
        NSFetchRequest*request = [NSFetchRequest fetchRequestWithEntityName:@"Task"];
        request.sortDescriptors = nil;
        request.predicate = nil;
        
        NSError *error = nil;
        NSArray *matches = [self.context executeFetchRequest:request error:&error];
        
        for(Task *task in matches)
        {
            if(task.due_date)
            {
                NSString *message = [NSString stringWithFormat:@"Task %@ is due now", task.title];
                [NotificationManager scheduleLocalNotification:message fireDate:task.due_date];
            }
        }
    }];
}

@end
