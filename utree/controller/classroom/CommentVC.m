//
//  CommentVC.m
//  utree
//
//  Created by 科研部 on 2019/9/25.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "CommentVC.h"

@interface CommentVC ()
@property(nonatomic, strong) MyFlowLayout *flowLayout;
@property(nonatomic, assign) NSInteger oldIndex;
@property(nonatomic, assign) NSInteger currentIndex;
@property(nonatomic, assign) BOOL    hasDrag;
@property(nonatomic,strong)UTStudent *student;
@property(nonatomic, strong)UITextField *tagInput;
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

-(void)loadView
{
    
    MyLinearLayout *rootLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
    rootLayout.backgroundColor = [UIColor myColorWithHexString:@"#F7F7F7"];
    rootLayout.gravity = MyGravity_Horz_Fill;  //垂直线性布局里面的子视图的宽度和布局视图一致。
    rootLayout.wrapContentWidth = NO;
    rootLayout.wrapContentHeight = NO;
    self.view = rootLayout;
    
    [self createAddTagLayout];
    
    UILabel *tip2Label = [UILabel new];
    tip2Label.text = @"双击标签删除";
    tip2Label.font = [UIFont systemFontOfSize:13];
    tip2Label.textColor = [UIColor redColor];
    tip2Label.textAlignment = NSTextAlignmentCenter;
    tip2Label.myTop = 20;
    [tip2Label sizeToFit];
    [rootLayout addSubview:tip2Label];
    
    self.flowLayout = [MyFlowLayout flowLayoutWithOrientation:MyOrientation_Vert arrangedCount:0];
    self.flowLayout.backgroundColor = [UIColor myColorWithHexString:@"#FFF7F7F7"];
    self.flowLayout.padding = UIEdgeInsetsMake(10, 10, 10, 10);
    self.flowLayout.subviewSpace = 10;   //流式布局里面的子视图的水平和垂直间距都设置为10
    self.flowLayout.gravity = MyGravity_Horz_Fill;  //流式布局里面的子视图的宽度将平均分配。
    self.flowLayout.weight = 1;   //流式布局占用线性布局里面的剩余高度。
    self.flowLayout.myTop = 10;
    [rootLayout addSubview:self.flowLayout];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    for (NSInteger i = 0; i < 14; i++)
    {
        NSString *label = [NSString stringWithFormat:NSLocalizedString(@"点评语=%ld", @""),i];
        [self.flowLayout addSubview:[self createTagButton:label]];
    }
    
    //最后添加添加按钮。
//    self.addButton = [self createAddButton];
//    [self.flowLayout addSubview:self.addButton];
    
}

