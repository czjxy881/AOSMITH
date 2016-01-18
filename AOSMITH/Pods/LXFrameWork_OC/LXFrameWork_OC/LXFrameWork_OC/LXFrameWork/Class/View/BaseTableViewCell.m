//
//  BaseTableViewCell.m
//  LXFrameWork_OC
//
//  Created by 李晓 on 15/7/6.
//  Copyright (c) 2015年 LXFrameWork. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "PureLayout.h"
#import "BundleTool.h"
#import <SDWebImage/UIImageView+WebCache.h>

#define centerCellTextFont 17.0f
#define titleTextFont 16.0f
#define detailTextFont 13.0f
#define iconSizeWH 55

@interface BaseTableViewCell ()
{
    UIImageView *_iconImg;
    UILabel *_title;
    UILabel *_subTitle;
}
// 右侧的箭头图片
@property (nonatomic,strong) UIImageView *imgArrowView;
// 右侧的switch
@property (nonatomic,strong) UISwitch *rightSwitch;

@end

@implementation BaseTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.font = [UIFont systemFontOfSize:titleTextFont];
        self.detailTextLabel.font = [UIFont systemFontOfSize:detailTextFont];
        self.detailTextLabel.textColor = [UIColor lightGrayColor];
    }
    return self;
}

- (void)setItems:(BaseCellItem *)items
{
    _items = items;
    // 设置cell 的数据
    [self setCellData];
    // 设置cell 右侧内容
    [self setUpAccessoryView:items];
}

- (void) setCellData
{
    // 如果是个人信息字段直接跳过设置
    if ([_items isKindOfClass:[BaseIconItem class]] || [_items isKindOfClass:[BaseCenterTitleCellItem class]]) return;
    self.textLabel.text = self.items.title;
    self.detailTextLabel.text = self.items.subTitle;
    if (!self.items.icon) return;
    self.imageView.image = [UIImage imageNamed:self.items.icon];
}

- (void) setUpAccessoryView:(BaseCellItem *)items
{
    if ([items isKindOfClass:[BaseArrowCellItem class]] || [items isKindOfClass:[BaseSubtitleCellItem class]]) { // accessoryView 箭头
        self.accessoryView = self.imgArrowView;
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
    }else if ([items isKindOfClass:[BaseSwitchCellItem class]]){
        BaseSwitchCellItem *switchItem = (BaseSwitchCellItem *)items;
        self.rightSwitch.on = switchItem.open;
        self.accessoryView = self.rightSwitch;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }else if ([items isKindOfClass:[BaseCenterTitleCellItem class]]){
        [self createCenterTitleCell];
    }else if ([items isKindOfClass:[BaseIconItem class]]){
        [self createIconItemCell];
    }
}

/**
 *  创建第一条显示个人消息的Cell（原型头像）
 */
