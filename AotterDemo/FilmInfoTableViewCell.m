//
//  FilmInfoTableViewCell.m
//  AotterDemo
//
//  Created by Elead on 2019/6/12.
//  Copyright © 2019 com. All rights reserved.
//

#import "FilmInfoTableViewCell.h"

@implementation FilmInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [_mReadmore_Btn addTarget:self action:@selector(onReadmoreClicked) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)onReadmoreClicked {
    [_mDescription setScrollEnabled:YES];
    [_mReadmore_Btn setHidden:YES];
    [_mReadmore_Btn setEnabled:NO];
}

@end
