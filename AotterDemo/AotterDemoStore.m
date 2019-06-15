//
//  AotterDemoStore.m
//  AotterDemo
//
//  Created by E-Lead on 07/02/2018.
//  Copyright © 2018 E-Lead. All rights reserved.
//

#import "AotterDemoStore.h"
#import "AppDelegate.h"
#import "Utils.h"

@implementation AotterDemoStore

+ (AotterDemoStore *)getInstance {
    
    static AotterDemoStore *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[AotterDemoStore alloc] init];
    });
    return instance;
}

#pragma mark - Record DB Operation
/* private Method */
-(FilmCollectionRecord *)newFilmRecordObject{
    return (FilmCollectionRecord *)[NSEntityDescription
                                    insertNewObjectForEntityForName:@"FilmCollectionRecord"
                                    inManagedObjectContext:self.managedObjectContext];
}

-(MusicCollectionRecord *)newMusicRecordObject{
    return (MusicCollectionRecord *)[NSEntityDescription
                                     insertNewObjectForEntityForName:@"MusicCollectionRecord"
                                     inManagedObjectContext:self.managedObjectContext];
}

/*  FilmRecord DB Operation  */
-(MoFilmCollectionRecord *)createOrUpateFilmRecord:(MoFilmCollectionRecord *) moFilmCollectionRecord {
    MoFilmCollectionRecord *record = [self getFilmRecordById:moFilmCollectionRecord.trackId withError:nil];
    //    NSLog(@"into createOrUpdateRecord -> 01,getRecordById userCid=%lld,dateTime=%lld",record.userCid,record.displayDateTime);
    //    NSLog(@"into createOrUpdateRecord -> 01,moRecord userCid=%lld,recordDateName=%lld",moRecord.userCid,moRecord.displayDateTime);
    //    NSLog(@"into createOrUpdateRecord -> 02, isCloseReadOverOneHour:%d", moRecord.isCloseReadOverOneHour);
    
    if(record){
        //        moRecord.updatedAt =[[Utils timestampNowMillsecond]longLongValue];
        //        record = [self updateRecord:moRecord];
    }else{
        FilmCollectionRecord *newRecord = [self newFilmRecordObject];
        newRecord.trackId = moFilmCollectionRecord.trackId;
        newRecord.filmTitle = moFilmCollectionRecord.filmTitle;
        newRecord.artistName = moFilmCollectionRecord.artistName;
        newRecord.descriptionText = moFilmCollectionRecord.descriptionText;
        newRecord.collectionName = moFilmCollectionRecord.collectionName;
        newRecord.trackViewURL = moFilmCollectionRecord.trackViewURL;
        newRecord.filmDuration = moFilmCollectionRecord.filmDuration;
        newRecord.frontImage = moFilmCollectionRecord.frontImage;
        
//        NSLog(@"into createOrUpdateRecord -> cid=%lld, diff=%d, stepSum=%d, timeSum=%lld, date=%lld", newRecord.cid, record.difficultyLevel, record.stepsConsuming, record.timeConsuming, record.createdAt);
        [self saveContext];
        
        record = [[MoFilmCollectionRecord alloc] initWithRecordData:newRecord];
    }
    return record;
}

