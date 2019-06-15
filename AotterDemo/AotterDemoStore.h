//
//  AotterDemoStore.h
//  AotterDemo
//
//  Created by E-Lead on 07/02/2018.
//  Copyright © 2018 E-Lead. All rights reserved.
//

#import "BaseManagedObjectContext.h"

#import "FilmCollectionRecord+CoreDataClass.h"
#import "MoFilmCollectionRecord.h"
#import "MusicCollectionRecord+CoreDataClass.h"
#import "MoMusicCollectionRecord.h"

@interface AotterDemoStore : BaseManagedObjectContext
{
    NSManagedObjectContext *mContext;
}

+ (AotterDemoStore *)getInstance;

/*  FilmRecord DB Operation  */
-(MoFilmCollectionRecord *)createOrUpateFilmRecord:(MoFilmCollectionRecord *) moFilmCollectionRecord;
-(void)deleteFilmRecordById:(int64_t)recordId;
-(BOOL)isFilmRecordExistedById:(int64_t)recordId;
-(NSMutableArray *)getFilmRecords;
-(NSUInteger)getNumberOfFilmRecords;
-(MoFilmCollectionRecord *)getFilmRecordById:(int64_t)recordId withError:(NSError**)error;

/*  MusicRecord DB Operation  */
-(MoMusicCollectionRecord *)createOrUpateMusicRecord:(MoMusicCollectionRecord *) moMusicCollectionRecord;
-(void)deleteMusicRecordById:(int64_t)recordId;
-(BOOL)isMusicRecordExistedById:(int64_t)recordId;
-(NSMutableArray *)getMusicRecords;
-(NSUInteger)getNumberOfMusicRecords;
-(MoMusicCollectionRecord *)getMusicRecordById:(int64_t)recordId withError:(NSError**)error;

@end
