//
//  SWLocationManager.m
//  SimpleWeather
//
//  Created by Dim on 20.07.15.
//  Copyright (c) 2015 Dmitriy Baklanov. All rights reserved.
//

@import CoreLocation;

#import "SWLocationManager.h"

@interface SWLocationManager () <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (copy, nonatomic) HandlerBlock handler;

@end

@implementation SWLocationManager

- (void)getCurrentLocationUsingHandler:(HandlerBlock)handler {
    
    if (!handler) {
        return;
    }
        
    self.handler = handler;
    
    [self.locationManager startUpdatingLocation];
}

#pragma mark - Getters

- (CLLocationManager *)locationManager {
    
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [_locationManager requestWhenInUseAuthorization];
    }
    
    return _locationManager;
}

#pragma mark - <CLLocationManagerDelegate>

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    CLLocation *currentLocation = [locations lastObject];
    
    if (currentLocation.horizontalAccuracy > 0) {
        
        [self.locationManager stopUpdatingLocation];
        
        CLLocationCoordinate2D coordinate = currentLocation.coordinate;
        
        NSDictionary *location = @{@"lat" : @(coordinate.latitude),
                                   @"lon" : @(coordinate.longitude)};
        
        if (self.handler) {
            self.handler(YES, location, nil);
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    if (self.handler) {
        self.handler(NO, nil, error);
    }
}

@end
