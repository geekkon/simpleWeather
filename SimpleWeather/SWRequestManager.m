//
//  SWRequestManager.m
//  SimpleWeather
//
//  Created by Dim on 14.07.15.
//  Copyright (c) 2015 Dmitriy Baklanov. All rights reserved.
//

#import "SWRequestManager.h"

NSString * const baseURL = @"http://api.openweathermap.org/data/2.5/weather?id=499099&units=metric";

@implementation SWRequestManager

- (void)getDataFromServerWithCompletionHandler:(CompletionHandler)completionHandler {
    
    if (!completionHandler) {
        return;
    }

    NSString *stringURL = baseURL;
    
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:stringURL]
                                 completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                     
                                     NSLog(@"%@", [NSThread currentThread]);
                                     
                                     dispatch_async(dispatch_get_main_queue(), ^{
                                         
                                         NSLog(@"%@", [NSThread currentThread]);
                                         
                                         if (error) {
                                             completionHandler(NO, nil, error);
                                         } else {
                                             completionHandler(YES, data, nil);
                                         }
                                         
                                     });
                                 }] resume];
    
}

- (void)dealloc {
    NSLog(@"Request Manager DEALLOCATED");
}

@end
