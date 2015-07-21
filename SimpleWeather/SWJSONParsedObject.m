//
//  SWJSONParsedObject.m
//  SimpleWeather
//
//  Created by Dim on 15.07.15.
//  Copyright (c) 2015 Dmitriy Baklanov. All rights reserved.
//

#import "SWJSONParsedObject.h"

@implementation SWJSONParsedObject

+ (SWJSONParsedObject *)parsedObjectWithDictionaryFromJSON:(NSDictionary *)JSON {
    
    SWJSONParsedObject *parsedObject = [[SWJSONParsedObject alloc] init];
    
    parsedObject.name = JSON[@"name"];
    parsedObject.country = JSON[@"sys"][@"country"];
    parsedObject.cityID =  JSON[@"id"] ;
    parsedObject.lon = JSON[@"coord"][@"lon"];
    parsedObject.lat = JSON[@"coord"][@"lat"];
    
    NSArray *weather = JSON[@"weather"];
    
    if ([weather firstObject]) {
        parsedObject.conditionID = [weather firstObject][@"id"];
        parsedObject.icon = [weather firstObject][@"icon"];
        parsedObject.info = [weather firstObject][@"description"];
        parsedObject.main = [weather firstObject][@"main"];
    }
    
    parsedObject.temp = JSON[@"main"][@"temp"];
    parsedObject.updateTime = JSON[@"dt"];
    
    return parsedObject;
}

@end
