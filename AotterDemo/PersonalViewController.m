//
//  PersonalViewController.m
//  AotterDemo
//
//  Created by Elead on 2019/6/11.
//  Copyright © 2019 com. All rights reserved.
//

#import "PersonalViewController.h"
#import "ThemeConfigurationViewController.h"
#import "CollectionItemsViewController.h"
#import "AppManager.h"

#import "Utils/Utils.h"
#import "Utils/Constants.h"

@interface PersonalViewController () {
    AppManager *mAppManager;
}
@property (weak, nonatomic) IBOutlet UIButton *mThemeConfig_Btn;
@property (weak, nonatomic) IBOutlet UIButton *mCollectItem_Btn;
@property (weak, nonatomic) IBOutlet UIButton *mAbout_Btn;

@end

@implementation PersonalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSLog(@"PersonalViewController -> viewDidLoad");
    [self setData];
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated {
    [self initView];
}

- (void) setData {
    //init mAppManager
    if(mAppManager == nil){
        mAppManager = [AppManager sharedInstance];
    }
}

- (void)initView {
    [self settingViewBg];
//    [_mThemeConfig_Btn addTarget:self action:@selector(gotoThemeConfigVC) forControlEvents:UIControlEventTouchUpInside];
//    [_mCollectItem_Btn addTarget:self action:@selector(gotoCollectItemVC) forControlEvents:UIControlEventTouchUpInside];
    [_mAbout_Btn addTarget:self action:@selector(openSafari) forControlEvents:UIControlEventTouchUpInside];

    [_mThemeConfig_Btn setTitle:[Constants getThemeTypeStringByThemeType:[mAppManager get_ThemeType]] forState:UIControlStateNormal];
    
    //計算所有收藏的資料筆數
    NSUInteger collectionItem = [[mAppManager getAotterDemoStore] getNumberOfFilmRecords] + [[mAppManager getAotterDemoStore] getNumberOfMusicRecords];
    [_mCollectItem_Btn setTitle:[NSString stringWithFormat:@"共有%lu項收藏", (unsigned long)collectionItem] forState:UIControlStateNormal];
}

- (void)settingViewBg {
    switch ([mAppManager get_ThemeType]) {
        case LIGHT_THEME:
            [self.view setBackgroundColor:UIColor.whiteColor];
            break;
            
        case DARK_THEME:
            [self.view setBackgroundColor:UIColor.lightGrayColor];
            break;
            
        default:
            break;
    }
}

- (void)gotoThemeConfigVC {
    //跳轉至ThemeConfigurationViewController 畫面
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    ThemeConfigurationViewController *tcvc = [storyboard instantiateViewControllerWithIdentifier:@"ThemeConfigurationViewControllerID"];
    
    [self presentViewController:tcvc animated:YES completion:^{
        
    }];
}

- (void)gotoCollectItemVC {
    //跳轉至CollectionItemsViewController.h 畫面
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    CollectionItemsViewController *civc = [storyboard instantiateViewControllerWithIdentifier:@"CollectionItemsViewControllerID"];
    
    [self presentViewController:civc animated:YES completion:^{
        
    }];
}

- (void)openSafari {
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *URL = [NSURL URLWithString:@"https://support.apple.com/itunes"];
    [application openURL:URL options:@{} completionHandler:^(BOOL success) {
//        if (success) {
//            NSLog(@"Opened url");
//        }
    }];
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
