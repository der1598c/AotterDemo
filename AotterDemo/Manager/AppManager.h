//
//  AppManager.h
//  AotterDemo
//
//  Created by Leyee.H on 2019/6/12.
//  Copyright © 2019 com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AotterDemoStore.h"
#import "Constants.h"
//#import "StatusManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppManager : NSObject

+(AppManager*)sharedInstance;
- (AotterDemoStore*)getAotterDemoStore;

- (void) set_ThemeType:(ThemeTypeEnum) type;
- (ThemeTypeEnum) get_ThemeType;

@end

NS_ASSUME_NONNULL_END
