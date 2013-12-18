//
//  Location+Cloud.m
//  ConsumeWSDL
//
//  Created by Pierre Thelusma on 11/15/13.
//  Copyright (c) 2013 Pierre Thelusma. All rights reserved.
//

#import "Location+Cloud.h"

@implementation Location (Cloud)

+ (void) createLocation: (NSDictionary *) dictionary context:(NSManagedObjectContext *)context
{
    Location *location = nil;
    NSNumber *location_id = [dictionary objectForKey:@"location_id"];
    
    NSFetchRequest*request = [NSFetchRequest fetchRequestWithEntityName:@"Location"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"location_id = %d", [location_id integerValue]];
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if(!matches || [matches count] > 1) //many matches on pk
    {
        NSLog(@"%@", @"Multiple matches on primary key");
    } else if([matches count]) //one match on pk
    {
        location = [matches lastObject];
        
        location.title = [dictionary objectForKey:@"title"];
        location.latitude = [dictionary objectForKey:@"latitude"];
        location.longitude = [dictionary objectForKey:@"longitude"];
        
    } else //no matches on pk
    {
        location = [NSEntityDescription insertNewObjectForEntityForName:@"Location" inManagedObjectContext:context];
        
        location.location_id = [dictionary objectForKey:@"location_id"];
        location.title = [dictionary objectForKey:@"title"];
        location.latitude = [dictionary objectForKey:@"latitude"];
        location.longitude = [dictionary objectForKey:@"longitude"];
        
    }
}

+ (Location *) retrieveLocation:(NSInteger) location_id context:(NSManagedObjectContext *)context
{
    Location *location = nil;
    
    NSFetchRequest*request = [NSFetchRequest fetchRequestWithEntityName:@"Location"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"location_id = %d", location_id];
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if(!matches || [matches count] > 1) //many matches on pk
    {
        NSLog(@"%@", @"Multiple matches on primary key");
    } else if([matches count]) //one match on pk
    {
        location = [matches lastObject];
    }
    
    return location;
    
}

@end
