//
//  SWCity.h
//  SimpleWeather
//
//  Created by Dim on 14.07.15.
//  Copyright (c) 2015 Dmitriy Baklanov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SWWeather;

@interface SWCity : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * country;
@property (nonatomic) NSUInteger cityID;
@property (nonatomic) float lon;
@property (nonatomic) float lat;
@property (nonatomic, retain) SWWeather *weather;

@end
