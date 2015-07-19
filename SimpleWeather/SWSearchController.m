//
//  SWSearchController.m
//  SimpleWeather
//
//  Created by Dim on 19.07.15.
//  Copyright (c) 2015 Dmitriy Baklanov. All rights reserved.
//

#import "SWSearchController.h"
#import "SWRequestManager.h"
#import "SWJSONParser.h"

@implementation SWSearchController

- (void)findCitiesByNameWithString:(NSString *)string {
    
    NSDictionary *params = @{@"cities" : string};
    
    __weak SWSearchController *weakSelf = self;
    
    [[[SWRequestManager alloc] init] getDataFromServerWithParams:params
                                               completionHandler:^(BOOL success, NSData *data, NSError *error) {
                                                   if (success) {
                                                       [weakSelf parseCitiesWithData:data];
                                                   } else {
                                                       NSLog(@"Request error %@", [error localizedDescription]);
                                                   }
                                               }];
}

- (void)parseCitiesWithData:(NSData *)data {
    
    __weak SWSearchController *weakSelf = self;
    
    [[[SWJSONParser alloc] init] parseData:data completionHandler:^(BOOL success, NSArray *parsedObjects, NSError *error) {
        if (success) {
            if ([weakSelf.delegate respondsToSelector:@selector(searchController:didFindCities:)]) {
                [weakSelf.delegate searchController:weakSelf didFindCities:parsedObjects];
            }
        } else {
            NSLog(@"Parsing error %@", [error localizedDescription]);
        }
    }];
}

@end
