//
//  ContextManager.m
//  ConsumeWSDL
//
//  Created by Pierre Thelusma on 12/20/13.
//  Copyright (c) 2013 Pierre Thelusma. All rights reserved.
//

#import "ContextManager.h"

@implementation ContextManager

+ (instancetype)sharedContextManager
{
    static ContextManager *_sharedContextManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedContextManager = [[ContextManager alloc] init];
    });
    
    return _sharedContextManager;
}

- (id) init
{
    self = [super init];
    
    NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    
    url = [url URLByAppendingPathComponent:@"Document"];
    
    UIManagedDocument *document = [[UIManagedDocument alloc] initWithFileURL:url];
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:[url path]])
    {
        [document saveToURL:url forSaveOperation:UIDocumentSaveForCreating
          completionHandler:^(BOOL success) {
              if(success)
              {
                  self.context = document.managedObjectContext;
              }
          }];
    } else if (document.documentState == UIDocumentStateClosed)
    {
        [document openWithCompletionHandler:^(BOOL success) {
            if(success)
            {
                self.context = document.managedObjectContext;
            }
        }];
    } else
    {
        self.context = document.managedObjectContext;
    }
    
    return self;
    
}

@end