-(void)createAddTagLayout
{
    MyRelativeLayout *navBarLayout = [MyRelativeLayout new];
    navBarLayout.frame = CGRectMake(0, 0, ScreenWidth, 64);
    navBarLayout.backgroundColor = [UIColor whiteColor];
    navBarLayout.myTop=iPhone_StatuBarHeight;
    navBarLayout.myLeft=0;
    
    UILabel *navTitle = [[UILabel alloc]init];
    navTitle.myCenterX=0;
    navTitle.myCenterY=0;
    navTitle.textColor = [UIColor blackColor];
    navTitle.font = [UIFont systemFontOfSize:18];
    navTitle.text=[NSString stringWithFormat:@"您正在点评 %@",_student.studentName];
    [navTitle sizeToFit];
    
    UIButton *closeButton = [[UIButton alloc]init];
    [closeButton setImage:[UIImage imageNamed:@"ic_close_black"] forState:UIControlStateNormal];
    [closeButton sizeToFit];
    [closeButton addTarget:self action:@selector(finishVC:) forControlEvents:UIControlEventTouchUpInside];
    closeButton.myTop=0;
    closeButton.myLeft=18;
    closeButton.myCenterY=0;
    [navBarLayout addSubview:closeButton];
    [navBarLayout addSubview:navTitle];
    
    [self.view addSubview:navBarLayout];
    
    MyLinearLayout *linearLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Horz];
    linearLayout.frame = CGRectMake(18, 100, ScreenWidth, 40);
    linearLayout.myTop=68;
    linearLayout.myLeft=20;
    _tagInput = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth-150, 30)];
    _tagInput.placeholder = @"请输入新的点评语";
    [_tagInput setBorderStyle:UITextBorderStyleLine];
    _tagInput.leftViewMode = UITextFieldViewModeAlways;
    [_tagInput setClearButtonMode:UITextFieldViewModeWhileEditing];
    
    UIButton *addTagBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 30, 120, 40)];
    [addTagBtn setTitle:@"添加标签" forState:UIControlStateNormal];
    [addTagBtn setTitleColor:[UIColor myColorWithHexString:PrimaryColor] forState:UIControlStateNormal];
    
    [addTagBtn addTarget:self action:@selector(handleAddTagButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [linearLayout addSubview:_tagInput];
    [linearLayout addSubview:addTagBtn];
    
    [self.view addSubview:linearLayout];
    
}

-(void)handleAddTagButton:(UIButton *)sender
{

    [self.flowLayout addSubview:[self createTagButton:_tagInput.text]];
    _tagInput.text=@"";
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- Layout Construction

//创建标签按钮
-(UIButton*)createTagButton:(NSString*)text
{
    UIButton *tagButton = [UIButton new];
    [tagButton setTitle:text forState:UIControlStateNormal];
    tagButton.titleLabel.font = [UIFont systemFontOfSize:15];
    tagButton.layer.cornerRadius = 15;
    tagButton.backgroundColor = [CFTool color:rand()%15];
    //这里可以看到尺寸宽度等于自己的尺寸宽度并且再增加10，且最小是40，意思是按钮的宽度是等于自身内容的宽度再加10，但最小的宽度是40
    //如果没有这个设置，而是直接调用了sizeToFit则按钮的宽度就是内容的宽度。
    tagButton.widthSize.equalTo(tagButton.widthSize).add(10).min(40);
    tagButton.heightSize.equalTo(tagButton.heightSize).add(10); //高度根据自身的内容再增加10
    [tagButton sizeToFit];
//    [tagButton addTarget:self action:@selector(handleDelTag:) forControlEvents:UIControlEventTouchUpInside];
    [self.flowLayout addSubview:tagButton];
    
    [tagButton addTarget:self action:@selector(handlerClick:) forControlEvents:UIControlEventTouchUpInside];
    [tagButton addTarget:self action:@selector(handleTouchDrag:withEvent:) forControlEvents:UIControlEventTouchDragInside]; //注册拖动事件。
    [tagButton addTarget:self action:@selector(handleTouchDrag:withEvent:) forControlEvents:UIControlEventTouchDragOutside]; //注册外面拖动事件。
    [tagButton addTarget:self action:@selector(handleTouchDown:withEvent:) forControlEvents:UIControlEventTouchDown]; //注册按下事件
    [tagButton addTarget:self action:@selector(handleTouchUp:withEvent:) forControlEvents:UIControlEventTouchUpInside]; //注册抬起事件
    [tagButton addTarget:self action:@selector(handleTouchUp:withEvent:) forControlEvents:UIControlEventTouchCancel]; //注册终止事件
    [tagButton addTarget:self action:@selector(handleTouchDownRepeat:withEvent:) forControlEvents:UIControlEventTouchDownRepeat]; //注册多次点击事件
    
    return tagButton;
    
}

//创建添加按钮
-(UIButton*)createAddButton
{
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [addButton setTitle:NSLocalizedString(@"add tag", @"") forState:UIControlStateNormal];
    addButton.titleLabel.font = [UIFont systemFontOfSize:14];
    addButton.layer.cornerRadius = 20;
    addButton.layer.borderWidth = 0.5;
    addButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    addButton.heightSize.equalTo(@44);
    
    [addButton addTarget:self action:@selector(handleAddTagButton:) forControlEvents:UIControlEventTouchUpInside];
    
    return addButton;
}




#pragma mark -- Handle Method

-(void)handlerClick:(id)sender
{
    NSLog(@"commentVC handlerClick");
}

-(void)handleAddTagButtonNormal:(id)sender
{
    NSString *label = [NSString stringWithFormat:NSLocalizedString(@"drag me %ld", @""),self.flowLayout.subviews.count - 1];
    [self.flowLayout insertSubview:[self createTagButton:label] atIndex:self.flowLayout.subviews.count - 1];
    
}

- (IBAction)handleTouchDown:(UIButton*)sender withEvent:(UIEvent*)event {
    
    //在按下时记录当前要拖动的控件的索引。
    self.oldIndex = [self.flowLayout.subviews indexOfObject:sender];
    self.currentIndex = self.oldIndex;
    self.hasDrag = NO;
    
}

- (IBAction)handleTouchUp:(UIButton*)sender withEvent:(UIEvent*)event {
    
    if (!self.hasDrag)
        return;
    
    //当抬起时，需要让拖动的子视图调整到正确的顺序，并重新参与布局，因此这里要把拖动的子视图的useFrame设置为NO，同时把布局视图的autoresizesSubviews还原为YES。
    
    //调整索引。
    for (NSInteger i = self.flowLayout.subviews.count - 1; i > self.currentIndex; i--)
    {
        [self.flowLayout exchangeSubviewAtIndex:i withSubviewAtIndex:i - 1];
    }
    
    sender.useFrame = NO;  //让拖动的子视图重新参与布局，将useFrame设置为NO
    self.flowLayout.autoresizesSubviews = YES; //让布局视图可以重新激发布局，这里还原为YES。
    
    
}


- (IBAction)handleTouchDrag:(UIButton*)sender withEvent:(UIEvent*)event {
    
    self.hasDrag = YES;
    
    NSLog(@"AAA:%@", event);
    //取出拖动时当前的位置点。
    CGPoint pt = [[event touchesForView:sender].anyObject locationInView:self.flowLayout];
    
    UIView *sbv2 = nil;  //sbv2保存拖动时手指所在的视图。
    //判断当前手指在具体视图的位置。这里要排除self.addButton的位置(因为这个按钮将固定不调整)。
    for (UIView *sbv in self.flowLayout.subviews)
    {
        if (sbv != sender && sender.useFrame )
        {
            CGRect rc1 =  sbv.frame;
            if (CGRectContainsPoint(rc1, pt))
            {
                sbv2 = sbv;
                break;
            }
        }
    }
    
    //如果拖动的控件sender和手指下当前其他的兄弟控件有重合时则意味着需要将当前控件插入到手指下的sbv2所在的位置，并且调整sbv2的位置。
    if (sbv2 != nil)
    {
        
        [self.flowLayout layoutAnimationWithDuration:0.2];
        
        //得到要移动的视图的位置索引。
        self.currentIndex = [self.flowLayout.subviews indexOfObjectIdenticalTo:sbv2];
        
        if (self.oldIndex != self.currentIndex)
        {
            self.oldIndex = self.currentIndex;
        }
        else
        {
            self.currentIndex = self.oldIndex + 1;
        }
        
        
        
        //因为sender在bringSubviewToFront后变为了最后一个子视图，因此要调整正确的位置。
        for (NSInteger i = self.flowLayout.subviews.count - 1; i > self.currentIndex; i--)
        {
            [self.flowLayout exchangeSubviewAtIndex:i withSubviewAtIndex:i - 1];
        }
        
        //经过上面的sbv2的位置调整完成后，需要重新激发布局视图的布局，因此这里要设置autoresizesSubviews为YES。
        self.flowLayout.autoresizesSubviews = YES;
        sender.useFrame = NO;
        sender.noLayout = YES;  //这里设置为YES表示布局时不会改变sender的真实位置而只是在布局视图中占用一个位置和尺寸，正是因为只是占用位置，因此会调整其他视图的位置。
        [self.flowLayout layoutIfNeeded];
        
    }
    
    //在进行sender的位置调整时，要把sender移动到最顶端，也就子视图数组的的最后。同时布局视图不能激发子视图布局，因此要把autoresizesSubviews设置为NO，同时因为要自定义sender的位置，因此要把useFrame设置为YES，并且恢复noLayout为NO。
    [self.flowLayout bringSubviewToFront:sender]; //把拖动的子视图放在最后，这样这个子视图在移动时就会在所有兄弟视图的上面。
    self.flowLayout.autoresizesSubviews = NO;  //在拖动时不要让布局视图激发布局
    sender.useFrame = YES;  //因为拖动时，拖动的控件需要自己确定位置，不能被布局约束，因此必须要将useFrame设置为YES下面的center设置才会有效。
    sender.center = pt;  //因为useFrame设置为了YES所有这里可以直接调整center，从而实现了位置的自定义设置。
    sender.noLayout = NO; //恢复noLayout为NO。
    
}

- (IBAction)handleTouchDownRepeat:(UIButton*)sender withEvent:(UIEvent*)event {
    
    [sender removeFromSuperview];
    [self.flowLayout layoutAnimationWithDuration:0.2];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.showNavWhenDisappear = NO;
    [super viewWillAppear:animated];
    
}

-(void)finishVC:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
