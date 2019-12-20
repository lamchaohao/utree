//
//  MineInfoVC.m
//  utree
//
//  Created by 科研部 on 2019/9/17.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "MineInfoVC.h"
#import "UTCache.h"
#import "TZImagePickerController.h"
#import "PersonalDC.h"
#import "FileObject.h"

@interface MineInfoVC ()<UITableViewDelegate,UITableViewDataSource,TZImagePickerControllerDelegate,UploadFileListener>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *itemNames;
@property(nonatomic,strong)PersonalDC *dataController;
@property(nonatomic,strong)FileObject *uploadPicObject;
@end

@implementation MineInfoVC
static NSString *CellID = @"fineID";
- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataController = [[PersonalDC alloc]init];
    [self createView];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.showNavigationBarImageWhenDisappear = YES;
    [super viewWillAppear:animated];
    
}
-(void)createView
{
    self.title=@"个人资料";
    self.view.backgroundColor=[UIColor whiteColor];
    _itemNames = [[NSArray alloc]initWithObjects:@"头像",@"昵称", @"所在学校",nil] ;
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStyleGrouped];
//    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellID];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    
    [self.view addSubview:_tableView];
    _tableView.rowHeight=62;
    self.view.backgroundColor = [UIColor_ColorChange colorWithHexString:@"#F7F7F7"];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row==0) {
        [self pickPicture];
    }else if(indexPath.row==1)
    {
        [self showProgressView];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *personDic=[UTCache readProfile];
    NSString *schoolName = [personDic objectForKey:@"companyName"];
    NSString *teachName = [personDic objectForKey:@"teacherName"];
    NSString *headPicUrl = [personDic objectForKey:@"filePath"];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleValue1
                                      reuseIdentifier: CellID];
    }
    
    [cell.textLabel setText:_itemNames[indexPath.row]];
    
    switch (indexPath.row) {
        case 0:
        {
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"default_head"]];
            if (![self isBlankString:headPicUrl]) {
                [imageView sd_setImageWithURL:[NSURL URLWithString:headPicUrl] placeholderImage:[UIImage imageNamed:@"default_head"]];
                imageView.layer.cornerRadius=imageView.frame.size.width/2 ;//裁成圆角
                imageView.layer.masksToBounds=YES;//隐藏裁剪掉的部分
                imageView.layer.borderWidth = 0.1f;//边框宽度
            }
            cell.accessoryView = imageView;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
           
            break;
        case 1:
            [cell.detailTextLabel setText:@"未登录"];
            if (![self isBlankString:teachName]) {
                [cell.detailTextLabel setText:teachName];
            }
            cell.accessoryType = UITableViewCellAccessoryNone;
            break;
        case 2:
            [cell.detailTextLabel setText:@"未加入"];
            if (![self isBlankString:schoolName]) {
                [cell.detailTextLabel setText:schoolName];
            }
            cell.accessoryType = UITableViewCellAccessoryNone;
            break;
        default:
            break;
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _itemNames.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(void)showProgressView
{
    

}

-(void)pickPicture
{
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    imagePickerVc.allowTakeVideo=NO;
    imagePickerVc.allowPickingVideo=NO;
    imagePickerVc.allowPickingGif=NO;
    imagePickerVc.allowPickingOriginalPhoto=YES;
    imagePickerVc.allowTakePicture=YES;
    imagePickerVc.allowCrop=YES;
    imagePickerVc.allowPreview=YES;
    // You can get the photos by block, the same as by delegate.
    [self presentViewController:imagePickerVc animated:YES completion:nil];
    
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto
{
    [self.navigationController.view makeToastActivity:CSToastPositionCenter];
    
    PHAsset *asset = [assets objectAtIndex:0];
    NSString *fileName = [asset valueForKey:@"filename"];
    NSLog(@"fileName = %@",fileName);
    UIImage *image = [photos objectAtIndex:0];
    self.uploadPicObject = [[FileObject alloc]init];
    self.uploadPicObject.fileKind=[NSNumber numberWithInt:10];
    self.uploadPicObject.fileName =fileName;
    self.uploadPicObject.pid=[NSString stringWithFormat:@"%d",1];
    self.uploadPicObject.fileType=[fileName pathExtension];
    //开始上传
    self.dataController.uploadListener = self;
    [self.dataController uploadFileData:[image sd_imageData] fileName:fileName mediaType:@"pic" fileIndex:1];

}

- (void)onFileUploadResult:(BOOL)success filePath:(NSString *)filePath fileIndex:(NSInteger)index md5Value:(NSString *)md5Str
{
    [self.navigationController.view hideToastActivity];
    if (success) {
        self.uploadPicObject.fileMD5=md5Str;
        self.uploadPicObject.path=filePath;
        
        [self.dataController requestUpdateAvatarWithFile:self.uploadPicObject WithSuccess:^(UTResult * _Nonnull result) {
            [self.tableView reloadData];
        } failure:^(UTResult * _Nonnull result) {
            [self.view makeToast:result.failureResult];
        }];
    }
    
    
    
}

- (void)onFileUploadProgress:(CGFloat)progress filePath:(NSString *)filePath fileIndex:(NSInteger)index
{
    
}


@end
