//
//  SWLocationManager.h
//  SimpleWeather
//
//  Created by Dim on 20.07.15.
//  Copyright (c) 2015 Dmitriy Baklanov. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^HandlerBlock)(BOOL success, NSDictionary *location, NSError *error);

@interface SWLocationManager : NSObject

- (void)getCurrentLocationUsingHandler:(HandlerBlock)handler;

@end
