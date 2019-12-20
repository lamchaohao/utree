//
//  FeedbackVC.m
//  utree
//
//  Created by 科研部 on 2019/9/11.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "FeedbackVC.h"

@interface FeedbackVC ()<UITextViewDelegate>
@property (strong, nonatomic)UIBarButtonItem *rightbarItem;
@property (strong, nonatomic)UILabel *inputCounter;
@property (strong, nonatomic)UITextView *feedbackInput;
@end

@implementation FeedbackVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"意见反馈";
    [self initView];
    
}

-(void)initView
{
    self.view.backgroundColor = [UIColor_ColorChange colorWithHexString:@"#F7F7F7"];
    
    _feedbackInput = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth*0.84)];
//    _feedbackInput.text
//    _feedbackInput.placeholder = @"请输入您的宝贵意见";
    _feedbackInput.backgroundColor = [UIColor whiteColor];
    _feedbackInput.textAlignment = NSTextAlignmentLeft;
    _feedbackInput.font = [UIFont systemFontOfSize:16];
    _feedbackInput.adjustsFontForContentSizeCategory = YES;
    [self.view addSubview:_feedbackInput];
    
    _rightbarItem = [[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(onSubmit:)];
    _rightbarItem.tintColor=[UIColor blackColor];
    self.navigationItem.rightBarButtonItem=_rightbarItem;
    
    
    _feedbackInput.delegate = self;
    
    _inputCounter = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-60, ScreenWidth*0.84-20, 40, 20)];
    [_inputCounter setTextColor:[UIColor grayColor]];
    
    [self.view addSubview:_inputCounter];
    
}

-(void)onSubmit:(UIButton *)sender
{
   
}

-(void)textViewDidChange:(UITextView *)textView
{
    
    //实时显示字数
    _inputCounter.text = [NSString stringWithFormat:@"%ld/200",(long)textView.text.length];
    [_inputCounter sizeToFit];
    //字数限制
    if (textView.text.length >= 200) {
        textView.text = [textView.text substringToIndex:200];
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
