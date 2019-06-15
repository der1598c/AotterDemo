//
//  FilmCollectionViewController.m
//  AotterDemo
//
//  Created by Elead on 2019/6/14.
//  Copyright © 2019 com. All rights reserved.
//

#import "FilmCollectionViewController.h"
#import "UIParameter.h"
#import "AppManager.h"
#import "FilmInfoTableViewCell.h"
#import <SDWebImage/SDWebImage.h>
#import "Utils/Utils.h"

@interface FilmCollectionViewController ()<UITableViewDelegate,UITableViewDataSource> {
    AppManager *mAppManager;
    
    NSMutableArray *mMoFilmRecordArray;
}
@property (nonatomic, strong) UITableView *myTableView;
@end

@implementation FilmCollectionViewController

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
    mMoFilmRecordArray = [[mAppManager getAotterDemoStore] getFilmRecords];
}

- (void)refreshUI {
    [self setData];
    [_myTableView reloadData];
}

#pragma mark - myTableView
- (UITableView *)myTableView {
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        [_myTableView registerNib:[UINib nibWithNibName:@"FilmInfoTableViewCell" bundle:nil]
                     forCellReuseIdentifier:@"FilmInfoCell"];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.allowsSelection = NO;
        _myTableView.rowHeight = _myTableView.frame.size.height /4;
        
        //Gesture setting
        UITapGestureRecognizer *filmTableView_TapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
        filmTableView_TapGesture.numberOfTapsRequired = 1;
        [_myTableView addGestureRecognizer:filmTableView_TapGesture];
    }
    return _myTableView;
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [mMoFilmRecordArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //製作可重複利用的表格欄位Cell
    FilmInfoTableViewCell *cell = (FilmInfoTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"FilmInfoCell"];
    [cell setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    MoFilmCollectionRecord *record = [[MoFilmCollectionRecord alloc] initWithRecordData:[mMoFilmRecordArray objectAtIndex:indexPath.row]];
    //設定欄位的內容
    [cell.mFilmName setText:record.filmTitle];
    [cell.mArtistName setText:record.artistName];
    [cell.mCollectionName setText:record.collectionName];
    [cell.mFilmDuration setText:[NSString stringWithFormat:@"影片長度：%@", [Utils timeFormatted:record.filmDuration]]];
    [cell.mDescription setText:record.descriptionText];
    
    [cell.mCollection_Btn setTitle:@"取消收藏" forState:UIControlStateNormal];
    [cell.mCollection_Btn addTarget:self action:@selector(onFilmCollectionBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
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

- (void)onFilmCollectionBtnClicked:(id)sender  {
    NSLog(@"FilmCollectionBtnClicked.Tag:%ld", (long)[sender tag]);
    MoFilmCollectionRecord *record = [mMoFilmRecordArray objectAtIndex:[sender tag]];
    if([[mAppManager getAotterDemoStore] isFilmRecordExistedById:record.trackId]) {
        //取消收藏
        [[mAppManager getAotterDemoStore] deleteFilmRecordById:record.trackId];
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
        FilmInfoTableViewCell *cell = [_myTableView cellForRowAtIndexPath:indexPath];
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
            
            MoFilmCollectionRecord *record = [[MoFilmCollectionRecord alloc] initWithRecordData:[mMoFilmRecordArray objectAtIndex:indexPath.row]];
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

@end
