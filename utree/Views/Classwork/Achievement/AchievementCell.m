//
//  AchievementCellTableViewCell.m
//  utree
//
//  Created by 科研部 on 2019/12/9.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "AchievementCell.h"


@interface AchievementCell()
@property(nonatomic,strong)MyRelativeLayout *topLayout;
@property(nonatomic,strong)MyTableLayout *tableLayout;
@end

@implementation AchievementCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}


-(void)setupUI
{
    MyLinearLayout *contentLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
    contentLayout.frame = CGRectMake(0, 0, ScreenWidth-30, 370);
    contentLayout.myCenterX=0;
    contentLayout.layer.cornerRadius = 10;
    contentLayout.backgroundColor = [UIColor whiteColor];
    
    MyRelativeLayout *topLayout = [MyRelativeLayout new];
    topLayout.frame = CGRectMake(0, 0, ScreenWidth-60, 56);
    topLayout.myCenterX=0;
    
    _headView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 48, 48)];
    _posterLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 254, 20)];
    _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 260, 18)];
    _unreadView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_new_unread"]];
    
    _headView.myTop=circleCellMargin;
    _posterLabel.topPos.equalTo(_headView.topPos).offset(5);
    _posterLabel.leftPos.equalTo(_headView.rightPos).offset(10);
    _timeLabel.topPos.equalTo(_posterLabel.bottomPos).offset(5);
    _timeLabel.leftPos.equalTo(_headView.rightPos).offset(10);
    _unreadView.leftPos.equalTo(_posterLabel.rightPos).offset(7);
    _unreadView.topPos.equalTo(_posterLabel.topPos).offset(2);
    
    [_timeLabel setTextColor:[UIColor_ColorChange colorWithHexString:SecondTextColor]];
    [_timeLabel setFont:[UIFont systemFontOfSize:13]];
    [_posterLabel setFont:[UIFont systemFontOfSize:17]];

    _headView.layer.cornerRadius=_headView.frame.size.width/2 ;//裁成圆角
    _headView.layer.masksToBounds=YES;//隐藏裁剪掉的部分
    _headView.layer.borderWidth = 0.1f;//边框宽度
    
    [topLayout addSubview:_headView];
    [topLayout addSubview:_posterLabel];
    [topLayout addSubview:_timeLabel];
    self.topLayout = topLayout;
    UIView *divideView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth-36, 1)];
    divideView.backgroundColor = [UIColor myColorWithHexString:@"#FFE6E6E6"];
    divideView.myTop=circleCellMargin;
    divideView.myLeft=divideView.myRight=2;
    
    _subjectAndTitleLabel =[[UILabel alloc]initWithFrame:CGRectMake(0, 45, 260, 18)];
    _subjectAndTitleLabel.font= [UIFont systemFontOfSize:14];
    _subjectAndTitleLabel.myTop=_subjectAndTitleLabel.myLeft=circleCellMargin;
    
    _tableLayout = [MyTableLayout tableLayoutWithOrientation:MyOrientation_Vert];
    _tableLayout.myTop=_tableLayout.myLeft=circleCellMargin;
    _tableLayout.myBottom=20;
    _tableLayout.frame = CGRectMake(15, 15, ScreenWidth-60, 220);
    
    
    //建立一个表格外边界的边界线。颜色为黑色，粗细为3.
     MyBorderline *outerBorderLine = [[MyBorderline alloc] initWithColor:[UIColor myColorWithHexString:@"#E0E0E0"]];
     outerBorderLine.thick = 3;
     _tableLayout.boundBorderline = outerBorderLine;
     
