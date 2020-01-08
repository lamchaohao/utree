//
//  RMDateSelection.m
//  utree
//
//  Created by 科研部 on 2019/12/27.
//  Copyright © 2019 科研部. All rights reserved.
//
#import "RMDateSelectionViewController.h"

#pragma mark - Defines

#define RM_DATE_PICKER_HEIGHT_PORTRAIT 216
#define RM_DATE_PICKER_HEIGHT_LANDSCAPE 162

#if !__has_feature(attribute_availability_app_extension)
//Normal App
#define RM_CURRENT_ORIENTATION_IS_LANDSCAPE_PREDICATE UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)
#else
//App Extension
#define RM_CURRENT_ORIENTATION_IS_LANDSCAPE_PREDICATE [UIScreen mainScreen].bounds.size.height < [UIScreen mainScreen].bounds.size.width
#endif

#pragma mark - Interfaces

@interface RMDateSelectionViewController ()

@property (nonatomic, readwrite) UIDatePicker *datePicker;
@property (nonatomic, weak) NSLayoutConstraint *datePickerHeightConstraint;

@end

#pragma mark - Implementations

@implementation RMDateSelectionViewController

#pragma mark - Init and Dealloc
- (instancetype)initWithStyle:(RMActionControllerStyle)aStyle title:(NSString *)aTitle message:(NSString *)aMessage selectAction:(RMAction *)selectAction andCancelAction:(RMAction *)cancelAction {
    self = [super initWithStyle:aStyle title:aTitle message:aMessage selectAction:selectAction andCancelAction:cancelAction];
    if(self) {
        self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectZero];
        self.datePicker.translatesAutoresizingMaskIntoConstraints = NO;

//        self.datePicker.backgroundColor = [UIColor whiteColor];
        //设置地区: zh-中国
        self.datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
        
        //设置日期模式(Displays month, day, and year depending on the locale setting)
        self.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        // 设置当前显示时间
        [self.datePicker setDate:[NSDate date] animated:YES];
        // 设置显示最大时间（90d）
        NSDate *today = [NSDate dateWithTimeIntervalSinceNow:7776000];
        
        [self.datePicker setMaximumDate:today];
        [self.datePicker setMinimumDate:[NSDate dateWithTimeIntervalSinceNow:0]];
        self.datePickerHeightConstraint = [NSLayoutConstraint constraintWithItem:self.datePicker attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:0];
        
        if(RM_CURRENT_ORIENTATION_IS_LANDSCAPE_PREDICATE) {
            self.datePickerHeightConstraint.constant = RM_DATE_PICKER_HEIGHT_LANDSCAPE;
        } else {
            self.datePickerHeightConstraint.constant = RM_DATE_PICKER_HEIGHT_PORTRAIT;
        }
        
        [self.datePicker addConstraint:self.datePickerHeightConstraint];
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRotate) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    
    [super viewDidDisappear:animated];
}

#pragma mark - Orientation
- (void)didRotate {
    NSTimeInterval duration = 0.4;
    
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        duration = 0.3;
        
        if(RM_CURRENT_ORIENTATION_IS_LANDSCAPE_PREDICATE) {
            self.datePickerHeightConstraint.constant = RM_DATE_PICKER_HEIGHT_LANDSCAPE;
        } else {
            self.datePickerHeightConstraint.constant = RM_DATE_PICKER_HEIGHT_PORTRAIT;
        }
        
        [self.datePicker setNeedsUpdateConstraints];
        [self.datePicker layoutIfNeeded];
    }
    
    [self.view.superview setNeedsUpdateConstraints];
    __weak RMDateSelectionViewController *blockself = self;
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        [blockself.view.superview layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
}

#pragma mark - Properties
- (UIView *)contentView {
    return self.datePicker;
}

@end
