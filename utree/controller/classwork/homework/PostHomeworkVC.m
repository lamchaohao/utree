//
//  PostHomeworkVC.m
//  utree
//
//  Created by 科研部 on 2019/10/8.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "PostHomeworkVC.h"
#import "UITextView+ZBPlaceHolder.h"
#import "PhotoCell.h"
#import "MMAlertView.h"
#import "RecorderView.h"
#import "XHAudioPlayerHelper.h"
#import "TZImagePickerController.h"
#import "RxWebViewController.h"

@interface PostHomeworkVC ()<UICollectionViewDelegate,UICollectionViewDataSource,TZImagePickerControllerDelegate,DeletePicDelegate,RecorderViewDelegate,ZBWebviewLoadedDelegate>
@property(nonatomic,strong)MyLinearLayout *rootLayout;
@property(nonatomic,strong)UISwitch *parentSwitch;
@property(nonatomic,strong)UILabel *deadLineLabel;
@property(nonatomic,strong)MyRelativeLayout *audioLayout;
@property(nonatomic,strong)UIButton *audioButton;
@property(nonatomic,strong)UIButton *closeAudioButton;

@property(nonatomic,strong)UICollectionView *picCollectionView;
@property(nonatomic,strong)NSMutableArray *picList;
@property(nonatomic,strong)NSMutableArray *selectAssets;

@property(nonatomic,strong)UIImageView *urlImage;
@property(nonatomic,strong)UILabel *urlTitleLabel;
@property(nonatomic,strong)NSString *urlInput;
@property(nonatomic,strong)MyRelativeLayout *urlLayout;
@property(nonatomic,strong)NSString *audioPath;
@property(nonatomic,strong)UIDatePicker *datePicker;
@property(nonatomic,strong)XHAudioPlayerHelper *playerHelper;
@end

@implementation PostHomeworkVC

static NSString *cellID = @"photoCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDatePicker];
    [self initNaviBar];
    [self initMainLayout];
}
#pragma mark 初始化顶部导航栏
-(void)initNaviBar
{
    UIScrollView *scrollView = [UIScrollView new];
    scrollView.frame = CGRectMake(0, 64, ScreenWidth, ScreenHeight-iPhone_Bottom_NavH);
    [self.view addSubview:scrollView];
    
    self.rootLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
    self.rootLayout.padding = UIEdgeInsetsMake(10, 0, 10, 0); //设置布局内的子视图离自己的边距.
    self.rootLayout.myHorzMargin = 0;                          //同时指定左右边距为0表示宽度和父视图一样宽
    self.rootLayout.heightSize.lBound(scrollView.heightSize, 10, 1);
    self.view.backgroundColor=[UIColor myColorWithHexString:@"#F7F7F7"];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    MyRelativeLayout *navBarLayout = [MyRelativeLayout new];
    navBarLayout.frame = CGRectMake(0, 0, ScreenWidth, 64);
    navBarLayout.backgroundColor = [UIColor whiteColor];
    navBarLayout.myTop=iPhone_StatuBarHeight;
    navBarLayout.myLeft=0;
    
    UILabel *navTitle = [[UILabel alloc]init];
    navTitle.myCenterX=0;
    navTitle.myCenterY=0;
    navTitle.textColor = [UIColor blackColor];
    navTitle.font = [UIFont boldSystemFontOfSize:20];
    navTitle.text=@"布置作业/任务";
    [navTitle sizeToFit];
    
    UIButton *closeButton = [[UIButton alloc]init];
    [closeButton setTitle:@"取消" forState:UIControlStateNormal];
    [closeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    [closeButton sizeToFit];
    [closeButton addTarget:self action:@selector(finishVC:) forControlEvents:UIControlEventTouchUpInside];
    closeButton.myTop=0;
    closeButton.myLeft=18;
    closeButton.myCenterY=0;
    
    
    UIButton *postBtn = [[UIButton alloc]init];
    [postBtn setTitle:@"发送" forState:UIControlStateNormal];
    [postBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [postBtn sizeToFit];
    [postBtn addTarget:self action:@selector(postToServer:) forControlEvents:UIControlEventTouchUpInside];
    postBtn.myTop=0;
    postBtn.myRight=18;
    postBtn.myCenterY=0;
    
    
    [navBarLayout addSubview:closeButton];
    [navBarLayout addSubview:navTitle];
    [navBarLayout addSubview:postBtn];
    [self.view addSubview:navBarLayout];
    
    [scrollView addSubview:self.rootLayout];
}
#pragma mark 初始化主布局界面
-(void)initMainLayout
{
    UITextField *titleInput = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth-80, 48)];
    titleInput.borderStyle=UITextBorderStyleNone;
    [titleInput setPlaceholder:@"请输入作业/任务标题"];
    titleInput.myLeft=titleInput.myRight=18;
    
    
    UITextView *contentInput = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth-40, 120)];
    [contentInput setPlaceholder:@"请输入作业/任务内容"];
    contentInput.myLeft=contentInput.myRight=18;
    
    [_rootLayout addSubview:titleInput];
    [_rootLayout addSubview: [self needDivideView]];
    [_rootLayout addSubview:contentInput];
