//
//  MyClassCell.m
//  utree
//
//  Created by 科研部 on 2019/9/9.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "MyClassCell.h"

@implementation MyClassCell


// 1. 初始化子视图
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        
//        self.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"class_bg_unselected"]];
        self.backgroundColor = [UIColor whiteColor];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 10.0;
        self.layer.shadowColor =   [[UIColor_ColorChange colorWithHexString:@"#FFECECEC"] CGColor];
        
        MyLinearLayout *rootLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Horz];
        rootLayout.frame = CGRectMake(0, 0, ScreenWidth*0.74, ScreenHeight*0.1345);
        
        _classNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
        [_classNameLabel setText:@"三年二班"];
        _classNameLabel.myLeft = 30;
        _classNameLabel.myCenterY=0;
        [_classNameLabel setFont:[UIFont systemFontOfSize:19]];
        [_classNameLabel setTextColor:[UIColor_ColorChange colorWithHexString:@"666666"]];

        //        contentLayout.backgroundColor = [UIColor grayColor];
        _iconImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"class_left_icon"]];
        _iconImg.frame = CGRectMake(0, 0, ScreenWidth*0.152, ScreenWidth*0.152);
        _iconImg.myLeft = 21;
        _iconImg.myCenterY=-5;
        
        [rootLayout addSubview:_iconImg];
        [rootLayout addSubview:_classNameLabel];
        
        [self.contentView addSubview:rootLayout];
    }
    
    return self;
}


- (void)setFrame:(CGRect)frame{
    frame.origin.x += 10;
    frame.origin.y += 10;
    frame.size.height -= 10;
    frame.size.width -= 20;
    [super setFrame:frame];
    
}

// 3. 填充数据
- (void)setClassModel:(UTClassModel *)classModel {
   
    [self.classNameLabel setText:classModel.className];
    [_classNameLabel sizeToFit];
    
    
}


@end
