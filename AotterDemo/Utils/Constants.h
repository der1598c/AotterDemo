//
//  Constants.h
//  AotterDemo
//
//  Created by Elead on 2019/6/11.
//  Copyright © 2019 com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define KEY_OF_THEME_TYPE @"KeyOfDebugMode"

typedef enum : NSUInteger {
    LIGHT_THEME = 0,
    DARK_THEME = 1
} ThemeTypeEnum;

typedef enum : NSUInteger {
    FILM_SEARCH_KIND = 0,
    MUSIC_SEARCH_KIND = 1
} SearchKindEnum;

@interface Constants : NSObject

+(NSString*) getThemeTypeStringByThemeType:(ThemeTypeEnum)type;

@end

NS_ASSUME_NONNULL_END
