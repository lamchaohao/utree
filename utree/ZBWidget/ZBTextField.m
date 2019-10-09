//
//  ZBTextField.m
//  utree
//
//  Created by 科研部 on 2019/7/26.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "ZBTextField.h"
#import "UIColor+ColorChange.h"
@implementation ZBTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)init
{
    self.leftMargin = 15;
    self.textMargin = 45;
    self = [super init];
    return self;
}

-(instancetype)initWitheLeftMargin:(CGFloat)x andTextMargin:(CGFloat)textMargin
{
    self.leftMargin = x;
    self.textMargin = textMargin;
    self = [super init];
    return self;
}


- (CGRect)leftViewRectForBounds:(CGRect)bounds
{
    CGRect iconRect = [super leftViewRectForBounds:bounds];
    iconRect.origin.x += self.leftMargin; //像右边偏15
    return iconRect;
}

//UITextField 文字与输入框的距离
- (CGRect)textRectForBounds:(CGRect)bounds{
    
    return CGRectInset(bounds, self.textMargin, 0);
    
}

//控制文本的位置
- (CGRect)editingRectForBounds:(CGRect)bounds{
    
    return CGRectInset(bounds, self.textMargin, 0);
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor_ColorChange colorWithHexString:@"#E8E8E8"].CGColor);
    CGContextFillRect(context, CGRectMake(self.leftMargin, CGRectGetHeight(self.frame)-1, CGRectGetWidth(self.frame), 1));
}

@end
