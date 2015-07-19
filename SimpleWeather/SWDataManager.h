//
//  SWDataManager.h
//  SimpleWeather
//
//  Created by Dim on 14.07.15.
//  Copyright (c) 2015 Dmitriy Baklanov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SWDataManager, SWJSONParsedObject, SWCity, SWWeather;

@protocol SWDataManagerDelegate <NSObject>

@optional

- (void)dataManager:(SWDataManager *)dataManger didFetchWeather:(SWWeather *)weather forCity:(SWCity *)city;

- (void)dataManager:(SWDataManager *)dataManger didFindCities:(NSArray *)cities;

@end

@interface SWDataManager : NSObject

+ (SWDataManager *)sharedManager;

- (SWCity *)fetchCityFromStore;

- (void)fetchWeatherForCityID:(NSNumber *)cityID delegate:(id <SWDataManagerDelegate>)delegate;

- (void)findCitiesByNameWithString:(NSString *)string delegate:(id <SWDataManagerDelegate>)delegate;

- (void)updateLocalStoreWithParsedObject:(SWJSONParsedObject *)parsedObject delegate:(id <SWDataManagerDelegate>)delegate;

- (NSArray *)fetchCiries;

@end
