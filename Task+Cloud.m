//
//  Task+Cloud.m
//  ConsumeWSDL
//
//  Created by Pierre Thelusma on 11/15/13.
//  Copyright (c) 2013 Pierre Thelusma. All rights reserved.
//

#import "Task+Cloud.h"
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
    }
    
    return task;
}






@end
