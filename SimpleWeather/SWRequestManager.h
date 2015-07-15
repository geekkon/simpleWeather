//
//  SWRequestManager.h
//  SimpleWeather
//
//  Created by Dim on 14.07.15.
//  Copyright (c) 2015 Dmitriy Baklanov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SWRequestManager : NSObject

- (void)getDataFromServerWithCityID:(NSNumber *)cityID completionHandler:(void (^)(BOOL success, NSData *data, NSError *error))completionHandler;

@end
