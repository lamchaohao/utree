//
//  UUInputToolsView.m
//  utree
//
//  Created by 科研部 on 2019/12/16.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "UUInputToolsView.h"
#import "UUChatCategory.h"
#import "TZImagePickerController.h"

@interface UUInputToolsView ()<UITextViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

{
   BOOL isbeginVoiceRecord;
   NSInteger playTime;
   NSString *_docmentFilePath;
}

@property (nonatomic, strong) UILabel *placeHold;

@property (nonatomic, weak, readonly) UIViewController *superVC;

@end

@implementation UUInputToolsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.isAbleToSendTextMessage = NO;

        //发送消息
        self.btnMoreFunc = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.btnMoreFunc setBackgroundImage:[UIImage uu_imageWithName:@"chat_bar_more_normal"] forState:UIControlStateNormal];
        [self.btnMoreFunc addTarget:self action:@selector(onMoreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.btnMoreFunc];
        
        //改变状态（语音、文字）
        self.btnChangeVoiceState = [UIButton buttonWithType:UIButtonTypeCustom];
        isbeginVoiceRecord = NO;
        [self.btnChangeVoiceState setBackgroundImage:[UIImage uu_imageWithName:@"chat_bar_voice_normal"] forState:UIControlStateNormal];
        self.btnChangeVoiceState.titleLabel.font = [UIFont systemFontOfSize:12];
        [self.btnChangeVoiceState addTarget:self action:@selector(voiceRecordBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.btnChangeVoiceState];

        //语音录入键
        self.btnVoiceRecord = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btnVoiceRecord.hidden = YES;
        [self.btnVoiceRecord setBackgroundImage:[UIImage uu_imageWithName:@"chat_message_back"] forState:UIControlStateNormal];
        [self.btnVoiceRecord setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self.btnVoiceRecord setTitleColor:[[UIColor lightGrayColor] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
        [self.btnVoiceRecord setTitle:@"按住 说话" forState:UIControlStateNormal];
        [self.btnVoiceRecord setTitle:@"松开 结束" forState:UIControlStateHighlighted];
        [self.btnVoiceRecord addTarget:self action:@selector(beginRecordVoice:) forControlEvents:UIControlEventTouchDown];
        [self.btnVoiceRecord addTarget:self action:@selector(endRecordVoice:) forControlEvents:UIControlEventTouchUpInside];
        [self.btnVoiceRecord addTarget:self action:@selector(cancelRecordVoice:) forControlEvents:UIControlEventTouchUpOutside | UIControlEventTouchCancel];
        [self.btnVoiceRecord addTarget:self action:@selector(RemindDragExit:) forControlEvents:UIControlEventTouchDragExit];
        [self.btnVoiceRecord addTarget:self action:@selector(RemindDragEnter:) forControlEvents:UIControlEventTouchDragEnter];
        [self addSubview:self.btnVoiceRecord];
        
        //输入框
        self.textViewInput = [[UITextView alloc] init];
        self.textViewInput.layer.cornerRadius = 4;
        self.textViewInput.layer.masksToBounds = YES;
        self.textViewInput.delegate = self;
        self.textViewInput.layer.borderWidth = 1;
        self.textViewInput.font = [UIFont systemFontOfSize:16];
        self.textViewInput.layer.borderColor = [[[UIColor lightGrayColor] colorWithAlphaComponent:0.4] CGColor];
        self.textViewInput.returnKeyType = UIReturnKeySend;
        [self addSubview:self.textViewInput];
        
        //输入框的提示语
        _placeHold = [[UILabel alloc] init];
        _placeHold.text = @"";
        _placeHold.textColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.8];
        [self.textViewInput addSubview:_placeHold];
        
        //分割线
        self.layer.borderWidth = 1;
        self.layer.borderColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3].CGColor;
        
        //添加通知
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textViewDidEndEditing:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.btnVoiceRecord.frame = CGRectMake(70, 5, self.uu_width-70*2, 30);
    self.btnMoreFunc.frame = CGRectMake(self.uu_width-40, 5, 30, 30);
    self.textViewInput.frame = CGRectMake(45, 5, self.uu_width-2*45, 30);
    _placeHold.frame = CGRectMake(20, 0, 200, 30);
    self.btnChangeVoiceState.frame = CGRectMake(5, 5, 30, 30);
}

- (UIViewController *)superVC
{
    return [self uu_findNextResonderInClass:[UIViewController class]];
}

#pragma mark - 录音touch事件
- (void)beginRecordVoice:(UIButton *)button
{
   
    [self.delegate startRecordAudio];
}

- (void)endRecordVoice:(UIButton *)button
{
    
    [self.delegate endRecordVoice];
    //缓冲消失时间 (最好有block回调消失完成)
    self.btnVoiceRecord.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.btnVoiceRecord.enabled = YES;
    });
}

- (void)cancelRecordVoice:(UIButton *)button
{
   
    [self.delegate cancleRecordAudio];
    //缓冲消失时间 (最好有block回调消失完成)
    self.btnVoiceRecord.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.btnVoiceRecord.enabled = YES;
    });
}

