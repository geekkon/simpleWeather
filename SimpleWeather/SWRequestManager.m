//
//  SWRequestManager.m
//  SimpleWeather
//
//  Created by Dim on 14.07.15.
//  Copyright (c) 2015 Dmitriy Baklanov. All rights reserved.
//

#import "SWRequestManager.h"

NSString * const templateForRequest = @"http://api.openweathermap.org/data/2.5/%@&units=metric";

@implementation SWRequestManager

- (void)getDataFromServerWithParams:(NSDictionary *)params completionHandler:(void (^)(BOOL, NSData *, NSError *))completionHandler {
    
    if (!completionHandler) {
        return;
    }
    
    NSString *requestString = [self requestStringFromParams:params];
    
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:requestString]
                                 completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                     
                                     dispatch_async(dispatch_get_main_queue(), ^{
                                         if (error) {
                                             completionHandler(NO, nil, error);
                                         } else {
                                             completionHandler(YES, data, nil);
                                         }
                                     });
                                 }] resume];
}

#pragma mark - Private

- (NSString *)requestStringFromParams:(NSDictionary *)params {
    
    NSString *formatString = nil;
    
    if (params[@"cityID"]) {
        
        formatString = [NSString stringWithFormat:@"weather?id=%@", params[@"cityID"]];
        
    } else if (params[@"cities"]) {
        
        formatString = [NSString stringWithFormat:@"find?q=%@&type=like", [self prepareStringForRequest:params[@"cities"]]];
        
    } else if (params[@"location"]) {
        
    }
    
    NSString *stringURL = [NSString stringWithFormat:templateForRequest, formatString];
    
    NSLog(@"%@", stringURL);
    
    return stringURL;
}

- (NSString *)prepareStringForRequest:(NSString *)string {
    
    NSArray *components = [string componentsSeparatedByString:@" "];
    
    return [components componentsJoinedByString:@"+"];
}

@end
