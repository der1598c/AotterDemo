//
//  Constants.m
//  AotterDemo
//
//  Created by Elead on 2019/6/11.
//  Copyright © 2019 com. All rights reserved.
//

#import "Constants.h"

@implementation Constants

+(NSString*) getThemeTypeStringByThemeType:(ThemeTypeEnum)type {
    switch(type){
        case LIGHT_THEME:
            return @"淺色主題";
        case DARK_THEME:
            return @"深色主題";
        default:
            return @"淺色主題";
    }
}

@end
