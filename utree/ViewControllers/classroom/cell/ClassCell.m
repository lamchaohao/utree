//
//  ClassCell.m
//  utree
//
//  Created by 科研部 on 2019/8/27.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "ClassCell.h"
#import "UTClassModel.h"

@interface ClassCell()
@property (strong, nonatomic) UILabel *classNameLabel;
@property (strong, nonatomic) UIImageView *iconImg;
@property (strong, nonatomic) UILabel *subjectLabel;
@property (strong, nonatomic) UILabel *studentCountLabel;
@property (strong, nonatomic) UILabel *dropCountLabel;
@end

@implementation ClassCell


// 1. 初始化子视图
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        MyLinearLayout *rootLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
        rootLayout.frame = CGRectMake(0, 0, ScreenWidth*0.75+10, ScreenWidth*0.432+10);
        
        self.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"class_bg_unselected"]];
//        self.backgroundColor = [UIColor grayColor];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 8.0;
        self.layer.shadowOpacity=0.6f;
        self.layer.shadowOffset = CGSizeMake(5, 5);
        self.layer.shadowColor =   [[UIColor_ColorChange colorWithHexString:@"#FFECECEC"] CGColor];
        
        MyLinearLayout *classNameLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Horz];
        classNameLayout.frame = CGRectMake(0, 0, circleCellWidth, 24);
        classNameLayout.myLeft=classNameLayout.myTop=circleCellMargin;
        UIView *dotView = [[UIView alloc] init];
        dotView.frame = CGRectMake(0,0,3,20);
        dotView.backgroundColor = [UIColor colorWithRed:67/255.0 green:210/255.0 blue:127/255.0 alpha:1.0];
        
//        UILabel *infoTitle =[UILabel new];
//        infoTitle.text = @"成绩总览";
//        infoTitle.font = [CFTool font:16];
//        infoTitle.myLeft = circleCellMargin;
//        infoTitle.myTop= 0;
//        [infoTitle sizeToFit];
        _classNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
        [_classNameLabel setText:@"三年二班"];
        _classNameLabel.myLeft = 8;
//        _classNameLabel.myTop = 12;
        [_classNameLabel setFont:[UIFont systemFontOfSize:14]];
        [classNameLayout addSubview:dotView];
        [classNameLayout addSubview:_classNameLabel];
        
        
        
//        _classNameLabel.myCenterY = 0;
        MyLinearLayout *contentLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Horz];
        
        contentLayout.frame = CGRectMake(0, 0, ScreenWidth*0.75+10, ScreenWidth*0.33+10);
//        contentLayout.backgroundColor = [UIColor grayColor];
        _iconImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"class_left_icon"]];
        _iconImg.myLeft = 21;
        _iconImg.myCenterY=-20;
        
        MyLinearLayout *detailLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
        detailLayout.frame = CGRectMake(0, 0, ScreenWidth*0.75*0.6+10, ScreenWidth*0.33+10);
        detailLayout.myCenterY = -20;
        detailLayout.myLeft = 20;
        
        _subjectLabel = [[UILabel alloc]init];
        _studentCountLabel = [[UILabel alloc]init];
        _dropCountLabel = [[UILabel alloc]init];
        _subjectLabel.myTop=8;
        _studentCountLabel.myTop=8;
        _dropCountLabel.myTop=8;

        
        [_subjectLabel setText:@"null"];
        [_studentCountLabel setText:@"null"];
        [_dropCountLabel setText:@"null"];
        
        [_subjectLabel setFont:[UIFont systemFontOfSize:14]];
        [_studentCountLabel setFont:[UIFont systemFontOfSize:14]];
        [_dropCountLabel setFont:[UIFont systemFontOfSize:14]];

        [_subjectLabel sizeToFit];
        [_studentCountLabel sizeToFit];
        [_dropCountLabel sizeToFit];

        [detailLayout addSubview:_subjectLabel];
        [detailLayout addSubview:_studentCountLabel];
        [detailLayout addSubview:_dropCountLabel];
        
        [contentLayout addSubview:_iconImg];
        [contentLayout addSubview:detailLayout];
        
        [rootLayout addSubview:classNameLayout];
        [rootLayout addSubview:contentLayout];
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
    NSString *appendClassName = @"";
    if(classModel.headTeacher.boolValue){
        appendClassName = [classModel.className stringByAppendingString:@"(班主任)"];
        NSMutableAttributedString *abStr = [[NSMutableAttributedString alloc] initWithString:appendClassName];
        [abStr addAttribute:NSForegroundColorAttributeName value:[UIColor myColorWithHexString:@"#F8A21A"] range:NSMakeRange(classModel.className.length, 5)];
        self.classNameLabel.attributedText = abStr;
        [self.classNameLabel sizeToFit];
    }else{
        [self.classNameLabel setText:classModel.className];
        [self.classNameLabel sizeToFit];
    }

    NSMutableAttributedString *subjectAbs = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"科目：%@",classModel.subject]];
    [subjectAbs addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(3, classModel.subject.length)];
    self.subjectLabel.attributedText = subjectAbs;
    
    NSMutableAttributedString *studentCountAbs = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"学生：%d",classModel.studentCount.intValue]];
    [studentCountAbs addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(3, [NSString stringWithFormat:@"%d",classModel.studentCount.intValue].length)];
     [studentCountAbs addAttribute:NSForegroundColorAttributeName value:[UIColor myColorWithHexString:@"#43D27F"] range:NSMakeRange(3, classModel.studentCount.stringValue.length)];
    self.studentCountLabel.attributedText = studentCountAbs;
    
//    [self.studentCountLabel setText: [NSString stringWithFormat:@"学生: %d",classModel.studentCount.intValue]];
    
    NSMutableAttributedString *dropCountAbs = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"水滴：%d",classModel.dropCount.intValue]];
    [dropCountAbs addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(3, [NSString stringWithFormat:@"%d",classModel.dropCount.intValue].length)];
     [dropCountAbs addAttribute:NSForegroundColorAttributeName value:[UIColor myColorWithHexString:@"#44D2FF"] range:NSMakeRange(3, classModel.dropCount.stringValue.length)];
    self.dropCountLabel.attributedText = dropCountAbs;
//    [self.dropCountLabel setText:[NSString stringWithFormat:@"水滴: %d",classModel.dropCount.intValue]];
    [_subjectLabel sizeToFit];
    [_studentCountLabel sizeToFit];
    [_dropCountLabel sizeToFit];
    
    if(classModel.isSelected)
        self.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"class_bg_selected"]];
    else
        self.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"class_bg_unselected"]];

    
}



@end
