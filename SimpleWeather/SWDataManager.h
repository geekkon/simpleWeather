//
//  SWDataManager.h
//  SimpleWeather
//
//  Created by Dim on 14.07.15.
//  Copyright (c) 2015 Dmitriy Baklanov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SWDataManager, SWCity, SWWeather;

@protocol SWDataManagerDelegate <NSObject>

@optional

- (void)dataManager:(SWDataManager *)dataManger didFetchWeather:(SWWeather *)weather forCity:(SWCity *)city;

@end

@interface SWDataManager : NSObject

+ (SWDataManager *)sharedManager;

- (SWCity *)fetchCityFromStore;

//- (void)fetchWeatherForCity:(SWCity *)city delegate:(id <SWDataManagerDelegate>)delegate;
- (void)fetchWeatherForCityID:(NSNumber *)cityID delegate:(id <SWDataManagerDelegate>)delegate;




- (NSArray *)fetchCiries;


@end
