//
//  AchievementDetailView.m
//  utree
//
//  Created by 科研部 on 2019/12/10.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "AchievementDetailView.h"
#import "AchievementModel.h"
#import "ScoreModel.h"

@interface AchievementDetailView()

@property(nonatomic,strong)AchievementModel *achievementModel;
@property(nonatomic,strong)MyLinearLayout *contentView;

@property(nonatomic,strong)MyTableLayout *achievementLayout;

@end

@implementation AchievementDetailView

- (instancetype)initWithFrame:(CGRect)frame andAchievementModel:(AchievementModel *)model
{
    self = [super initWithFrame:frame];
    if (self) {
        self.achievementModel = model;
        [self setUpUI];
    }
    return self;
}

-(void)setUpUI
{
    
    self.backgroundColor = [UIColor myColorWithHexString:@"#FAFAFA"];
    UIImageView *bgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 212)];
    [bgView setImage:[UIImage imageNamed:@"bg_work_green"]];
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0, self.frame.size.width, self.frame.size.height)];
    
    _contentView = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];;
//    _contentView.frame =CGRectMake(circleCellWidth,0, self.frame.size.width, self.frame.size.height);
    [scrollView addSubview:bgView];
    [scrollView addSubview:_contentView];
    [self addSubview:scrollView];
    [self setUpTitlePreview];
    [self setupExamInfoView];
    [self setupExamScoreDetail];
}

-(void)setUpTitlePreview
{
    MyTableLayout *previewLayout = [MyTableLayout tableLayoutWithOrientation:MyOrientation_Vert];
    previewLayout.myTop=circleCellMargin;
    previewLayout.myLeft=circleCellMargin;
    previewLayout.frame = CGRectMake(0, 0, circleCellWidth, 220);
    previewLayout.backgroundColor = [UIColor whiteColor];
    previewLayout.layer.cornerRadius = 10;
    MyBorderline *innerBorderLine = [[MyBorderline alloc] initWithColor:[UIColor myColorWithHexString:@"#E0E0E0"]];
    previewLayout.intelligentBorderline = innerBorderLine;
    
    //添加第一行。行高为50，每列宽由自己确定。
    MyLinearLayout *firstRow = [previewLayout addRow:110 colSize:MyLayoutSize.fill];
    firstRow.notUseIntelligentBorderline = YES;
    firstRow.bottomBorderline = [[MyBorderline alloc] initWithColor:[UIColor myColorWithHexString:@"#E0E0E0"]];

    UIView *subjectCell = [self createTitlePreviewCell:@"科目" value:self.achievementModel.subjectName];
    UIView *typeCell = [self createTitlePreviewCell:@"考试名称" value:self.achievementModel.examType];
    subjectCell.weight=1;
    typeCell.weight=1;
    [previewLayout addSubview:subjectCell];
    [previewLayout addSubview:typeCell];
    
    MyLinearLayout *secondRow = [previewLayout addRow:110 colSize:MyLayoutSize.fill];
    secondRow.notUseIntelligentBorderline = YES;
    secondRow.bottomBorderline = [[MyBorderline alloc] initWithColor:[UIColor myColorWithHexString:@"#E0E0E0"]];
    UIView *posterCell = [self createTitlePreviewCell:@"发布人" value:self.achievementModel.teacherDo.teacherName];
    UIView *timeCell = [self createTitlePreviewCell:@"发布时间" value:self.achievementModel.uploadTime];
    posterCell.weight=1;
    timeCell.weight=1;
    
    [previewLayout addSubview:posterCell];
    [previewLayout addSubview:timeCell];
    
    [self.contentView addSubview:previewLayout];
    
}

-(MyFrameLayout*)createTitlePreviewCell:(NSString*)title value:(NSString*)value
{
    MyFrameLayout *cellLayout = [MyFrameLayout new];
    
    UILabel *valueLabel = [UILabel new];
    valueLabel.text = value;
    valueLabel.textColor = [UIColor myColorWithHexString:PrimaryColor];
    valueLabel.font = [CFTool font:16];
    valueLabel.adjustsFontSizeToFitWidth = YES;
    valueLabel.textAlignment = NSTextAlignmentCenter;
    valueLabel.myCenterX=0;
    valueLabel.myMargin=0;
    valueLabel.myTop=-30;
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = title;
    titleLabel.textColor = [UIColor myColorWithHexString:@"#999999"];
    titleLabel.font = [CFTool font:13];
    titleLabel.adjustsFontSizeToFitWidth = YES;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.myCenterX=0;
    titleLabel.myMargin=0;
    titleLabel.myTop=30;
    
    [cellLayout addSubview:valueLabel];
    [cellLayout addSubview:titleLabel];
       
    return cellLayout;
}

