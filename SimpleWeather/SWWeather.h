//
//  SWWeather.h
//  SimpleWeather
//
//  Created by Dim on 15.07.15.
//  Copyright (c) 2015 Dmitriy Baklanov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SWCity;

@interface SWWeather : NSManagedObject

@property (nonatomic, retain) NSNumber * conditionID;
@property (nonatomic, retain) NSString * icon;
@property (nonatomic, retain) NSString * info;
@property (nonatomic, retain) NSString * main;
@property (nonatomic, retain) NSNumber * temp;
@property (nonatomic, retain) NSNumber * updateTime;
@property (nonatomic, retain) SWCity *city;

@end
