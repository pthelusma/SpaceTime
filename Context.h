//
//  Context.h
//  SPoT
//
//  Created by Pierre Thelusma on 10/30/13.
//  Copyright (c) 2013 Pierre Thelusma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Context : NSObject

+ (void) createContext:(void(^)(NSManagedObjectContext *))callback refresh:(void(^)(void))refresh;

@end