-(void)setupExamInfoView
{
    MyLinearLayout *examInfoTitleLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Horz];
    examInfoTitleLayout.frame = CGRectMake(0, 0, circleCellWidth, 24);
    examInfoTitleLayout.myLeft=examInfoTitleLayout.myTop=circleCellMargin;
    UIView *dotView = [[UIView alloc] init];
    dotView.frame = CGRectMake(0,0,3,20);
    dotView.backgroundColor = [UIColor colorWithRed:67/255.0 green:210/255.0 blue:127/255.0 alpha:1.0];
    
    UILabel *infoTitle =[UILabel new];
    infoTitle.text = @"成绩总览";
    infoTitle.font = [CFTool font:16];
    infoTitle.myLeft = circleCellMargin;
    infoTitle.myTop= 0;
    [infoTitle sizeToFit];
    [examInfoTitleLayout addSubview:dotView];
    [examInfoTitleLayout addSubview:infoTitle];
    [self.contentView addSubview:examInfoTitleLayout];
    
    MyTableLayout *examInfoLayout = [MyTableLayout tableLayoutWithOrientation:MyOrientation_Vert];
    examInfoLayout.myTop=examInfoLayout.myLeft=circleCellMargin;
    examInfoLayout.myBottom=20;
    examInfoLayout.frame = CGRectMake(15, 15, circleCellWidth, 110);
        
     MyBorderline *outerBorderLine = [[MyBorderline alloc] initWithColor:[UIColor myColorWithHexString:@"#E0E0E0"]];
     outerBorderLine.thick = 2;
     examInfoLayout.boundBorderline = outerBorderLine;
         
    MyBorderline *innerBorderLine = [[MyBorderline alloc] initWithColor:[UIColor myColorWithHexString:@"#E0E0E0"]];
    examInfoLayout.intelligentBorderline = innerBorderLine;
    
    MyLinearLayout *subjectRow = [examInfoLayout addRow:36 colSize:MyLayoutSize.fill];
    subjectRow.notUseIntelligentBorderline = YES;
    subjectRow.bottomBorderline = [[MyBorderline alloc] initWithColor:[UIColor myColorWithHexString:@"#E0E0E0"]];
    UIView *firstCell = [self createCellLayout:@"科目"];
    firstCell.backgroundColor = [UIColor myColorWithHexString:@"#F7F7F7"];
    UIView *secondCell = [self createCellLayout:self.achievementModel.subjectName];
    secondCell.backgroundColor = [UIColor myColorWithHexString:@"#F7F7F7"];
    firstCell.weight=1;
    secondCell.weight=1;
    [examInfoLayout addSubview:firstCell];
    [examInfoLayout addSubview:secondCell];
    
    MyLinearLayout *maxScoreRow = [examInfoLayout addRow:36 colSize:MyLayoutSize.fill];
    maxScoreRow.notUseIntelligentBorderline = YES;
    maxScoreRow.bottomBorderline = [[MyBorderline alloc] initWithColor:[UIColor myColorWithHexString:@"#E0E0E0"]];
    UIView *maxNameCell = [self createCellLayout:@"满分💯"];
    UIView *maxValueCell = [self createCellLayout:[NSString stringWithFormat:@"%ld",self.achievementModel.examMax.longValue]];
    maxNameCell.weight=1;
    maxValueCell.weight=1;
    [examInfoLayout addSubview:maxNameCell];
    [examInfoLayout addSubview:maxValueCell];
    
    MyLinearLayout *averageRow = [examInfoLayout addRow:36 colSize:MyLayoutSize.fill];
    averageRow.notUseIntelligentBorderline = YES;
    averageRow.bottomBorderline = [[MyBorderline alloc] initWithColor:[UIColor myColorWithHexString:@"#E0E0E0"]];
    UIView *averageNameCell = [self createCellLayout:@"平均分💯"];
    UIView *averageValueCell = [self createCellLayout:[NSString stringWithFormat:@"%ld",self.achievementModel.examAverage.longValue]];
    averageNameCell.weight=1;
    averageValueCell.weight=1;
    [examInfoLayout addSubview:averageNameCell];
    [examInfoLayout addSubview:averageValueCell];
    
    [self.contentView addSubview:examInfoLayout];
}

