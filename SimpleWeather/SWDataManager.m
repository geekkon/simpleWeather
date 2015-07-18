//
//  SWDataManager.m
//  SimpleWeather
//
//  Created by Dim on 14.07.15.
//  Copyright (c) 2015 Dmitriy Baklanov. All rights reserved.
//

@import CoreData;

#import "SWDataManager.h"
#import "SWCity.h"
#import "SWWeather.h"
#import "SWRequestManager.h"
#import "SWJSONParsedObject.h"
#import "SWJSONParser.h"

@interface SWDataManager ()

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (weak, nonatomic) id <SWDataManagerDelegate> delegate;

@end

@implementation SWDataManager

+ (SWDataManager *)sharedManager {
   
    static SWDataManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SWDataManager alloc] init];
    });
    
    return manager;
}

- (NSArray *)fetchCiries {
    
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

- (SWCity *)fetchCityFromStore {
    
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

- (void)fetchWeatherForCityID:(NSNumber *)cityID delegate:(id <SWDataManagerDelegate>)delegate {
    
    self.delegate = delegate;
    
    NSDictionary *params = @{@"cityID" : cityID};

    [self requestManagerTaskWithParams:params];
}

- (void)findCitiesByNameWithString:(NSString *)string delegate:(id <SWDataManagerDelegate>)delegate {

    self.delegate = delegate;
    
    NSDictionary *params = @{@"cities" : string};

    [self requestManagerTaskWithParams:params];
}

- (void)requestManagerTaskWithParams:(NSDictionary *)params {
    
    __weak SWDataManager *weakSelf = self;
    
    [[[SWRequestManager alloc] init] getDataFromServerWithParams:params
                                               completionHandler:^(BOOL success, NSData *data, NSError *error) {
                                                   if (success) {
                                                       [weakSelf handleData:data withParams:params];
                                                   } else {
                                                       NSLog(@"Request error %@", [error localizedDescription]);
                                                   }
                                               }];
}

- (void)handleData:(NSData *)data withParams:(NSDictionary *)params {
    
    if (params[@"cityID"]) {
        [self parserTaskWithData:data];
    } else if (params[@"cities"]) {
        [self parseCitiesWithData:data];
    }
                
}

- (void)parserTaskWithData:(NSData *)data {
    
    __weak SWDataManager *weakSelf = self;
    
    [[[SWJSONParser alloc] init] parseData:data completionHandler:^(BOOL success, NSArray *parsedObjects, NSError *error) {
        if (success) {
            [weakSelf setupEntitiesFromParsedObject:[parsedObjects firstObject]];
        } else {
            NSLog(@"Parsing error %@", [error localizedDescription]);
        }
    }];
}

- (void)parseCitiesWithData:(NSData *)data {
    
    __weak SWDataManager *weakSelf = self;
    
    [[[SWJSONParser alloc] init] parseData:data completionHandler:^(BOOL success, NSArray *parsedObjects, NSError *error) {
        if (success) {
            if ([weakSelf.delegate respondsToSelector:@selector(dataManager:didFindCities:)]) {
                [weakSelf.delegate dataManager:weakSelf didFindCities:parsedObjects];
            }
        } else {
            NSLog(@"Parsing error %@", [error localizedDescription]);
        }
    }];
}

- (void)setupEntitiesFromParsedObject:(SWJSONParsedObject *)parsedObject {
    
    SWCity *city = [self fetchCityFromStore];
    
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
        
    if ([self.delegate respondsToSelector:@selector(dataManager:didFetchWeather:forCity:)]) {
        [self.delegate dataManager:self didFetchWeather:weather forCity:city];
    }
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
