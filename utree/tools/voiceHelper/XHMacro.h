//
//  XHMacro.h
//  utree
//
//  Created by 科研部 on 2019/9/30.
//  Copyright © 2019 科研部. All rights reserved.
//

#ifndef XHMacro_h
#define XHMacro_h

#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DLog(...)
#endif

// block self
#define WEAKSELF typeof(self) __weak weakSelf = self;
#define STRONGSELF typeof(weakSelf) __strong strongSelf = weakSelf;

// device verson float value
#define CURRENT_SYS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

// Max record Time
#define kVoiceRecorderTotalTime 120.0


#endif /* XHMacro_h */
