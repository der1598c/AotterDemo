//
//  BaseManagedObjectContext.m
//  EZEyesExam
//
//  Created by E-Lead on 07/02/2018.
//  Copyright © 2018 E-Lead. All rights reserved.
//

#import "BaseManagedObjectContext.h"

@implementation BaseManagedObjectContext

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;


+ (BaseManagedObjectContext *)shareData {
    
    static dispatch_once_t pred;
    static BaseManagedObjectContext *_instance = nil;
    dispatch_once(&pred, ^{_instance  = [[self alloc] init];});
    return _instance;
}

- (void)saveContext {
    
    NSManagedObjectContext *managedObjectContext = _managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


- (NSManagedObjectContext *)managedObjectContext {
    
    if (!_managedObjectContext) {
        if (self.persistentStoreCoordinator) {
            _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
            [_managedObjectContext setPersistentStoreCoordinator:self.persistentStoreCoordinator];
        }
    }
    return _managedObjectContext;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    
    if (!_persistentStoreCoordinator){
        
        NSError *error = nil;
        NSString *failureReason = @"There was an error creating or loading the application's saved data.";
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
        NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"AotterDemoModel.sqlite"];
        NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                                 [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
        
        if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
            // Report any error we got.
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
            dict[NSLocalizedFailureReasonErrorKey] = failureReason;
            dict[NSUnderlyingErrorKey] = error;
            error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
    return _persistentStoreCoordinator;
}

- (NSManagedObjectModel *)managedObjectModel{
    
    if (!_managedObjectModel) {
        
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"AotterDemoModel" withExtension:@"momd"];
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    }
    
    return _managedObjectModel;
}

#pragma mark - Application's Documents directory

- (NSURL *)applicationDocumentsDirectory{
    
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
