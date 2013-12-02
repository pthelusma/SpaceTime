//
//  Task.h
//  ConsumeWSDL
//
//  Created by Pierre Thelusma on 11/21/13.
//  Copyright (c) 2013 Pierre Thelusma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Task : NSManagedObject

@property (nonatomic, retain) NSNumber * task_id;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSDate * create_date;
@property (nonatomic, retain) NSDate * update_date;
@property (nonatomic, retain) NSDate * due_date;
@property (nonatomic, retain) NSString * alternate_id;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSNumber * active;
@property (nonatomic, retain) NSString * sync_status;

@end
