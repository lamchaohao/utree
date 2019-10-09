//
//  PostNoticeVC.m
//  utree
//
//  Created by 科研部 on 2019/9/27.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "PostNoticeVC.h"
#import "UITextView+ZBPlaceHolder.h"
#import "PhotoCell.h"
#import "MMAlertView.h"
#import "RecorderView.h"
#import "XHAudioPlayerHelper.h"

@interface PostNoticeVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate,DeletePicDelegate,RecorderViewDelegate>
@property(nonatomic,strong)MyLinearLayout *rootLayout;
@property(nonatomic,strong)UISwitch *parentSwitch;
@property(nonatomic,strong)UISwitch *needFeedbackSwitch;
@property(nonatomic,strong)MyRelativeLayout *audioLayout;
@property(nonatomic,strong)UIButton *audioButton;
@property(nonatomic,strong)UIButton *closeAudioButton;

@property(nonatomic,strong)UICollectionView *picCollectionView;
@property(nonatomic,strong)NSMutableArray *picList;
@property(nonatomic,strong)UIImageView *urlImage;
@property(nonatomic,strong)UILabel *urlTitleLabel;
@property(nonatomic,strong)MyRelativeLayout *urlLayout;
@property(nonatomic,strong)NSString *audioPath;
@end

@implementation PostNoticeVC
static NSString *cellID = @"photoCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNaviBar];
    [self initMainLayout];
}

-(void)initNaviBar
{
    UIScrollView *scrollView = [UIScrollView new];
    scrollView.frame = CGRectMake(0, 64, ScreenWidth, ScreenHeight);
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
    navTitle.text=@"发布通知";
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

-(void)initMainLayout
{
    UITextField *titleInput = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth-80, 48)];
    titleInput.borderStyle=UITextBorderStyleNone;
    [titleInput setPlaceholder:@"请输入通知标题"];
    titleInput.myLeft=titleInput.myRight=18;
    
    
    UITextView *contentInput = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth-40, 120)];
    [contentInput setPlaceholder:@"请输入通知内容"];
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
    
    UIButton *urlButton = [[UIButton alloc]init];
    [urlButton setImage:[UIImage imageNamed:@"ic_web_url"] forState:UIControlStateNormal];
    [urlButton sizeToFit];
    [urlButton addTarget:self action:@selector(showUrlShareDialog:) forControlEvents:UIControlEventTouchUpInside];
    
    [attachLayout addSubview:audioButton];
    [attachLayout addSubview:picButton];
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
    
    MyRelativeLayout *feedbackLayout = [MyRelativeLayout new];
    feedbackLayout.frame =CGRectMake(0, 0, ScreenWidth, 66);
    feedbackLayout.myLeft=feedbackLayout.myRight=18;
    UILabel *feedbackLabel =[self createLabel:@"需家长发送电子回执"];
    
    _needFeedbackSwitch = [[UISwitch alloc]init];
    [_needFeedbackSwitch sizeToFit];
    _needFeedbackSwitch.myCenterY=0;
    _needFeedbackSwitch.rightPos.equalTo(feedbackLayout.rightPos);
    [feedbackLayout addSubview:feedbackLabel];
    [feedbackLayout addSubview:_needFeedbackSwitch];
    
    [_rootLayout addSubview:parentLayout];
    [_rootLayout addSubview:[self needDivideView]];
    [_rootLayout addSubview:feedbackLayout];
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
    
    _urlTitleLabel= [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth-55, 46)];
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
    [_rootLayout addSubview:_urlLayout];
}


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

/**
 cell的大小
 */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat itemW = 114;
    CGFloat itemH = 110;
    return CGSizeMake(itemW, itemH);
}

-(void)pickPicture:(id)sender
{
    UIImagePickerController *vc = [[UIImagePickerController alloc] init];
    vc.delegate = self;
    vc.allowsEditing = YES;
    vc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:vc animated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];

    NSData *imageData = UIImageJPEGRepresentation(image, 0.5f);
    if (imageData.length/1024 > 1024*20)
    {
//        mAlertView(@"温馨提示", @"请重新选择一张不超过20M的图片");
    }
    else
    {
//        _imageType = [NSData typeForImageData:imageData];
//        _imageBase64 = [imageData base64EncodedString];
        [_picList addObject:image];
        _picCollectionView.hidden=NO;
        [_picCollectionView reloadData];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];

}

-(void)showAudioLayout:(id)sender
{
//    MMPopupCompletionBlock completeBlock = ^(MMPopupView *popupView, BOOL finished){
//            NSLog(@"showAudioLayout complete");
//        };
        
    RecorderView *alertView = [[RecorderView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
//    [alertView showWithBlock:completeBlock];
    [alertView showAlert];
    alertView.delegate =self;
    
//    [self.view addSubview:alertView];
}

-(void)recordOver:(NSString *)filePath duration:(NSString *)duration
{
    NSLog(@"duration= %@",duration);
    [_audioButton setTitle:duration forState:UIControlStateNormal];
    [_audioButton addTarget:self action:@selector(playAudio:) forControlEvents:UIControlEventTouchUpInside];
    [_audioLayout setHidden:NO];
    self.audioPath = filePath;
}

-(void)playAudio:(id)sender
{
    XHAudioPlayerHelper *playerHelper = [XHAudioPlayerHelper shareInstance];
    [playerHelper managerAudioWithFileName:self.audioPath toPlay:YES];
}

-(void)showUrlShareDialog:(id)sender
{
    MMPopupCompletionBlock completeBlock = ^(MMPopupView *popupView, BOOL finished){
            NSLog(@"showUrlShareDialog complete");
        };
        
    MMAlertView *alertView = [[MMAlertView alloc] initWithInputTitle:@"添加链接" detail:nil placeholder:@"请输入链接地址" handler:^(NSString *textInput) {
        NSLog(@"input:%@",textInput);
        [self.urlTitleLabel setText:textInput];
        [self.urlImage setImage:[UIImage imageNamed:@"head_boy"]];
        self.urlLayout.hidden=NO;
    }];
    [alertView showWithBlock:completeBlock];
    
    
}

-(void)closeAudioView:(id)sender
{
    _audioLayout.hidden=YES;
    
}


-(void)closeUrlClick:(id)sender
{
    _urlLayout.hidden=YES;
}

-(void)finishVC:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)postToServer:(id)sender
{
    
}

@end
