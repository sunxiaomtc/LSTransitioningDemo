//
//  LSImageEnlargeManager.h
//  LSTransitioningDemo
//
//  Created by gankai on 2018/11/15.
//  Copyright © 2018年 laoSun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageEnlargeViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface LSImageEnlargeManager : UIPercentDrivenInteractiveTransition

/** 返回上级，上级图片显示*/
@property (nonatomic, copy) void(^didDismissBlock)(void);

+ (instancetype)sharedManager;

/**
实现动画转场
 @param formViewController 转场上一层
 @param rect 当前图片位置
 @param image 当前图片
 */
- (void)setFormViewController:(UIViewController *)formViewController imageCGrect:(CGRect)rect Image:(UIImage *)image originalImage:(UIImage *)originalImage;

/**
 网络图片动画转场
 @param formViewController 转场上级
 @param rect 当前图片位置
 @param imageURL 图片URL
 @param screenImage 当前显示图片
 */
- (void)setFormViewController:(UIViewController *)formViewController imageCGrect:(CGRect)rect imageURL:(NSString *)imageURL screenImage:(UIImage *)screenImage;

/** 展示*/
- (void)showImageViewController;

/**
 返回

 @param rect 图片原始坐标
 @param image 图片
 */
- (void)dismissImageViewController:(CGRect)rect image:(UIImage *)image originalImage:(UIImage *)originalImage;

@end

NS_ASSUME_NONNULL_END
