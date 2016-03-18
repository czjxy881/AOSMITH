//
//  ShareBindDeviceTableCell.m
//  Pods
//
//  Created by ybyao07 on 16/1/21.
//
//

#import "ShareBindDeviceTableCell.h"
#import "SkywareUIManager.h"
#import <PureLayout.h>
@implementation ShareBindDeviceTableCell

-(void)awakeFromNib{
    SkywareUIManager *UIM = [SkywareUIManager sharedSkywareUIManager];
    [_btnUnBind setBackgroundColor:UIM.User_button_bgColor == nil? UIM.All_button_bgColor : UIM.User_button_bgColor];
    
}
- (IBAction)onBindDevice:(UIButton *)sender {
    if (self.unBindBlock) {
        self.unBindBlock();
    }
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addView];
    }
    return self;
}

-(void)addView
{
    _lblPhone = [UILabel newAutoLayoutView];
    [self addSubview:_lblPhone];
    [_lblPhone autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [_lblPhone autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:20];
    _lblPhone.textColor = [UIColor lightGrayColor];
    _lblPhone.font = [UIFont systemFontOfSize:14];
    
    _btnUnBind = [UIButton newAutoLayoutView];
    [self addSubview:_btnUnBind];
    [_btnUnBind autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [_btnUnBind autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:20];
//    [_btnUnBind autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self withOffset:20];
    [_btnUnBind autoSetDimensionsToSize:CGSizeMake(84, 30)];
    [_btnUnBind addTarget:self action:@selector(onBindDevice:) forControlEvents:UIControlEventTouchUpInside];
    [_btnUnBind setTitle:@"删除" forState:UIControlStateNormal];
    _btnUnBind.layer.cornerRadius = 4;
    _btnUnBind.layer.masksToBounds = YES;
    SkywareUIManager *UIM = [SkywareUIManager sharedSkywareUIManager];
    [_btnUnBind setBackgroundColor:UIM.User_button_bgColor == nil? UIM.All_button_bgColor : UIM.User_button_bgColor];

}




@end
