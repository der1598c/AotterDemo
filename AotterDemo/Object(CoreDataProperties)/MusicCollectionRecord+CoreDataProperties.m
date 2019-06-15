//
//  MusicCollectionRecord+CoreDataProperties.m
//  AotterDemo
//
//  Created by Elead on 2019/6/12.
//  Copyright © 2019 com. All rights reserved.
//
//

#import "MusicCollectionRecord+CoreDataProperties.h"

@implementation MusicCollectionRecord (CoreDataProperties)

+ (NSFetchRequest<MusicCollectionRecord *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"MusicCollectionRecord"];
}

@dynamic artistName;
@dynamic collectionName;
@dynamic frontImage;
@dynamic musicDuration;
@dynamic musicTitle;
@dynamic trackId;
@dynamic trackViewURL;

@end
