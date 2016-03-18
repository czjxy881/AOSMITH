//
//  ShareCoceQRViewController.h
//  Pods
//
//  Created by ybyao07 on 16/1/20.
//
//

#import "BaseViewController.h"

@interface ShareCodeQRViewController : BaseViewController

@property (nonatomic,strong) IBOutlet UIImageView *QRCodeImg;

@property (nonatomic,copy) NSString *codeStr;
@property (nonatomic,assign) BOOL isFromBindViewDevice;

@end