//建立智能边界线。所谓智能边界线就是布局里面的如果有子布局视图，则子布局视图会根据自身的布局位置智能的设置边界线。
     //智能边界线只支持表格布局、线性布局、流式布局、浮动布局。
     //如果要想完美使用智能分界线，则请将cellview建立为一个布局视图，比如本例子中的createCellLayout。
     MyBorderline *innerBorderLine = [[MyBorderline alloc] initWithColor:[UIColor myColorWithHexString:@"#E0E0E0"]];
     _tableLayout.intelligentBorderline = innerBorderLine;

    [self addFirstRow];
    
    
    [contentLayout addSubview:topLayout];
    [contentLayout addSubview:divideView];
    [contentLayout addSubview:_subjectAndTitleLabel];
    [contentLayout addSubview:_tableLayout];
    [self.contentView addSubview:contentLayout];
    self.backgroundColor= [UIColor myColorWithHexString:@"#F7F7F7"];
}

-(MyFrameLayout*)createCellLayout:(NSString*)value
{
    MyFrameLayout *cellLayout = [MyFrameLayout new];
    [cellLayout setTarget:self action:@selector(handleCellTap:)];
//    cellLayout.highlightedBackgroundColor = [CFTool color:8];
    
    UILabel *label = [UILabel new];
    label.text = value;
    label.font = [CFTool font:15];
    label.adjustsFontSizeToFitWidth = YES;
    label.textAlignment = NSTextAlignmentCenter;
    label.myMargin = 0;
    [cellLayout addSubview:label];
    
    return cellLayout;
}

-(void)addFirstRow
{
    //添加第一行。行高为50，每列宽由自己确定。
    MyLinearLayout *firstRow = [_tableLayout addRow:55 colSize:MyLayoutSize.fill];
    firstRow.notUseIntelligentBorderline = YES;
    firstRow.bottomBorderline = [[MyBorderline alloc] initWithColor:[UIColor myColorWithHexString:@"#E0E0E0"]];

    UIView *nameCellView = [self createCellLayout:@"姓名"];
    UIView *scoreCellView = [self createCellLayout:@"总分"];
    nameCellView.weight=1;
    scoreCellView.weight=1;
    nameCellView.backgroundColor = [UIColor myColorWithHexString:@"#F7F7F7"];
    scoreCellView.backgroundColor = [UIColor myColorWithHexString:@"#F7F7F7"];
    [_tableLayout addSubview:nameCellView];
    [_tableLayout addSubview:scoreCellView];
}

-(void)handleCellTap:(id)send
{
    
}

-(void)setDataToView:(AchievementModel *)model
{
    if (model.examUnread.boolValue) {
        [self.topLayout addSubview:_unreadView];
    }else{
        [_unreadView removeFromSuperview];
    }
    [_headView sd_setImageWithURL:[NSURL URLWithString:model.teacherDo.path] placeholderImage:[UIImage imageNamed:@"default_head"]];
    
    [_posterLabel setText:model.teacherDo.teacherName];
    [_posterLabel sizeToFit];
    [_timeLabel setText:model.uploadTime];
    [_subjectAndTitleLabel setText:[NSString stringWithFormat:@"科目：%@    标题：%@",model.subjectName,model.examType]];
    
    [self.tableLayout removeAllSubviews];
    [self addFirstRow];
    for (int rank=1; rank<4; rank++) {
        for (ScoreModel *score in model.scoreList) {
            if (score.ranking.longValue==rank) {
                MyLinearLayout *scoreRow = [self.tableLayout addRow:55 colSize:MyLayoutSize.fill];
                scoreRow.notUseIntelligentBorderline = YES;
                scoreRow.bottomBorderline = [[MyBorderline alloc] initWithColor:[UIColor myColorWithHexString:@"#E0E0E0"]];
                UIView *innerName = [self createCellLayout:score.studentName];
                UIView *innerScore = [self createCellLayout:[NSString stringWithFormat:@"%ld",score.score.longValue]];
                innerName.weight=1;
                innerScore.weight=1;
                [self.tableLayout addSubview:innerName];
                [self.tableLayout addSubview:innerScore];
                break;
            }
            
        }
    }
    
    
    
}

@end