- (void)RemindDragExit:(UIButton *)button
{
    
    [self.delegate remindRecordDragExit];
}

- (void)RemindDragEnter:(UIButton *)button
{
    [self.delegate remindRecordDragEnter];
}


- (void)countVoiceTime
{
    playTime ++;
    if (playTime>=60) {
        [self endRecordVoice:nil];
    }
}



//改变输入与录音状态
- (void)voiceRecordBtnClick:(UIButton *)sender
{
    self.btnVoiceRecord.hidden = !self.btnVoiceRecord.hidden;
    self.textViewInput.hidden  = !self.textViewInput.hidden;
    isbeginVoiceRecord = !isbeginVoiceRecord;
    if (isbeginVoiceRecord) {
        [self.btnChangeVoiceState setBackgroundImage:[UIImage uu_imageWithName:@"chat_bar_input_normal"] forState:UIControlStateNormal];
        [self.textViewInput resignFirstResponder];
        //quickReplyView and FunctionView should be dismiss;
//        [self.delegate onFunctionSwitchClick:NO];
        [self.delegate onRecordBtnSwitchToEnable];
    }else{
        [self.btnChangeVoiceState setBackgroundImage:[UIImage uu_imageWithName:@"chat_bar_voice_normal"] forState:UIControlStateNormal];
        [self.textViewInput becomeFirstResponder];
    }
}

//发送消息（文字图片）
- (void)onMoreBtnClick:(UIButton *)sender
{
    if (self.isAbleToSendTextMessage) {
        NSString *resultStr = [self.textViewInput.text stringByReplacingOccurrencesOfString:@"   " withString:@""];
        [self.delegate UUInputToolsView:self sendMessage:resultStr];
    }
    else{
        [self.textViewInput resignFirstResponder];
        self.btnVoiceRecord.hidden=YES;
        self.textViewInput.hidden=NO;
        isbeginVoiceRecord=NO;
        [self.btnChangeVoiceState setBackgroundImage:[UIImage uu_imageWithName:@"chat_bar_voice_normal"] forState:UIControlStateNormal];
        [self.delegate onFunctionSwitchClick:NO];
    }
}


#pragma mark - TextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    _placeHold.hidden = self.textViewInput.text.length > 0;
}

- (void)textViewDidChange:(UITextView *)textView
{
    //由键盘发送键代替
//    [self changeSendBtnWithPhoto:textView.text.length>0?NO:YES];
    _placeHold.hidden = textView.text.length>0;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        NSString *resultStr = [self.textViewInput.text stringByReplacingOccurrencesOfString:@"   " withString:@""];
        [self.delegate UUInputToolsView:self sendMessage:resultStr];
        return NO;
    }else{
        return YES;
    }
}


- (void)textViewDidEndEditing:(UITextView *)textView
{
    _placeHold.hidden = self.textViewInput.text.length > 0;
}


-(void)onFunctionActionClick:(int)position
{
    if (position == 0) {
        [self addCarema];
    }else if (position == 1){
        [self pickPicture];
    }else if(position==2){
       [self.delegate onFunctionSwitchClick:YES];
    }
}

-(void)addCarema {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = NO;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self.superVC presentViewController:picker animated:YES completion:^{}];
    }else{
        //如果没有提示用户
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tip" message:@"Your device don't have camera" delegate:nil cancelButtonTitle:@"Sure" otherButtonTitles:nil];
        [alert show];
    }
}

//结束采集之后 之后怎么处理都在这里写 通过Infokey取出相应的信息  Infokey可在进入文件中查看
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey, id> *)info{
//查看是视频还是照片  public.image 或 public.movie
    NSString * mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:@"public.image"]) {//照片
        UIImage* editedImage =(UIImage *)[info objectForKey:
                    UIImagePickerControllerEditedImage]; //取出编辑过的照片
        UIImage* originalImage =(UIImage *)[info objectForKey:
                    UIImagePickerControllerOriginalImage];//取出原生照片
//        PHAsset* asset =(PHAsset *)[info objectForKey:
//        UIImagePickerControllerPHAsset];//取出asset

        UIImage* imageToSave = nil;
        if(editedImage){
            imageToSave = editedImage;
        } else {
            imageToSave = originalImage;
        }
    //将新图像（原始图像或已编辑）保存到相机胶卷
        UIImageWriteToSavedPhotosAlbum(imageToSave,nil,nil,nil);
        [self.delegate UUInputToolsView:self sendPicture:[NSArray arrayWithObject:imageToSave] assets:[[NSMutableArray alloc]init]];
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark 选择图片
-(void)pickPicture
{
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:3 delegate:nil];
    imagePickerVc.allowPickingVideo=NO;
    imagePickerVc.allowCrop=NO;
    
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
//       PHAsset *asset
//        self.picList = [NSMutableArray arrayWithArray:photos];
//        self.selectAssets = [NSMutableArray arrayWithArray:assets];
        [self.delegate UUInputToolsView:self sendPicture:photos assets:assets];
        
    }];
   
    [self.superVC presentViewController:imagePickerVc animated:YES completion:nil];
    
}





-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}



@end
