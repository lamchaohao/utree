//
//  UITextView+ZBPlaceHolder.m
//  utree
//
//  Created by 科研部 on 2019/9/27.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "UITextView+ZBPlaceHolder.h"
#import <objc/runtime.h>
static const void *zb_placeHolderKey;

@interface UITextView ()
@property (nonatomic, readonly) UILabel *zb_placeHolderLabel;
@end
@implementation UITextView (ZWPlaceHolder)
+(void)load{
    [super load];
    method_exchangeImplementations(class_getInstanceMethod(self.class, NSSelectorFromString(@"layoutSubviews")),
                                   class_getInstanceMethod(self.class, @selector(zwPlaceHolder_swizzling_layoutSubviews)));
    method_exchangeImplementations(class_getInstanceMethod(self.class, NSSelectorFromString(@"dealloc")),
                                   class_getInstanceMethod(self.class, @selector(zwPlaceHolder_swizzled_dealloc)));
    method_exchangeImplementations(class_getInstanceMethod(self.class, NSSelectorFromString(@"setText:")),
                                   class_getInstanceMethod(self.class, @selector(zwPlaceHolder_swizzled_setText:)));
}
#pragma mark - swizzled
- (void)zwPlaceHolder_swizzled_dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self zwPlaceHolder_swizzled_dealloc];
}
- (void)zwPlaceHolder_swizzling_layoutSubviews {
    if (self.zw_placeHolder) {
        UIEdgeInsets textContainerInset = self.textContainerInset;
        CGFloat lineFragmentPadding = self.textContainer.lineFragmentPadding;
        CGFloat x = lineFragmentPadding + textContainerInset.left + self.layer.borderWidth;
        CGFloat y = textContainerInset.top + self.layer.borderWidth;
        CGFloat width = CGRectGetWidth(self.bounds) - x - textContainerInset.right - 2*self.layer.borderWidth;
        CGFloat height = [self.zw_placeHolderLabel sizeThatFits:CGSizeMake(width, 0)].height;
        self.zw_placeHolderLabel.frame = CGRectMake(x, y, width, height);
    }
    [self zwPlaceHolder_swizzling_layoutSubviews];
}
- (void)zwPlaceHolder_swizzled_setText:(NSString *)text{
    [self zwPlaceHolder_swizzled_setText:text];
    if (self.zw_placeHolder) {
        [self updatePlaceHolder];
    }
}
#pragma mark - associated
-(NSString *)zw_placeHolder{
    return objc_getAssociatedObject(self, &zb_placeHolderKey);
}
-(void)setZw_placeHolder:(NSString *)zb_placeHolder{
    objc_setAssociatedObject(self, &zb_placeHolderKey, zb_placeHolder, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self updatePlaceHolder];
}
-(UIColor *)zw_placeHolderColor{
    return self.zw_placeHolderLabel.textColor;
}
-(void)setZw_placeHolderColor:(UIColor *)zw_placeHolderColor{
    self.zw_placeHolderLabel.textColor = zw_placeHolderColor;
}
-(NSString *)placeholder{
    return self.zw_placeHolder;
}
-(void)setPlaceholder:(NSString *)placeholder{
    self.zw_placeHolder = placeholder;
}
#pragma mark - update
- (void)updatePlaceHolder{
    if (self.text.length) {
        [self.zw_placeHolderLabel removeFromSuperview];
        return;
    }
    self.zw_placeHolderLabel.font = self.font?self.font:self.cacutDefaultFont;
    self.zw_placeHolderLabel.textAlignment = self.textAlignment;
    self.zw_placeHolderLabel.text = self.zw_placeHolder;
    [self insertSubview:self.zw_placeHolderLabel atIndex:0];
}
#pragma mark - lazzing
-(UILabel *)zw_placeHolderLabel{
    UILabel *placeHolderLab = objc_getAssociatedObject(self, @selector(zw_placeHolderLabel));
    if (!placeHolderLab) {
        placeHolderLab = [[UILabel alloc] init];
        placeHolderLab.numberOfLines = 0;
        placeHolderLab.textColor = [UIColor lightGrayColor];
        objc_setAssociatedObject(self, @selector(zw_placeHolderLabel), placeHolderLab, OBJC_ASSOCIATION_RETAIN);
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePlaceHolder) name:UITextViewTextDidChangeNotification object:self];
    }
    return placeHolderLab;
}
- (UIFont *)cacutDefaultFont{
    self.font=[CFTool font:16];
    return [CFTool font:16];
}
@end
