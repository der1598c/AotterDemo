//
//  FilmInfoTableViewCell.h
//  AotterDemo
//
//  Created by Elead on 2019/6/12.
//  Copyright © 2019 com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FilmInfoTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *mFront_ImgView;

@property (weak, nonatomic) IBOutlet UILabel *mFilmName;
@property (weak, nonatomic) IBOutlet UILabel *mArtistName;
@property (weak, nonatomic) IBOutlet UILabel *mCollectionName;
@property (weak, nonatomic) IBOutlet UILabel *mFilmDuration;
@property (weak, nonatomic) IBOutlet UITextView *mDescription;

@property (weak, nonatomic) IBOutlet UIButton *mCollection_Btn;
@property (weak, nonatomic) IBOutlet UIButton *mReadmore_Btn;

@end

NS_ASSUME_NONNULL_END
