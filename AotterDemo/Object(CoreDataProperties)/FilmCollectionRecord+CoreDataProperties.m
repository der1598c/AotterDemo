//
//  FilmCollectionRecord+CoreDataProperties.m
//  AotterDemo
//
//  Created by Elead on 2019/6/12.
//  Copyright © 2019 com. All rights reserved.
//
//

#import "FilmCollectionRecord+CoreDataProperties.h"

@implementation FilmCollectionRecord (CoreDataProperties)

+ (NSFetchRequest<FilmCollectionRecord *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"FilmCollectionRecord"];
}

@dynamic artistName;
@dynamic collectionName;
@dynamic descriptionText;
@dynamic filmDuration;
@dynamic filmTitle;
@dynamic frontImage;
@dynamic trackId;
@dynamic trackViewURL;

@end
