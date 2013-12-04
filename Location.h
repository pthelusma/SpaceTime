//
//  Location.h
//  ConsumeWSDL
//
//  Created by Pierre Thelusma on 12/3/13.
//  Copyright (c) 2013 Pierre Thelusma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Location : NSManagedObject

@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * location_id;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * title;

@end
