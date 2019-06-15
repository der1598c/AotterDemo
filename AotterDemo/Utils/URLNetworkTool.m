//
//  URLNetworkTool.m
//  AotterDemo
//
//  Created by Leyee.H on 2019/6/11.
//  Copyright © 2019 com. All rights reserved.
//

#import "URLNetworkTool.h"
#import "Utils.h"

static NSString * const webService = @"https://itunes.apple.com/search?";

@interface URLNetworkTool ()

@property (nonatomic) AFHTTPSessionManager *sessionManager;

@end

@implementation URLNetworkTool

@synthesize sessionManager;

+ (instancetype)sharedInstance
{
    static URLNetworkTool *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] initWithBaseURL:nil];
    });
    
    return instance;
}

- (void)initSessionManager
{
    sessionManager = [AFHTTPSessionManager manager];
    sessionManager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    //    sessionManager.securityPolicy.allowInvalidCertificates = YES;
    sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
    sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [sessionManager.requestSerializer setValue: @"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    //    [sessionManager.requestSerializer setValue: @"crm" forHTTPHeaderField:@"CallName"];
    //    [sessionManager.requestSerializer setValue: @"pass" forHTTPHeaderField:@"CallPassword"];
    //    manager.operationQueue.maxConcurrentOperationCount = 5;
    sessionManager.requestSerializer.timeoutInterval = 10;
}

- (NSString*)getURLStringForRequestWithKeyWorks:(NSString *)keyWorks SearchKind:(SearchKindEnum)searchKind
{
    //movie
    NSString *urlString = [NSString stringWithFormat:@"%@term=%@&entity=movie&attribute=movieTerm&limit=10", webService, keyWorks];
    //music
    if(MUSIC_SEARCH_KIND == searchKind) {
        urlString = [NSString stringWithFormat:@"%@term=%@&entity=musicTrack&attribute=songTerm&limit=10", webService, keyWorks];
    }
    
    return urlString;
}

- (void)getRequestWithKeyWorks:(NSString *)keyWorks
                    SearchKind:(SearchKindEnum)searchKind
                     Success:(SuccessBlock)successBlock
                        Fail:(FailBlock)failBlock
{
    
    //Check network status.
    if(![Utils isInternetReachable]) {
        NSLog(@"There is NO internet connection");
        
        NSDictionary *userInfo = @{
                                   NSLocalizedDescriptionKey: NSLocalizedString(@"NO internet connection", nil)
//                                   NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"The operation timed out.", nil),
//                                   NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Have you tried turning it off and on again?", nil)
                                   };
        NSError *networkError = [NSError errorWithDomain:NetworkErrorDomain
                                             code:ErrorOne
                                         userInfo:userInfo];
        
        failBlock(networkError);
        return;
    }
    
    [self initSessionManager];
    
    NSString *urlString = [self getURLStringForRequestWithKeyWorks:keyWorks SearchKind:searchKind];
    
    [Utils showMsgWith:@"Now request" mode:MBProgressHUDModeCustomView icon:nil ParentView:[Utils topmostWindow] isBlock:NO];
    
    [sessionManager GET:urlString
             parameters:nil
                headers:nil
               progress:nil
                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    
                    [Utils hideHUDForView:[Utils topmostWindow] animated:NO];
                    
                    if (successBlock) {
                        id obj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                        NSLog(@"Network dict:\n%@", obj);
                        
//                        if ([obj isKindOfClass:[NSArray class]]) {
//                            NSMutableArray * mary = obj;
//                            NSLog(@"NSMutableArray%@",mary);
//                        }else{
//                            NSMutableDictionary * mdic = obj;
//                            NSLog(@"NSMutableDictionary%@",mdic);
//                        }
                        
                        NSMutableDictionary * mdic = obj;
                        NSMutableArray *mary = [mdic objectForKey:@"results"];
                        successBlock(mary);
                    }
                }
                failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    if (failBlock) {
                        failBlock(error);
                        NSLog(@"Network error:\n%@", error);
                    }
                }
     ];
}

- (void)postRequestWithKeyWorks:(NSString *)keyWorks
                     SearchKind:(SearchKindEnum)searchKind
                      Success:(SuccessBlock)successBlock
                         Fail:(FailBlock)failBlock
{
    [self initSessionManager];
    
    NSString *urlString = [NSString stringWithFormat:@"%@", webService];
    [sessionManager POST:urlString
              parameters:nil
                 headers:nil
                progress:nil
                 success:^(NSURLSessionTask * _Nonnull task, id _Nullable responseObject) {
                     
                     [Utils hideHUDForView:[Utils topmostWindow] animated:NO];
                     
        if (successBlock) {
            id obj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"Network dict:\n%@", obj);
            
            //                        if ([obj isKindOfClass:[NSArray class]]) {
            //                            NSMutableArray * mary = obj;
            //                            NSLog(@"NSMutableArray%@",mary);
            //                        }else{
            //                            NSMutableDictionary * mdic = obj;
            //                            NSLog(@"NSMutableDictionary%@",mdic);
            //                        }
            
            NSMutableDictionary * mdic = obj;
            NSMutableArray *mary = [mdic objectForKey:@"results"];
            successBlock(mary);
        }
    }
                 failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        if (failBlock) {
            failBlock(error);
            [Utils hideHUDForView:[Utils topmostWindow] animated:NO];
            [Utils showMsgWith:@"error" mode:MBProgressHUDModeCustomView icon:nil ParentView:[Utils topmostWindow] isBlock:NO];
            NSLog(@"Network error:\n%@",error);
        }
    }];
}

@end