//    [self.view addSubview: divideView];
    
    [self initMedialayout];
    
    MyLinearLayout *attachLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Horz];
    attachLayout.frame =CGRectMake(0, 0, ScreenWidth, 30);
    attachLayout.myTop=5;
    attachLayout.myLeft=18;
    attachLayout.myBottom=3;
    UIButton *audioButton = [[UIButton alloc]init];
    [audioButton setImage:[UIImage imageNamed:@"ic_microphone"] forState:UIControlStateNormal];
    [audioButton sizeToFit];
    [audioButton addTarget:self action:@selector(showAudioLayout:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *picButton = [[UIButton alloc]init];
    [picButton setImage:[UIImage imageNamed:@"ic_photo"] forState:UIControlStateNormal];
    [picButton sizeToFit];
    picButton.myLeft=picButton.myRight=23;
    [picButton addTarget:self action:@selector(pickPicture:) forControlEvents:UIControlEventTouchUpInside];
    //ic_video_attach
    UIButton *videoBtn = [[UIButton alloc]init];
    [videoBtn setImage:[UIImage imageNamed:@"ic_video_attach"] forState:UIControlStateNormal];
    [videoBtn sizeToFit];
    videoBtn.myRight=23;
    [videoBtn addTarget:self action:@selector(pickPicture:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *urlButton = [[UIButton alloc]init];
    [urlButton setImage:[UIImage imageNamed:@"ic_web_url"] forState:UIControlStateNormal];
    [urlButton sizeToFit];
    [urlButton addTarget:self action:@selector(showUrlShareDialog:) forControlEvents:UIControlEventTouchUpInside];
    
    [attachLayout addSubview:audioButton];
    [attachLayout addSubview:picButton];
    [attachLayout addSubview:videoBtn];
    [attachLayout addSubview:urlButton];
    
    [_rootLayout addSubview:attachLayout];
    [_rootLayout addSubview: [self needDivideView]];
    
    MyRelativeLayout *parentLayout = [MyRelativeLayout new];
    parentLayout.frame =CGRectMake(0, 0, ScreenWidth, 66);
    parentLayout.myLeft=parentLayout.myRight=18;
    UILabel *parentLabel =[self createLabel:@"仅家长可见"];
    
    _parentSwitch = [[UISwitch alloc]init];
    [_parentSwitch sizeToFit];
    _parentSwitch.myCenterY=0;
    _parentSwitch.rightPos.equalTo(parentLayout.rightPos);
    [parentLayout addSubview:parentLabel];
    [parentLayout addSubview:_parentSwitch];
    
    MyRelativeLayout *deadlineLayout = [MyRelativeLayout new];
    deadlineLayout.frame =CGRectMake(0, 0, ScreenWidth, 66);
    deadlineLayout.myLeft=deadlineLayout.myRight=18;
    UILabel *feedbackLabel =[self createLabel:@"截止时间"];
    
    _deadLineLabel = [[UILabel alloc]init];
    [_deadLineLabel setText:@"2099-00-00  00:00"];
    [_deadLineLabel setFont:[CFTool font:14]];
    [_deadLineLabel sizeToFit];
    _deadLineLabel.myCenterY=0;
    _deadLineLabel.rightPos.equalTo(deadlineLayout.rightPos);
    [deadlineLayout addSubview:feedbackLabel];
    [deadlineLayout addSubview:_deadLineLabel];
    [self dateChange:nil];//设定一下时间
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showDatePicker:)];
    [deadlineLayout addGestureRecognizer:tapGesture];
    [_rootLayout addSubview:parentLayout];
    [_rootLayout addSubview:[self needDivideView]];
    [_rootLayout addSubview:deadlineLayout];
    [_rootLayout addSubview:[self needDivideView]];
    
    UILabel *lastTip = [[UILabel alloc]init];;
    lastTip.text = @"常用于重要通知，家长需在APP或微信确认已阅";
    lastTip.font = [CFTool font:13];
    lastTip.textColor = [UIColor myColorWithHexString:@"#FFB3B3B3"];
    lastTip.myTop=5;
    lastTip.myLeft=18;
    [lastTip sizeToFit];
    [_rootLayout addSubview:lastTip];
}

#pragma mark 初始化附件布局界面
-(void)initMedialayout
{
    _audioLayout = [MyRelativeLayout new];
    _audioLayout.frame=CGRectMake(0, 0, ScreenWidth, 54);
    _audioButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_audioButton setBackgroundImage:[UIImage imageNamed:@"bg_audio_record"] forState:UIControlStateNormal];
    [_audioButton setTitle:@"58“" forState:UIControlStateNormal];
    [_audioButton setTitleColor:[UIColor myColorWithHexString:@"#028CC3"] forState:UIControlStateNormal];
    _audioButton.frame = CGRectMake(20,8,163,39);
    _audioButton.myLeft=18;
    _audioButton.myBottom=8;
    [_audioLayout addSubview:_audioButton];
    _closeAudioButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [_closeAudioButton setBackgroundImage:[UIImage imageNamed:@"ic_white_round_close"] forState:UIControlStateNormal];
    _closeAudioButton.frame = CGRectMake(0,0,20,20);
    _closeAudioButton.topPos.equalTo(_audioButton.topPos).offset(-10);
    _closeAudioButton.leftPos.equalTo(_audioButton.rightPos).offset(-10);
    [_closeAudioButton addTarget:self action:@selector(closeAudioView:) forControlEvents:UIControlEventTouchUpInside];
    [_audioLayout addSubview:_closeAudioButton];
    [_audioLayout setHidden:YES];
    [_rootLayout addSubview:_audioLayout];
    
    _picList = [[NSMutableArray alloc]init];
    _selectAssets = [[NSMutableArray alloc]init];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 4;
    layout.minimumInteritemSpacing = 4;
    
    _picCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth,118) collectionViewLayout:layout];
    _picCollectionView.delegate = self;
    _picCollectionView.dataSource = self;
    _picCollectionView.backgroundColor = [UIColor whiteColor];
    _picCollectionView.allowsMultipleSelection = YES;
    _picCollectionView.alwaysBounceHorizontal = YES;
    _picCollectionView.myLeft=_picCollectionView.myRight=18;
     [_picCollectionView registerClass:[PhotoCell class] forCellWithReuseIdentifier:cellID];
    [_rootLayout addSubview:_picCollectionView];
    _picCollectionView.hidden=YES;
    
    _urlLayout = [MyRelativeLayout new];
    _urlLayout.frame = CGRectMake(0, 0, ScreenWidth, 56);
