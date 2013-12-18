//
//  LocationCDTVC.h
//  ConsumeWSDL
//
//  Created by Pierre Thelusma on 12/10/13.
//  Copyright (c) 2013 Pierre Thelusma. All rights reserved.
//

#import "CoreDataTableViewController.h"
#import "Location.h"

@interface LocationCDTVC : CoreDataTableViewController

@property (nonatomic, strong) Location *location;
@property (nonatomic, strong) NSManagedObjectContext *context;

@end
