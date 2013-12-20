//
//  Radius+Cloud.m
//  ConsumeWSDL
//
//  Created by Pierre Thelusma on 12/9/13.
//  Copyright (c) 2013 Pierre Thelusma. All rights reserved.
//
//  Class used to create and retrieve Radius records in CoreData
//

#import "Radius+Cloud.h"

@implementation Radius (Cloud)

+ (void) createRadius: (NSDictionary *) dictionary context:(NSManagedObjectContext *)context
{
    Radius *radius = nil;
    NSNumber *radius_id = [dictionary objectForKey:@"radius_id"];
    
    NSFetchRequest*request = [NSFetchRequest fetchRequestWithEntityName:@"Radius"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"radius_description" ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"radius_id = %d", [radius_id integerValue]];
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if(!matches || [matches count] > 1) //many matches on pk
    {
        NSLog(@"%@", @"Multiple matches on primary key");
    } else if([matches count]) //one match on pk
    {
        radius = [matches lastObject];
        
        radius.radius_description = [dictionary objectForKey:@"description"];
        radius.radius_distance = [dictionary objectForKey:@"radius_distance"];
        radius.unit = [dictionary objectForKey:@"unit"];
        
    } else //no matches on pk
    {
        radius = [NSEntityDescription insertNewObjectForEntityForName:@"Radius" inManagedObjectContext:context];
        
        radius.radius_id = [dictionary objectForKey:@"radius_id"];
        radius.radius_description = [dictionary objectForKey:@"description"];
        radius.radius_distance = [dictionary objectForKey:@"radius_distance"];
        radius.unit = [dictionary objectForKey:@"unit"];
        
    }
}

+ (Radius *) retrieveRadius:(NSInteger) radius_id context:(NSManagedObjectContext *)context
{
    Radius *radius = nil;
    
    NSFetchRequest*request = [NSFetchRequest fetchRequestWithEntityName:@"Radius"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"radius_id" ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"radius_id = %d", radius_id];
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if(!matches || [matches count] > 1) //many matches on pk
    {
        NSLog(@"%@", @"Multiple matches on primary key");
    } else if([matches count]) //one match on pk
    {
        radius = [matches lastObject];
    }
    
    return radius;
    
}

@end
