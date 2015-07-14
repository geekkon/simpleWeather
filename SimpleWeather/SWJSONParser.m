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

- (void)parseData:(NSData *)data completionHandler:(void (^)(BOOL, SWJSONParsedObject *, NSError *))completionHandler {
    
    if (!completionHandler) {
        return;
    }
    
    NSLog(@"%@", [NSThread currentThread]);
    
    dispatch_async([SWJSONParser queue], ^ {
        
        NSLog(@"%@", [NSThread currentThread]);
        
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
                
                SWJSONParsedObject *parsedObject = [[SWJSONParsedObject alloc] init];
                
                parsedObject.name = JSON[@"name"];
                parsedObject.country = JSON[@"sys"][@"country"];
                parsedObject.cityID =  JSON[@"id"] ;
                parsedObject.lon = JSON[@"coord"][@"lon"];
                parsedObject.lat = JSON[@"coord"][@"lat"];
                
                parsedObject.conditionID = JSON[@"weather"][0][@"id"];
                parsedObject.icon = JSON[@"weather"][0][@"icon"];
                parsedObject.info = JSON[@"weather"][0][@"description"];
                parsedObject.main = JSON[@"weather"][0][@"main"];
                parsedObject.temp = JSON[@"main"][@"temp"];
                parsedObject.updateTime = JSON[@"dt"];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionHandler(YES, parsedObject, nil);
                });
            }
        }
    });
}

- (void)dealloc {
    NSLog(@"Parser DEALLOCATED");
}


@end
