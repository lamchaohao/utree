//
//  PostMomentVC.m
//  utree
//
//  Created by 科研部 on 2019/10/14.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "PostMomentVC.h"
#import "UITextView+ZBPlaceHolder.h"
#import "PhotoCell.h"
#import "TZImagePickerController.h"
#import "MomentDC.h"
#import "FileObject.h"
#import "JhDownProgressView.h"
@interface PostMomentVC ()<UICollectionViewDelegate,UICollectionViewDataSource,DeletePicDelegate,TZImagePickerControllerDelegate,UploadFileListener>
@property(nonatomic,strong)MyLinearLayout *rootLayout;
@property(nonatomic,strong)UICollectionView *picCollectionView;
@property(nonatomic,strong)NSMutableArray *picList;
@property(nonatomic,strong)NSMutableArray *selectAssets;
@property(nonatomic,strong)MomentDC *dataController;
@property(nonatomic,strong)UITextView *contentInput;
@property(nonatomic,strong)NSMutableArray *uploadPicObjecList;
@property(nonatomic,strong)NSMutableDictionary *uploadQueue;
@property(nonatomic,strong)FileObject *videoObject;
@property(nonatomic,strong)NSString *momentText;
@property(nonatomic,strong)JhDownProgressView *progressView;
@end

@implementation PostMomentVC
static NSString *cellID=@"photoCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"发布班级圈";
    self.dataController = [[MomentDC alloc]init];
    [self initView];
    [self createMediaLayout];
    
}

