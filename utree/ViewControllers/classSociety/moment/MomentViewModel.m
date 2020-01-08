//
//  MomentViewModel.m
//  utree
//
//  Created by 科研部 on 2019/9/4.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "MomentViewModel.h"

@implementation MomentViewModel

- (void)setMomentModel:(MomentModel *)momentModel
{
    _momentModel = momentModel;
    //计算主体Frame
    [self setMomentsBodyFrames];
    //计算工具条Frame
    [self setMomentsToolBarFrames];
    //计算CellHeight
    [self setCellHeight];
}



//计算Code圈主体Frame
- (void)setMomentsBodyFrames{
    self.topFrame = CGRectMake(0, circleCellMargin, ScreenWidth, 50);
    
    //正文
    CGFloat textX = circleCellMargin;
    CGFloat textY = CGRectGetMaxY(self.topFrame) + circleCellMargin;
    CGFloat textW = circleCellWidth;
    CGSize textSize = [self.momentModel.content boundingRectWithSize:CGSizeMake(textW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:circleCellTextattributes context:nil].size;
    self.bodyTextFrame = (CGRect){{textX,textY},textSize};
    
    //图片 (判断是否有图片)
    if ([self.momentModel.picList count] != 0) {
        CGFloat photosX = circleCellMargin;
        CGFloat photosY = CGRectGetMaxY(self.bodyTextFrame) + circleCellMargin;
        CGFloat photosW = circleCellWidth;
        if ([self.momentModel.picList count] > 3) {
            
            if ([self.momentModel.picList count] > 6) {
                CGFloat photosH = circleCellPhotosWH * 3 + circleCellPhotosMargin*2;
                self.bodyPhotoFrame = CGRectMake(photosX, photosY, photosW, photosH);
            }else{
                CGFloat photosH = circleCellPhotosWH * 2 + circleCellPhotosMargin;
                self.bodyPhotoFrame = CGRectMake(photosX, photosY, photosW, photosH);
            }
        }else{
            if ([self.momentModel.picList count]==1) {//1张
                CGFloat photosH = circleCellPhotosWH*1.5;
                self.bodyPhotoFrame = CGRectMake(photosX, photosY, circleCellPhotosWH*2.5, photosH);
            }else {//2,3张
                CGFloat photosH = circleCellPhotosWH;
                self.bodyPhotoFrame = CGRectMake(photosX, photosY, photosW, photosH);
            }
            
        }
        
        //主体frame
        CGFloat bodyH = CGRectGetMaxY(self.bodyPhotoFrame);
        self.momentsBodyFrame = CGRectMake(0, 0, circleCellWidth, bodyH);
    }else{
        //主体frame
        CGFloat bodyH = CGRectGetMaxY(self.bodyTextFrame) + circleCellMargin;
        self.momentsBodyFrame = CGRectMake(0, 0, circleCellWidth, bodyH);
    }
    
    if (self.momentModel.video) {
        CGFloat videoY= CGRectGetMaxY(self.momentsBodyFrame) + circleCellMargin;
        CGFloat videoH = 9*20;
        CGFloat videoW = 16*20;
        if (self.momentModel.video.videoHeight<self.momentModel.video.videoWidth) {
           //横屏
           self.bodyVideoFrame =CGRectMake(0, videoY, videoW, videoH);
        }else{
            //竖屏,为了cell的高度更新不要太频繁，所以设置为正方形,MomentDetail里的宽高与此不同
            self.bodyVideoFrame =CGRectMake(0, videoY, videoH, videoH);
        }
        
        CGFloat bodyH = CGRectGetMaxY(self.bodyVideoFrame);
        self.momentsBodyFrame = CGRectMake(0, 0, circleCellWidth, bodyH);
    }
    
    
}

//计算Code圈工具条Frame
- (void)setMomentsToolBarFrames{
    //工具条frame
    CGFloat toolBarX = 0;
    CGFloat toolBarY = CGRectGetMaxY(self.momentsBodyFrame)+circleCellMargin;
    CGFloat toolBarW = circleCellWidth;
    CGFloat toolBarH = circleCellToolBarHeight;
    self.momentsToolBarFrame = CGRectMake(toolBarX, toolBarY, toolBarW, toolBarH);
}

- (void)setCellHeight{
    self.cellHeight = CGRectGetMaxY(self.momentsToolBarFrame);
}
@end
