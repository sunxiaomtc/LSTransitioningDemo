//
//  ImageEnlargeViewController.m
//  LSTransitioningDemo
//
//  Created by gankai on 2018/11/20.
//  Copyright © 2018年 laoSun. All rights reserved.
//

#import "ImageEnlargeViewController.h"
#import "LSImageEnlargeManager.h"

#define kScreenW ([[UIScreen mainScreen]bounds].size.width)
#define kScreenH ([[UIScreen mainScreen]bounds].size.height)

@interface ImageEnlargeViewController ()<UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic,strong) UIImageView *imageView;

@property (nonatomic) BOOL isPrefersStatusBarHidden;

@end

@implementation ImageEnlargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor blackColor];
    
    //界面搭建
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    self.scrollView.minimumZoomScale = 1.0;
    self.scrollView.maximumZoomScale = 3.0;
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    
    CGRect bigRect = [self getLayoutImageView];
    
    self.imageView = [[UIImageView alloc] initWithFrame:bigRect];
    self.imageView.image = self.originalImage;
    [self.scrollView addSubview:self.imageView];
    self.scrollView.contentSize = self.imageView.bounds.size;
    
    //添加手势
    self.scrollView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    
    [self.scrollView addGestureRecognizer:tap];
    
    //延时消失状态栏
    __weak __typeof(self)weakSelf = self;
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3/*延迟执行时间*/ * NSEC_PER_SEC));
    
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        weakSelf.isPrefersStatusBarHidden = YES;
        [weakSelf prefersStatusBarHidden];
        [weakSelf performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    });
}

-(BOOL)prefersStatusBarHidden
{
    return self.isPrefersStatusBarHidden;
}


-(void)tapClick:(UITapGestureRecognizer *)sender
{
    [[LSImageEnlargeManager sharedManager] dismissImageViewController:self.rect image:self.image originalImage:self.originalImage];
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    CGFloat offsetX = (kScreenW>self.scrollView.contentSize.width)?(kScreenW-self.scrollView.contentSize.width)*0.5:0.0;
    CGFloat offsetY = (kScreenH>self.scrollView.contentSize.height)?(kScreenH-self.scrollView.contentSize.height)*0.5:0.0;
    self.imageView.center = CGPointMake(scrollView.contentSize.width*0.5+offsetX, scrollView.contentSize.height*0.5+offsetY);
}

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
