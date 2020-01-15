//
//  HomeworkViewModel.m
//  utree
//
//  Created by 科研部 on 2019/11/26.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "HomeworkViewModel.h"

@implementation HomeworkViewModel

- (void)setTaskModelToCaculate:(HomeworkModel *)task
{
    self.taskModel = task;
    if ([task.teacherDo.teacherId isEqualToString:self.userId]) {
        self.isNeedSummaryCount = YES;
    }
    //计算主体Frame
    [self setMomentsBodyFrames];
    //计算CellHeight
    [self setCellHeight];

}


//计算Code圈主体Frame
- (void)setMomentsBodyFrames{
    
    self.headDataFrame = (CGRect){{0,0},{0,50}};
    //科目
    CGFloat subjectY = CGRectGetMaxY(self.headDataFrame) + circleContentTextMargin;
    CGSize subjectSize = [self.taskModel.topic boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:circleCellTimeattributes context:nil].size;
    CGRect subjectFrame = (CGRect){{0,subjectY},subjectSize};
    
    
    CGFloat topicY = CGRectGetMaxY(subjectFrame) + circleContentTextMargin;
    CGSize topicSize = [self.taskModel.topic boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:circleCellTimeattributes context:nil].size;
    
    CGRect titleFrame = (CGRect){{0,topicY},topicSize};
    
    //正文
    CGFloat textX = circleCellMargin;
    CGFloat textY = CGRectGetMaxY(titleFrame) + circleContentTextMargin;
    CGFloat textW = circleCellWidth;
    
    NSString *textToshow = @"";
    if(self.taskModel.content.length>100){
        textToshow =[[self.taskModel.content substringToIndex:100] stringByAppendingFormat:@"..."];
    }else{
        textToshow =self.taskModel.content;
    }
    
    CGSize textSize = [textToshow boundingRectWithSize:CGSizeMake(textW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:circleCellTextattributes context:nil].size;
    textSize.height = ceil(textSize.height) + 1;
    self.detailTextFrame = (CGRect){{textX,textY},textSize};
    //录音(判断是否有录音)
    if (self.taskModel.audio) {
        self.bodyAudioFrame = CGRectMake(0, circleContentTextMargin, 0, 40);
    }
    
    CGFloat theLastHeight =CGRectGetMaxY(self.detailTextFrame) + circleCellMargin+ CGRectGetHeight(self.bodyAudioFrame)+circleContentTextMargin;
    //图片 (判断是否有图片)
    if ([self.taskModel.picList count] != 0) {
        CGFloat photosX = circleCellMargin;
        CGFloat photosY = theLastHeight;
        CGFloat photosW = textW;
        if ([self.taskModel.picList count] > 3) {//分两行或三行
            if ([self.taskModel.picList count] > 6) {
                CGFloat photosH = circleCellPhotosWH * 3 + circleCellPhotosMargin*2;
                self.bodyPhotoFrame = CGRectMake(photosX, photosY, photosW, photosH);
            }else{
                CGFloat photosH = circleCellPhotosWH * 2 + circleCellPhotosMargin;
                self.bodyPhotoFrame = CGRectMake(photosX, photosY, photosW, photosH);
            }
           
        }else{
            if ([self.taskModel.picList count]==1) {
                CGFloat photosH = circleCellPhotosWH*1.5;
                self.bodyPhotoFrame = CGRectMake(photosX, photosY, circleCellPhotosWH*2.5, photosH);
            }else{
                CGFloat photosH = circleCellPhotosWH;
                self.bodyPhotoFrame = CGRectMake(photosX, photosY, photosW, photosH);
            }
           
        }
        //主体frame
        CGFloat bodyH = CGRectGetMaxY(self.bodyPhotoFrame);
        self.taskBodyFrame = CGRectMake(0, 0, circleCellWidth, bodyH);
    }else{
        //主体frame
        CGFloat bodyH = theLastHeight;
        self.taskBodyFrame = CGRectMake(0, 0, circleCellWidth, bodyH);
    }
    //判断是否有链接
    if (self.taskModel.link&&self.taskModel.link.length>0) {
       CGFloat linkY= CGRectGetMaxY(self.taskBodyFrame) + circleContentTextMargin;
       CGFloat linkW = ScreenWidth-30;
       CGFloat linkH = 56;
       self.bodyWeblinkFrame =CGRectMake(0, linkY, linkW, linkH);
       
       CGFloat bodyH = CGRectGetMaxY(self.bodyWeblinkFrame);
       self.taskBodyFrame = CGRectMake(0, 0, circleCellWidth, bodyH);
    }
    
    if (self.taskModel.video) {
        CGFloat videoY= CGRectGetMaxY(self.taskBodyFrame) + circleContentTextMargin;
        CGFloat videoW = ScreenWidth-30;
        CGFloat videoH = 56;
        self.bodyVideoFrame =CGRectMake(0, videoY, videoW, videoH);
        
        CGFloat bodyH = CGRectGetMaxY(self.bodyVideoFrame);
        self.taskBodyFrame = CGRectMake(0, 0, circleCellWidth, bodyH);
    }
    
    
}


- (void)setCellHeight{
    CGFloat summaryHeight = circleCellMargin;
    if (self.isNeedSummaryCount) {
        summaryHeight=circleCellToolBarHeight;
    }
    self.cellHeight = CGRectGetMaxY(self.taskBodyFrame)+summaryHeight;
}

@end
