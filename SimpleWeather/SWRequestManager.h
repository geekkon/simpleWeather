//
//  SWRequestManager.h
//  SimpleWeather
//
//  Created by Dim on 14.07.15.
//  Copyright (c) 2015 Dmitriy Baklanov. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^CompletionHandler)(BOOL successful, NSData *data, NSError *error);

@interface SWRequestManager : NSObject

- (void)getDataFromServerWithCompletionHandler:(CompletionHandler)completionHandler;

@end
