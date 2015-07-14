//
//  SWDataManager.h
//  SimpleWeather
//
//  Created by Dim on 14.07.15.
//  Copyright (c) 2015 Dmitriy Baklanov. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^CompletionBlock)(BOOL successful,  id oblect, NSError *error);

@interface SWDataManager : NSObject

+ (SWDataManager *)sharedManager;

- (void)fetchWeatherWithCityID:(NSUInteger)cityID
               completionBlock:(CompletionBlock)completionBlock;
@end