//    _urlLayout.backgroundColor=[UIColor myColorWithHexString:@"#FFEBEBEB"];
//    _urlLayout.myLeft=_urlLayout.myRight=18;
    UIView *urlBg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 56)];
    urlBg.myLeft=urlBg.myRight=18;
    urlBg.backgroundColor=[UIColor myColorWithHexString:@"#FFEBEBEB"];
    
    _urlImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 45, 45)];
    _urlImage.myCenterY=0;
    _urlImage.leftPos.equalTo(urlBg.leftPos).offset(4);
    
    _urlTitleLabel= [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth-100, 46)];
    _urlTitleLabel.myCenterY=0;
    _urlTitleLabel.leftPos.equalTo(_urlImage.rightPos).offset(10);
    _urlTitleLabel.rightPos.equalTo(_urlLayout.rightPos).offset(-10);
    
    UIButton *closeUrlBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [closeUrlBtn setBackgroundImage:[UIImage imageNamed:@"ic_white_round_close"] forState:UIControlStateNormal];
    closeUrlBtn.frame = CGRectMake(0,0,20,20);
    closeUrlBtn.topPos.equalTo(_urlLayout.topPos).offset(-10);
    closeUrlBtn.leftPos.equalTo(urlBg.rightPos).offset(-10);
    [closeUrlBtn addTarget:self action:@selector(closeUrlClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [_urlLayout addSubview:urlBg];
    [_urlLayout addSubview:_urlImage];
    [_urlLayout addSubview:_urlTitleLabel];
    [_urlLayout addSubview:closeUrlBtn];
    _urlLayout.hidden=YES;
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showWebViewWithUrl:)];
    [_urlLayout addGestureRecognizer:tapGesture];
    
    [_rootLayout addSubview:_urlLayout];
}

