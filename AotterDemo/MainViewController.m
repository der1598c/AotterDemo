//
//  MainViewController.m
//  AotterDemo
//
//  Created by Elead on 2019/6/10.
//  Copyright © 2019 com. All rights reserved.
//

#import "MainViewController.h"
#import "URLNetworkTool.h"
#import "Utils/Utils.h"
#import "MoFilmCollectionRecord.h"
#import "MoMusicCollectionRecord.h"
#import "FilmInfoTableViewCell.h"
#import "MusicInfoTableViewCell.h"
#import "AppManager.h"
#import <SDWebImage/SDWebImage.h>

@interface MainViewController () {
    URLNetworkTool *mURLNetworkTool;
    
    AppManager *mAppManager;
    
    MoFilmCollectionRecord *mSelectedMoFilmRecord;
    MoMusicCollectionRecord *mSelectedMoMusicRecord;
    NSMutableArray *mMoFilmRecordArray;
    NSMutableArray *mMoMusicRecordArray;
}

@property (weak, nonatomic) IBOutlet UITextField *mKeyWord_TxtField;
@property (weak, nonatomic) IBOutlet UIButton *mSearch_Btn;
@property (weak, nonatomic) IBOutlet UITableView *mFilmResult_TableView;
@property (weak, nonatomic) IBOutlet UITableView *mMusicResult_TableView;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self setData];
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated {
    [self settingViewBg];
}

- (void)setData {
    //init mURLNetworkTool
    if(mURLNetworkTool == nil){
        mURLNetworkTool = [URLNetworkTool sharedInstance];
    }
    
    //init mAppManager
    if(mAppManager == nil){
        mAppManager = [AppManager sharedInstance];
    }
}

- (void)initView {
    [_mSearch_Btn addTarget:self action:@selector(doSearch) forControlEvents:UIControlEventTouchUpInside];
    [self disableConfirmBtn];
    
    [self initTableView];
    
    //Gesture setting
    UITapGestureRecognizer *filmTableView_TapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureOnFilmTable:)];
    filmTableView_TapGesture.numberOfTapsRequired = 1;
    [_mFilmResult_TableView addGestureRecognizer:filmTableView_TapGesture];
    UITapGestureRecognizer *musicTableView_TapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureOnMusicTable:)];
    filmTableView_TapGesture.numberOfTapsRequired = 1;
    [_mMusicResult_TableView addGestureRecognizer:musicTableView_TapGesture];
}

- (void)initTableView {
    //TextField
    [_mKeyWord_TxtField addTarget:self action:@selector(textFieldDone:) forControlEvents:UIControlEventEditingDidEndOnExit];
    _mKeyWord_TxtField.delegate = self;
    
    //Film
    [_mFilmResult_TableView registerNib:[UINib nibWithNibName:@"FilmInfoTableViewCell" bundle:nil]
                forCellReuseIdentifier:@"FilmInfoCell"];
    _mFilmResult_TableView.delegate = self;
    _mFilmResult_TableView.dataSource = self;
    _mFilmResult_TableView.allowsSelection = NO;
    _mFilmResult_TableView.rowHeight = _mFilmResult_TableView.frame.size.height /2;
    
    //Music
    [_mMusicResult_TableView registerNib:[UINib nibWithNibName:@"MusicInfoTableViewCell" bundle:nil]
                 forCellReuseIdentifier:@"MusicInfoCell"];
    _mMusicResult_TableView.delegate = self;
    _mMusicResult_TableView.dataSource = self;
    _mMusicResult_TableView.allowsSelection = NO;
//    _mMusicResult_TableView.rowHeight = _mFilmResult_TableView.frame.size.height /3;
}

