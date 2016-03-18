//
//  ShareBindDeviceTableCell.h
//  Pods
//
//  Created by ybyao07 on 16/1/21.
//
//

#import <UIKit/UIKit.h>

typedef void(^UnBindBlock)();

@interface ShareBindDeviceTableCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lblPhone;
@property (strong, nonatomic) IBOutlet UIButton *btnUnBind;

@property (nonatomic,copy) UnBindBlock unBindBlock;
@end
