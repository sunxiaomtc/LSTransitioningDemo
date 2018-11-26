//
//  ImageCell.m
//  LSTransitioningDemo
//
//  Created by gankai on 2018/11/16.
//  Copyright © 2018年 laoSun. All rights reserved.
//

#import "ImageCell.h"

@implementation ImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.imgView.layer.masksToBounds = YES;
    
    self.imgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    
    [self.imgView addGestureRecognizer:tap];
}

-(void)setImage:(UIImage *)image
{
    _image = image;
    self.imgView.image = image;
}

-(void)tapClick:(UITapGestureRecognizer *)sender
{
    if(_tapImageBlock)
    {
        self.tapImageBlock();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
