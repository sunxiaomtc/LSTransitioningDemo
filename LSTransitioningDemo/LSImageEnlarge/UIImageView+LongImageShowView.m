//
//  UIImageView+LongImageShowView.m
//  LSTransitioningDemo
//
//  Created by gankai on 2018/11/22.
//  Copyright © 2018年 laoSun. All rights reserved.
//

#import "UIImageView+LongImageShowView.h"

@implementation UIImageView (LongImageShowView)


// 对指定视图进行截图
- (UIImage *)screenShotView
{
    UIImage *imageRet = nil;
    
    if (self)
    {
        UIGraphicsBeginImageContext(self.frame.size);
        [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:NO];
        imageRet =  UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }else{
    }
    
    return imageRet;
}

@end
