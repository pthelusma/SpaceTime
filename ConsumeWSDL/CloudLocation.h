//
//  CloudLocation.h
//  ConsumeWSDL
//
//  Created by Pierre Thelusma on 11/17/13.
//  Copyright (c) 2013 Pierre Thelusma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CloudLocation : NSObject

@property (nonatomic, strong) NSManagedObjectContext *context;

- (void) fetchLocations;

@end
