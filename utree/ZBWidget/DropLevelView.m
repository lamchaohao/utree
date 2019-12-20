//
//  DropLevelView.m
//  utree
//
//  Created by 科研部 on 2019/9/23.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "DropLevelView.h"

@interface DropLevelView()

@property(nonatomic,strong)UILabel *scoreLabel;

@end

@implementation DropLevelView

- (instancetype)initWithFrame:(CGRect)frame;
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createViewAndScore];
    }
    return self;
    
}

-(void)createViewAndScore
{
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(35, 0, 49, 22)];
    titleLab.font=[UIFont boldSystemFontOfSize:12];
    titleLab.textColor = [UIColor whiteColor];
    titleLab.text = @"当前级别";
    [titleLab sizeToFit];
    
    UILabel *lvLab = [[UILabel alloc]initWithFrame:CGRectMake(8, 17, 49, 22)];
    lvLab.font=[UIFont boldSystemFontOfSize:14];
    lvLab.textColor = [UIColor whiteColor];
    lvLab.text = @"LV";
    [lvLab sizeToFit];

    
    UIImageView *dropImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 31, 41)];
    dropImg.image = [UIImage imageNamed:@"level_drop"];
    
    UIView *levelScoreBg = [[UIView alloc] init];
    levelScoreBg.frame = CGRectMake(14,15,80,24.3);
    levelScoreBg.backgroundColor = [UIColor myColorWithHexString:@"#34C3F4"];
    levelScoreBg.layer.cornerRadius = 12;
    
    self.scoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 15, 85, 24)];
    self.scoreLabel.textAlignment = NSTextAlignmentRight;
    self.scoreLabel.textColor = [UIColor whiteColor];
    self.scoreLabel.font = [UIFont systemFontOfSize:12];
    self.scoreLabel.text = @"258/290";
    
    [self addSubview:titleLab];
    [self addSubview:levelScoreBg];
    [self addSubview:dropImg];
    [self addSubview:lvLab];
    [self addSubview:self.scoreLabel];
    
    
}

-(void)setScoreLabelText:(NSString *)text
{
    [self.scoreLabel setText:text];
}


@end
