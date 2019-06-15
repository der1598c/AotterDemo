//
//  BaseManagedObjectContext.h
//  EZEyesExam
//
//  Created by E-Lead on 07/02/2018.
//  Copyright © 2018 E-Lead. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface BaseManagedObjectContext : NSObject

@property(readonly,nonatomic,strong) NSManagedObjectContext *managedObjectContext;

@property(readonly,nonatomic,strong) NSManagedObjectModel *managedObjectModel;

@property(readonly,nonatomic,strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (BaseManagedObjectContext *)shareData;

- (void)saveContext;

@end
