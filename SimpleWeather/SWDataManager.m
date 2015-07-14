//
//  SWDataManager.m
//  SimpleWeather
//
//  Created by Dim on 14.07.15.
//  Copyright (c) 2015 Dmitriy Baklanov. All rights reserved.
//

@import CoreData;

#import "SWDataManager.h"
#import "SWRequestManager.h"
#import "SWJSONParser.h"

@interface SWDataManager ()

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

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

- (void)fetchWeatherWithCityID:(NSUInteger)cityID
                      completionBlock:(CompletionBlock)completionBlock {
    
    
    __weak SWDataManager *weakSelf = self;

    [[[SWRequestManager alloc] init] getDataFromServerWithCompletionHandler:^(BOOL successful, NSData *data, NSError *error) {
        if (successful) {
            NSLog(@"Data returened to DM");
            [weakSelf parserTaskWithData:data];
        } else {
            NSLog(@"Request error %@", [error localizedDescription]);
        }
    }];
    
    if (completionBlock) {
        completionBlock(YES, nil, nil);
    }
}

- (void)parserTaskWithData:(NSData *)data {
    
    NSLog(@"Parser call %@", [NSThread currentThread]);
    
    [[[SWJSONParser alloc] init] parseData:data completionHandler:^(BOOL success, SWJSONParsedObject *parsedObject, NSError *error) {
        if (success) {
            NSLog(@"Parser return %@", [NSThread currentThread]);
        } else {
            NSLog(@"Parsing error %@", [error localizedDescription]);
        }
    }];
    
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
