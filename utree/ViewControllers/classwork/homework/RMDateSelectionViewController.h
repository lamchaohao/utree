//
//  RMDateSelection.h
//  utree
//
//  Created by 科研部 on 2019/12/27.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "BaseSecondVC.h"

#import "RMActionController.h"

/**
 *  RMDateSelectionViewController is an iOS control for selecting a date using UIDatePicker in a UIActionSheet like fashon. When a RMDateSelectionViewController is shown the user gets the opportunity to select a date using a UIDatePicker.
 *
 *  RMDateSelectionViewController supports bouncing effects when animating the date selection view controller. In addition, motion effects are supported while showing the date selection view controller. Both effects can be disabled by using the properties called disableBouncingWhenShowing and disableMotionEffects.
 *
 *  On iOS 8 and later Apple opened up their API for blurring the background of UIViews. RMDateSelectionViewController makes use of this API. The type of the blur effect can be changed by using the blurEffectStyle property. If you want to disable the blur effect you can do so by using the disableBlurEffects property.
 *
 *  @warning RMDateSelectionViewController is not designed to be reused. Each time you want to display a RMDateSelectionViewController a new instance should be created. If you want to set a specific date before displaying, you can do so by using the datePicker property.
 */
@interface RMDateSelectionViewController : RMActionController <UIDatePicker *>

/**
 *  The UIDatePicker instance used by RMDateSelectionViewController.
 *
 *  Use this property to access the date picker and to set options like minuteInterval and others.
 */
@property (nonatomic, readonly) UIDatePicker *datePicker;

@end
