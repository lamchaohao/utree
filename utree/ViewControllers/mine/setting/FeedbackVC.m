//
//  FeedbackVC.m
//  utree
//
//  Created by 科研部 on 2019/9/11.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "FeedbackVC.h"
#import "FeedbackDC.h"
#import "MMAlertView.h"
#import "UITextView+ZBPlaceHolder.h"

@interface FeedbackVC ()<UITextViewDelegate>
@property (strong, nonatomic)UIBarButtonItem *rightbarItem;
@property (strong, nonatomic)UILabel *inputCounter;
@property (strong, nonatomic)UITextView *feedbackInput;
@property (strong, nonatomic)FeedbackDC *dataController;
@end

@implementation FeedbackVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataController = [[FeedbackDC alloc]init];
    self.title = @"意见反馈";
    [self initView];
    
}

-(void)initView
{
    self.view.backgroundColor = [UIColor_ColorChange colorWithHexString:@"#F7F7F7"];
    
    _feedbackInput = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth*0.84)];
//    _feedbackInput.text
    [_feedbackInput setPlaceholder:@"请输入您宝贵的意见"];
    _feedbackInput.backgroundColor = [UIColor whiteColor];
    _feedbackInput.textAlignment = NSTextAlignmentLeft;
    _feedbackInput.font = [UIFont systemFontOfSize:16];
    _feedbackInput.adjustsFontForContentSizeCategory = YES;
    [self.view addSubview:_feedbackInput];
    
    _rightbarItem = [[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(onSubmit:)];
    _rightbarItem.tintColor=[UIColor blackColor];
    self.navigationItem.rightBarButtonItem=_rightbarItem;
    
    
    _feedbackInput.delegate = self;
    
    _inputCounter = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-80, ScreenWidth*0.84-20, 40, 20)];
    [_inputCounter setTextColor:[UIColor grayColor]];
    
    [self.view addSubview:_inputCounter];
    _inputCounter.text = @"0/200";
    [_inputCounter sizeToFit];
}

-(void)onSubmit:(UIButton *)sender
{
    NSString *content = _feedbackInput.text;
    if (![self isBlankString:content]) {
        [self.dataController submitFeedbackWithContent:content withSuccess:^(UTResult * _Nonnull result) {
            [self showInfoAfterSubmit];
        } failure:^(UTResult * _Nonnull result) {
            [self.view makeToast:result.failureResult];
        }];
    }
}

-(void)showInfoAfterSubmit
{
    MMPopupCompletionBlock completeBlock = ^(MMPopupView *popupView, BOOL finished){
        [self.navigationController popViewControllerAnimated:YES];
    };
    MMAlertView *alertView = [[MMAlertView alloc]initWithConfirmTitle:@"反馈成功" detail:@"我们将会对您反馈的问题进行处理,谢谢！"];
    [alertView showWithBlock:completeBlock];
}


-(void)textViewDidChange:(UITextView *)textView
{
    
    //实时显示字数
    _inputCounter.text = [NSString stringWithFormat:@"%ld/200",(long)textView.text.length];
    [_inputCounter sizeToFit];
    //字数限制
    if (textView.text.length >= 199) {
        textView.text = [textView.text substringToIndex:199];
    }
    
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        
        [_feedbackInput resignFirstResponder];
        
        return NO;
    }
    
    return YES;
}




@end
