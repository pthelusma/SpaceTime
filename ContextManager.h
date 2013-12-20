//
//  ContextManager.h
//  ConsumeWSDL
//
//  Created by Pierre Thelusma on 12/20/13.
//  Copyright (c) 2013 Pierre Thelusma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContextManager : NSObject

+ (instancetype)sharedContextManager;

@property (nonatomic, strong) NSManagedObjectContext *context;

@end