-(void)initView
{

//    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(publishMoment:)];
    UIBarButtonItem *barButtonItem =[[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(publishMoment:)];
    self.navigationItem.rightBarButtonItem = barButtonItem;
    self.showNavigationBarImageWhenDisappear = YES;
    _rootLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
    self.rootLayout.frame=self.view.frame;
    self.rootLayout.padding = UIEdgeInsetsMake(10, 0, 10, 0); //设置布局内的子视图离自己的边距.
    self.rootLayout.myHorzMargin = 0;
    [self.view addSubview:_rootLayout];
}


-(void)createMediaLayout
{
    self.contentInput = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth-40, 220)];
    [self.contentInput setPlaceholder:@"记录孩子的每一刻"];
    self.contentInput.myLeft=_contentInput.myRight=18;
    
    [_rootLayout addSubview:self.contentInput];
    [self createPhotoLayout];
    
    MyLinearLayout *attachLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Horz];
    attachLayout.frame =CGRectMake(0, 0, ScreenWidth, 30);
    attachLayout.myTop=5;
    attachLayout.myLeft=18;
    attachLayout.myBottom=3;
    
    UIButton *picButton = [[UIButton alloc]init];
    [picButton setImage:[UIImage imageNamed:@"ic_photo"] forState:UIControlStateNormal];
    [picButton sizeToFit];
    picButton.myRight=23;
    [picButton addTarget:self action:@selector(pickPicture:) forControlEvents:UIControlEventTouchUpInside];
    //ic_video_attach
    UIButton *videoBtn = [[UIButton alloc]init];
    [videoBtn setImage:[UIImage imageNamed:@"ic_video_attach"] forState:UIControlStateNormal];
    [videoBtn sizeToFit];
    videoBtn.myRight=23;
    [videoBtn addTarget:self action:@selector(onPickVideoClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [attachLayout addSubview:picButton];
    [attachLayout addSubview:videoBtn];
    [_rootLayout addSubview:attachLayout];
    [_rootLayout addSubview:[self needDivideView]];
    
    UILabel *lastTip = [[UILabel alloc]init];;
    lastTip.text = @"学生端及家长端将同步收到";
    lastTip.font = [CFTool font:13];
    lastTip.textColor = [UIColor myColorWithHexString:@"#FFB3B3B3"];
    lastTip.myTop=5;
    lastTip.myLeft=18;
    [lastTip sizeToFit];
    [_rootLayout addSubview:lastTip];
    
}


#pragma mark 初始化附件布局界面
-(void)createPhotoLayout
{
    
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

- (void)viewWillAppear:(BOOL)animated
{
    self.showNavigationBarImageWhenDisappear = YES;
    [super viewWillAppear:animated];
    
}


-(void)publishMoment:(id)sender
{
    [self.contentInput resignFirstResponder];
    self.momentText =self.contentInput.text;
    if (self.momentText.length==0&&_selectAssets.count==0) {
        [self showAlertMessage:@"" title:@"请分享你心情"];
    }else{
        if (_selectAssets.count==0) {
            [self postFormToServer];
        }else{
            [self uploadFileToOSS];
        }
        
    }
    
}


- (void)deletedPhotoWithImage:(UIImage *)image index:(NSInteger)index
{
    [_picList removeObject:image];
    [_selectAssets removeObjectAtIndex:index];
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
    
    imagePickerVc.selectedAssets=self.selectAssets;
    imagePickerVc.allowPickingVideo=NO;
    imagePickerVc.allowCrop=NO;
    // You can get the photos by block, the same as by delegate.
    [self presentViewController:imagePickerVc animated:YES completion:nil];
    
}
-(void)onPickVideoClick:(id)sender
{
    TZImagePickerController *videoPickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    videoPickerVc.allowPickingVideo=YES;
    videoPickerVc.allowPickingImage=NO;
    videoPickerVc.allowCrop=NO;
    [self presentViewController:videoPickerVc animated:YES completion:nil];
}

#pragma mark 选择视频回调
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(PHAsset *)asset
{
    self.picList = [NSMutableArray arrayWithObject:coverImage];
    self.selectAssets = [NSMutableArray arrayWithObject:asset];
    self.picCollectionView.hidden=NO;
    [self.picCollectionView reloadData];
}


#pragma mark 选择图片回调
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto
{
    int videoIndex=-1;
    for (int index=0; index<self.selectAssets.count; index++) {
        PHAsset *asset = [self.selectAssets objectAtIndex:index];
        BOOL isVideo = asset.mediaType == PHAssetMediaTypeVideo;
        if (isVideo) {
            videoIndex=index;
        }
    }
    self.picList = [NSMutableArray arrayWithArray:photos];
    self.selectAssets = [NSMutableArray arrayWithArray:assets];
    if (videoIndex!=-1) {
        [self.picList removeObjectAtIndex:videoIndex];
        [self.selectAssets removeObjectAtIndex:videoIndex];
    }
    
    self.picCollectionView.hidden=NO;
    [self.picCollectionView reloadData];
}


-(void)uploadFileToOSS
{
    self.dataController.uploadListener = self;
    self.uploadQueue = [[NSMutableDictionary alloc]init];
    self.uploadPicObjecList= [[NSMutableArray alloc]init];

    for (int index=0; index<self.selectAssets.count; index++) {
        PHAsset *asset = [self.selectAssets objectAtIndex:index];
        BOOL isVideo = asset.mediaType == PHAssetMediaTypeVideo;
        if (isVideo) {
            NSString *fileName = [asset valueForKey:@"filename"];
            self.videoObject = [[FileObject alloc]init];
            self.videoObject.fileKind=[NSNumber numberWithInt:11];
            self.videoObject.fileType=[fileName pathExtension];
            self.videoObject.fileName =fileName;
            [self onStartUploadView];
//            [self.view makeToastActivity:CSToastPositionCenter];
            [self handleVideoData:asset];
        }else{
            NSString *fileName = [asset valueForKey:@"filename"];
            NSLog(@"fileName = %@",fileName);
            UIImage *image = [self.picList objectAtIndex:index];
            FileObject *uploadPicObject = [[FileObject alloc]init];
            uploadPicObject.fileKind=[NSNumber numberWithInt:11];
            uploadPicObject.fileName =fileName;
            uploadPicObject.fileType=[fileName pathExtension];
            [self.uploadPicObjecList addObject:uploadPicObject];
            [self.uploadQueue setObject:uploadPicObject.fileName forKey:[NSString stringWithFormat:@"%d",index]];
            [self onStartUploadView];
//            [self.view makeToastActivity:CSToastPositionCenter];
            [self.dataController uploadFileData:[image sd_imageData] fileName:fileName mediaType:@"pic" fileIndex:index];
        }
        
    }
    
  
}

-(void)onStartUploadView
{
    self.view.userInteractionEnabled = NO;
    self.navigationController.navigationBar.userInteractionEnabled=NO;//将nav事件禁止
    self.tabBarController.tabBar.userInteractionEnabled=NO;//将tabbar事件禁止
    if (!self.progressView) {
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
           self.videoObject.path=filePath;
           self.videoObject.fileMD5=md5Str;
       }
        [self.uploadQueue removeObjectForKey:[NSString stringWithFormat:@"%d",(int)index]];
       if (self.uploadQueue.count==0) {
           [self onUploadDoneView];
//           [self.view hideToastActivity];
           [self postFormToServer];
       }

    }else{
        [self onUploadDoneView];
//           [self.view hideToastActivity];
           [self showAlertMessage:@"" title:@"分享失败,请重试"];
           NSLog(@"上传失败 %@",filePath);
       }
}
#pragma mark 上传进度
- (void)onFileUploadProgress:(CGFloat)progress filePath:(NSString *)filePath fileIndex:(NSInteger)index
{
    NSLog(@"onFileUploadProgress---%f",progress);
    if (self.progressView) {
        [self.progressView setProgress:progress];
    }
}


-(void)postFormToServer
{
    
    if (self.selectAssets.count==0) {
        //文字
        [self.dataController postMomentWithText:_momentText WithSuccess:^(UTResult * _Nonnull result) {
            [self handleSuccess];
        } failure:^(UTResult * _Nonnull result) {
            [self handlerFailure:result.failureResult];
        }];
    }else if(self.videoObject){
        [self.dataController postMomentWith:self.momentText video:_videoObject WithSuccess:^(UTResult * _Nonnull result) {
            [self handleSuccess];
        } failure:^(UTResult * _Nonnull result) {
            [self handlerFailure:result.failureResult];
        }];
    }else{
        [self.dataController postMomentWith:_momentText pictures:self.uploadPicObjecList WithSuccess:^(UTResult * _Nonnull result) {
            [self handleSuccess];
        } failure:^(UTResult * _Nonnull result) {
            [self handlerFailure:result.failureResult];
        }];
    }
   
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.contentInput resignFirstResponder];
}