-(void)deleteFilmRecordById:(int64_t)recordId {
    NSFetchRequest *fetchRequest= [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"FilmCollectionRecord" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate= [NSPredicate predicateWithFormat:@" trackId == %lld", recordId];
    [fetchRequest setPredicate:predicate];
    NSError *error = nil;
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    for (FilmCollectionRecord *target in fetchedObjects) {
        [self.managedObjectContext deleteObject:target];
    }
    [self saveContext];
}

-(BOOL)isFilmRecordExistedById:(int64_t)recordId {
    NSFetchRequest *fetchRequest= [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"FilmCollectionRecord" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate= [NSPredicate predicateWithFormat:@" trackId == %lld", recordId];
    [fetchRequest setPredicate:predicate];
    NSError *error = nil;
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    return fetchedObjects.count > 0;
}

-(NSMutableArray *)getFilmRecords {
    NSMutableArray *moRecordDataArray = [[NSMutableArray alloc] init];
    
    NSFetchRequest *fetchRequest= [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"FilmCollectionRecord" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error = nil;
    NSArray *fetchedRecords = [self.managedObjectContext executeFetchRequest:fetchRequest error:&(error)];
    
    if (fetchedRecords.count == 0) {
        return nil;
    }else{
        for (FilmCollectionRecord *recordData in fetchedRecords) {
            [moRecordDataArray addObject:[[MoFilmCollectionRecord alloc] initWithRecordData:recordData]];
        }
    }
    
    return moRecordDataArray;
}

-(NSUInteger)getNumberOfFilmRecords {
    NSFetchRequest *fetchRequest= [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"FilmCollectionRecord" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error = nil;
    NSArray *fetchedRecords = [self.managedObjectContext executeFetchRequest:fetchRequest error:&(error)];
    
    return fetchedRecords.count;
}

-(MoFilmCollectionRecord *)getFilmRecordById:(int64_t)recordId withError:(NSError**)error {
    NSFetchRequest *fetchRequest= [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"FilmCollectionRecord" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSPredicate* pred;
    pred = [NSPredicate predicateWithFormat:@"trackId == %lld",recordId];
    [fetchRequest setPredicate:pred];
    fetchRequest.sortDescriptors = nil;
    [fetchRequest setFetchLimit:1];
    
    NSArray *fetchedRecords = [self.managedObjectContext executeFetchRequest:fetchRequest error:&(*error)];
    FilmCollectionRecord *ret = [fetchedRecords firstObject];
    
    if(ret != nil){
        return [[MoFilmCollectionRecord alloc] initWithRecordData:ret];
    }
    return nil;
}

/*  MusicRecord DB Operation  */
-(MoMusicCollectionRecord *)createOrUpateMusicRecord:(MoMusicCollectionRecord *) moMusicCollectionRecord {
    MoMusicCollectionRecord *record = [self getMusicRecordById:moMusicCollectionRecord.trackId withError:nil];
    //    NSLog(@"into createOrUpdateRecord -> 01,getRecordById userCid=%lld,dateTime=%lld",record.userCid,record.displayDateTime);
    //    NSLog(@"into createOrUpdateRecord -> 01,moRecord userCid=%lld,recordDateName=%lld",moRecord.userCid,moRecord.displayDateTime);
    //    NSLog(@"into createOrUpdateRecord -> 02, isCloseReadOverOneHour:%d", moRecord.isCloseReadOverOneHour);
    
    if(record){
        //        moRecord.updatedAt =[[Utils timestampNowMillsecond]longLongValue];
        //        record = [self updateRecord:moRecord];
    }else{
        MusicCollectionRecord *newRecord = [self newMusicRecordObject];
        newRecord.trackId = moMusicCollectionRecord.trackId;
        newRecord.musicTitle = moMusicCollectionRecord.musicTitle;
        newRecord.artistName = moMusicCollectionRecord.artistName;
        newRecord.collectionName = moMusicCollectionRecord.collectionName;
        newRecord.trackViewURL = moMusicCollectionRecord.trackViewURL;
        newRecord.musicDuration = moMusicCollectionRecord.musicDuration;
        newRecord.frontImage = moMusicCollectionRecord.frontImage;
        
        //        NSLog(@"into createOrUpdateRecord -> cid=%lld, diff=%d, stepSum=%d, timeSum=%lld, date=%lld", newRecord.cid, record.difficultyLevel, record.stepsConsuming, record.timeConsuming, record.createdAt);
        [self saveContext];
        
        record = [[MoMusicCollectionRecord alloc] initWithRecordData:newRecord];
    }
    return record;
}

-(void)deleteMusicRecordById:(int64_t)recordId {
    NSFetchRequest *fetchRequest= [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MusicCollectionRecord" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate= [NSPredicate predicateWithFormat:@" trackId == %lld", recordId];
    [fetchRequest setPredicate:predicate];
    NSError *error = nil;
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    for (MusicCollectionRecord *target in fetchedObjects) {
        [self.managedObjectContext deleteObject:target];
    }
    [self saveContext];
}

-(BOOL)isMusicRecordExistedById:(int64_t)recordId {
    NSFetchRequest *fetchRequest= [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MusicCollectionRecord" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate= [NSPredicate predicateWithFormat:@" trackId == %lld", recordId];
    [fetchRequest setPredicate:predicate];
    NSError *error = nil;
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    return fetchedObjects.count > 0;
}

-(NSMutableArray *)getMusicRecords {
    NSMutableArray *moRecordDataArray = [[NSMutableArray alloc] init];
    
    NSFetchRequest *fetchRequest= [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MusicCollectionRecord" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error = nil;
    NSArray *fetchedRecords = [self.managedObjectContext executeFetchRequest:fetchRequest error:&(error)];
    
    if (fetchedRecords.count == 0) {
        return nil;
    }else{
        for (MusicCollectionRecord *recordData in fetchedRecords) {
            [moRecordDataArray addObject:[[MoMusicCollectionRecord alloc] initWithRecordData:recordData]];
        }
    }
    
    return moRecordDataArray;
}

-(NSUInteger)getNumberOfMusicRecords {
    NSFetchRequest *fetchRequest= [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MusicCollectionRecord" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error = nil;
    NSArray *fetchedRecords = [self.managedObjectContext executeFetchRequest:fetchRequest error:&(error)];
    
    return fetchedRecords.count;
}

-(MoMusicCollectionRecord *)getMusicRecordById:(int64_t)recordId withError:(NSError**)error {
    NSFetchRequest *fetchRequest= [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MusicCollectionRecord" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSPredicate* pred;
    pred = [NSPredicate predicateWithFormat:@"trackId == %lld",recordId];
    [fetchRequest setPredicate:pred];
    fetchRequest.sortDescriptors = nil;
    [fetchRequest setFetchLimit:1];
    
    NSArray *fetchedRecords = [self.managedObjectContext executeFetchRequest:fetchRequest error:&(*error)];
    MusicCollectionRecord *ret = [fetchedRecords firstObject];
    
    //    NSLog(@"into getRecordById -> 01 recordCid=%lld,difficultyLevel=%d,stepsConsuming=%d,timeConsuming=%lld",ret.cid,ret.difficultyLevel,ret.stepsConsuming,ret.timeConsuming);
    //    NSLog(@"into getRecordById -> 01 ret=%@",ret);
    
    if(ret != nil){
        return [[MoMusicCollectionRecord alloc] initWithRecordData:ret];
    }
    return nil;
}

@end
