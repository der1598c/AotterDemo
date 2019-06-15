//
//  ThemeConfigurationViewController.m
//  AotterDemo
//
//  Created by Elead on 2019/6/12.
//  Copyright © 2019 com. All rights reserved.
//

#import "ThemeConfigurationViewController.h"
#import "PersonalViewController.h"
#import "AppManager.h"

typedef enum : NSUInteger {
    TOGGLE_OFF = 0,
    TOGGLE_ON = 1
} ToggleEnum;

@interface ThemeConfigurationViewController () {
    AppManager *mAppManager;
}

- (IBAction)gotoPreviousPage:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *mDarkTheme_Btn;
@property (weak, nonatomic) IBOutlet UIButton *mLightTheme_Btn;

@end

@implementation ThemeConfigurationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Theme";
    [self setData];
    [self initView];
}

- (void) setData {
    //init mAppManager
    if(mAppManager == nil){
        mAppManager = [AppManager sharedInstance];
    }
}

- (void)initView {
    [_mDarkTheme_Btn addTarget:self action:@selector(darkThemeToggling:) forControlEvents:UIControlEventTouchUpInside];
    [_mLightTheme_Btn addTarget:self action:@selector(lightThemeToggling:) forControlEvents:UIControlEventTouchUpInside];
    [self refreshThemeToggleButton];
    [self settingViewBg];
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

- (void)gotoPersonalVC {
    //跳轉至PersonalViewController 畫面
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    PersonalViewController *pvc = [storyboard instantiateViewControllerWithIdentifier:@"PersonalViewControllerID"];
    
    [self presentViewController:pvc animated:YES completion:^{
        
    }];
}

- (void)refreshThemeToggleButton {
    
    switch ([mAppManager get_ThemeType]) {
        case LIGHT_THEME:
            [_mDarkTheme_Btn setTitle:@" " forState:UIControlStateNormal];
            _mDarkTheme_Btn.tag = TOGGLE_ON;
            [_mLightTheme_Btn setTitle:@"V" forState:UIControlStateNormal];
            _mLightTheme_Btn.tag = TOGGLE_OFF;
            break;
            
        case DARK_THEME:
            [_mDarkTheme_Btn setTitle:@"V" forState:UIControlStateNormal];
            _mDarkTheme_Btn.tag = TOGGLE_OFF;
            [_mLightTheme_Btn setTitle:@" " forState:UIControlStateNormal];
            _mLightTheme_Btn.tag = TOGGLE_ON;
            break;
            
        default:
            break;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)darkThemeToggling:(id)sender {
    if(LIGHT_THEME == [mAppManager get_ThemeType]) {
        [mAppManager set_ThemeType:DARK_THEME];
    }
    
    [self refreshThemeToggleButton];
    [self settingViewBg];
}

- (void)lightThemeToggling:(id)sender {
    if(DARK_THEME == [mAppManager get_ThemeType]) {
        [mAppManager set_ThemeType:LIGHT_THEME];
    }
    
    [self refreshThemeToggleButton];
    [self settingViewBg];
}

- (IBAction)gotoPreviousPage:(id)sender {
//    [self gotoPersonalVC];
    // 跳回原來的頁面
//    [self dismissViewControllerAnimated:NO completion:nil];
}
@end
