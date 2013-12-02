//
//  DetailsViewController.h
//  ConsumeWSDL
//
//  Created by Pierre Thelusma on 11/19/13.
//  Copyright (c) 2013 Pierre Thelusma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task+Cloud.h"
#import <CoreLocation/CoreLocation.h>


@interface DetailsViewController : UIViewController <UITextFieldDelegate, CLLocationManagerDelegate>

@property (nonatomic, strong) Task *task;
@property (nonatomic, strong) NSManagedObjectContext *context;

@end
