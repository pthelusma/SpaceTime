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

+ (void)scheduleLocalNotification:(NSString *)message fireDate:(NSDate *) fireDate;

+ (instancetype)sharedNotificationManager;
- (void) registerNotifications;

@end
