//
//  SWJSONParser.h
//  SimpleWeather
//
//  Created by Dim on 14.07.15.
//  Copyright (c) 2015 Dmitriy Baklanov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SWJSONParser : NSObject

- (void)parseData:(NSData *)data completionHandler:(void (^)(BOOL success, NSArray *parsedObjects, NSError *error))completionHandler;

@end
