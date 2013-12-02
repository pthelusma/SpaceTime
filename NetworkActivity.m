//
//  NetworkActivity.m
//  SPoT
//
//  Created by Pierre Thelusma on 10/17/13.
//  Copyright (c) 2013 Pierre Thelusma. All rights reserved.
//

#import "NetworkActivity.h"

@implementation NetworkActivity

+ (void) startIndicator
{
    [self updateCounter: 1];
}

+ (void) stopIndicator
{
    [self updateCounter:-1];
}

+ (void)updateCounter:(NSUInteger)change
{
    static NSUInteger counter = 0;
    dispatch_queue_t queue = dispatch_queue_create("NetworkActivityIndicator Q", NULL);
    
    dispatch_sync(queue, ^{
        if (counter + change <= 0) {
            counter = 0;
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        } else {
            counter += change;
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        }
    });
}


@end
