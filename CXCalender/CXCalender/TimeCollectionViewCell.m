//
//  TimeCollectionViewCell.m
//  test
//
//  Created on 2017/5/5.
//  Copyright © 2017年 . All rights reserved.
//

#import "TimeCollectionViewCell.h"

@implementation TimeCollectionViewCell
- (UILabel *)dateLabel
{
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] initWithFrame:self.bounds];
        [_dateLabel setTextAlignment:NSTextAlignmentCenter];
        [_dateLabel setFont:[UIFont systemFontOfSize:17]];
        [_dateLabel.layer setCornerRadius:self.bounds.size.width / 2];
        [_dateLabel.layer setMasksToBounds:YES];
        [self addSubview:_dateLabel];
    }
    return _dateLabel;
}
@end
