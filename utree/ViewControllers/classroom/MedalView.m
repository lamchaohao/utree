//
//  MedalView.m
//  utree
//
//  Created by 科研部 on 2019/10/11.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "MedalView.h"
#import "MedalCell.h"

@interface MedalView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property int kLineNum;
@property int kLineSpacing ;
@property(nonatomic,strong)NSMutableArray *medalImgList;
@property(nonatomic,strong)NSMutableArray *medalModelList;
@end

@implementation MedalView

static NSString *cellID = @"medalViewCell";

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame: frame];
    if (self) {
        _kLineNum=4;
        _kLineSpacing=4;
        self.medalModelList = [[NSMutableArray alloc]initWithCapacity:6];
        [self createCustomView];
    }
    return self;
}

-(void)setMedalData:(NSArray<StuMedalModel *> *)mData
{
    [self.medalModelList removeAllObjects];
    for (int i=0; i<6; i++) {
        for (StuMedalModel *model in mData) {
            if ((model.medalType.intValue-1)==i) {
                [self.medalModelList addObject:model];
            }
        }
    }
    [self.collectionView reloadData];
}

-(void)createCustomView
{
    self.backgroundColor = [UIColor blackColor];
    self.alpha = 0.2;
    
    [self createContentView];
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 30)];
    self.backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 48, 48)];
    self.backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    self.backBtn.myLeft=self.backBtn.myTop=10;
    [self.backBtn setImage:[UIImage imageNamed:@"ic_close_black"] forState:UIControlStateNormal];
    [self.backBtn addTarget:self action:@selector(dismissAlert:) forControlEvents:UIControlEventTouchUpInside];
    [self.titleLabel setText:@"TA的勋章"];
    self.titleLabel.myCenterX=0;
    self.titleLabel.myTop=10;
    [self.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    [self.titleLabel setTextColor:[UIColor myColorWithHexString:@"#FF666666"]];
    
    [self.contentView addSubview:self.backBtn];
    [self.contentView addSubview:self.titleLabel];
    
    [ self createMedalList];
}

-(void)createMedalList
{
    self.medalImgList = [[NSMutableArray alloc]initWithCapacity:6];
    [self.medalImgList addObject:@"medal_study"];
    [self.medalImgList addObject:@"medal_labor"];
    [self.medalImgList addObject:@"medal_entertainment"];
    [self.medalImgList addObject:@"medal_moral"];
    [self.medalImgList addObject:@"medal_practice"];
    [self.medalImgList addObject:@"medal_parent"];
    [self initGridView];
    
}


- (UIView *)createContentView{
    if (!_contentView) {
        _contentView =[MyFrameLayout new];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.frame = CGRectMake(0, 0, ScreenWidth*0.9, ScreenWidth*0.9);
        _contentView.myCenterX=_contentView.myCenterY=0;
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.opaque = YES;
        _contentView.layer.cornerRadius = 11;
        _contentView.clipsToBounds = YES;
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.borderWidth = 0;
        [self addSubview:_contentView];
    }
    return _contentView;
}


- (void)showAlert {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window addSubview:self];
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissAlert:)]];
    //遮罩
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.5;
    }];
    [window addSubview:_contentView];
    
    self.contentView.transform = CGAffineTransformMakeTranslation(0.01, 389);
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.transform = CGAffineTransformMakeTranslation(0.01, 0.01);
    }];
}
 
- (void)dismissAlert :(id)sender{
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.transform = CGAffineTransformMakeTranslation(0.01, 389);
        self.contentView.alpha = 0.2;
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self.contentView removeFromSuperview];
    }];
}



-(void)initGridView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth*0.9,ScreenWidth*0.7) collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor_ColorChange colorWithHexString:@"#F7F7F7"];
    _collectionView.contentInset = UIEdgeInsetsMake(0, 0, 20, 0);
    _collectionView.allowsMultipleSelection = YES;
    _collectionView.myCenterY=1;
    _collectionView.myLeft=_collectionView.myRight=10;
    //    self.edgesForExtendedLayout=UIRectEdgeNone;
    _collectionView.topPos.equalTo(self.titleLabel.bottomPos).offset(12);
    [_collectionView registerClass:[MedalCell class] forCellWithReuseIdentifier:cellID];
    
    [self.contentView addSubview:_collectionView];
}


/**
 分区个数
 */
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
/**
 每个分区item的个数
 */
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.medalImgList.count;
}
/**
 创建cell
 */
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MedalCell *cell =(MedalCell *) [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    
    NSString *imgPath = _medalImgList[indexPath.row];
    if (self.medalModelList.count>indexPath.row) {
        StuMedalModel *model = [self.medalModelList objectAtIndex:indexPath.row];
//        CGFloat progress = model.medalNow.floatValue/model.medalMax.floatValue;
        [cell setDataToviewWithMedalImagePath:imgPath metalNow:model.medalNow.floatValue metalMax:model.medalMax.floatValue needMask:(model.medalNow.intValue!=model.medalMax.intValue)];

    }else{
         [cell setDataToviewWithMedalImagePath:imgPath metalNow:0 metalMax:99 needMask:YES];
//         [cell setDataToviewWithMedalImagePath:imgPath progress:0 needMask:YES];
    }
    
    return cell;
}


/**
 cell的大小
 */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
//    CGFloat itemW = (ScreenWidth-(_kLineNum+1)*_kLineSpacing)/_kLineNum-0.001;
    CGFloat itemH = ScreenWidth*0.26*(1+0.27);
    return CGSizeMake(ScreenWidth*0.26, itemH);
}


@end
