//
//  CommentVC.m
//  utree
//
//  Created by 科研部 on 2019/9/25.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "CommentVC.h"
#import "TTGTextTagCollectionView.h"
#import "ZBTextField.h"
#import "EditCommentVC.h"
#import "CommentDC.h"
@interface CommentVC ()<TTGTextTagCollectionViewDelegate,UITextFieldDelegate,EditCommentSender>

@property(nonatomic,strong)UTStudent *student;
@property(nonatomic,strong)TTGTextTagCollectionView *tagView;
@property(nonatomic,strong)UIView *toolBar;
@property(nonatomic,strong)ZBTextField *tagInputField;
@property(nonatomic,strong)TTGTextTagConfig *config;
@property(nonatomic,strong)CommentDC *dataController;

@end

@implementation CommentVC
-(instancetype)initWithStuName:(UTStudent *)stuName
{
    self = [super init];
    
    if (self) {
        _student = stuName;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // 添加通知监听见键盘弹出/退出
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardAction:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardAction:) name:UIKeyboardWillHideNotification object:nil];
    
    self.title = [NSString stringWithFormat:@"您正在点评 %@",_student.studentName];
    self.view.backgroundColor = [UIColor myColorWithHexString:@"#F7F7F7"];
    [self initView];
}

-(void)initView
{
   
    self.dataController = [[CommentDC alloc]init];
    NSArray *tags = [self.dataController requestCommentList];
       
    self.tagView = [[TTGTextTagCollectionView alloc]initWithFrame:CGRectMake(0, iPhone_Top_NavH+10, ScreenWidth, ScreenHeight-iPhone_Safe_BottomNavH-iPhone_Top_NavH-48)];
    [self.view addSubview:_tagView];
    self.tagView.backgroundColor = [UIColor myColorWithHexString:@"#F7F7F7"];
    _tagView.alignment = TTGTagCollectionAlignmentFillByExpandingWidth;
    
    self.config = [TTGTextTagConfig new];
    self.config.textFont = [UIFont systemFontOfSize:20];
    
    self.config.textColor = [UIColor myColorWithHexString:@"#666666"];
    self.config.selectedTextColor = [UIColor whiteColor];
    self.config.selectedBackgroundColor=[UIColor myColorWithHexString:PrimaryColor];
    self.config.backgroundColor=[UIColor whiteColor];
    
    [self.tagView addTags:tags withConfig:self.config];
    self.tagView.delegate = self;
    
    [self.tagView reload];
    UITapGestureRecognizer *guesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyboard:)];
    [self.tagView addGestureRecognizer:guesture];
    

    self.toolBar = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight-iPhone_Safe_BottomNavH-40, ScreenWidth, 40)];
    self.tagInputField = [[ZBTextField alloc]initWitheLeftMargin:10 andTextMargin:10];
    self.tagInputField.placeholder = @"请点评";
    self.tagInputField.frame = CGRectMake(10, 0, ScreenWidth-70, 38);
    self.tagInputField.backgroundColor=[UIColor myColorWithHexString:@"#EEEEEE"];
    [self.toolBar addSubview:self.tagInputField];
    self.tagInputField.delegate = self;
    self.tagInputField.returnKeyType=UIReturnKeySend;
    self.tagInputField.layer.cornerRadius=3;
    
    UIButton *sendCommentBtn = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth-55, 0, 50, 38)];
    [sendCommentBtn setTitle:@"点评" forState:UIControlStateNormal];
    
    [sendCommentBtn addTarget:self action:@selector(onSendComment:) forControlEvents:UIControlEventTouchUpInside];
    sendCommentBtn.layer.cornerRadius=6;
    [sendCommentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendCommentBtn setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
    sendCommentBtn.backgroundColor = [UIColor myColorWithHexString:PrimaryColor];
    [self.toolBar addSubview:sendCommentBtn];
    [self.view addSubview:self.toolBar];
    
    UIBarButtonItem *rightbarItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"mine_icon_publish"] style:UIBarButtonItemStylePlain target:self action:@selector(toEditView:) ];
    rightbarItem.tintColor=[UIColor blackColor];
    self.navigationItem.rightBarButtonItem=rightbarItem;
}

- (void)textTagCollectionView:(TTGTextTagCollectionView *)textTagCollectionView didTapTag:(NSString *)tagText atIndex:(NSUInteger)index selected:(BOOL)selected tagConfig:(TTGTextTagConfig *)config {
    [self.tagInputField resignFirstResponder];
    [textTagCollectionView setTagAtIndex:index selected:NO];
    self.tagInputField.text = tagText;
    NSLog(@"Did tap: %@, config extra: %@", tagText, config.extraData);
}


//发动按钮
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self onSendComment:textField];
    return YES;
}

// 键盘监听事件
- (void)keyboardAction:(NSNotification*)sender{
    // 通过通知对象获取键盘frame: [value CGRectValue]
    NSDictionary *useInfo = [sender userInfo];
    NSValue *value = [useInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    // <注意>具有约束的控件通过改变约束值进行frame的改变处理
    if([sender.name isEqualToString:UIKeyboardWillShowNotification]){
        CGFloat height = [value CGRectValue].size.height;
        
        CGRect frame = self.toolBar.frame;
        if(frame.origin.y!=ScreenHeight-iPhone_Safe_BottomNavH-40){
            return;
        }
        int offSet = frame.origin.y + 70 -height-self.toolBar.frame.size.height-40;
        [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
        [UIView setAnimationDuration:0.3f];
        //将试图的Y坐标向上移动offset个单位，以使线面腾出开的地方用于软键盘的显示
        if (offSet > 0) {
            self.toolBar.frame = CGRectMake(0.0f, offSet, self.toolBar.frame.size.width, self.toolBar.frame.size.height);
            [UIView commitAnimations];
            
        }
    }else{
        //视图恢复到原始状态
         self.toolBar.frame = CGRectMake(0, ScreenHeight-iPhone_Safe_BottomNavH-40, ScreenWidth, 40);
    }
}

-(void)onSendComment:(id)sender
{
    if (self.tagInputField.text.length>0) {
       
        [self.dataController requestCommentToStuId:self.student.studentId comment:self.tagInputField.text WithSuccess:^(UTResult * _Nonnull result) {
            [self sendCommentSuccess];
        } failure:^(UTResult * _Nonnull result) {
            [self.view makeToast:result.failureResult];
        }];
        
        
    }else{
        [self.view makeToast:@"请输入点评语"];
    }
}

-(void)sendCommentSuccess
{
    [self.view makeToast:@"点评成功"];
    
    NSArray *comments = [self.dataController requestCommentList];
    BOOL isExsit=NO;
    for (NSString *comment in comments) {
       if ([comment isEqualToString:self.tagInputField.text]) {
           isExsit = YES;
           break;
       }
    }
    if (!isExsit) {
       [self.tagView addTag:self.tagInputField.text withConfig:self.config];
        [self.dataController addSingleComment:self.tagInputField.text];
    }
    self.tagInputField.text=@"";
}

- (void)onDeleteComment:(NSString *)deleted
{
    [self.tagView removeTag:deleted];
}


-(void)toEditView:(id)sender
{
    EditCommentVC *editVC = [[EditCommentVC alloc]init];
    editVC.sender = self;
    [self.navigationController pushViewController:editVC animated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.tagInputField resignFirstResponder];
}

-(void)hideKeyboard:(id)sender
{
    [self.tagInputField resignFirstResponder];
}

@end
