//
//  CollectionItemsViewController.m
//  AotterDemo
//
//  Created by Elead on 2019/6/14.
//  Copyright © 2019 com. All rights reserved.
//

#import "CollectionItemsViewController.h"

#import "NinaPagerView.h"
#import "UIParameter.h"

@interface CollectionItemsViewController () {
    NSArray *titleArray, *objects;
}
@property (weak, nonatomic) IBOutlet UIView *mContainer_View;
@property (nonatomic, strong) NinaPagerView *ninaPagerView;
@end

@implementation CollectionItemsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Collection";
    self.view.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:self.ninaPagerView];
}

- (void)viewWillAppear:(BOOL)animated {
//    [self.view setNeedsDisplay];
    [self.view addSubview:self.ninaPagerView];
}

- (void)viewDidAppear {
//    [self.view addSubview:self.ninaPagerView];
//    [self.view setNeedsDisplay];
}

#pragma mark - NinaParaArrays
/**
 *  上方显示标题(您需要注意的是，虽然框架中对长标题进行了优化处理，但是建议您设置标题时汉字的长度不要超过10)。
 *  Titles showing on the topTab
 *
 *  @return Array of titles.
 */
- (NSArray *)ninaTitleArray {
    return @[
             @"電影",
             @"音樂"
             ];
}

/**
 *  WithObjects传入方法1：每个标题下对应的控制器，只需将您创建的控制器类名加入下列数组即可(注意:数量应与上方的titles数量保持一致，若少于titles数量，下方会打印您缺少相应的控制器，同时默认设置的最大控制器数量为10)  。
 *  ViewControllers to the titles on the topTab.Just add your VCs' Class Name to the array. Wanning:the number of ViewControllers should equal to the titles.Meanwhile,default max VC number is 10.
 *
 *  @return Array of controllers' class names.
 */
- (NSArray *)ninaVCsArray {
    return @[
             @"FilmCollectionViewController",
             @"MusicCollectionViewController"
             ];
}

#pragma mark - LazyLoad
- (NinaPagerView *)ninaPagerView {
    if (!_ninaPagerView) {
        NSArray *titleArray = [self ninaTitleArray];
        NSArray *vcsArray = [self ninaVCsArray];
        /**
         *  创建ninaPagerView，控制器第一次是根据您划的位置进行相应的添加的，类似网易新闻虎扑看球等的效果，后面再滑动到相应位置时不再重新添加，如果想刷新数据，您可以在相应的控制器里加入刷新功能。需要注意的是，在创建您的控制器时，设置的frame为FUll_CONTENT_HEIGHT，即全屏高减去导航栏高度，如果这个高度不是您想要的，您可以去在下面的frame自定义设置。
         *  A tip you should know is that when init the VCs frames,the default frame i set is FUll_CONTENT_HEIGHT,it means fullscreen height - NavigationHeight - TabbarHeight.If the frame is not what you want,just set frame as you wish.
         */

        CGRect pagerRect = CGRectMake(0, 0, FUll_VIEW_WIDTH, FUll_CONTENT_HEIGHT -100);
        //_mContainer_View.frame 會跑版
        _ninaPagerView = [[NinaPagerView alloc] initWithFrame:pagerRect WithTitles:titleArray WithObjects:vcsArray];
        _ninaPagerView.ninaPagerStyles = NinaPagerStyleBottomLine;
    }
    return _ninaPagerView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
