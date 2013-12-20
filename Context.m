//
//  Context.m
//  SPoT
//
//  Created by Pierre Thelusma on 10/30/13.
//  Copyright (c) 2013 Pierre Thelusma. All rights reserved.
//
//  Class created to establish managed object context for application in order to access CoreData
//
#import "Context.h"

@implementation Context

static NSManagedObjectContext *context = nil;

+ (void) createContext:(void(^)(NSManagedObjectContext *))callback refresh:(void(^)(void))refresh
{
    NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    
    url = [url URLByAppendingPathComponent:@"Document"];
    
    UIManagedDocument *document = [[UIManagedDocument alloc] initWithFileURL:url];
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:[url path]])
    {
        [document saveToURL:url forSaveOperation:UIDocumentSaveForCreating
          completionHandler:^(BOOL success) {
              if(success)
              {
                  context = document.managedObjectContext;
                  callback(context);
                  refresh();
              }
          }];
    } else if (document.documentState == UIDocumentStateClosed)
    {
        [document openWithCompletionHandler:^(BOOL success) {
            if(success)
            {
                context = document.managedObjectContext;
                callback(context);
            }
        }];
    } else
    {
        context = document.managedObjectContext;
        callback(context);
    }
}

@end
