//
//  Task+Cloud.h
//  ConsumeWSDL
//
//  Created by Pierre Thelusma on 11/15/13.
//  Copyright (c) 2013 Pierre Thelusma. All rights reserved.
//

#import "Task.h"

@interface Task (Cloud) <NSURLConnectionDataDelegate>

+ (Task *) createTask: (NSDictionary *) dictionary context:(NSManagedObjectContext *)context;


@end
