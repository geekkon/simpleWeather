//
//  SWDataController.h
//  SimpleWeather
//
//  Created by Dim on 14.07.15.
//  Copyright (c) 2015 Dmitriy Baklanov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SWDataController, SWJSONParsedObject, SWCity;

@protocol SWDataControllerDelegate <NSObject>

@optional

- (void)dataController:(SWDataController *)dataController didFetchWeatherForCity:(SWCity *)city;
- (void)dataController:(SWDataController *)dataController didFailWithError:(NSError *)error;

@end

@interface SWDataController : NSObject

@property (weak, nonatomic) id <SWDataControllerDelegate> delegate;

+ (SWDataController *)defaultController;

- (SWCity *)getCurrentCity;

- (void)fetchWeatherForCity:(SWCity *)city;

- (void)handleParsedObject:(SWJSONParsedObject *)parsedObject;

@end
