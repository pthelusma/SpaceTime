//
//  TaskCDTVC.h
//  ConsumeWSDL
//
//  Created by Pierre Thelusma on 11/17/13.
//  Copyright (c) 2013 Pierre Thelusma. All rights reserved.
//

#import "CoreDataTableViewController.h"
#import "LocationService.h"
#import <CoreLocation/CoreLocation.h>
#import "LocationService.h"

@interface TaskCDTVC : CoreDataTableViewController <CLLocationManagerDelegate>

@property (nonatomic, strong) NSManagedObjectContext *context;



@end
