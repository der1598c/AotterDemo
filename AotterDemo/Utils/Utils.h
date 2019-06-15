//
//  Utils.h
//  AotterDemo
//
//  Created by Leyee.H on 2019/6/11.
//  Copyright © 2019 com. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "MBProgressHUD.h"

@interface Utils : NSObject

/*!
 * @topmostWindow
 * 取得最上層View
 */
+ (UIWindow *)topmostWindow;

/*!
 * @convertImageToData
 * 將UIImage轉成NSData
 */
+ (NSData *)convertImageToData:(UIImage *)image;

/*!
 * @show hud loading
 * @param mode MBHud的mode
 * @param icon 客製圖示可以不帶
  * @param parentView 要顯示的View
 * @param isBlock 是否要擋住下層事件，不讓使用者繼續觸發事件，通常要擋住
 */
+ (void)showMsgWith:(NSString*)str mode:(MBProgressHUDMode)mode icon:(NSString*)icon ParentView:(UIView*)parentView isBlock:(Boolean)isBlock;
+ (void)showMsgWith:(NSString*)str delayTime:(NSTimeInterval)delayTime mode:(MBProgressHUDMode)mode icon:(NSString*)icon ParentView:(UIView*)parentView isBlock:(Boolean)isBlock;
+ (void)hideHUDForView:(UIView *)view animated:(BOOL)animated;

/*!
 * @isInternetReachable
 * 當前網路是否可用
 */
+ (BOOL)isInternetReachable;

+ (NSString *)timeFormatted:(int)millisSeconds;
@end