-(void)handleSuccess
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                //需要在主线程执行的代码
        if([self.callback respondsToSelector:@selector(onPostSuccess)]){
            [self.callback onPostSuccess];
        }
        [self showToastView:@"分享成功"];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
}

-(void)handlerFailure:(id)msg
{
    [self showAlertMessage:@"" title:msg];
}

-(void)handleVideoData:(PHAsset *)asset
{
    [self getVideoPathFromPHAsset:asset Complete:^(NSString * _Nonnull filePath, NSString * _Nonnull fileName) {
        
        if (filePath&&fileName) {
            [self.dataController uploadFile:filePath mediaType:@"video" fileIndex:10];
            [self.uploadQueue setObject:self.videoObject.fileName forKey:[NSString stringWithFormat:@"%d",10]];
        }
    }];
}

-(void)getVideoPathFromPHAsset:(PHAsset *)asset Complete:(ResultPath)result {
    NSArray *assetResources = [PHAssetResource assetResourcesForAsset:asset];
    PHAssetResource *resource;

    for (PHAssetResource *assetRes in assetResources) {
        if (assetRes.type == PHAssetResourceTypePairedVideo ||
            assetRes.type == PHAssetResourceTypeVideo) {
            resource = assetRes;
        }
    }
    NSString *fileName = @"tempAssetVideo.mov";
    if (resource.originalFilename) {
        fileName = resource.originalFilename;
    }

    if (asset.mediaType == PHAssetMediaTypeVideo || asset.mediaSubtypes == PHAssetMediaSubtypePhotoLive) {
        PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
        options.version = PHImageRequestOptionsVersionCurrent;
        options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
         NSString *PATH_MOVIE_FILE = [NSTemporaryDirectory() stringByAppendingPathComponent:fileName];
        [[NSFileManager defaultManager] removeItemAtPath:PATH_MOVIE_FILE error:nil];
        [[PHAssetResourceManager defaultManager] writeDataForAssetResource:resource toFile:[NSURL fileURLWithPath:PATH_MOVIE_FILE] options:nil completionHandler:^(NSError * _Nullable error) {
                if (error) {
                 result(nil, nil);
                } else {
                 result(PATH_MOVIE_FILE, fileName);
                }
    }];
    }else{
        result(nil, nil);
    }
}

@end
