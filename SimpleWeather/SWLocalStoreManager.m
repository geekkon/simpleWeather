//
//  SWLocalStoreManager.m
//  SimpleWeather
//
//  Created by Dim on 19.07.15.
//  Copyright (c) 2015 Dmitriy Baklanov. All rights reserved.
//

@import CoreData;

#import "SWLocalStoreManager.h"
#import "SWCity.h"
#import "SWWeather.h"
#import "SWJSONParsedObject.h"

@interface SWLocalStoreManager ()

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

@implementation SWLocalStoreManager

- (SWCity *)fetchCurrentCity {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    fetchRequest.entity = [NSEntityDescription entityForName:@"SWCity"
                                      inManagedObjectContext:self.managedObjectContext];
    fetchRequest.fetchLimit = 1;
    
    NSError *requestError = nil;
    
    NSArray *resultArray = [self.managedObjectContext executeFetchRequest:fetchRequest error:&requestError];
    
    if (requestError) {
        NSLog(@"%@", [requestError localizedDescription]);
        return nil;
    }
    
    return [resultArray firstObject];
}

- (NSArray *)fetchCities {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    fetchRequest.entity = [NSEntityDescription entityForName:@"SWCity"
                                      inManagedObjectContext:self.managedObjectContext];
    NSError *requestError = nil;
    
    NSArray *resultArray = [self.managedObjectContext executeFetchRequest:fetchRequest error:&requestError];
    
    if (requestError) {
        NSLog(@"%@", [requestError localizedDescription]);
        return nil;
    }
    
    return resultArray;
}

- (SWCity *)updateWithParsedObject:(SWJSONParsedObject *)parsedObject {
    
    SWCity *city = [self fetchCurrentCity];
    
    if (!city) {
        city = [NSEntityDescription insertNewObjectForEntityForName:@"SWCity"
                                             inManagedObjectContext:self.managedObjectContext];
    }
    
    SWWeather *weather = city.weather;
    
    if (!weather) {
        weather = [NSEntityDescription insertNewObjectForEntityForName:@"SWWeather"
                                                inManagedObjectContext:self.managedObjectContext];
        city.weather = weather;
    }
    
    city.name = parsedObject.name;
    city.country = parsedObject.country;
    city.cityID = parsedObject.cityID;
    city.lon = parsedObject.lon;
    city.lat = parsedObject.lat;
    
    weather.updateTime = parsedObject.updateTime;
    weather.temp = parsedObject.temp;
    weather.info = parsedObject.info;
    weather.icon = parsedObject.icon;
    weather.conditionID = parsedObject.conditionID;
    weather.main = parsedObject.main;
    
    [self saveContext];
    
    return city;
}

#pragma mark - Core Data stack

- (NSManagedObjectContext *)managedObjectContext {
    
    if (_managedObjectContext) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = self.persistentStoreCoordinator;
    
    if (coordinator) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        _managedObjectContext.persistentStoreCoordinator = coordinator;
    }
    
    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel {
    
    if (_managedObjectModel) {
        return _managedObjectModel;
    }
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"SimpleWeather" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    
    if (_persistentStoreCoordinator) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"SimpleWeather.sqlite"];
    
    NSError *error = nil;
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
    
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                   configuration:nil
                                                             URL:storeURL
                                                         options:nil
                                                           error:&error]) {
        
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

- (NSURL *)applicationDocumentsDirectory {
    
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                   inDomains:NSUserDomainMask] lastObject];
}

- (void)saveContext {
    
    NSError *error = nil;
    
    BOOL successful = [self.managedObjectContext save:&error];
    
    if (!successful) {
        [NSException raise:@"Error saving" format:@"Reason : %@", [error localizedDescription]];
    }
}

@end
