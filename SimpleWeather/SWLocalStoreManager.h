//
//  SWLocalStoreManager.h
//  SimpleWeather
//
//  Created by Dim on 19.07.15.
//  Copyright (c) 2015 Dmitriy Baklanov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SWCity, SWJSONParsedObject;

@interface SWLocalStoreManager : NSObject

- (SWCity *)fetchCurrentCity;

- (NSArray *)fetchCities;

- (SWCity *)updateWithParsedObject:(SWJSONParsedObject *)parsedObject;

@end
