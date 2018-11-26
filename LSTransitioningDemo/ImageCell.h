//
//  ImageCell.h
//  LSTransitioningDemo
//
//  Created by gankai on 2018/11/16.
//  Copyright © 2018年 laoSun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImageCell : UITableViewCell

@property (nonatomic, copy) void(^tapImageBlock)(void);
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@property (nonatomic, strong) UIImage *image;

@end

NS_ASSUME_NONNULL_END
