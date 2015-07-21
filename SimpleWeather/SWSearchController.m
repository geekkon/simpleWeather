//
//  SWSearchController.m
//  SimpleWeather
//
//  Created by Dim on 19.07.15.
//  Copyright (c) 2015 Dmitriy Baklanov. All rights reserved.
//

#import "SWSearchController.h"
#import "SWLocationManager.h"
#import "SWRequestManager.h"
#import "SWJSONParser.h"

@interface SWSearchController ()

@property (strong, nonatomic) SWLocationManager *locationManager;

@end

@implementation SWSearchController

- (void)findCitiesByNameWithString:(NSString *)string {
    
    NSDictionary *params = @{@"cities" : string};
    
    [self findCitiesWithParams:params];
}

- (void)findCityByCurrentLocation {
   
    __weak SWSearchController *weakSelf = self;
        
    [self.locationManager getCurrentLocationUsingHandler:^(BOOL success, NSDictionary *location, NSError *error) {
        
        if (success) {
            NSDictionary *params = @{@"location" : location};
            [weakSelf findCitiesWithParams:params];
        } else {
            NSLog(@"Location error %@", [error localizedDescription]);
        }
    }];
}

#pragma mark - Getters

- (SWLocationManager *)locationManager {
    
    if (!_locationManager) {
        _locationManager = [[SWLocationManager alloc] init];
    }
    
    return _locationManager;
}

#pragma mark - Private

- (void)findCitiesWithParams:(NSDictionary *)params {
    
    __weak SWSearchController *weakSelf = self;
    
    [[[SWRequestManager alloc] init] getDataFromServerWithParams:params completionHandler:^(BOOL success, NSData *data, NSError *error) {
        
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

@end
