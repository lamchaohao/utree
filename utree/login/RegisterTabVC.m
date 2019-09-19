//
//  RegisterVC.m
//  utree
//
//  Created by 科研部 on 2019/7/30.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "RegisterTabVC.h"
//#import "Masonry.h"
#import "AutoScaleFrameMain.h"
@interface RegisterTabVC ()

@end

@implementation RegisterTabVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
}

-(void)initView{
    CGRect rect = asKFrame(0, 230, ScreenWidth, ScreenHeight-230, asKFrameXY);
    [self.view setFrame:rect];
    
    UILabel *label = [[UILabel alloc]init];
    [label setText:@"注册"];
    
    [self.view addSubview:label];
    
//    [label mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.equalTo(self.view);
//    }];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
