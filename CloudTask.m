//
//  CloudTask.m
//  ConsumeWSDL
//
//  Created by Pierre Thelusma on 11/16/13.
//  Copyright (c) 2013 Pierre Thelusma. All rights reserved.
//

#import "CloudTask.h"
#import "Context.h"
#import "Task+Cloud.h"


@implementation CloudTask

+ (NSArray *) fetchTasks
{
    
    NSString *query = @"http://pierrethelusma.com/Services/api/task/GetTasks/";
    NSData *jsonData = [[NSString stringWithContentsOfURL:[NSURL URLWithString:query] encoding:NSUTF8StringEncoding error:nil] dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSArray *results = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error] : nil;
    if (error)
        NSLog(@"[%@ %@] JSON error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), error.localizedDescription);
    
    return results;
    
}

+ (NSArray *) fetchLocations
{
    
    NSString *query = @"http://pierrethelusma.com/Services/api/task/GetLocations/";
    NSData *jsonData = [[NSString stringWithContentsOfURL:[NSURL URLWithString:query] encoding:NSUTF8StringEncoding error:nil] dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSArray *results = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error] : nil;
    if (error)
        NSLog(@"[%@ %@] JSON error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), error.localizedDescription);
    
    return results;
    
}

+ (NSArray *) fetchRadii
{
    
    NSString *query = @"http://pierrethelusma.com/Services/api/task/GetRadii/";
    NSData *jsonData = [[NSString stringWithContentsOfURL:[NSURL URLWithString:query] encoding:NSUTF8StringEncoding error:nil] dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSArray *results = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error] : nil;
    if (error)
        NSLog(@"[%@ %@] JSON error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), error.localizedDescription);
    
    return results;
    
}

+ (NSString *) fetchCityStateByLat:(NSNumber *)lat Lng:(NSNumber *)lng
{
    NSString *query = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?latlng=%f,%f&sensor=true", [lat doubleValue], [lng doubleValue]];
    
    NSData *jsonData = [[NSString stringWithContentsOfURL:[NSURL URLWithString:query] encoding:NSUTF8StringEncoding error:nil] dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *jsonResults = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error] : nil;
    if (error)
        NSLog(@"[%@ %@] JSON error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), error.localizedDescription);
    
    NSString *status = [jsonResults objectForKey:@"status"];
    NSArray *results = [jsonResults objectForKey:@"results"];
    NSString *city = nil;
    NSString *state = nil;
    
    if([status isEqualToString:@"OK"] && results.count > 0)
    {
        for(NSDictionary *result in results)
        {
            NSArray *types = [result objectForKey:@"types"];
            NSPredicate *typePredicate = [NSPredicate predicateWithFormat:@"SELF IN %@", types];
            if([typePredicate evaluateWithObject:@"street_address"])
            {
                NSArray *addressComponents = [result objectForKey:@"address_components"];
                
                for(NSDictionary *addressComponent in addressComponents)
                {
                    NSArray *types = [addressComponent objectForKey:@"types"];
                    NSPredicate *typePredicate = [NSPredicate predicateWithFormat:@"SELF IN %@", types];
                    if([typePredicate evaluateWithObject:@"sublocality"])
                    {
                        city = [addressComponent objectForKey:@"short_name"];
                    }
                    
                    if([typePredicate evaluateWithObject:@"administrative_area_level_1"])
                    {
                        state = [addressComponent objectForKey:@"short_name"];
                    }
                }
            }
        }
    }
    
    return [[city stringByAppendingString:@", "] stringByAppendingString:state];
}

@end
