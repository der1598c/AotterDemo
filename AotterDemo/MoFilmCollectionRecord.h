//
//  MoFilmCollectionRecord.h
//  AotterDemo
//
//  Created by Leyee.H on 2019/6/11.
//  Copyright © 2019 com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FilmCollectionRecord+CoreDataClass.h"
#import "Constants.h"

@interface MoFilmCollectionRecord : NSObject

@property NSString* artistName;
@property NSString* collectionName;
@property NSString* filmTitle;
@property NSString* descriptionText;
@property NSString* trackViewURL;
@property int64_t filmDuration;
@property int64_t trackId;
@property NSData* frontImage;

-(id)initWithEmpty;

-(id)initWithRecordData:(FilmCollectionRecord *) filmCollectionRecord;


//-(DifficultyLevelEnum)getDifficultyLevelToEnum;
//
//-(int32_t)getStepsConsuming;
//
//-(int64_t)getTimeConsuming;
//
//-(NSData*)getImage;

@end
