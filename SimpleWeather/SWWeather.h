//
//  SWWeather.h
//  SimpleWeather
//
//  Created by Dim on 14.07.15.
//  Copyright (c) 2015 Dmitriy Baklanov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SWCity;

@interface SWWeather : NSManagedObject

@property (nonatomic) NSUInteger updateTime;
@property (nonatomic) NSUInteger conditionID;
@property (nonatomic, retain) NSString * main;
@property (nonatomic, retain) NSString * info;
@property (nonatomic, retain) NSString * icon;
@property (nonatomic) float temp;
@property (nonatomic, retain) SWCity *city;

@end
