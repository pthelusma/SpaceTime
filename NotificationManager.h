//
//  NotificationManager.h
//  ConsumeWSDL
//
//  Created by Pierre Thelusma on 12/18/13.
//  Copyright (c) 2013 Pierre Thelusma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotificationManager : NSObject

@property (nonatomic, strong) NSManagedObjectContext *context;

+ (instancetype)sharedNotificationManager;
- (void) registerNotifications;
+ (void)scheduleLocalNotification:(NSString *)message fireDate:(NSDate *) fireDate type:(NSString *) notificationType identifier:(NSString *) alternate_id;

@end
