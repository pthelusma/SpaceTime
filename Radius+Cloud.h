//
//  Radius+Cloud.h
//  ConsumeWSDL
//
//  Created by Pierre Thelusma on 12/9/13.
//  Copyright (c) 2013 Pierre Thelusma. All rights reserved.
//

#import "Radius.h"

@interface Radius (Cloud)

+ (void) createRadius: (NSDictionary *) dictionary context:(NSManagedObjectContext *)context;

+ (Radius *) retrieveRadius:(NSInteger) radius_id context:(NSManagedObjectContext *)context;

@end
