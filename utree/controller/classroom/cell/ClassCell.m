//
//  ClassCell.m
//  utree
//
//  Created by 科研部 on 2019/8/27.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "ClassCell.h"
#import "ClassModel.h"

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
        
        
        _classNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
        [_classNameLabel setText:@"三年二班"];
        _classNameLabel.myLeft = 30;
        _classNameLabel.myTop = 12;
        [_classNameLabel setFont:[UIFont systemFontOfSize:14]];
        
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
        
        [rootLayout addSubview:_classNameLabel];
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
- (void)setClassModel:(ClassModel *)classModel {
    [self.subjectLabel setText:classModel.subject];
    [self.classNameLabel setText:classModel.className];
    [self.studentCountLabel setText: [NSString stringWithFormat:@"学生: %d",classModel.studentCount]];
    [self.dropCountLabel setText:[NSString stringWithFormat:@"水滴: %d",classModel.dropScore]];
    [_subjectLabel sizeToFit];
    [_studentCountLabel sizeToFit];
    [_dropCountLabel sizeToFit];
    
    if(classModel.isSelected)
        self.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"class_bg_selected"]];
    else
        self.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"class_bg_unselected"]];

    
}



@end
