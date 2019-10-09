//
//  PhotoCell.m
//  utree
//
//  Created by 科研部 on 2019/9/29.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "PhotoCell.h"

@implementation PhotoCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(0, 10, frame.size.width, frame.size.height)];
    if (self) {
        
        [self creatItemView];
    }
    return self;
}

-(void)creatItemView
{
    _mainImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10, 100, 100)];
    UIButton *closeBtn = [[UIButton alloc]initWithFrame:CGRectMake(90, 0, 20, 20)];
    [closeBtn setImage:[UIImage imageNamed:@"ic_white_round_close"] forState:UIControlStateNormal];
    
    [closeBtn addTarget:self action:@selector(closeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    _mainImageView.layer.cornerRadius=11;
    [self addSubview:_mainImageView];
    [self addSubview:closeBtn];
}

-(void)closeBtnClick:(id)sender
{
    if (self.delegate) {
         [self.delegate deletedPhoto:_mainImageView.image];
    }
   
}

@end