- (void)refreshUI{
//    [self setData];
    [_mFilmResult_TableView reloadData];
    [_mMusicResult_TableView reloadData];
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

- (void)doSearch {
    NSLog(@"MainViewController -> doSearch");
    //收鍵盤
    [_mKeyWord_TxtField resignFirstResponder];
    //清除空白，檢查空字串問題
    NSString* keyWord = _mKeyWord_TxtField.text;
    keyWord = [keyWord stringByReplacingOccurrencesOfString:@" " withString:@""];
    if([keyWord isEqualToString:@""] || 0 == [keyWord length]) {
        [Utils showMsgWith:@"invalid keyword." mode:MBProgressHUDModeCustomView icon:nil ParentView:[Utils topmostWindow] isBlock:NO];
        return;
    }
    
    [mURLNetworkTool getRequestWithKeyWorks:keyWord
                                 SearchKind:FILM_SEARCH_KIND
                                  Success:^(id responseObject) {
                                    NSLog(@"Success:%@",responseObject);
                                      self->mMoFilmRecordArray = [responseObject copy];
                                      [self refreshUI];
    }
                                     Fail:^(NSError *error) {
                                         NSLog(@"Fail:%@",error.localizedDescription);
//                                         NSLog(@"Fail:%@",error.localizedFailureReason);
//                                         NSLog(@"Fail:%@",error.localizedRecoverySuggestion);
                                         [Utils showMsgWith:error.localizedDescription mode:MBProgressHUDModeCustomView icon:nil ParentView:[Utils topmostWindow] isBlock:NO];
    }];
    
    [mURLNetworkTool getRequestWithKeyWorks:keyWord
                                 SearchKind:MUSIC_SEARCH_KIND
                                    Success:^(id responseObject) {
                                        NSLog(@"Success:%@",responseObject);
                                        self->mMoMusicRecordArray = [responseObject copy];
                                        [self refreshUI];
                                    }
                                       Fail:^(NSError *error) {
                                           NSLog(@"Fail:%@",error.localizedDescription);
//                                         NSLog(@"Fail:%@",error.localizedFailureReason);
//                                         NSLog(@"Fail:%@",error.localizedRecoverySuggestion);
                                           [Utils showMsgWith:error.localizedDescription mode:MBProgressHUDModeCustomView icon:nil ParentView:[Utils topmostWindow] isBlock:NO];
                                       }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ([self isUserInputedKeyword]) {
        [self enableConfirmBtn];
    }else {
        [self disableConfirmBtn];
    }
    
    //     character range limit in 20.
    if (range.location >= 20) {
        //disable input.
        return  NO;
    }
    if (range.location == 0) {
        //disable input.
        [self disableConfirmBtn];
    }
    return YES;
}

-(void)textFieldDone:(UITextField*)textField
{
    if (![self isUserInputedKeyword]) {
        [self disableConfirmBtn];
    }else {
        [self enableConfirmBtn];
    }
    [textField resignFirstResponder];
}

- (BOOL)isUserInputedKeyword {
    NSString* keyWord = _mKeyWord_TxtField.text;
    //檢查@""
    if([keyWord isEqualToString:@""] || 0 == [keyWord length]) {
        [self disableConfirmBtn];
        return NO;
    }
    
    [self enableConfirmBtn];
    return YES;
}

- (void) disableConfirmBtn {
    _mSearch_Btn.userInteractionEnabled = NO;
    _mSearch_Btn.enabled = NO;
}

- (void) enableConfirmBtn {
    _mSearch_Btn.userInteractionEnabled = YES;
    _mSearch_Btn.enabled = YES;
}

#pragma mark -UITableViewDelegate,UITableViewDataSource
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if ([tableView isEqual:_mFilmResult_TableView]) {
        //製作可重複利用的表格欄位Cell
        FilmInfoTableViewCell *cell = (FilmInfoTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"FilmInfoCell"];
        [cell setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
        NSDictionary *result = [mMoFilmRecordArray objectAtIndex:indexPath.row];
        //設定欄位的內容
        [cell.mFilmName setText:[result objectForKey:@"trackName"]];
        [cell.mArtistName setText:[result objectForKey:@"artistName"]];
        [cell.mCollectionName setText:[result objectForKey:@"collectionExplicitness"]];
        [cell.mFilmDuration setText:[NSString stringWithFormat:@"影片長度：%@", [Utils timeFormatted:[[result objectForKey:@"trackTimeMillis"] intValue]]]];
        [cell.mDescription setText:[result objectForKey:@"longDescription"]];
        [cell.mCollection_Btn addTarget:self action:@selector(onFilmCollectionBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell.mCollection_Btn setTag:indexPath.row];
        
        NSString* artworkUrlString = [result objectForKey:@"artworkUrl100"];
        [cell.mFront_ImgView sd_setImageWithURL:[NSURL URLWithString:artworkUrlString]
                               placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        
        //判斷是否已經寫在資料庫了(收藏)
        if([[mAppManager getAotterDemoStore] isFilmRecordExistedById:[[result objectForKey:@"trackId"] longLongValue]]) {
            [cell.mCollection_Btn setTitle:@"取消收藏" forState:UIControlStateNormal];
        }
        else {
            [cell.mCollection_Btn setTitle:@"收藏" forState:UIControlStateNormal];
        }
//        cell.mReadmore_Btn
        
        return cell;
    }
    else if ([tableView isEqual:_mMusicResult_TableView])
    {
        //製作可重複利用的表格欄位Cell
        MusicInfoTableViewCell *cell = (MusicInfoTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"MusicInfoCell"];
        [cell setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
        NSDictionary *result = [mMoMusicRecordArray objectAtIndex:indexPath.row];
        //設定欄位的內容
        [cell.mMusicName setText:[result objectForKey:@"trackName"]];
        [cell.mArtistName setText:[result objectForKey:@"artistName"]];
        [cell.mCollectionName setText:[result objectForKey:@"collectionExplicitness"]];
        [cell.mMusicDuration setText:[NSString stringWithFormat:@"音樂長度：%@", [Utils timeFormatted:[[result objectForKey:@"trackTimeMillis"] intValue]]]];
        
        [cell.mCollection_Btn addTarget:self action:@selector(onMusicCollectionBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell.mCollection_Btn setTag:indexPath.row];
        
        NSString* artworkUrlString = [result objectForKey:@"artworkUrl100"];
        [cell.mFront_ImgView sd_setImageWithURL:[NSURL URLWithString:artworkUrlString]
                               placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        
        //判斷是否已經寫在資料庫了(收藏)
        if([[mAppManager getAotterDemoStore] isMusicRecordExistedById:[[result objectForKey:@"trackId"] longLongValue]]) {
            [cell.mCollection_Btn setTitle:@"取消收藏" forState:UIControlStateNormal];
        }
        else {
            [cell.mCollection_Btn setTitle:@"收藏" forState:UIControlStateNormal];
        }
        
        return cell;
    }
    
    return nil;
}

- (void)onFilmCollectionBtnClicked:(id)sender  {
    NSLog(@"FilmCollectionBtnClicked.Tag:%ld", (long)[sender tag]);
    //收鍵盤
    [_mKeyWord_TxtField resignFirstResponder];
    NSDictionary *result = [mMoFilmRecordArray objectAtIndex:[sender tag]];
    if([[mAppManager getAotterDemoStore] isFilmRecordExistedById:[[result objectForKey:@"trackId"] longLongValue]]) {
        //取消收藏
        [[mAppManager getAotterDemoStore] deleteFilmRecordById:[[result objectForKey:@"trackId"] longLongValue]];
    }
    else {
        //收藏
        MoFilmCollectionRecord *record = [[MoFilmCollectionRecord alloc] initWithEmpty];
        record.artistName = [result objectForKey:@"artistName"];
        record.collectionName = [result objectForKey:@"collectionExplicitness"];
        record.filmTitle = [result objectForKey:@"trackName"];
        record.descriptionText = [result objectForKey:@"longDescription"];
        record.trackViewURL = [result objectForKey:@"trackViewUrl"];
        record.filmDuration = [[result objectForKey:@"trackTimeMillis"] longLongValue];
        record.trackId = [[result objectForKey:@"trackId"] longLongValue];
        
        UIImageView *imgView = [[UIImageView alloc] init];
        NSString* artworkUrlString = [result objectForKey:@"artworkUrl100"];
        [imgView sd_setImageWithURL:[NSURL URLWithString:artworkUrlString] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//            NSLog(@"");
            record.frontImage = UIImagePNGRepresentation(imgView.image);
            [[self->mAppManager getAotterDemoStore] createOrUpateFilmRecord:record];
        }];
//        [[mAppManager getAotterDemoStore] createOrUpateFilmRecord:record];
    }
    
    [self refreshTableViewAtRowsWith:_mFilmResult_TableView ByRowIndex:[sender tag]];
}

- (void)onMusicCollectionBtnClicked:(id)sender  {
    NSLog(@"MusicCollectionBtnClicked.Tag:%ld", (long)[sender tag]);
    //收鍵盤
    [_mKeyWord_TxtField resignFirstResponder];
    NSDictionary *result = [mMoMusicRecordArray objectAtIndex:[sender tag]];
    if([[mAppManager getAotterDemoStore] isMusicRecordExistedById:[[result objectForKey:@"trackId"] longLongValue]]) {
        //取消收藏
        [[mAppManager getAotterDemoStore] deleteMusicRecordById:[[result objectForKey:@"trackId"] longLongValue]];
    }
    else {
        //收藏
        MoMusicCollectionRecord *record = [[MoMusicCollectionRecord alloc] initWithEmpty];
        record.artistName = [result objectForKey:@"artistName"];
        record.collectionName = [result objectForKey:@"collectionExplicitness"];
        record.musicTitle = [result objectForKey:@"trackName"];
        record.trackViewURL = [result objectForKey:@"trackViewUrl"];
        record.musicDuration = [[result objectForKey:@"trackTimeMillis"] longLongValue];
        record.trackId = [[result objectForKey:@"trackId"] longLongValue];
        
        UIImageView *imgView = [[UIImageView alloc] init];
        NSString* artworkUrlString = [result objectForKey:@"artworkUrl100"];
        [imgView sd_setImageWithURL:[NSURL URLWithString:artworkUrlString] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            //            NSLog(@"");
            record.frontImage = UIImagePNGRepresentation(imgView.image);
            [[self->mAppManager getAotterDemoStore] createOrUpateMusicRecord:record];
        }];
//        [[mAppManager getAotterDemoStore] createOrUpateMusicRecord:record];
    }
    
    [self refreshTableViewAtRowsWith:_mMusicResult_TableView ByRowIndex:[sender tag]];
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:_mFilmResult_TableView]) {
        return [mMoFilmRecordArray count];
    }
    else if ([tableView isEqual:_mMusicResult_TableView])
    {
        return [mMoMusicRecordArray count];
    }
    return 0;
}

- (void)refreshTableViewAtRowsWith:(UITableView*)tableView ByRowIndex:(NSInteger)index {
    NSIndexPath *rowIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
    dispatch_async(dispatch_get_main_queue(), ^{
//        [tableView scrollToRowAtIndexPath:rowIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
        NSArray *myArray = [NSArray arrayWithObjects:rowIndexPath, nil];
        [tableView reloadRowsAtIndexPaths:myArray withRowAnimation:UITableViewRowAnimationFade];
    });
}

- (void)scrollTableViewAtRowsWith:(UITableView*)tableView ByRowIndex:(NSInteger)index {
    NSIndexPath *rowIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
    dispatch_async(dispatch_get_main_queue(), ^{
        [tableView scrollToRowAtIndexPath:rowIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
    });
}

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    // 可在 XIB 檔案，點選 My Talbe View Cell 從 Size inspector 得知
//    if ([tableView isEqual:_mFilmResult_TableView]) {
//        return 148;
//    }
//    return 108;
//}

#pragma mark - UITapGestureRecognizer
- (void)tapGestureOnFilmTable:(UITapGestureRecognizer *)gesture {
    NSLog(@"tapGesture: %@", gesture.description);
    //收鍵盤
    [_mKeyWord_TxtField resignFirstResponder];
    //取得當前觸發的gesture其在UITableView中的座標
    CGPoint location = [gesture locationInView:_mFilmResult_TableView];
    //取得當前座標對應的indexPath
    NSIndexPath *indexPath = [_mFilmResult_TableView indexPathForRowAtPoint:location];
    
    if (indexPath) {
        //由indexpath取得對應的cell
        FilmInfoTableViewCell *cell = [_mFilmResult_TableView cellForRowAtIndexPath:indexPath];
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
            
            NSDictionary *result = [mMoFilmRecordArray objectAtIndex:indexPath.row];
            [self openSafariWithURL:[result objectForKey:@"trackViewUrl"]];
        }
    }
}

- (void)tapGestureOnMusicTable:(UITapGestureRecognizer *)gesture {
    NSLog(@"tapGesture: %@", gesture.description);
    //取得當前觸發的gesture其在UITableView中的座標
    CGPoint location = [gesture locationInView:_mMusicResult_TableView];
    //取得當前座標對應的indexPath
    NSIndexPath *indexPath = [_mMusicResult_TableView indexPathForRowAtPoint:location];
    
    if (indexPath) {
        //由indexpath取得對應的cell
        MusicInfoTableViewCell *cell = [_mMusicResult_TableView cellForRowAtIndexPath:indexPath];
        //取得cell.contentView中的UILabel
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
            
            NSDictionary *result = [mMoMusicRecordArray objectAtIndex:indexPath.row];
            [self openSafariWithURL:[result objectForKey:@"trackViewUrl"]];
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
