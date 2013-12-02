//
//  CloudTask.h
//  ConsumeWSDL
//
//  Created by Pierre Thelusma on 11/16/13.
//  Copyright (c) 2013 Pierre Thelusma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CloudTask : NSObject

@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) NSArray *jsonObject;

+ (NSArray *) fetchTasks;

@end
