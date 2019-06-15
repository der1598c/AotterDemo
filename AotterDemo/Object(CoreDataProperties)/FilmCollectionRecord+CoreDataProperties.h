//
//  FilmCollectionRecord+CoreDataProperties.h
//  AotterDemo
//
//  Created by Elead on 2019/6/12.
//  Copyright © 2019 com. All rights reserved.
//
//

#import "FilmCollectionRecord+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface FilmCollectionRecord (CoreDataProperties)

+ (NSFetchRequest<FilmCollectionRecord *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *artistName;
@property (nullable, nonatomic, copy) NSString *collectionName;
@property (nullable, nonatomic, copy) NSString *descriptionText;
@property (nonatomic) int64_t filmDuration;
@property (nullable, nonatomic, copy) NSString *filmTitle;
@property (nullable, nonatomic, retain) NSData *frontImage;
@property (nonatomic) int64_t trackId;
@property (nullable, nonatomic, copy) NSString *trackViewURL;

@end

NS_ASSUME_NONNULL_END
