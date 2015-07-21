//
//  SWJSONParser.m
//  SimpleWeather
//
//  Created by Dim on 14.07.15.
//  Copyright (c) 2015 Dmitriy Baklanov. All rights reserved.
//

#import "SWJSONParser.h"
#import "SWJSONParsedObject.h"

@implementation SWJSONParser

+ (dispatch_queue_t)queue {
    
   return dispatch_queue_create("simple.weather.parser.queue", DISPATCH_QUEUE_SERIAL);
}

- (void)parseData:(NSData *)data completionHandler:(void (^)(BOOL success, NSArray *parsedObjects, NSError *error))completionHandler {
    
    if (!completionHandler) {
        return;
    }
    
    dispatch_async([SWJSONParser queue], ^ {
        
        NSError *error = nil;
        
        NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:data
                                                             options:0
                                                               error:&error];
        
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionHandler(NO, nil, error);
            });
        } else {
            if ([NSJSONSerialization isValidJSONObject:JSON]) {
                
                NSMutableArray *parsedObjects = [NSMutableArray array];
                
                if (JSON[@"list"]) {
                    
                    NSArray *list = JSON[@"list"];
                    
                    for (NSDictionary *json in list) {
                        [parsedObjects addObject:[SWJSONParsedObject parsedObjectWithDictionaryFromJSON:json]];
                    }
                    
                } else {
                    
                    
                    SWJSONParsedObject *parsedObject = [SWJSONParsedObject parsedObjectWithDictionaryFromJSON:JSON];
                    
                    [parsedObjects addObject:parsedObject];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionHandler(YES, parsedObjects, nil);
                });
            }
        }
    });
}

@end