#pragma mark 创建分割线
-(UIView *)needDivideView
{
    UIView *divideView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth-36, 1)];
    divideView.backgroundColor = [UIColor myColorWithHexString:@"#FFE6E6E6"];
    divideView.myTop=3;
    divideView.myLeft=divideView.myRight=18;
    return divideView;
}
-(UILabel *)createLabel:(NSString *)text
{
    UILabel *label = [[UILabel alloc]init];
    label.font = [CFTool font:17];
    label.textColor = [UIColor myColorWithHexString:@"#666666"];
    label.text=text;
    label.myCenterY=0;
    [label sizeToFit];
    return label;
}

#pragma mark 初始化日期时间选择控件
- (void)initDatePicker {
    
    self.datePicker = [[UIDatePicker alloc] init];
    self.datePicker.backgroundColor = [UIColor whiteColor];
    //设置地区: zh-中国
    self.datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
    
    //设置日期模式(Displays month, day, and year depending on the locale setting)
    self.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    // 设置当前显示时间
    [self.datePicker setDate:[NSDate date] animated:YES];
    // 设置显示最大时间（90d）
    NSDate *today = [NSDate dateWithTimeIntervalSinceNow:7776000];
    
    [self.datePicker setMaximumDate:today];
    
    //设置时间格式
    
    //监听DataPicker的滚动
    [self.datePicker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
}

- (void)dateChange:(UIDatePicker *)datePicker {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //设置时间格式
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    NSString *dateStr = [formatter  stringFromDate:datePicker.date];
    
    self.deadLineLabel.text = dateStr;
}

- (void)deletedPhoto:(UIImage *)image
{
    [_picList removeObject:image];
    [_picCollectionView reloadData];
    if (_picList.count==0) {
        _picCollectionView.hidden=YES;
    }
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
    return _picList.count;
}
/**
 创建cell
 */
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PhotoCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.mainImageView.image = _picList[indexPath.row];

    cell.delegate=self;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // preview photos or video / 预览照片或者视频
    PHAsset *asset = _selectAssets[indexPath.item];
    BOOL isVideo = NO;
    isVideo = asset.mediaType == PHAssetMediaTypeVideo;
    if ([[asset valueForKey:@"filename"] containsString:@"GIF"]) {
        TZGifPhotoPreviewController *vc = [[TZGifPhotoPreviewController alloc] init];
        TZAssetModel *model = [TZAssetModel modelWithAsset:asset type:TZAssetModelMediaTypePhotoGif timeLength:@""];
        vc.model = model;
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:vc animated:YES completion:nil];
    } else if (isVideo) { // perview video / 预览视频
        TZVideoPlayerController *vc = [[TZVideoPlayerController alloc] init];
        TZAssetModel *model = [TZAssetModel modelWithAsset:asset type:TZAssetModelMediaTypeVideo timeLength:@""];
        vc.model = model;
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:vc animated:YES completion:nil];
    } else { // preview photos / 预览照片
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithSelectedAssets:_selectAssets selectedPhotos:_picList index:indexPath.item];
        imagePickerVc.maxImagesCount = 9;
        imagePickerVc.allowPickingGif = YES;
        imagePickerVc.allowPickingOriginalPhoto = YES;
        imagePickerVc.allowPickingMultipleVideo =YES;
        imagePickerVc.showSelectedIndex = YES;
        imagePickerVc.isSelectOriginalPhoto = YES;
        imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
                self.picList = [NSMutableArray arrayWithArray:photos];
                self.selectAssets = [NSMutableArray arrayWithArray:assets];
                self.picCollectionView.hidden=NO;
                [self.picCollectionView reloadData];
        }];
        [self presentViewController:imagePickerVc animated:YES completion:nil];
    }
}


