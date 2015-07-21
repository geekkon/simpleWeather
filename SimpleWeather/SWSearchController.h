//
//  SWSearchController.h
//  SimpleWeather
//
//  Created by Dim on 19.07.15.
//  Copyright (c) 2015 Dmitriy Baklanov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SWSearchController;

@protocol SWSearchControllerDelegate <NSObject>

@optional

- (void)searchController:(SWSearchController *)searchController didFindCities:(NSArray *)cities;
- (void)searchController:(SWSearchController *)searchController didFailWithError:(NSError *)error;

@end

@interface SWSearchController : NSObject

@property (weak, nonatomic) id <SWSearchControllerDelegate> delegate;

- (void)findCitiesByNameWithString:(NSString *)string;
- (void)findCityByCurrentLocation;

@end
