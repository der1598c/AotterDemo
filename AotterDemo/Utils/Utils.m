//
//  Utils.m
//  AotterDemo
//
//  Created by Leyee.H on 2019/6/11.
//  Copyright © 2019 com. All rights reserved.
//

#import "Utils.h"
#import "Reachability.h"

@interface Utils ()

@end


@implementation Utils

+ (UIWindow *)topmostWindow
{
#ifndef TARGET_IS_EXTENSION // if it's not defined
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    return window;
    
//    UIWindow *topMostWindow;
//    NSArray *windowArray = [[UIApplication sharedApplication] windows];
//    
//    for (UIWindow *windowObject in windowArray) {
//        if (windowObject.frame.size.height != 64) {
//            topMostWindow = windowObject;
//        }
//    }
//    
//    return topMostWindow;
#else
    return nil;
#endif
    
}

+ (NSData *)convertImageToData:(UIImage *)image{
    NSData *imgData = UIImageJPEGRepresentation(image, 1.0);
    return imgData;
}

+ (void)showMsgWith:(NSString*)str mode:(MBProgressHUDMode)mode icon:(NSString*)icon ParentView:(UIView*)parentView isBlock:(Boolean)isBlock {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:parentView];
        [parentView addSubview:hud];
        if(icon){
            hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:icon]];
        }
        hud.mode = mode;
        hud.userInteractionEnabled = isBlock;
        hud.detailsLabelText = str;
        [hud show:YES];
        [hud hide:YES afterDelay:3.0];
    });
}

+ (void)showMsgWith:(NSString*)str delayTime:(NSTimeInterval)delayTime mode:(MBProgressHUDMode)mode icon:(NSString*)icon ParentView:(UIView*)parentView isBlock:(Boolean)isBlock {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:parentView];
        [parentView addSubview:hud];
        if(icon){
            hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:icon]];
        }
        hud.mode = mode;
        hud.userInteractionEnabled = isBlock;
        hud.detailsLabelText = str;
        [hud show:YES];
        if (delayTime != 0) {
            [hud hide:YES afterDelay:delayTime];
        }
    });
}

+ (void)hideHUDForView:(UIView *)view animated:(BOOL)animated {
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:view animated:animated];
//        [MBProgressHUD hideAllHUDsForView:view animated:animated];
    });
}

+ (BOOL)isInternetReachable {
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        return NO;
    }
    return YES;
}

+ (NSString *)timeFormatted:(int)millisSeconds {
    int totalSeconds = millisSeconds / 1000;
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    
    if(hours != 0) return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
    return [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
}

@end
