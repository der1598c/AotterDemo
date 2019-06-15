//
//  URLNetworkTool.h
//  AotterDemo
//
//  Created by Leyee.H on 2019/6/11.
//  Copyright © 2019 com. All rights reserved.
//

#import "AFNetworking/AFNetworking.h"
#import "Constants.h"

#define NetworkErrorDomain @"com.NetworkError.Domain"
typedef NS_ENUM(NSInteger, NetworkError){
    ErrorOne = 1
};

@interface URLNetworkTool : AFHTTPSessionManager

typedef void (^SuccessBlock) (NSMutableArray *dataMary);
typedef void (^FailBlock) (NSError *error);

/**
 Create URLNetworkTool instance
 
 @return instancetype
 */
+ (instancetype)sharedInstance;

/**
 GET
 
 @param keyWorks 關鍵字
 @param searchKind 搜尋類型
 @param successBlock 成功Callback
 @param failBlock 失敗Callback
 */
- (void)getRequestWithKeyWorks:(NSString *)keyWorks
                    SearchKind:(SearchKindEnum)searchKind
                     Success:(SuccessBlock)successBlock
                        Fail:(FailBlock)failBlock;

/**
 POST
 
 @param keyWorks 關鍵字
 @param searchKind 搜尋類型
 @param successBlock 成功Callback
 @param failBlock 失敗Callback
 */
- (void)postRequestWithKeyWorks:(NSString *)keyWorks
                     SearchKind:(SearchKindEnum)searchKind
                      Success:(SuccessBlock)successBlock
                         Fail:(FailBlock)failBlock;

@end
