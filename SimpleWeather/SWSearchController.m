//
//  SWSearchController.m
//  SimpleWeather
//
//  Created by Dim on 19.07.15.
//  Copyright (c) 2015 Dmitriy Baklanov. All rights reserved.
//

@import CoreLocation;

#import "SWSearchController.h"
#import "SWRequestManager.h"
#import "SWJSONParser.h"

@interface SWSearchController () <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation SWSearchController

- (void)findCitiesByNameWithString:(NSString *)string {
    
    NSDictionary *params = @{@"cities" : string};
    
    [self findCitiesWithParams:params];
}

- (void)findCityByCurrentLocation {
    
    [self.locationManager startUpdatingLocation];
}

#pragma mark - Getters

- (CLLocationManager *)locationManager {
    
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest; // kCLLocationAccuracyThreeKilometers;
        [_locationManager requestWhenInUseAuthorization];
    }
    
    return _locationManager;
}

#pragma mark - Private

- (void)findCitiesWithParams:(NSDictionary *)params {
    
    __weak SWSearchController *weakSelf = self;
    
    [[[SWRequestManager alloc] init] getDataFromServerWithParams:params
                                               completionHandler:^(BOOL success, NSData *data, NSError *error) {
                                                   if (success) {
                                                       [weakSelf parseCitiesWithData:data];
                                                   } else {
                                                       NSLog(@"Request error %@", [error localizedDescription]);
                                                   }
                                               }];
}

- (void)parseCitiesWithData:(NSData *)data {
    
    __weak SWSearchController *weakSelf = self;
    
    [[[SWJSONParser alloc] init] parseData:data completionHandler:^(BOOL success, NSArray *parsedObjects, NSError *error) {
        if (success) {
            if ([weakSelf.delegate respondsToSelector:@selector(searchController:didFindCities:)]) {
                [weakSelf.delegate searchController:weakSelf didFindCities:parsedObjects];
            }
        } else {
            NSLog(@"Parsing error %@", [error localizedDescription]);
        }
    }];
}



#pragma mark - <CLLocationManagerDelegate>

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    CLLocation *currentLocation = [locations lastObject];
    
    if (currentLocation.horizontalAccuracy > 0) {
        
        [self.locationManager stopUpdatingLocation];

        CLLocationCoordinate2D coordinate = currentLocation.coordinate;
        
        NSDictionary *location = @{@"lat" : @(coordinate.latitude),
                                   @"lon" : @(coordinate.longitude)};
        
        NSDictionary *params = @{@"location" : location};
        
        [self findCitiesWithParams:params];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
 
    NSLog(@"%@", [error localizedDescription]);
}

@end
