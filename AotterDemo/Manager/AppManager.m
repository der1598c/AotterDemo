//
//  AppManager.m
//  AotterDemo
//
//  Created by Leyee.H on 2019/6/12.
//  Copyright © 2019 com. All rights reserved.
//

#import "AppManager.h"

@interface AppManager () {
    NSUserDefaults *mNSUserDefaults;
}

@property(nonatomic,strong) AppManager *mAppManager;
@property(nonatomic,strong) AotterDemoStore *mAotterDemoStore;

@end

@implementation AppManager

static AppManager *instance;

+(AppManager*)sharedInstance{
    if(instance == nil){
        @synchronized([AppManager class]) {
            if(instance == nil){
                instance = [[AppManager alloc]init];
            }
        }
    }
    return instance;
}

-(instancetype)init{
    if(self = [super init]){
        //TODO init WebAPIManager
        mNSUserDefaults = [NSUserDefaults standardUserDefaults];
    }
    return  self;
}

- (AotterDemoStore*)getAotterDemoStore {
    if(self.mAotterDemoStore == nil){
        self.mAotterDemoStore = [AotterDemoStore getInstance];
    }
    return self.mAotterDemoStore;
}

//
- (void) set_ThemeType:(ThemeTypeEnum) type {
    [self setUserDefaultInt:type key:KEY_OF_THEME_TYPE];
}
- (ThemeTypeEnum) get_ThemeType {
    switch([self getUserDefaultInt:KEY_OF_THEME_TYPE]){
        case 0:
            return LIGHT_THEME;
        case 1:
            return DARK_THEME;
        default:
            return LIGHT_THEME;
    }
}

#pragma mark - UserDefault implementation
-(void)setUserDefaultInt:(int)value key:(NSString *)key{
    [mNSUserDefaults setInteger:value forKey:key];
    [mNSUserDefaults synchronize];
}
-(int)getUserDefaultInt:(NSString *)key{
    //     int result = [mNSUserefaults integerForKey:key];
    if(key != nil){
        return (int)[mNSUserDefaults integerForKey:key];
    }
    return 0;
}

-(void)setUserDefaultBool:(bool)value key:(NSString *)key{
    [mNSUserDefaults setBool:value forKey:key];
    [mNSUserDefaults synchronize];
}
-(bool)getUserDefaultBool:(NSString *)key{
    if(key != nil){
        return (bool)[mNSUserDefaults boolForKey:key];
    }
    return false;
}

-(void)setUserDefaultDate:(NSDate*)date key:(NSString *)key{
    [mNSUserDefaults setObject:date  forKey:key];
    [mNSUserDefaults synchronize];
}
-(NSDate*)getUserDefaultDate:(NSString *)key{
    if(key != nil){
        return [mNSUserDefaults objectForKey:key];
    }
    return nil;
}

@end
