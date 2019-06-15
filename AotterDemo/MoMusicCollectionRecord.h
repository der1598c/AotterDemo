//
//  MoMusicCollectionRecord.h
//  AotterDemo
//
//  Created by Leyee.H on 2019/6/12.
//  Copyright © 2019 com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MusicCollectionRecord+CoreDataClass.h"
#import "Constants.h"

@interface MoMusicCollectionRecord : NSObject

@property NSString* artistName;
@property NSString* collectionName;
@property NSString* musicTitle;
@property NSString* trackViewURL;
@property int64_t musicDuration;
@property int64_t trackId;
@property NSData* frontImage;

-(id)initWithEmpty;

-(id)initWithRecordData:(MusicCollectionRecord *) musicCollectionRecord;


//-(DifficultyLevelEnum)getDifficultyLevelToEnum;
//
//-(int32_t)getStepsConsuming;
//
//-(int64_t)getTimeConsuming;
//
//-(NSData*)getImage;

@end
