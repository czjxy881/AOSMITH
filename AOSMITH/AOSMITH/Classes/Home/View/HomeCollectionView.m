//
//  HomeCollectionView.m
//  HangingFurnace
//
//  Created by 李晓 on 15/9/6.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import "HomeCollectionView.h"

@interface HomeCollectionView ()
/**
 *  自定义流水布局
 */
@property (nonatomic,strong)UICollectionViewFlowLayout *layout;

@end

@implementation HomeCollectionView

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self = [super initWithFrame:self.frame collectionViewLayout:self.layout];
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.pagingEnabled = YES;
        self.bounces = NO;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _layout.itemSize = CGSizeMake(self.width, self.height);
}


-  (UICollectionViewFlowLayout *)layout
{
    if (!_layout) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _layout.minimumLineSpacing = 0;
        _layout.minimumInteritemSpacing = 0;
    }
    return _layout;
}

@end
