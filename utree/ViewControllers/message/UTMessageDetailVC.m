//
//  UTMessageDetailVC.m
//  utree
//
//  Created by 科研部 on 2020/1/16.
//  Copyright © 2020 科研部. All rights reserved.
//

#import "UTMessageDetailVC.h"
#import "NoticeMessageModel.h"
#import "NotificationDC.h"

@interface UTMessageDetailVC ()
@property(nonatomic,strong)NSString *noticeMsgId;
@property(nonatomic,assign)BOOL isSystemInfo;
@property(nonatomic,strong)NoticeMessageModel *noticeMsgModel;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *timeLabel;
@property(nonatomic,strong)UILabel *contentLabel;
@property(nonatomic,strong)UIScrollView *scrollView;

@end

@implementation UTMessageDetailVC

- (instancetype)initWithNoticeId:(NSString *)msgId isSystemMsg:(BOOL)isSysMsg
{
    self = [super init];
    if (self) {
        _noticeMsgId = msgId;
        _isSystemInfo = isSysMsg;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpView];
    [self loadData];
}

-(void)setUpView
{
    
    MyLinearLayout *rootLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
    rootLayout.frame = self.view.bounds;
    self.titleLabel = [UILabel new];
    [self.titleLabel setFont:[UIFont systemFontOfSize:18]];
    self.titleLabel.myTop=12;
    self.titleLabel.myLeft=self.titleLabel.myRight=12;
    self.titleLabel.numberOfLines = 0;//表示label可以多行显示
    self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;//换行模式，与上面的计算保持一致。
    
    
    self.timeLabel = [UILabel new];
    self.timeLabel.frame = CGRectMake(0, 0, ScreenWidth, 20);
    self.timeLabel.myTop=self.timeLabel.myLeft=12;
    [self.timeLabel setFont:[UIFont systemFontOfSize:12]];
    [self.timeLabel setTextColor:[UIColor myColorWithHexString:@"#999999"]];
    
    self.contentLabel = [UILabel new];
    [self.contentLabel setFont:[UIFont systemFontOfSize:15]];
    [self.contentLabel setTextColor:[UIColor myColorWithHexString:@"#808080"]];
    self.contentLabel.myTop=24;
    self.contentLabel.myBottom=23;
    self.contentLabel.myLeft=self.contentLabel.myRight=12;
    self.contentLabel.numberOfLines = 0;//表示label可以多行显示
    self.contentLabel.lineBreakMode = NSLineBreakByWordWrapping;//换行模式，与上面的计算保持一致。
    
    self.scrollView = [UIScrollView new];
    self.scrollView.frame = self.view.frame;
    self.scrollView.contentSize = self.view.frame.size;
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    [rootLayout addSubview:self.titleLabel];
    [rootLayout addSubview:self.timeLabel];
    [rootLayout addSubview:self.contentLabel];
    [self.scrollView addSubview:rootLayout];
    [self.view addSubview:self.scrollView];
}

-(void)loadData
{
    NotificationDC *dataController =  [[NotificationDC alloc]init];
    
    [dataController requestNoticeDetailWith:self.noticeMsgId isSystemNotice:self.isSystemInfo WithSuccess:^(UTResult * _Nonnull result) {
        self.noticeMsgModel = result.successResult;
        [self reloadDataToViews];
    } failure:^(UTResult * _Nonnull result) {
        [self.view makeToast:result.failureResult];
    }];
}


-(void)reloadDataToViews
{
    NSString *titleShowText = @"";
    NSString *contentShowText = @"";
    [self.timeLabel setText:self.noticeMsgModel.createTime];
    if (self.noticeMsgModel.recall.boolValue) {
        titleShowText =[NSString stringWithFormat:@"【已撤回】%@",self.noticeMsgModel.topic];
        contentShowText =@"【已撤回】";
    }else{
        titleShowText = self.noticeMsgModel.topic;
        contentShowText = self.noticeMsgModel.content;
    }
    
    
    CGSize titleTextSize = [self stringSizeWithFont:self.titleLabel.font str:titleShowText maxWidth:ScreenWidth-24 maxHeight:MAXFLOAT];
    titleTextSize.height = ceil(titleTextSize.height) + 1;
    self.titleLabel.frame = (CGRect){{0,0},titleTextSize};
    
    CGSize contentTextSize = [self stringSizeWithFont:self.contentLabel.font str:contentShowText maxWidth:ScreenWidth-24 maxHeight:MAXFLOAT];
        contentTextSize.height = ceil(contentTextSize.height) + 1;
    self.contentLabel.frame = (CGRect){{0,0},contentTextSize};
    
    [self.titleLabel setText:titleShowText];
    [self.contentLabel setText:contentShowText];
    self.title = titleShowText;
    CGFloat viewHeight = CGRectGetMaxY(self.titleLabel.frame)+CGRectGetMaxY(self.contentLabel.frame)+20;
    
    self.scrollView.contentSize = CGSizeMake(ScreenWidth, viewHeight);
}

- (CGSize)stringSizeWithFont:(UIFont *)font str:(NSString*)str maxWidth:(CGFloat)maxWidth maxHeight:(CGFloat)maxHeight
{
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    CGSize maxSize = CGSizeMake(maxWidth, maxHeight);
    attr[NSFontAttributeName] = font;
    return [str boundingRectWithSize:maxSize options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attr context:nil].size;
    
}

@end
