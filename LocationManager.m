//
//  LocationManager.m
//  ConsumeWSDL
//
//  Created by Pierre Thelusma on 12/18/13.
//  Copyright (c) 2013 Pierre Thelusma. All rights reserved.
//

#import "LocationManager.h"
#import "NotificationManager.h"
#import "Context.h"
#import "Task.h"
#import "Task+Cloud.h"
#import "Radius.h"
#import "Radius+Cloud.h"
#import "Location.h"
#import "Location+Cloud.h"
#import "TaskLocation.h"
#import "TaskLocation+Cloud.h"

@interface LocationManager () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation LocationManager

+ (instancetype)sharedLocationManager
{
    static LocationManager *_sharedLocationManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedLocationManager = [[LocationManager alloc] init];
    });
    
    return _sharedLocationManager;
}

- (id) init
{
    self = [super init];
    
    if(!self.context)
    {
        [Context createContext:^(NSManagedObjectContext *context){
            self.context = context;
        } refresh:^{
            nil;
        }];
    }
    
    return self;
    
}

- (void)startMonitoringLocationChanges
{
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    
    [self.locationManager startUpdatingLocation];
}

- (void)stopMonitoringLocationChanges;
{
    [self.locationManager stopUpdatingLocation];
}

- (CLLocationManager *)locationManager
{
    if (!_locationManager)
    {
        _locationManager = [[CLLocationManager alloc] init];
    }
    
    return _locationManager;
}

- (CLLocation *)currentLocation
{
    return self.locationManager.location;
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    
    self.currentLocation = [locations lastObject];
    NSLog(@"latitude %+.6f, longitude %+.6f\n", self.currentLocation.coordinate.latitude, self.currentLocation.coordinate.longitude);
}

- (void) registerRegions
{
    
    Boolean isRegionMonitoringAvailable = YES;
    
    if(isRegionMonitoringAvailable)
    {
        [self.context performBlock:^{
            NSFetchRequest*request = [NSFetchRequest fetchRequestWithEntityName:@"TaskLocation"];
            request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"task_location_id" ascending:YES]];
            request.predicate = nil;
            
            NSError *error = nil;
            NSArray *matches = [self.context executeFetchRequest:request error:&error];
            
            for(TaskLocation *taskLocation in matches)
            {
                Radius *radius = [Radius retrieveRadius:[taskLocation.radius_id integerValue] context:self.context];
                Location *location = [Location retrieveLocation:[taskLocation.location_id integerValue] context:self.context];
                
                CLCircularRegion *geoRegion = [[CLCircularRegion alloc]
                                               initWithCenter:CLLocationCoordinate2DMake([location.latitude doubleValue], [location.longitude doubleValue])
                                               radius:[radius.radius_distance integerValue]
                                               identifier:taskLocation.alternate_id];
                
                [self.locationManager startMonitoringForRegion:geoRegion];
                [self.locationManager requestStateForRegion:geoRegion];
                
                NSLog(@"Registered region: radius=%@, latitude=%@ longitude=%@", radius.radius_description, location.latitude, location.longitude);
            }
        }];
    }
}

- (void) locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    NSLog(@"%@", @"Entered region");
}

- (void) locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    NSLog(@"%@", @"Exited region");
}

- (void)locationManager:(CLLocationManager *)manager
      didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    if (state == CLRegionStateInside)
    {
        TaskLocation *taskLocation = [TaskLocation retrieveTaskLocationByAlternateId:[region identifier] context:self.context];
        Radius *radius = [Radius retrieveRadius:[taskLocation.radius_id integerValue] context:self.context];
        Location *location = [Location retrieveLocation:[taskLocation.location_id integerValue] context:self.context];
        Task *task = [Task retrieveTask:[taskLocation.task_id integerValue] context:self.context];
        
        NSString *message = [NSString stringWithFormat:@"You are within %@ of location %@ for task %@", radius.radius_description, location.title, task.title];
        
        [NotificationManager scheduleLocalNotification:message fireDate: nil];
    }
}

- (void) locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error
{
    NSLog(@"%@", error);
}

@end