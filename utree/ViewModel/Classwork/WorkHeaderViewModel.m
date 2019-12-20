//
//  WorkHeaderViewModel.m
//  utree
//
//  Created by 科研部 on 2019/12/2.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "WorkHeaderViewModel.h"
#import "NoticeModel.h"
@implementation WorkHeaderViewModel

- (void)setTaskModelToCaculate:(HomeworkModel *)task
{
    self.taskModel = task;
    //计算主体Frame
    [self setMomentsBodyFrames];
    //计算工具条Frame
    [self setMomentsToolBarFrames];
    //计算CellHeight
    [self setCellHeight];

}

-(void)setNoticeToCaculate:(NoticeModel *)notice
{
    
    self.taskModel = [[HomeworkModel alloc]init];
    self.taskModel.audio=notice.audio;
    self.taskModel.picList=notice.picList;
    self.taskModel.topic = notice.topic;
    self.taskModel.teacherDo = notice.teacherDo;
    self.taskModel.content=notice.content;
    self.taskModel.picPath=notice.picPath;
    self.taskModel.createTime = notice.createTime;
    self.taskModel.link = notice.link;
    
    //计算主体Frame
    [self setMomentsBodyFrames];
    //计算工具条Frame
    [self setMomentsToolBarFrames];
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
    CGFloat textX = 0;
    CGFloat textY = CGRectGetMaxY(titleFrame) + circleContentTextMargin;
    CGFloat textW = circleCellWidth-2*circleCellMargin;
    CGSize textSize = [self.taskModel.content boundingRectWithSize:CGSizeMake(textW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:circleCellTextattributes context:nil].size;
    self.detailTextFrame = (CGRect){{textX,textY},{textSize.width,textSize.height+24}};
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
        self.contentBodyFrame = CGRectMake(0, 0, circleCellWidth, bodyH);
    }else{
        //主体frame
        CGFloat bodyH = theLastHeight;
        self.contentBodyFrame = CGRectMake(0, 0, circleCellWidth, bodyH);
    }
    //判断是否有链接
    if (self.taskModel.link) {
       CGFloat linkY= CGRectGetMaxY(self.contentBodyFrame) + circleContentTextMargin;
       CGFloat linkW = ScreenWidth-30;
       CGFloat linkH = 56;
       self.bodyWeblinkFrame =CGRectMake(0, linkY, linkW, linkH);
       
       CGFloat bodyH = CGRectGetMaxY(self.bodyWeblinkFrame);
       self.contentBodyFrame = CGRectMake(0, 0, circleCellWidth, bodyH);
    }
    
    if (self.taskModel.video) {
        CGFloat videoY= CGRectGetMaxY(self.contentBodyFrame) + circleContentTextMargin;
        CGFloat videoW = ScreenWidth-30;
        CGFloat videoH = 56;
        self.bodyVideoFrame =CGRectMake(0, videoY, videoW, videoH);
        
        CGFloat bodyH = CGRectGetMaxY(self.bodyVideoFrame);
        self.contentBodyFrame = CGRectMake(0, 0, circleCellWidth, bodyH);
    }
    
    
}

//计算Code圈工具条Frame
- (void)setMomentsToolBarFrames{
    //工具条frame
    CGFloat toolBarX = 0;
    CGFloat toolBarY = CGRectGetMaxY(self.contentBodyFrame);
    CGFloat toolBarW = circleCellWidth;
    CGFloat toolBarH = circleCellToolBarHeight;
    self.taskToolBarFrame = CGRectMake(toolBarX, toolBarY, toolBarW, toolBarH);
    
    
}

- (void)setCellHeight{
    self.cellHeight = CGRectGetMaxY(self.taskToolBarFrame);
}


@end