- (void) createIconItemCell
{
    self.selectionStyle = UITableViewCellSelectionStyleDefault;
    // 设置头像
    [_iconImg removeFromSuperview];
    _iconImg = [UIImageView newAutoLayoutView];
    _iconImg.layer.cornerRadius = iconSizeWH * 0.5 ;
    _iconImg.userInteractionEnabled = YES;
    _iconImg.contentMode = UIViewContentModeScaleAspectFill;
    _iconImg.clipsToBounds = YES;
    [self addSubview:_iconImg];
    UIImage *image = [BundleTool getImage:self.items.icon FromBundle:LXFrameWorkBundle];
    if (image) {
        _iconImg.image = image;
    }else{
        [_iconImg sd_setImageWithURL:[NSURL URLWithString:self.items.icon] placeholderImage:[BundleTool getImage:@"user_defaultavatar" FromBundle:LXFrameWorkBundle]];
    }
    
    [_iconImg autoSetDimensionsToSize:CGSizeMake(iconSizeWH, iconSizeWH)];
    [_iconImg autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [_iconImg autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizer:)];
    [_iconImg addGestureRecognizer:tap];
    // 如果点击Cell有操作，添加accessoryView
    if (_items.option) {
        self.accessoryView = self.imgArrowView;
    }
    // 根据 subTitle 添加detailTitlt位置
    if (_items.subTitle.length) {
        [_title removeFromSuperview];
        _title = [UILabel newAutoLayoutView];
        [self addSubview:_title];
        _title.textColor = [UIColor blackColor];
        _title.font = [UIFont boldSystemFontOfSize:titleTextFont];
        _title.text = _items.title;
        [_title autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:15];
        [_title autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_iconImg withOffset:18];
        
        [_subTitle removeFromSuperview];
        _subTitle = [UILabel newAutoLayoutView];
        [self addSubview:_subTitle];
        _subTitle.textColor = [UIColor grayColor];
        _subTitle.font = [UIFont boldSystemFontOfSize:detailTextFont];
        _subTitle.text = _items.subTitle;
        [_subTitle autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_iconImg withOffset:18];
        [_subTitle autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_title withOffset:5];
    }else{
        [_title removeFromSuperview];
        _title = [UILabel newAutoLayoutView];
        [self addSubview:_title];
        _title.textColor = [UIColor blackColor];
        _title.font = [UIFont boldSystemFontOfSize:titleTextFont];
        _title.text = _items.title;
        [_title autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [_title autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_iconImg withOffset:18];
    }
}

/**
 *  点击了个人Cell 的icon 调用
 */
- (void)tapGestureRecognizer:(UITapGestureRecognizer *) top
{
    BaseIconItem *iconItem = (BaseIconItem *) _items;
    if (iconItem.iconOption) {
        iconItem.iconOption();
    }
}

/**
 *  创建居中显示label 的Cell
 */
- (void) createCenterTitleCell
{
    BaseCenterTitleCellItem *centerCell = (BaseCenterTitleCellItem *) _items;
    UILabel *label = [UILabel newAutoLayoutView];
    [self addSubview:label];
    label.textColor = centerCell.color == nil ? [UIColor blackColor] : centerCell.color;
    label.font = [UIFont boldSystemFontOfSize:centerCellTextFont];
    label.text = centerCell.centerTitle;
    label.textAlignment = NSTextAlignmentCenter;
    [label autoSetDimensionsToSize:CGSizeMake(200, 44)];
    [label autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [label autoAlignAxisToSuperviewAxis:ALAxisVertical];
}

/**
 *  快速创建一个TableViewCell
 */
+ (instancetype)createProfileBaseCellWithTableView:(UITableView *)tableView andCellStyle:(UITableViewCellStyle)cellStyle
{
    NSString *cellStyleStr = nil;
    if (cellStyle == UITableViewCellStyleValue1) {
        cellStyleStr = @"TableViewCellValue1";
    }else if (cellStyle == UITableViewCellStyleSubtitle){
        cellStyleStr = @"TableViewCellSubtitle";
    }else if (cellStyle == UITableViewCellStyleDefault){
        cellStyleStr = @"UITableViewCellStyleDefault";
    }
    BaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStyleStr];
    if (cell == nil) {
        cell = [[BaseTableViewCell alloc]initWithStyle:cellStyle reuseIdentifier:cellStyleStr];
    }
    return cell;
}

#pragma mark - 懒加载

- (UIImageView *)imgArrowView
{
    if (!_imgArrowView) {
        _imgArrowView = [[UIImageView alloc] initWithImage:[BundleTool getImage:@"Arrow_Left" FromBundle:LXFrameWorkBundle]];
    }
    return _imgArrowView;
}

- (UISwitch *)rightSwitch
{
    if (!_rightSwitch) {
        _rightSwitch = [[UISwitch alloc] init];
        BaseSwitchCellItem *switchItem = (BaseSwitchCellItem *) _items;
        switchItem.switchs = _rightSwitch;
        [_rightSwitch addTarget:self  action:@selector(switchOption) forControlEvents:UIControlEventValueChanged];
    }
    return _rightSwitch;
}

/**
 *  波动开关以后调用
 */
- (void)switchOption
{
    BaseSwitchCellItem *switchItem = (BaseSwitchCellItem *) _items;
    if (switchItem.switchOption) {
        switchItem.switchOption(self.rightSwitch);
    }
}

@end
