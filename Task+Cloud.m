//
//  Task+Cloud.m
//  ConsumeWSDL
//
//  Created by Pierre Thelusma on 11/15/13.
//  Copyright (c) 2013 Pierre Thelusma. All rights reserved.
//
//  Class used to create and retrieve Task records in CoreData
//

#import "Task+Cloud.h"
#import "TaskLocation+Cloud.h"
#import "TaskLocation.h"
#import "FormatHelper.h"

@implementation Task (Cloud)

+ (Task *) createTask: (NSDictionary *) dictionary context:(NSManagedObjectContext *)context
{
    Task *task = nil;
    NSNumber *task_id = [dictionary objectForKey:@"task_id"];
    
    NSFetchRequest*request = [NSFetchRequest fetchRequestWithEntityName:@"Task"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"task_id = %d", [task_id integerValue]];
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if(!matches || [matches count] > 1) //many matches on pk
    {
        NSLog(@"%@", @"Multiple matches on primary key");
    } else if([matches count]) //one match on pk
    {
        task = [matches lastObject];
        
        task.title = [dictionary objectForKey:@"title"];
        task.create_date = [FormatHelper jsonDateToLocalDate:[dictionary objectForKey:@"create_date"]];
        task.due_date = [FormatHelper jsonDateToLocalDate:[dictionary objectForKey:@"due_date"]];
        task.update_date = [FormatHelper jsonDateToLocalDate:[dictionary objectForKey:@"update_date"]];
        task.latitude = [dictionary objectForKey:@"latitude"];
        task.longitude = [dictionary objectForKey:@"longitude"];
        task.active = [dictionary objectForKey:@"active"];
        task.alternate_id = [dictionary objectForKey:@"alternate_id"];
        task.sync_status = @"synched";
        
        NSArray *taskLocations = [dictionary objectForKey:@"TaskLocations"];
        
        [context performBlock:^{
            for(NSDictionary *tl in taskLocations)
            {
                [TaskLocation createTaskLocation:tl context:context];
            }
        }];
    } else //no matches on pk
    {
        task = [NSEntityDescription insertNewObjectForEntityForName:@"Task" inManagedObjectContext:context];
        
        task.task_id = [dictionary objectForKey:@"task_id"];
        task.title = [dictionary objectForKey:@"title"];
        task.create_date = [FormatHelper jsonDateToLocalDate:[dictionary objectForKey:@"create_date"]];
        task.due_date = [FormatHelper jsonDateToLocalDate:[dictionary objectForKey:@"due_date"]];
        task.update_date = [FormatHelper jsonDateToLocalDate:[dictionary objectForKey:@"update_date"]];
        task.latitude = [dictionary objectForKey:@"latitude"];
        task.longitude = [dictionary objectForKey:@"longitude"];
        task.active = [dictionary objectForKey:@"active"];
        task.alternate_id = [dictionary objectForKey:@"alternate_id"];
        task.sync_status = @"synched";
        
        NSArray *taskLocations = [dictionary objectForKey:@"TaskLocations"];
        
        [context performBlock:^{
            for(NSDictionary *tl in taskLocations)
            {
                [TaskLocation createTaskLocation:tl context:context];
            }
        }];
    }
    
    return task;
}

+ (Task *) retrieveTask:(NSInteger) task_id context:(NSManagedObjectContext *)context
{
    Task *task = nil;
    
    NSFetchRequest*request = [NSFetchRequest fetchRequestWithEntityName:@"Task"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"task_id" ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"task_id = %d", task_id];
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if(!matches || [matches count] > 1) //many matches on pk
    {
        NSLog(@"%@", @"Multiple matches on primary key");
    } else if([matches count]) //one match on pk
    {
        task = [matches lastObject];
    }
    
    return task;
    
}



@end
