//
//  ImageEnlargeViewController.h
//  LSTransitioningDemo
//
//  Created by gankai on 2018/11/20.
//  Copyright © 2018年 laoSun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImageEnlargeViewController : UIViewController

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, assign) CGRect rect;

@property (nonatomic, strong) UIImage *originalImage;

@end

NS_ASSUME_NONNULL_END
