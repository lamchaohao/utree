//
//  PostNoticeVC.m
//  utree
//
//  Created by 科研部 on 2019/9/27.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "PostNoticeVC.h"
#import "RegexTool.h"
#import "UITextView+ZBPlaceHolder.h"
#import "PhotoCell.h"
#import "JhDownProgressView.h"
#import "MMAlertView.h"
#import "RecorderView.h"
#import "XHAudioPlayerHelper.h"
#import "TZImagePickerController.h"
#import "EditGroupVC.h"
#import "PostNoticeDC.h"
#import "FileObject.h"
#import "SelectReadClassVC.h"
#import "RxWebViewController.h"
@interface PostNoticeVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UINavigationControllerDelegate,DeletePicDelegate,RecorderViewDelegate,TZImagePickerControllerDelegate,UploadFileListener,ZBWebviewLoadedDelegate>
@property(nonatomic,strong)MyLinearLayout *rootLayout;
@property(nonatomic,strong)UISwitch *parentSwitch;
@property(nonatomic,strong)UISwitch *needFeedbackSwitch;
@property(nonatomic,strong)MyRelativeLayout *audioLayout;
@property(nonatomic,strong)UIButton *audioButton;
@property(nonatomic,strong)UIButton *closeAudioButton;

@property(nonatomic,strong)UICollectionView *picCollectionView;
@property(nonatomic,strong)UIButton *webButton;
@property(nonatomic,strong)JhDownProgressView *progressView;

@property(nonatomic,strong)MyRelativeLayout *urlLayout;
@property(nonatomic,strong)NSString *audioPath;
@property(nonatomic,strong)UITextField *titleInput;
@property(nonatomic,strong)UITextView *contentInput;
@property(nonatomic,strong)UIScrollView *scrollView;

@property(nonatomic,strong)PostNoticeDC *dataController;
@property(nonatomic,strong)NSMutableArray *picList;
@property(nonatomic,strong)NSMutableArray *assetsList;

@property(nonatomic,strong)NSMutableDictionary *uploadQueue;
@property(nonatomic,strong)NSMutableArray *uploadPicObjecList;
@property(nonatomic,strong)FileObject *audioFileObject;
@property(nonatomic,strong)NSString *urlInput;
@property(nonatomic,strong)NSArray *classArray;
@end

@implementation PostNoticeVC
static NSString *cellID = @"photoCell";

- (instancetype)initWithClassArray:(NSArray *)classes
{
    self = [super init];
    if (self) {
        self.classArray = classes;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishVC:) name:PostWorkNotifyName object:nil];
    self.picList = [[NSMutableArray alloc]init];
    self.dataController = [[PostNoticeDC alloc]init];
    [self initNaviBar];
    [self initMainLayout];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PostWorkNotifyName object:nil];
}

-(void)initNaviBar
{
    self.scrollView = [UIScrollView new];
    _scrollView.frame = CGRectMake(0, iPhone_Top_NavH, ScreenWidth, ScreenHeight);
    [self setScrollViewTap];
    [self.view addSubview:_scrollView];

    self.rootLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
    self.rootLayout.padding = UIEdgeInsetsMake(10, 0, 10, 0); //设置布局内的子视图离自己的边距.
    self.rootLayout.myHorzMargin = 0;                          //同时指定左右边距为0表示宽度和父视图一样宽
    self.rootLayout.heightSize.lBound(_scrollView.heightSize, 10, 1);
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
    [postBtn addTarget:self action:@selector(uploadFileToOSS:) forControlEvents:UIControlEventTouchUpInside];
    postBtn.myTop=0;
    postBtn.myRight=18;
    postBtn.myCenterY=0;
    
    
    [navBarLayout addSubview:closeButton];
    [navBarLayout addSubview:navTitle];
    [navBarLayout addSubview:postBtn];
    [self.view addSubview:navBarLayout];
    
    [self.scrollView addSubview:self.rootLayout];
}

