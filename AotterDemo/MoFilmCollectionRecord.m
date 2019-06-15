//
//  MoFilmCollectionRecord.m
//  AotterDemo
//
//  Created by Leyee.H on 2019/6/11.
//  Copyright © 2019 com. All rights reserved.
//

#import "MoFilmCollectionRecord.h"

@implementation MoFilmCollectionRecord

-(id)initWithEmpty{
    _artistName = @"";
    _collectionName = @"";
    _filmTitle = @"";
    _descriptionText = @"";
    _trackViewURL = @"";
    _filmDuration = 0;
    _trackId = 0;
    _frontImage = nil;
    return self;
}

-(id)initWithRecordData:(FilmCollectionRecord *) filmCollectionRecord{
    _artistName = filmCollectionRecord.artistName;
    _collectionName = filmCollectionRecord.collectionName;
    _filmTitle = filmCollectionRecord.filmTitle;
    _descriptionText = filmCollectionRecord.descriptionText;
    _trackViewURL = filmCollectionRecord.trackViewURL;
    _filmDuration = filmCollectionRecord.filmDuration;
    _trackId = filmCollectionRecord.trackId;
    _frontImage = filmCollectionRecord.frontImage;
    
    NSLog(@"into Test MoFilmCollectionRecord initWithRecordData, artistName=[%@],collectionName=[%@],filmTitle=[%@],descriptionText=[%@],trackViewURL=[%@],filmDuration=[%lld],trackId=[%lld]",self.artistName,self.collectionName,self.filmTitle,self.descriptionText,self.trackViewURL,self.filmDuration,self.trackId);
    
    return self;
}

//-(DifficultyLevelEnum)getDifficultyLevelToEnum {
//
//    switch (_difficultyLevel) {
//        case 0:
//            return DIFFICULTY_EASY;
//        case 1:
//            return DIFFICULTY_NORMAL;
//        case 2:
//            return DIFFICULTY_HARD;
//        default:
//            return DIFFICULTY_EASY;
//    }
//}
//
//-(int32_t)getStepsConsuming {
//
//    return _stepsConsuming;
//}
//
//-(int64_t)getTimeConsuming{
//
//    return _timeConsuming;
//}
//
//-(NSData*)getImage {
//
//    return _image;
//}

@end
