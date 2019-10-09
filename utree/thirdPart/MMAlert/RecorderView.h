//
//  RecorderView.h
//  utree
//
//  Created by 科研部 on 2019/9/30.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "MMPopupView.h"
#import "MMAlertView.h"
#import "LVRecordTool.h"
NS_ASSUME_NONNULL_BEGIN
@protocol RecorderViewDelegate <NSObject>

@optional
- (void)recordOver:(NSString *)filePath duration:(NSString *)duration;

@end

@interface RecorderView : UIView
@property(nonatomic,strong)MyLinearLayout *contentView;
@property(nonatomic,strong)UILabel *topLabel;
@property(nonatomic,strong)UIButton *recordBtn;
@property(nonatomic,strong)UILabel *bottomLabel;
//@property(nonatomic,strong)UIButton *stopBtn;
@property (nonatomic, assign) id<RecorderViewDelegate> delegate;


- (void)showAlert;
- (void)dismissAlert;


@end

NS_ASSUME_NONNULL_END
