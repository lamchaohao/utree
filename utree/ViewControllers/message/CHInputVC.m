//
//  CHInputVC.m
//  utree
//
//  Created by 科研部 on 2020/1/9.
//  Copyright © 2020 科研部. All rights reserved.
//

#import "CHInputVC.h"

@interface CHInputVC ()<UITextViewDelegate>
{
    int _oldIndex;
    NSString *_content;
    CGFloat _keyboardHeight;
}
@property(atomic,strong)MyLinearLayout *mainView;

@end

@implementation CHInputVC

- (instancetype)initWithContent:(NSString *)content index:(int)index
{
    self = [super init];
    if (self) {
        _oldIndex = index;
        _content = content;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if(self.inputLengthLimit==0){
        self.inputLengthLimit=25;//默认限制输入25长度
    }
    [self showView];
}

-(void)showView
{
    MyRelativeLayout *rootLayout = [MyRelativeLayout new];
    self.view = rootLayout;
    
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissView:)];
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    bgView.backgroundColor=[UIColor clearColor];
    [bgView addGestureRecognizer:tapGesture];
    [tapGesture setNumberOfTapsRequired:1];
    [self.view addSubview:bgView];
    
    self.mainView = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Horz];
    self.mainView.frame = CGRectMake(0,0,ScreenWidth,80);
    self.mainView.backgroundColor = [UIColor myColorWithHexString:@"#F7F7F7"];
    self.mainView.layer.cornerRadius = 11;
    [self.view addSubview:self.mainView];
    self.mainView.myLeft=self.mainView.myRight=1;
    self.mainView.bottomPos.equalTo(self.view.bottomPos);
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];

    UITextView *textFiled = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth-70, 75)];
    textFiled.tag = 10001;
    textFiled.layer.cornerRadius = 5.0;
    textFiled.backgroundColor = [UIColor whiteColor];
    textFiled.textAlignment = NSTextAlignmentLeft;
    textFiled.font = [UIFont systemFontOfSize:16];
    textFiled.adjustsFontForContentSizeCategory = YES;
    textFiled.returnKeyType=UIReturnKeyDone;
    textFiled.delegate=self;
    textFiled.myLeft=8;
    textFiled.myTop=2.5;
    textFiled.text = _content;
    [textFiled becomeFirstResponder];
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 56, 30)];
    [button setTitle:@"保存" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor myColorWithHexString:PrimaryColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(completedEdit:) forControlEvents:UIControlEventTouchUpInside];
    
    button.myTop=25;
    
    [self.mainView addSubview:textFiled];
    [self.mainView addSubview:button];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [self completedEdit:textView];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
 
    return YES;
}



-(void)completedEdit:(id)send
{
    for (UIView *view in [self.mainView subviews]) {
        
        if(view.tag==10001){
            UITextView *textView= (UITextView *)view;
            NSString *inputText = textView.text;
            if (inputText.length>self.inputLengthLimit) {
                [self showToastView:[NSString stringWithFormat:@"字数不能超过%ld字",self.inputLengthLimit]];
                
            }else if([self isBlankString:inputText]){
                [self showToastView:@"没有输入内容"];
            }else{
                if ([self isBlankString:_content]) {
                    [self.callback CHInputAdded:textView.text];//添加
                }else{
                    [self.callback CHInputFinishEditing:textView.text index:_oldIndex];//编辑
                }
                
                [self dismissView:send];
            }
            
        }
    }
    
}

-(void)keyboardChange:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardEndFrame;
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    
    _keyboardHeight = keyboardEndFrame.size.height;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];

    
    if ([UIKeyboardWillShowNotification isEqualToString:notification.name]) {
        self.mainView.bottomPos.equalTo(self.view.bottomPos).offset(_keyboardHeight-iPhone_Safe_BottomNavH);
    }else{
        self.mainView.bottomPos.equalTo(self.view.bottomPos).offset(iPhone_Safe_BottomNavH);
    }
    [UIView commitAnimations];
    
}




-(void)dismissView:(UIButton *)sender
{
    [self dismissViewControllerAnimated:NO completion:nil];
    [self.callback CHInputdialogWillClose];
}

@end
