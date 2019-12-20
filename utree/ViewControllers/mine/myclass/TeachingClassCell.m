//
//  TeachingClassModel.m
//  utree
//
//  Created by 科研部 on 2019/9/9.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "TeachingClassCell.h"

@implementation TeachingClassCell

// 1. 初始化子视图
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        
//        self.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"class_bg_unselected"]];
        self.backgroundColor = [UIColor whiteColor];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 8.0;
        self.layer.shadowOpacity=0.6f;
        self.layer.shadowOffset = CGSizeMake(5, 5);
        self.layer.shadowColor =   [[UIColor_ColorChange colorWithHexString:@"#ECECEC"] CGColor];
        
        MyLinearLayout *rootLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
        rootLayout.frame = CGRectMake(0, 0, ScreenWidth*0.74, ScreenWidth*0.42);
        
        MyLinearLayout *topLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Horz];
        topLayout.frame = CGRectMake(0, 0, ScreenWidth, ScreenWidth*0.158+24);

        
        _classNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
        [_classNameLabel setText:@"三年二班"];
        _classNameLabel.myLeft = 30;
        _classNameLabel.myTop=24;
        [_classNameLabel setFont:[UIFont systemFontOfSize:19]];
        [_classNameLabel setTextColor:[UIColor_ColorChange colorWithHexString:@"666666"]];
        
        //        contentLayout.backgroundColor = [UIColor grayColor];
        _iconImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"class_left_icon"]];
        _iconImg.frame = CGRectMake(0, 0, ScreenWidth*0.152, ScreenWidth*0.152);
        _iconImg.myLeft = 21;
        _iconImg.myTop = 18;
        
        UIImageView *dotLineImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"dot_line"]];
        dotLineImg.myCenterX = 0;
        dotLineImg.myCenterY = 20;
        dotLineImg.myTop = 5;
        dotLineImg.myLeft = dotLineImg.myRight=22;
        
        MyLinearLayout *subjectLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Horz];
        subjectLayout.gravity = MyGravity_Horz_Between|MyGravity_Vert_Center;
        subjectLayout.frame = CGRectMake(0, 0, ScreenWidth*0.74, ScreenWidth*0.152);
        subjectLayout.myCenterX=0;
        _firstSubject = [UILabel new];
        _secondSubject = [UILabel new];
        _thirdSubject = [UILabel new];
        _firstSubject.wrapContentHeight=YES;
        _firstSubject.myWidth = ScreenWidth*0.217;
        _secondSubject.wrapContentHeight=YES;
        _secondSubject.myWidth = ScreenWidth*0.217;
        _thirdSubject.wrapContentHeight=YES;
        _thirdSubject.myWidth = ScreenWidth*0.217;
        
        _firstSubject.textAlignment = NSTextAlignmentCenter;
        _secondSubject.textAlignment = NSTextAlignmentCenter;
        _thirdSubject.textAlignment = NSTextAlignmentCenter;
        _firstSubject.textColor = [UIColor_ColorChange colorWithHexString:@"999999"];
        _secondSubject.textColor = [UIColor_ColorChange colorWithHexString:@"999999"];
        _thirdSubject.textColor = [UIColor_ColorChange colorWithHexString:@"999999"];

        [topLayout addSubview:_iconImg];
        [topLayout addSubview:_classNameLabel];
        
        [subjectLayout addSubview:_firstSubject];
        [subjectLayout addSubview:_secondSubject];
        [subjectLayout addSubview:_thirdSubject];

        [rootLayout addSubview:topLayout];
        [rootLayout addSubview:dotLineImg];
        [rootLayout addSubview:subjectLayout];
        
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
-(void)setTeachClassModel:(TeachClassModel *)model
{
    for (int index = 0; index<model.subjectArray.count; index++) {
        switch (index) {
            case 0:
                [_firstSubject setText:model.subjectArray[index]];
                [_firstSubject sizeToFit];
                break;
            case 1:
                [_secondSubject setText:model.subjectArray[index]];
                [_secondSubject sizeToFit];
                break;
            case 2:
                [_thirdSubject setText:model.subjectArray[index]];
                [_thirdSubject sizeToFit];
                break;
            default:
                break;
        }
    }
    
    [_classNameLabel setText:model.teachClassName];
    
}
@end
