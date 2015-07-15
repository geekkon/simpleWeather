//
//  SWRequestManager.m
//  SimpleWeather
//
//  Created by Dim on 14.07.15.
//  Copyright (c) 2015 Dmitriy Baklanov. All rights reserved.
//

#import "SWRequestManager.h"

NSString * const baseURL = @"http://api.openweathermap.org/data/2.5/weather?id=%@&units=metric";

@implementation SWRequestManager

- (void)getDataFromServerWithCityID:(NSNumber *)cityID completionHandler:(void (^)(BOOL success, NSData *data, NSError *error))completionHandler {
    
    if (!completionHandler) {
        return;
    }

    NSString *stringURL = [NSString stringWithFormat:baseURL, cityID];
    
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:stringURL]
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

@end
