//
//  TaskLocation.h
//  ConsumeWSDL
//
//  Created by Pierre Thelusma on 12/17/13.
//  Copyright (c) 2013 Pierre Thelusma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface TaskLocation : NSManagedObject

@property (nonatomic, retain) NSNumber * task_location_id;
@property (nonatomic, retain) NSNumber * task_id;
@property (nonatomic, retain) NSNumber * location_id;
@property (nonatomic, retain) NSNumber * radius_id;
@property (nonatomic, retain) NSString * alternate_id;

@end
