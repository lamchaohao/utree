//
//  TabView.m
//  utree
//
//  Created by 科研部 on 2019/8/7.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "ZBTabView.h"

@interface ZBTabView (){
    
    NSInteger _itemCounts;//控件的数目
    NSArray *_titleArray;//存放title
    float _itemWidth;
    
    //选中背景图
    UIView *_selectView;
}

@end

@implementation ZBTabView

-(id)initWithFrame:(CGRect)frame withTitleArray:(NSArray *)array{
    
    
    if ([super initWithFrame:frame]) {
        _itemCounts = array.count;
        _titleArray = array;
        [self creatSegmentView];
    }
    
    return self;
}

-(void)setTitleArray:(NSArray *)title{
    _itemCounts = title.count;
    _titleArray = title;
    [self creatSegmentView];
}

-(void)creatSegmentView{
    //设置按钮的宽度
    _itemWidth = self.frame.size.width/_itemCounts;
    //循环创建按钮
    for (int i = 0; i < _itemCounts; i++) {
        UIButton *button  = [[UIButton alloc]initWithFrame:CGRectMake(i *_itemWidth, 0, _itemWidth, self.frame.size.height)];
        [self addSubview:button];
        
        //设置button的字
        [button setTitle:_titleArray[i] forState:UIControlStateNormal];
        //设置button的字颜色
        
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //        [button setTitleColor:[UIColor_ColorChange colorWithHexString:@"#4EDF8E"] forState:UIControlStateSelected];
        
        //设置字体大小
        button.titleLabel.font = [UIFont systemFontOfSize:17];
        //设置居中显示
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        //设置tag值
        button.tag = 1000 + i;
        //添加点击事件
        
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        //如果是第一个，默认被选中
        if (i == 0) {
            button.selected = YES;
            button.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        }
    }
    
    
    //添加一个select
    _selectView = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height, _itemWidth, 2)];
    _selectView.backgroundColor=[UIColor colorWithRed:67/255.0 green:210/255.0 blue:127/255.0 alpha:1.0];;
    _selectView.layer.cornerRadius = 1;
    [self addSubview:_selectView];
    
}
-(void)buttonAction:(UIButton *)button{
    NSLog(@"buttonAction");
    //当button被点击，所有的button都设为未选中状态
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *subButton = (UIButton*)view;
            subButton.selected = NO;
            subButton.titleLabel.font = [UIFont systemFontOfSize:17];
        }
    }
    //然后将选中的这个button变为选中状态
    button.selected = YES;
    button.titleLabel.font = [UIFont systemFontOfSize:20];
    
    //通过当前的tag值设置select的位置
    NSInteger index = button.tag - 1000;
    [UIView animateWithDuration:.3 animations:^{
        _selectView.frame = CGRectMake(index*_itemWidth, _selectView.frame.origin.y, _selectView.frame.size.width, _selectView.frame.size.height);
    }];
    
    _returnBlock(index);
}

@end
