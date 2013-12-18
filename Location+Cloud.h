//
//  Location+Cloud.h
//  ConsumeWSDL
//
//  Created by Pierre Thelusma on 11/15/13.
//  Copyright (c) 2013 Pierre Thelusma. All rights reserved.
//

#import "Location.h"

@interface Location (Cloud)

+ (void) createLocation: (NSDictionary *) dictionary context:(NSManagedObjectContext *)context;

+ (Location *) retrieveLocation:(NSInteger) location_id context:(NSManagedObjectContext *)context;

@end
