//
//  BaseNavigationController.m
//  LXFrameWork_OC
//
//  Created by 李晓 on 15/7/6.
//  Copyright (c) 2015年 LXFrameWork. All rights reserved.
//

#import "BaseNavigationController.h"

#define ratio 0.7
#define spaceFromLeftBorder 38

@interface BaseNavigationController ()<UIGestureRecognizerDelegate>

{
    UIPanGestureRecognizer *_PanRecognizer;
}

/** 存放每一个控制器的全屏截图 */
@property (nonatomic, strong) NSMutableArray *images;
/** 最后一个显示的ViewController */
@property (nonatomic, strong) UIImageView *lastVcView;
/** 遮罩 */
@property (nonatomic, strong) UIView *cover;

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 拖拽手势
    _PanRecognizer= [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragging:)];
    _PanRecognizer.delegate = self;
    [self.view addGestureRecognizer:_PanRecognizer];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // 禁用系统自带的拖拽手势
    self.interactivePopGestureRecognizer.enabled = NO;
}

- (void)dealloc
{
    [self.lastVcView removeFromSuperview];
    [self.cover removeFromSuperview];
    [self.images removeAllObjects];
}

#pragma mark - 拦截 push pop 方法
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0 && [viewController isKindOfClass:[BaseViewController class]]) {
        BaseViewController *baseView = (BaseViewController *) viewController;
        [baseView setNavBackBtn];
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    //产生截图
    [self createScreenShot];
    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    return [super popViewControllerAnimated:animated];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    CGPoint point = [touch locationInView:touch.view];
    if (point.x < spaceFromLeftBorder) {
        return YES;
    }
    return  NO;
}

#pragma mark - 手势拖拽切换控制器方法

- (void)dragging:(UIPanGestureRecognizer *)recognizer
{
    if (self.viewControllers.count <= 1) return;
    // 在x方向上移动的距离
    CGFloat tx = [recognizer translationInView:self.view].x;
    if (tx < 0){
        self.view.transform = CGAffineTransformIdentity;
        self.lastVcView.transform = CGAffineTransformIdentity;
    } else if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled || recognizer.state == UIGestureRecognizerStateFailed) {
        // 决定pop还是还原
        if (self.view.x >= self.view.width * 0.3) {
            [UIView animateWithDuration:0.25 animations:^{
                self.view.transform = CGAffineTransformMakeTranslation(self.view.width, 0);
                self.lastVcView.x = 0;
            } completion:^(BOOL finished) {
                [self popViewControllerAnimated:NO];
                [self.images removeLastObject];
                [self.lastVcView removeFromSuperview];
                [self.cover removeFromSuperview];
                self.view.transform = CGAffineTransformIdentity;
                self.lastVcView.transform = CGAffineTransformIdentity;
                self.lastVcView.x = (- self.view.width) * ratio;
            }];
        } else { // 还原
            [UIView animateWithDuration:0.2 animations:^{
                self.view.transform = CGAffineTransformIdentity;
            }completion:^(BOOL finished) {
                self.lastVcView.transform = CGAffineTransformIdentity;
            }];
        }
    } else {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        // 添加截图到最后面
        if (!self.images.count) return;
        self.lastVcView.image = self.images[self.images.count - 1];
        [window insertSubview:self.lastVcView atIndex:0];
        [window insertSubview:self.cover aboveSubview:self.lastVcView];
        // 移动view
        self.view.transform = CGAffineTransformMakeTranslation(tx, 0);
        if (self.lastVcView.x >=0) return;
        self.lastVcView.transform = CGAffineTransformIdentity;
        self.lastVcView.transform = CGAffineTransformMakeTranslation(tx *0.7  , 0);
    }
}

// 产生截图
- (void)createScreenShot
{
    UIGraphicsBeginImageContextWithOptions(self.view.size, YES, 0.0);
    [self.view.window.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    [self.images addObject:image];
}

#pragma mark - 懒加载等方法
- (NSMutableArray *)images
{
    if (!_images) {
        self.images = [[NSMutableArray alloc] init];
    }
    return _images;
}

- (UIImageView *)lastVcView
{
    if (!_lastVcView) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        UIImageView *lastVcView = [[UIImageView alloc] init];
        lastVcView.frame = window.bounds;
        lastVcView.x = (- self.view.width) * ratio;
        self.lastVcView = lastVcView;
    }
    
    return _lastVcView;
}

- (UIView *)cover
{
    if (!_cover) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        UIView *cover = [[UIView alloc] init];
        cover.backgroundColor = [UIColor blackColor];
        cover.frame = window.bounds;
        cover.alpha = 0.4;
        self.cover = cover;
    }
    return _cover;
}

#pragma amrk - 设置状态栏颜色

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

@end
