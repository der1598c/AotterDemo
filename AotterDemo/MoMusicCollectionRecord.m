//
//  MoMusicCollectionRecord.m
//  AotterDemo
//
//  Created by Leyee.H on 2019/6/12.
//  Copyright © 2019 com. All rights reserved.
//

#import "MoMusicCollectionRecord.h"

@implementation MoMusicCollectionRecord

-(id)initWithEmpty{
    _artistName = @"";
    _collectionName = @"";
    _musicTitle = @"";
    _trackViewURL = @"";
    _musicDuration = 0;
    _trackId = 0;
    _frontImage = nil;
    return self;
}

-(id)initWithRecordData:(MusicCollectionRecord *) musicCollectionRecord{
    _artistName = musicCollectionRecord.artistName;
    _collectionName = musicCollectionRecord.collectionName;
    _musicTitle = musicCollectionRecord.musicTitle;
    _trackViewURL = musicCollectionRecord.trackViewURL;
    _musicDuration = musicCollectionRecord.musicDuration;
    _trackId = musicCollectionRecord.trackId;
    _frontImage = musicCollectionRecord.frontImage;
    
    NSLog(@"into Test MoMusicCollectionRecord initWithRecordData, artistName=[%@],collectionName=[%@],musicTitle=[%@],trackViewURL=[%@],musicDuration=[%lld],trackId=[%lld]",self.artistName,self.collectionName,self.musicTitle,self.trackViewURL,self.musicDuration,self.trackId);
    
    return self;
}

@end