/**
 cell的大小
 */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat itemW = 114;
    CGFloat itemH = 110;
    return CGSizeMake(itemW, itemH);
}
#pragma mark 选择图片
-(void)pickPicture:(id)sender
{
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
//       PHAsset *asset
        self.picList = [NSMutableArray arrayWithArray:photos];
        self.selectAssets = [NSMutableArray arrayWithArray:assets];
        self.picCollectionView.hidden=NO;
        [self.picCollectionView reloadData];
    }];
    [imagePickerVc setDidFinishPickingVideoHandle:^(UIImage *coverImage, PHAsset *asset) {
        [self.picList addObject:coverImage];
        [self.selectAssets addObject:asset];
        self.picCollectionView.hidden=NO;
        [self.picCollectionView reloadData];
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
    
}


#pragma mark 显示录音界面
-(void)showAudioLayout:(id)sender
{

    RecorderView *alertView = [[RecorderView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [alertView showAlert];
    alertView.delegate =self;
}

#pragma mark 录音回调
-(void)recordOver:(NSString *)filePath duration:(NSString *)duration
{
    NSLog(@"duration= %@",duration);
    [_audioButton setTitle:duration forState:UIControlStateNormal];
    [_audioButton addTarget:self action:@selector(playAudio:) forControlEvents:UIControlEventTouchUpInside];
    [_audioLayout setHidden:NO];
    self.audioPath = filePath;
}
#pragma mark 播放音频
-(void)playAudio:(id)sender
{
    _playerHelper = [XHAudioPlayerHelper shareInstance];
    [_playerHelper managerAudioWithFileName:self.audioPath toPlay:YES];
}
#pragma mark 显示输入超链接对话框
-(void)showUrlShareDialog:(id)sender
{
    MMPopupCompletionBlock completeBlock = ^(MMPopupView *popupView, BOOL finished){
            NSLog(@"showUrlShareDialog complete");
        };
        
    MMAlertView *urlInputDialog = [[MMAlertView alloc] initWithInputTitle:@"添加链接" detail:nil placeholder:@"请输入链接地址" handler:^(NSString *textInput) {
        NSLog(@"input:%@",textInput);
        [self.urlTitleLabel setText:textInput];
        self.urlInput = textInput;
        [self.urlImage setImage:[UIImage imageNamed:@"head_boy"]];
        self.urlLayout.hidden=NO;
    }];
    
    [urlInputDialog.editView setKeyboardType:UIKeyboardTypeURL];
    [urlInputDialog showWithBlock:completeBlock];
    
}

#pragma mark 打开webview
-(void)showWebViewWithUrl:(id)sender
{
    if(![self.urlInput hasPrefix:@"http"]){
        self.urlInput = [NSString stringWithFormat:@"https://%@",self.urlInput ];
    }
    
    RxWebViewController* webViewController = [[RxWebViewController alloc] initWithUrl:[NSURL URLWithString:self.urlInput]];
    
    [self presentViewController:webViewController animated:YES completion:nil];
    webViewController.zbWebviewLoadDelegate = self;
//    [self.navigationController pushViewController:webViewController animated:YES];
}
#pragma mark 获取到标题和icon
- (void)didLoadDoneWithTitle:(NSString *)title icon:(NSString *)iconUrl
{
    NSLog(@"title=%@,icon=%@",title,iconUrl);
    [_urlTitleLabel setText:title];
    [_urlImage sd_setImageWithURL:[NSURL URLWithString:iconUrl] placeholderImage:[UIImage imageNamed:@"ic_web_url"]];
}

#pragma mark 选择时间
-(void)showDatePicker:(id)sender
{
    BOOL isContain = NO;
    for (UIView *view in [self.rootLayout subviews]) {
        if([view isKindOfClass:[UIDatePicker class]])
        {
            isContain = YES;
        }
    }
    
    if(isContain){
        [self.datePicker removeFromSuperview];
        [self.datePicker setHidden:YES];
    }else{
        [self.rootLayout addSubview:self.datePicker];
         [self.datePicker setHidden:NO];
    }

}

#pragma mark 隐藏音频
-(void)closeAudioView:(id)sender
{
    _audioLayout.hidden=YES;
    [_playerHelper stopAudio];
}

#pragma mark 隐藏超链接
-(void)closeUrlClick:(id)sender
{
    _urlLayout.hidden=YES;
}



#pragma mark 退出
-(void)finishVC:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)postToServer:(id)sender
{
    
}
@end
