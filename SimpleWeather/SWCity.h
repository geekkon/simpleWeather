//
//  SWCity.h
//  SimpleWeather
//
//  Created by Dim on 15.07.15.
//  Copyright (c) 2015 Dmitriy Baklanov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SWWeather;

@interface SWCity : NSManagedObject

@property (nonatomic, retain) NSNumber * cityID;
@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) NSNumber * lat;
@property (nonatomic, retain) NSNumber * lon;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) SWWeather *weather;

@end
