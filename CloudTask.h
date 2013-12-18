//
//  CloudTask.h
//  ConsumeWSDL
//
//  Created by Pierre Thelusma on 11/16/13.
//  Copyright (c) 2013 Pierre Thelusma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CloudTask : NSObject

+ (NSArray *) fetchTasks;
+ (NSArray *) fetchLocations;
+ (NSArray *) fetchRadii;
+ (NSString *) fetchCityStateByLat:(NSNumber *)lat Lng:(NSNumber *)lng;


@end
