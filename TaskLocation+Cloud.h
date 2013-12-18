//
//  TaskLocation+Cloud.h
//  ConsumeWSDL
//
//  Created by Pierre Thelusma on 12/11/13.
//  Copyright (c) 2013 Pierre Thelusma. All rights reserved.
//

#import "TaskLocation.h"

@interface TaskLocation (Cloud)

+ (void) createTaskLocation: (NSDictionary *) dictionary context:(NSManagedObjectContext *)context;

+ (TaskLocation *) retrieveTaskLocation:(NSInteger) task_id context:(NSManagedObjectContext *)context;

+ (TaskLocation *) retrieveTaskLocationByAlternateId:(NSString *) alternate_id context:(NSManagedObjectContext *)context;

@end
