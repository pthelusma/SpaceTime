//
//  LocationManager.h
//  ConsumeWSDL
//
//  Created by Pierre Thelusma on 12/18/13.
//  Copyright (c) 2013 Pierre Thelusma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationManager : NSObject <CLLocationManagerDelegate>

@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) CLLocation *currentLocation;
@property (nonatomic, strong) NSString *cityState;

+ (instancetype)sharedLocationManager;
- (void)startMonitoringLocationChanges;
- (void)stopMonitoringLocationChanges;
- (void) registerRegions;


@end
