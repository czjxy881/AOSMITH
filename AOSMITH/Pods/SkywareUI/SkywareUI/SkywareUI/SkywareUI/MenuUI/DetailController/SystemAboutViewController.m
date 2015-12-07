//
//  SystemAboutViewController.m
//  WebIntegration
//
//  Created by 李晓 on 15/8/19.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import "SystemAboutViewController.h"

@interface SystemAboutViewController ()
/** App 图标 */
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
/** App 版本号 */
@property (weak, nonatomic) IBOutlet UILabel *version;
/** 公司信息 */
@property (weak, nonatomic) IBOutlet UILabel *company;
/** 版权信息 */
@property (weak, nonatomic) IBOutlet UILabel *copyright;

@end

@implementation SystemAboutViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        SkywareUIInstance *UIM = [SkywareUIInstance sharedSkywareUIInstance];
        self.view.backgroundColor = UIM.Menu_view_bgColor == nil?UIM.All_view_bgColor : UIM.Menu_view_bgColor;
        self.imageView.image = UIM.Menu_about_img;
        if (UIM.company.length) {
            self.company.text = UIM.company;
        }
        if (UIM.copyright.length) {
            self.copyright.text = UIM.copyright;
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //    [self setNavTitle:@"关于"];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navView setBackgroundColor:[UIColor clearColor]];
    [self.navView setScrollNavigationBarLineBackColor:[UIColor clearColor]];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [NSString stringWithFormat:@"软件版本信息: %@",[infoDictionary objectForKey:@"CFBundleShortVersionString"]];
    self.version.text = version;
}

@end
