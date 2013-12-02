//
//  LocationService.m
//  ConsumeWSDL
//
//  Created by Pierre Thelusma on 11/25/13.
//  Copyright (c) 2013 Pierre Thelusma. All rights reserved.
//

#import "LocationService.h"

@implementation LocationService


- (id) init
{
    self = [super init];
    
    if(self)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.locationManager = [[CLLocationManager alloc] init];
        });
        [self.locationManager setDelegate:self];
        [self.locationManager setDistanceFilter:kCLDistanceFilterNone];
        [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        [self.locationManager startUpdatingLocation];
    }
    
    return self;
}

- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation* location = [locations lastObject];
    
    NSLog(@"latitude %+.6f, longitude %+.6f\n",
          location.coordinate.latitude,
          location.coordinate.longitude);
}

- (void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"%@", @"Handle error");
}

@end
