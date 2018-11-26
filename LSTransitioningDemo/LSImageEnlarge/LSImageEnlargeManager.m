//
//  LSImageEnlargeManager.m
//  LSTransitioningDemo
//
//  Created by gankai on 2018/11/15.
//  Copyright © 2018年 laoSun. All rights reserved.
//

#import "LSImageEnlargeManager.h"
#import <SDWebImage/UIImageView+WebCache.h>

#define kScreenW ([[UIScreen mainScreen]bounds].size.width)
#define kScreenH ([[UIScreen mainScreen]bounds].size.height)

// 单例对象
static LSImageEnlargeManager *_lsImageEnlarge = nil;

@interface LSImageEnlargeManager ()<UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) ImageEnlargeViewController *imageViewController;
@property (nonatomic, weak) UIViewController *fromViewController;

/** present or dismiss */
@property (nonatomic, assign) BOOL present;

/** 是否在交互中 */
@property (nonatomic, assign) BOOL interactive;

@property (nonatomic, assign) CGRect imageRect;

/** 显示范围图片*/
@property (nonatomic, strong) UIImage *image;

/** 原始图片*/
@property (nonatomic, strong) UIImage *originalImage;

@property (nonatomic, weak) UIImageView *transitionImageView;

@end

@implementation LSImageEnlargeManager

#pragma mark - 单例方法
+ (instancetype)sharedManager {
    return [[self alloc] init];
}

+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(_lsImageEnlarge == nil)
        {
            _lsImageEnlarge = [super allocWithZone:zone];
        }
    });
    return _lsImageEnlarge;
}

#pragma mark - 初始化方法
- (instancetype)init {
    if (self = [super init]) {
        self.completionCurve = UIViewAnimationCurveLinear;
    }
    return self;
}

-(void)setFormViewController:(UIViewController *)formViewController imageCGrect:(CGRect)rect Image:(UIImage *)image originalImage:(UIImage *)originalImage
{
    //初始化
    if(image)
    {
        self.fromViewController = formViewController;
        
        self.imageViewController = [ImageEnlargeViewController new];
        
        self.imageViewController.image = image;
        
        self.imageViewController.originalImage = originalImage;
        
        self.imageViewController.rect = rect;
        
        self.imageRect = rect;
        
        self.image = image;
        
        self.originalImage = originalImage;
        
        self.imageViewController.transitioningDelegate = self;
        
        [self showImageViewController];
    }
}

-(void)setFormViewController:(UIViewController *)formViewController imageCGrect:(CGRect)rect imageURL:(NSString *)imageURL screenImage:(UIImage *)screenImage
{
    if(imageURL.length > 0)
    {
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        NSString* key = [manager cacheKeyForURL:[NSURL URLWithString:imageURL]];
        SDImageCache* cache = [SDImageCache sharedImageCache];
        //此方法会先从memory中取。
        UIImage *originalImage = [cache imageFromDiskCacheForKey:key];
        if(originalImage)
        {
            self.fromViewController = formViewController;
            
            self.imageViewController = [ImageEnlargeViewController new];
            
            self.imageViewController.image = screenImage;
            
            self.imageViewController.originalImage = originalImage;
            
            self.imageViewController.rect = rect;
            
            self.imageRect = rect;
            
            self.image = screenImage;
            
            self.originalImage = originalImage;
            
            self.imageViewController.transitioningDelegate = self;
            
            [self showImageViewController];
        }
    }
}

- (void)showImageViewController {
    [self.fromViewController presentViewController:self.imageViewController animated:YES completion:nil];
}

-(void)dismissImageViewController:(CGRect)rect image:(UIImage *)image originalImage:(nonnull UIImage *)originalImage
{
    self.imageRect = rect;
    self.image = image;
    self.originalImage = originalImage;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.imageViewController dismissViewControllerAnimated:YES completion:nil];
    });
}

#pragma mark - UIViewControllerTransitioningDelegate代理方法
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    self.present = YES;
    return self;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    self.present = NO;
    return self;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator {
    return self.interactive ? self : nil;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator {
    return self.interactive ? self : nil;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.3;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    if (self.present) {
        //实现动画转场
        UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        UIView *containerView = [transitionContext containerView];
        
        //添加图片
        UIImageView *transitionIMGV = [[UIImageView alloc] initWithFrame:self.imageRect];
        transitionIMGV.image = self.image;
        self.transitionImageView = transitionIMGV;
        [containerView addSubview:self.transitionImageView];
        
        //实现动画
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            self.transitionImageView.image = self.originalImage;
            CGRect bigRect = [self getLayoutImageView];
            self.transitionImageView.frame = bigRect;
        } completion:^(BOOL finished) {
            UIView *containerView = [transitionContext containerView];
            toVC.view.frame = CGRectMake(0, 0, containerView.frame.size.width, containerView.frame.size.height);
            [containerView addSubview:toVC.view];
            [containerView sendSubviewToBack:toVC.view];
            
            [self.transitionImageView removeFromSuperview];
            if ([transitionContext transitionWasCancelled]) {
                [transitionContext completeTransition:NO];
            } else {
                [transitionContext completeTransition:YES];
                
            }
        }];
    }else
    {
        UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        UIView *containerView = [transitionContext containerView];
        [containerView addSubview:toVC.view];
        CGRect bigRect = [self getLayoutImageView];
        UIImageView *transitionIMGV = [[UIImageView alloc] initWithFrame:bigRect];
        transitionIMGV.image = self.originalImage;
        self.transitionImageView = transitionIMGV;
        [toVC.view addSubview:self.transitionImageView];
        if ([transitionContext transitionWasCancelled]) {
            [transitionContext completeTransition:NO];
        } else {
            [transitionContext completeTransition:YES];
        }
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            self.transitionImageView.image = self.image;
            self.transitionImageView.frame = self.imageRect;
        } completion:^(BOOL finished) {
            if(self.didDismissBlock)
            {
                self.didDismissBlock();
            }
            [self.transitionImageView removeFromSuperview];
        }];
    }
}

//获取正常显示尺寸
- (CGRect)getLayoutImageView
{
    CGRect imageFrame;
    CGFloat imageRatio = self.originalImage.size.width/self.originalImage.size.height;
    CGFloat newImageHight = kScreenW / imageRatio;
    if(newImageHight > kScreenH)
    {
        imageFrame.size = CGSizeMake(kScreenW, newImageHight);
        imageFrame.origin.x = 0;
        imageFrame.origin.y = 0;
    }else
    {
        imageFrame.size = CGSizeMake(kScreenW, newImageHight);
        imageFrame.origin.x = 0;
        imageFrame.origin.y = (kScreenH-newImageHight)/2.0;
    }
    return imageFrame;
    
}

@end
