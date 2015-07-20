//
//  SWDataController.m
//  SimpleWeather
//
//  Created by Dim on 14.07.15.
//  Copyright (c) 2015 Dmitriy Baklanov. All rights reserved.
//


#import "SWDataController.h"
#import "SWLocalStoreManager.h"
#import "SWCity.h"
#import "SWWeather.h"
#import "SWRequestManager.h"
#import "SWJSONParser.h"

#define UPDATE_INTERVAL_IN_SECONDS 60 * 60

@interface SWDataController ()

@property (strong, nonatomic) SWLocalStoreManager *localStoreManager;

@end

@implementation SWDataController

+ (SWDataController *)defaultController {
    
    static SWDataController *controller = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        controller = [[SWDataController alloc] init];
    });
    
    return controller;
}

#pragma mark - Getters

- (SWLocalStoreManager *)localStoreManager {
    
    if (!_localStoreManager) {
        _localStoreManager = [[SWLocalStoreManager alloc] init];
    }
    
    return _localStoreManager;
}

#pragma mark - Public

- (NSArray *)getCities {
 
    return [self.localStoreManager fetchCities];
}

- (SWCity *)getCurrentCity {
    
    SWCity *city = [self.localStoreManager fetchCurrentCity];
    
    if (city && [self shouldUpdateCity:city]) {
        [self getWeatherForCity:city];
    }
    
    return city;
}

- (void)handleParsedObject:(SWJSONParsedObject *)parsedObject {
    
    SWCity *city = [self.localStoreManager updateWithParsedObject:parsedObject];
    
    if ([self.delegate respondsToSelector:@selector(dataController:didFetchWeatherForCity:)]) {
        [self.delegate dataController:self didFetchWeatherForCity:city];
    }
}

#pragma mark - Private

- (void)getWeatherForCity:(SWCity *)city {
    
    NSDictionary *params = @{@"cityID" : city.cityID};
    
    __weak SWDataController *weakSelf = self;
    
    [[[SWRequestManager alloc] init] getDataFromServerWithParams:params
                                               completionHandler:^(BOOL success, NSData *data, NSError *error) {
                                                   if (success) {
                                                       [weakSelf parserTaskWithData:data];
                                                   } else {
                                                       NSLog(@"Request error %@", [error localizedDescription]);
                                                   }
                                               }];
}

- (void)parserTaskWithData:(NSData *)data {
    
    __weak SWDataController *weakSelf = self;
    
    [[[SWJSONParser alloc] init] parseData:data completionHandler:^(BOOL success, NSArray *parsedObjects, NSError *error) {
        if (success) {
            [weakSelf handleParsedObject:[parsedObjects firstObject]];
        } else {
            NSLog(@"Parsing error %@", [error localizedDescription]);
        }
    }];
}

- (BOOL)shouldUpdateCity:(SWCity *)city {
    
    NSTimeInterval updateTime = [city.weather.updateTime integerValue];
    
    NSTimeInterval delta = [[NSDate date] timeIntervalSinceDate:[NSDate dateWithTimeIntervalSince1970:updateTime]];
    
    return (delta > UPDATE_INTERVAL_IN_SECONDS) ? YES : NO;
}

@end
