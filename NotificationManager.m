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
        _sharedNotificationManager = [[NotificationManager alloc] init];
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

/*
 Creates and schedules notifications in iOS notification center. UserInfo dictionary contains unique information pertaining to particular notification
 */
+ (void)scheduleLocalNotification:(NSString *)message fireDate:(NSDate *) fireDate type:(NSString *) notificationType identifier:(NSString *) alternate_id
{
    UILocalNotification *localNotification = [UILocalNotification new];
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
    
    [userInfo setValue:alternate_id forKey:@"alternate_id"];
    [userInfo setValue:notificationType forKey:@"notificationType"];
    [userInfo setValue:@"SpaceTime" forKey:@"application"];
    
    localNotification.alertBody = message;
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    localNotification.userInfo = userInfo;
    
    if(fireDate)
    {
        localNotification.fireDate = fireDate;
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    } else
    {
        [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
    }
}

/*
 Method used to register all time-based notifications.
 */
- (void) registerNotifications
{

    NSFetchRequest*request = [NSFetchRequest fetchRequestWithEntityName:@"Task"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"task_id" ascending:YES]];
    request.predicate = nil;
    
    NSError *error = nil;
    NSArray *matches = [self.context executeFetchRequest:request error:&error];
    
    for(Task *task in matches)
    {
        if(task.due_date)
        {
            NSString *message = [NSString stringWithFormat:@"Task %@ is due now", task.title];
            
            for(UILocalNotification *localNotification in [[UIApplication sharedApplication] scheduledLocalNotifications])
            {
                NSDictionary *userInfo = [localNotification userInfo];
                
                if([[userInfo objectForKey:@"alternate_id"] isEqualToString:task.alternate_id])
                {
                    NSLog(@"Cancelled notification for: %@", message);
                    [[UIApplication sharedApplication] cancelLocalNotification:localNotification];
                }
            }
            
            [NotificationManager scheduleLocalNotification:message fireDate:task.due_date type:@"Time" identifier:task.alternate_id];
            
            NSLog(@"Registered notification: %@", message);
        }
    }

}

@end