-(void)initMainLayout
{
    self.titleInput = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth-80, 48)];
    self.titleInput.borderStyle=UITextBorderStyleNone;
    [self.titleInput setPlaceholder:@"请输入通知标题"];
    self.titleInput.myLeft=self.titleInput.myRight=18;
    
    
    self.contentInput = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth-40, 120)];
    [self.contentInput setPlaceholder:@"请输入通知内容"];
    self.contentInput.myLeft=self.contentInput.myRight=18;
    
    [_rootLayout addSubview:self.titleInput];
    [_rootLayout addSubview: [self needDivideView]];
    [_rootLayout addSubview:self.contentInput];
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
    
//    _picList = [[NSMutableArray alloc]init];
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
    _urlLayout.frame = CGRectMake(18, 0, ScreenWidth, 70);
    _urlLayout.myLeft=_urlLayout.myRight=18;
    self.webButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth-50, 56)];
    self.webButton.backgroundColor = [UIColor myColorWithHexString:@"#FFEBEBEB"];
    [self.webButton setImage:[UIImage imageNamed:@"ic_link"] forState:UIControlStateNormal];
    self.webButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;//居左显示
    self.webButton.titleLabel.numberOfLines=0;
    [self.webButton setTitleColor:[UIColor myColorWithHexString:@"#4D4D4D"] forState:UIControlStateNormal];
    [self.webButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [self.webButton setImageEdgeInsets:UIEdgeInsetsMake(0, 12, 0, 0)];
    [self.webButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 25, 0, 0)];
    [self.webButton addTarget:self action:@selector(showWebViewWithUrl:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *closeUrlBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [closeUrlBtn setBackgroundImage:[UIImage imageNamed:@"ic_white_round_close"] forState:UIControlStateNormal];
    closeUrlBtn.frame = CGRectMake(0,0,20,20);
    closeUrlBtn.topPos.equalTo(_urlLayout.topPos).offset(-10);
    closeUrlBtn.leftPos.equalTo(_webButton.rightPos).offset(-10);
    [closeUrlBtn addTarget:self action:@selector(closeUrlClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [_urlLayout addSubview:_webButton];
    [_urlLayout addSubview:closeUrlBtn];
    _urlLayout.hidden=YES;
    [_rootLayout addSubview:_urlLayout];
}

-(void)setScrollViewTap{
    UITapGestureRecognizer *tapGeature = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBroad)];
    tapGeature.cancelsTouchesInView = NO;//设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    [_scrollView addGestureRecognizer:tapGeature];
}
- (void)hideKeyBroad
{
    [self.view endEditing:YES];
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

- (void)deletedPhotoWithImage:(UIImage *)image index:(NSInteger)index
{
    [_picList removeObject:image];
    [_assetsList removeObjectAtIndex:index];
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
    UIImage *image =[_picList objectAtIndex:indexPath.row];
    [cell setImageData:image index:indexPath.row];
    cell.delegate=self;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // preview photos or video / 预览照片或者视频
    PHAsset *asset = _assetsList[indexPath.item];
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
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithSelectedAssets:_assetsList selectedPhotos:_picList index:indexPath.item];
        imagePickerVc.maxImagesCount = 9;
        imagePickerVc.allowPickingGif = YES;
        imagePickerVc.allowPickingOriginalPhoto = YES;
        imagePickerVc.allowPickingMultipleVideo =YES;
        imagePickerVc.showSelectedIndex = YES;
        imagePickerVc.isSelectOriginalPhoto = YES;
        imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            
                self.picList = [NSMutableArray arrayWithArray:photos];
                self.assetsList = [NSMutableArray arrayWithArray:assets];
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

-(void)pickPicture:(id)sender
{

    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
    imagePickerVc.allowPickingVideo=NO;
    imagePickerVc.allowTakeVideo=NO;
    imagePickerVc.selectedAssets=self.assetsList;
    // You can get the photos by block, the same as by delegate.
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}


- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto
{
    
    self.picList = [NSMutableArray arrayWithArray:photos];
    self.assetsList = [NSMutableArray arrayWithArray:assets];
    self.picCollectionView.hidden=NO;
    [self.picCollectionView reloadData];
}




-(void)showAudioLayout:(id)sender
{
        
    RecorderView *alertView = [[RecorderView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];

    [alertView showAlert];
    alertView.delegate =self;
    
}

-(void)recordOver:(NSString *)filePath duration:(NSString *)duration
{    
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
        [self.webButton setTitle:textInput forState:UIControlStateNormal];
        self.urlInput =textInput;
        if(![self.urlInput hasPrefix:@"http"]){
            self.urlInput = [NSString stringWithFormat:@"http://%@",self.urlInput];
           }
        
        if(![RegexTool checkURL:self.urlInput]) {
            self.urlLayout.hidden=NO;
        }else{
            [self.view makeToast:@"链接不可用"];
        }
        
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

-(void)uploadFileToOSS:(id)sender
{
    self.dataController.uploadListener = self;
    self.uploadQueue = [[NSMutableDictionary alloc]init];
    self.uploadPicObjecList= [[NSMutableArray alloc]init];

    for (int index=0; index<self.picList.count; index++) {
        PHAsset *asset = [self.assetsList objectAtIndex:index];
        NSString *fileName = [asset valueForKey:@"filename"];
        NSLog(@"fileName = %@",fileName);
        UIImage *image = [self.picList objectAtIndex:index];
        FileObject *uploadPicObject = [[FileObject alloc]init];
        uploadPicObject.fileKind=[NSNumber numberWithInt:10];
        uploadPicObject.fileName =fileName;
        uploadPicObject.fileType=[fileName pathExtension];
        [self.uploadPicObjecList addObject:uploadPicObject];
        [self.uploadQueue setObject:uploadPicObject.fileName forKey:[NSString stringWithFormat:@"%d",index]];
//        [self.view makeToastActivity:CSToastPositionCenter];
        [self onStartUploadView];
        [self.dataController uploadFileData:[image sd_imageData] fileName:fileName mediaType:@"pic" fileIndex:index];
    }
    if (self.audioPath) {
        self.audioFileObject = [[FileObject alloc]init];
        self.audioFileObject.fileKind=[NSNumber numberWithInt:10];
        self.audioFileObject.fileName =[[self.audioPath lastPathComponent] stringByDeletingPathExtension];
        self.audioFileObject.fileType=[self.audioPath pathExtension];
//        [self.view makeToastActivity:CSToastPositionCenter];
        [self onStartUploadView];
        [self.uploadQueue setObject:self.audioFileObject.fileName forKey:[NSString stringWithFormat:@"%d",10]];
        [self.dataController uploadFile:self.audioPath mediaType:@"audio" fileIndex:10];
        
    }
    self.parentSwitch.on?[NSNumber numberWithInt:2]:[NSNumber numberWithInt:1];
    if (self.picList.count==0&&!self.audioPath) {
        [self checkWhenNoFile];
    }
    
}

-(void)onStartUploadView
{
    self.view.userInteractionEnabled = NO;
    self.navigationController.navigationBar.userInteractionEnabled=NO;//将nav事件禁止
    self.tabBarController.tabBar.userInteractionEnabled=NO;//将tabbar事件禁止
    if(!self.progressView){
        self.progressView = [JhDownProgressView showWithStyle:JhStyle_percentAndRing];
        self.progressView.center = self.view.center;
        [self.view addSubview:self.progressView];
    }
    
    
}

-(void)onUploadDoneView
{
    self.view.userInteractionEnabled = YES;
    self.navigationController.navigationBar.userInteractionEnabled=YES;
    self.tabBarController.tabBar.userInteractionEnabled=YES;
    [self.progressView removeFromSuperview];
}

- (void)onFileUploadResult:(BOOL)success filePath:(NSString *)filePath fileIndex:(NSInteger)index md5Value:(NSString *)md5Str
{
    if (success) {
       if (index<9) {
           FileObject *fileObj = [self.uploadPicObjecList objectAtIndex:index];
           fileObj.path = filePath;
           fileObj.fileMD5=md5Str;
       }else{
           self.audioFileObject.path=filePath;
           self.audioFileObject.fileMD5=md5Str;
       }
        
        
        [self.uploadQueue removeObjectForKey:[NSString stringWithFormat:@"%d",(int)index]];
       if (self.uploadQueue.count==0) {
//           [self.view hideToastActivity];
           [self onUploadDoneView];
           [self checkWhenNoFile];
       }

    }else{
//           [self.view hideToastActivity];
           [self onUploadDoneView];
           [self showToastView:@"上传文件失败,请重试"];
           NSLog(@"上传失败 %@",filePath);
       }
}

- (void)onFileUploadProgress:(CGFloat)progress filePath:(NSString *)filePath fileIndex:(NSInteger)index
{
    NSLog(@"PostNotice onFileUploadProgress---%f",progress);
    if (self.progressView) {
        [self.progressView setProgress:progress];
    }
}

#pragma mark 无图片和音频时候，检查是否有文字和链接
-(void)checkWhenNoFile
{
    if(self.titleInput.text.length<=0){
        [self.view makeToast:@"标题不能为空"];
    }else if(self.contentInput.text.length<=0){
        [self.view makeToast:@"通知详情还没写"];
    }else{
        [self publishNotice];
    }
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
    if (![self isBlankString:title]) {
        [self.webButton setTitle:title forState:UIControlStateNormal];
    }
    
    if(![iconUrl hasPrefix:@"http"]){
        iconUrl = [NSString stringWithFormat:@"http://%@",iconUrl];
    }
    
    [self.webButton sd_setImageWithURL:[NSURL URLWithString:iconUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"ic_web_url"]];
}


-(void)publishNotice
{
    NSMutableDictionary *enclosureDic = [[NSMutableDictionary alloc]init];
    if (self.uploadPicObjecList.count>0) {
        [enclosureDic setObject:self.uploadPicObjecList forKey:@"pics"];
    }
    if(self.audioFileObject)
        [enclosureDic setObject:self.audioFileObject forKey:@"audio"];
    if (![self isBlankString:self.urlInput]) {
        [enclosureDic setObject:self.urlInput forKey:@"link"];
    }
    [enclosureDic setObject:self.titleInput.text forKey:@"title"];
    [enclosureDic setObject:self.contentInput.text forKey:@"content"];

    [enclosureDic setObject:self.parentSwitch.on?[NSNumber numberWithInt:2]:[NSNumber numberWithInt:1] forKey:@"readType"];
    [enclosureDic setObject:@(self.needFeedbackSwitch.on) forKey:@"needReceipt"];
    
    [enclosureDic setObject:self.classArray forKey:@"classIds"];
    [self.dataController publishNoticeToServerWithTopic:self.titleInput.text content:self.contentInput.text enclosureDic:enclosureDic WithSuccess:^(UTResult * _Nonnull result) {
        [self showToastView:@"发布成功"];
        [self dismissViewControllerAnimated:YES completion:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:PostWorkNotifyName object:nil];
        }];
    } failure:^(UTResult * _Nonnull result) {
        
        [self showAlertMessage:@"错误" title:result.failureResult];
    }];
    
    
//    SelectReadClassVC *readClassVC = [[SelectReadClassVC alloc]initWithParams:enclosureDic];
//    readClassVC.modalPresentationStyle = UIModalPresentationFullScreen;
//
//    [self presentViewController:readClassVC animated:YES completion:^{
////        [self dismissViewControllerAnimated:NO completion:nil];
//    }];
    
}


@end