-(MyFrameLayout*)createCellLayout:(NSString*)value
{
    MyFrameLayout *cellLayout = [MyFrameLayout new];
//    [cellLayout setTarget:self action:@selector(handleCellTap:)];
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

-(void)setupExamScoreDetail
{
    MyLinearLayout *detailTitleLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Horz];
    detailTitleLayout.frame = CGRectMake(0, 0, circleCellWidth, 24);
    detailTitleLayout.myLeft=detailTitleLayout.myTop=circleCellMargin;
    UIView *dotView = [[UIView alloc] init];
    dotView.frame = CGRectMake(0,0,3,20);
    dotView.backgroundColor = [UIColor colorWithRed:67/255.0 green:210/255.0 blue:127/255.0 alpha:1.0];
    
    UILabel *detailTitleLabel =[UILabel new];
    detailTitleLabel.text = @"学生得分详情";
    detailTitleLabel.font = [CFTool font:16];
    detailTitleLabel.myLeft =circleCellMargin;
    detailTitleLabel.myTop= 0;
    [detailTitleLabel sizeToFit];
    [detailTitleLayout addSubview:dotView];
    [detailTitleLayout addSubview:detailTitleLabel];
    [self.contentView addSubview:detailTitleLayout];
    
    MyTableLayout *achievementLayout = [MyTableLayout tableLayoutWithOrientation:MyOrientation_Vert];
    achievementLayout.myTop=achievementLayout.myLeft=circleCellMargin;
    achievementLayout.myBottom=20;
    achievementLayout.frame = CGRectMake(15, 15, circleCellWidth, 110);
        
     MyBorderline *outerBorderLine = [[MyBorderline alloc] initWithColor:[UIColor myColorWithHexString:@"#E0E0E0"]];
     outerBorderLine.thick = 2;
     achievementLayout.boundBorderline = outerBorderLine;
         
    MyBorderline *innerBorderLine = [[MyBorderline alloc] initWithColor:[UIColor myColorWithHexString:@"#E0E0E0"]];
    achievementLayout.intelligentBorderline = innerBorderLine;
    
    MyLinearLayout *subjectRow = [achievementLayout addRow:36 colSize:MyLayoutSize.fill];
    subjectRow.notUseIntelligentBorderline = YES;
    subjectRow.bottomBorderline = [[MyBorderline alloc] initWithColor:[UIColor myColorWithHexString:@"#E0E0E0"]];
    UIView *firstCell = [self createCellLayout:@"序号"];
    firstCell.backgroundColor = [UIColor myColorWithHexString:@"#F7F7F7"];
    UIView *secondCell = [self createCellLayout:@"姓名"];
    secondCell.backgroundColor = [UIColor myColorWithHexString:@"#F7F7F7"];
    UIView *thirdCell = [self createCellLayout:@"总分"];
    thirdCell.backgroundColor = [UIColor myColorWithHexString:@"#F7F7F7"];
    firstCell.weight=1;
    secondCell.weight=1;
    thirdCell.weight=1;
    [achievementLayout addSubview:firstCell];
    [achievementLayout addSubview:secondCell];
    [achievementLayout addSubview:thirdCell];
    self.achievementLayout = achievementLayout;
    [self.contentView addSubview:achievementLayout];
}

-(void)addScoreListToView:(NSArray *)scoreList
{
    for (ScoreModel *model in scoreList) {
        MyLinearLayout *subjectRow = [_achievementLayout addRow:36 colSize:MyLayoutSize.fill];
        subjectRow.notUseIntelligentBorderline = YES;
        subjectRow.bottomBorderline = [[MyBorderline alloc] initWithColor:[UIColor myColorWithHexString:@"#E0E0E0"]];
        UIView *rankCell = [self createCellLayout:[NSString stringWithFormat:@"%ld",model.ranking.longValue]];
        
        UIView *nameCell = [self createCellLayout:[NSString stringWithFormat:@"%@",model.studentName]];
        
        UIView *scoreCell = [self createCellLayout:[NSString stringWithFormat:@"%ld",model.score.longValue]];
        
        rankCell.weight=1;
        nameCell.weight=1;
        scoreCell.weight=1;
        [_achievementLayout addSubview:rankCell];
        [_achievementLayout addSubview:nameCell];
        [_achievementLayout addSubview:scoreCell];
    }
}


@end
