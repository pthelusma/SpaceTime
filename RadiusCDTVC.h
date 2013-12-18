//
//  RadiusCDTVC.h
//  ConsumeWSDL
//
//  Created by Pierre Thelusma on 12/10/13.
//  Copyright (c) 2013 Pierre Thelusma. All rights reserved.
//

#import "CoreDataTableViewController.h"
#import "Radius.h"

@interface RadiusCDTVC : CoreDataTableViewController

@property (nonatomic, strong) Radius *radius;
@property (nonatomic, strong) NSManagedObjectContext *context;

@end
