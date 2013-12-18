//
//  TaskLocation+Cloud.m
//  ConsumeWSDL
//
//  Created by Pierre Thelusma on 12/11/13.
//  Copyright (c) 2013 Pierre Thelusma. All rights reserved.
//

#import "TaskLocation+Cloud.h"

@implementation TaskLocation (Cloud)

+ (void) createTaskLocation:(NSDictionary *) dictionary context:(NSManagedObjectContext *)context
{
    TaskLocation *tl = nil;
    NSNumber *task_id = [dictionary objectForKey:@"task_id"];
    
    NSFetchRequest*request = [NSFetchRequest fetchRequestWithEntityName:@"TaskLocation"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"task_location_id" ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"task_id = %d", [task_id integerValue]];
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if(!matches || [matches count] > 1) //many matches on pk
    {
        NSLog(@"%@", @"Multiple matches on primary key");
    } else if([matches count]) //one match on pk
    {
        tl = [matches lastObject];
        
        tl.task_location_id = [dictionary objectForKey:@"task_location_id"];
        tl.radius_id = [dictionary objectForKey:@"radius_id"];
        tl.location_id = [dictionary objectForKey:@"location_id"];
        tl.alternate_id = [dictionary objectForKey:@"alternate_id"];
        
    } else //no matches on pk
    {
        tl = [NSEntityDescription insertNewObjectForEntityForName:@"TaskLocation" inManagedObjectContext:context];
        
        tl.task_id = [dictionary objectForKey:@"task_id"];
        tl.task_location_id = [dictionary objectForKey:@"task_location_id"];
        tl.radius_id = [dictionary objectForKey:@"radius_id"];
        tl.location_id = [dictionary objectForKey:@"location_id"];
        tl.alternate_id = [dictionary objectForKey:@"alternate_id"];
    }
}

+ (TaskLocation *) retrieveTaskLocation:(NSInteger) task_id context:(NSManagedObjectContext *)context
{
    TaskLocation *taskLocation = nil;
    
    NSFetchRequest*request = [NSFetchRequest fetchRequestWithEntityName:@"TaskLocation"];
    request.sortDescriptors = nil;
    request.predicate = [NSPredicate predicateWithFormat:@"task_id = %d", task_id];
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if(!matches || [matches count] > 1) //many matches on pk
    {
        NSLog(@"%@", @"Multiple matches on primary key");
    } else if([matches count]) //one match on pk
    {
        taskLocation = [matches lastObject];
    }
    
    return taskLocation;
}

+ (TaskLocation *) retrieveTaskLocationByAlternateId:(NSString *) alternate_id context:(NSManagedObjectContext *)context
{
    TaskLocation *taskLocation = nil;
    
    NSFetchRequest*request = [NSFetchRequest fetchRequestWithEntityName:@"TaskLocation"];
    request.sortDescriptors = nil;
    request.predicate = [NSPredicate predicateWithFormat:@"alternate_id == %@", alternate_id];
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if(!matches || [matches count] > 1) //many matches on pk
    {
        NSLog(@"%@", @"Multiple matches on primary key");
    } else if([matches count]) //one match on pk
    {
        taskLocation = [matches lastObject];
    }
    
    return taskLocation;
}

@end
