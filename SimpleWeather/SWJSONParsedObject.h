//
//  SWJSONParsedObject.h
//  SimpleWeather
//
//  Created by Dim on 15.07.15.
//  Copyright (c) 2015 Dmitriy Baklanov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SWJSONParsedObject : NSObject

@property (nonatomic, retain) NSNumber * cityID;
@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) NSNumber * lat;
@property (nonatomic, retain) NSNumber * lon;
@property (nonatomic, retain) NSString * name;

@property (nonatomic, retain) NSNumber * conditionID;
@property (nonatomic, retain) NSString * icon;
@property (nonatomic, retain) NSString * info;
@property (nonatomic, retain) NSString * main;
@property (nonatomic, retain) NSNumber * temp;
@property (nonatomic, retain) NSNumber * updateTime;

@end
