//
//  MusicInfoTableViewCell.h
//  AotterDemo
//
//  Created by Elead on 2019/6/10.
//  Copyright © 2019 com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MusicInfoTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *mFront_ImgView;

@property (weak, nonatomic) IBOutlet UILabel *mMusicName;
@property (weak, nonatomic) IBOutlet UILabel *mArtistName;
@property (weak, nonatomic) IBOutlet UILabel *mCollectionName;
@property (weak, nonatomic) IBOutlet UILabel *mMusicDuration;

@property (weak, nonatomic) IBOutlet UIButton *mCollection_Btn;

@end

NS_ASSUME_NONNULL_END
