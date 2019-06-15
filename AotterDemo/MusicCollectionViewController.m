//
//  MusicCollectionViewController.m
//  AotterDemo
//
//  Created by Leyee.H on 2019/6/15.
//  Copyright © 2019 com. All rights reserved.
//

#import "MusicCollectionViewController.h"
#import "UIParameter.h"
#import "AppManager.h"
#import "MusicInfoTableViewCell.h"
#import <SDWebImage/SDWebImage.h>
#import "Utils/Utils.h"

@interface MusicCollectionViewController ()<UITableViewDelegate,UITableViewDataSource> {
    AppManager *mAppManager;
    
    NSMutableArray *mMoMusicRecordArray;
}
@property (nonatomic, strong) UITableView *myTableView;
@end

@implementation MusicCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor cyanColor];
    [self setData];
}

- (void)viewWillLayoutSubviews {
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    [self.view addSubview:self.myTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [self refreshUI];
}

- (void)setData {
    //init mAppManager
    if(mAppManager == nil){
        mAppManager = [AppManager sharedInstance];
    }
    
    //取得電影收藏紀錄。
    mMoMusicRecordArray = [[mAppManager getAotterDemoStore] getMusicRecords];
}

- (void)refreshUI {
    [self setData];
    [_myTableView reloadData];
}

#pragma mark - myTableView
- (UITableView *)myTableView {
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        [_myTableView registerNib:[UINib nibWithNibName:@"MusicInfoTableViewCell" bundle:nil]
           forCellReuseIdentifier:@"MusicInfoCell"];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.allowsSelection = NO;
        _myTableView.rowHeight = _myTableView.frame.size.height /8;
        
        //Gesture setting
        UITapGestureRecognizer *musicTableView_TapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
        musicTableView_TapGesture.numberOfTapsRequired = 1;
        [_myTableView addGestureRecognizer:musicTableView_TapGesture];
    }
    return _myTableView;
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [mMoMusicRecordArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //製作可重複利用的表格欄位Cell
    MusicInfoTableViewCell *cell = (MusicInfoTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"MusicInfoCell"];
    [cell setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    MoMusicCollectionRecord *record = [[MoMusicCollectionRecord alloc] initWithRecordData:[mMoMusicRecordArray objectAtIndex:indexPath.row]];
    //設定欄位的內容
    [cell.mMusicName setText:record.musicTitle];
    [cell.mArtistName setText:record.artistName];
    [cell.mCollectionName setText:record.collectionName];
    [cell.mMusicDuration setText:[NSString stringWithFormat:@"音樂長度：%@", [Utils timeFormatted:record.musicDuration]]];
    
    [cell.mCollection_Btn setTitle:@"取消收藏" forState:UIControlStateNormal];
    [cell.mCollection_Btn addTarget:self action:@selector(onMusicCollectionBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.mCollection_Btn setTag:indexPath.row];
    
    //    NSString* artworkUrlString = [result objectForKey:@"artworkUrl100"];
    //    [cell.mFront_ImgView sd_setImageWithURL:[NSURL URLWithString:artworkUrlString]
    //                           placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    [cell.mFront_ImgView setImage:[UIImage imageWithData: record.frontImage]];
    
    return cell;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (isDebugging) {
//        NSLog(@"点击了控制器1单元格的%li",(long)indexPath.row);
//    }
////    TestViewController *testVC = [TestViewController new];
////    [self.navigationController pushViewController:testVC animated:YES];
//}

- (void)onMusicCollectionBtnClicked:(id)sender  {
    NSLog(@"MusicCollectionBtnClicked.Tag:%ld", (long)[sender tag]);
    MoMusicCollectionRecord *record = [mMoMusicRecordArray objectAtIndex:[sender tag]];
    if([[mAppManager getAotterDemoStore] isMusicRecordExistedById:record.trackId]) {
        //取消收藏
        [[mAppManager getAotterDemoStore] deleteMusicRecordById:record.trackId];
    }
    
    [self refreshUI];
}

#pragma mark - UITapGestureRecognizer
- (void)tapGesture:(UITapGestureRecognizer *)gesture {
    NSLog(@"tapGesture: %@", gesture.description);
    //取得當前觸發的gesture其在UITableView中的座標
    CGPoint location = [gesture locationInView:_myTableView];
    //取得當前座標對應的indexPath
    NSIndexPath *indexPath = [_myTableView indexPathForRowAtPoint:location];
    
    if (indexPath) {
        //由indexpath取得對應的cell
        MusicInfoTableViewCell *cell = [_myTableView cellForRowAtIndexPath:indexPath];
        //获得添加到cell.contentView中的UILabel
        UIView *uiview = nil;
        for (UIView *view in cell.contentView.subviews) {
            if ([view isKindOfClass:[UIView class]]) {
                uiview = (UIView *)view;
                break;
            }
        }
        
        //取得當前gesture點擊在UILabe中的座標
        CGPoint p = [gesture locationInView:uiview];
        //        NSLog(@"CGPoint p.x: %f, p.y: %f", p.x, p.y);
        //檢查座標是否在UILabel之中
        if (CGRectContainsPoint(uiview.frame, p)) {
            //            NSLog(@"label text : %@", label.text);
            NSLog(@"into MainVC indexPath: %ld, CGPoint p.x: %f, p.y: %f", (long)indexPath.row, p.x, p.y);
            
            MoMusicCollectionRecord *record = [[MoMusicCollectionRecord alloc] initWithRecordData:[mMoMusicRecordArray objectAtIndex:indexPath.row]];
            [self openSafariWithURL:record.trackViewURL];
        }
    }
}

- (void)openSafariWithURL:(NSString*)urlString {
    NSLog(@"openSafariWithURL:%@", urlString);
    
    //    urlString = [urlString stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *URL = [NSURL URLWithString:urlString];
    NSDictionary *options = @{UIApplicationOpenURLOptionUniversalLinksOnly : @NO
                              };
    [application openURL:URL options:options completionHandler:^(BOOL success) {
        if (!success) {
            NSLog(@"Opened url fail. \nURL:%@", urlString);
        }
    }];
}

- (NSString *)timeFormatted:(int)millisSeconds {
    int totalSeconds = millisSeconds / 1000;
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    
    if(hours != 0) return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
    return [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
}

@end
