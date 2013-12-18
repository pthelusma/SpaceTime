//
//  Radius.h
//  ConsumeWSDL
//
//  Created by Pierre Thelusma on 12/9/13.
//  Copyright (c) 2013 Pierre Thelusma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Radius : NSManagedObject

@property (nonatomic, retain) NSNumber * radius_id;
@property (nonatomic, retain) NSString * unit;
@property (nonatomic, retain) NSString * radius_description;
@property (nonatomic, retain) NSNumber * radius_distance;

@end
