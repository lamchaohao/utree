//
//  NoticeViewModel.m
//  utree
//
//  Created by 科研部 on 2019/8/30.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "NoticeViewModel.h"

@implementation NoticeViewModel

- (void)setNotice:(NoticeModel *)notice
{
    _notice = notice;
    if ([notice.teacherDo.teacherId isEqualToString:self.userId]&&notice.needReceipt.boolValue) {
        self.isNeedSummaryCount = YES;
    }
    //计算主体Frame
    [self setBodyFrames];
    //计算CellHeight
    [self setCellHeight];

}


//计算Code圈主体Frame
- (void)setBodyFrames{
    
    self.headDataFrame = (CGRect){{0,0},{0,65}};

    //标题
    CGFloat topicY = CGRectGetMaxY(self.headDataFrame)+circleCellMargin;

    CGSize topicSize = [self stringSizeWithFont:circleCellTextFont str:[NSString stringWithFormat:@"标题:%@",self.notice.topic] maxWidth:circleCellWidth maxHeight:MAXFLOAT];
    topicSize.height = ceil(topicSize.height) + 15;
    self.titleTextFrame = (CGRect){{circleCellMargin,topicY},topicSize};
    
    //正文
    CGFloat textX = circleCellMargin;
    CGFloat textY = CGRectGetMaxY(self.titleTextFrame) + circleCellMargin;
    CGFloat textW = circleCellWidth;
//    CGSize textSize = [self.notice.content boundingRectWithSize:CGSizeMake(textW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:circleCellTextattributes context:nil].size;
//    textSize.height+=20;
    NSString *textToshow = @"";
    if(self.notice.content.length>100){
        textToshow =[[self.notice.content substringToIndex:100] stringByAppendingFormat:@"..."];
    }else{
        textToshow =self.notice.content;
    }
    CGSize textSize = [self stringSizeWithFont:circleCellTextFont str:textToshow maxWidth:circleCellWidth maxHeight:MAXFLOAT];
    textSize.height = ceil(textSize.height) + 1;
    self.detailTextFrame = (CGRect){{textX,textY},textSize};
    
    //录音(判断是否有录音)
    CGFloat audioX = circleCellMargin;
    CGFloat audioY = CGRectGetMaxY(self.detailTextFrame);
    CGFloat audioW = circleCellWidth;
    
    if (self.notice.audio) {
        audioY += circleCellMargin;
        self.bodyAudioFrame = CGRectMake(audioX, audioY, audioW, 40);
    }else{
        self.bodyAudioFrame = CGRectMake(audioX, audioY, audioW, 0);
    }
    
    CGFloat theLastHeight = CGRectGetMaxY(self.bodyAudioFrame)+circleCellMargin;
    //图片 (判断是否有图片)
    if ([self.notice.picList count] != 0) {
        CGFloat photosX = circleCellMargin;
        CGFloat photosY = theLastHeight;
        CGFloat photosW = textW;
        if ([self.notice.picList count] > 3) {//分两行或三行
            if ([self.notice.picList count] > 6) {
                CGFloat photosH = circleCellPhotosWH * 3 + circleCellPhotosMargin*2;
                self.bodyPhotoFrame = CGRectMake(photosX, photosY, photosW, photosH);
            }else{
                CGFloat photosH = circleCellPhotosWH * 2 + circleCellPhotosMargin;
                self.bodyPhotoFrame = CGRectMake(photosX, photosY, photosW, photosH);
            }
           
        }else{
            if ([self.notice.picList count]==1) {
                CGFloat photosH = circleCellPhotosWH*1.5;
                self.bodyPhotoFrame = CGRectMake(photosX, photosY, circleCellPhotosWH*2.5, photosH);
            }else{
                CGFloat photosH = circleCellPhotosWH;
                self.bodyPhotoFrame = CGRectMake(photosX, photosY, photosW, photosH);
            }
           
        }
        //主体frame
        CGFloat bodyH = CGRectGetMaxY(self.bodyPhotoFrame);
        self.noticeBodyFrame = CGRectMake(0, 0, circleCellWidth, bodyH);
    }else{
        //主体frame
        CGFloat bodyH = theLastHeight;
        self.noticeBodyFrame = CGRectMake(0, 0, circleCellWidth, bodyH);
    }
    //判断是否有链接
    if (self.notice.link&&self.notice.link.length>0) {
        CGFloat linkY= CGRectGetMaxY(self.noticeBodyFrame) + circleCellMargin;
        CGFloat linkW = circleCellWidth;
        CGFloat linkH = 56;
        self.bodyWeblinkFrame =CGRectMake(0, linkY, linkW, linkH);
        
        CGFloat bodyH = CGRectGetMaxY(self.bodyWeblinkFrame);
        self.noticeBodyFrame = CGRectMake(0, 0, circleCellWidth, bodyH);
    }
    
}


- (void)setCellHeight{
    CGFloat summaryHeight = circleCellMargin;
    if (self.isNeedSummaryCount) {
        summaryHeight += circleCellToolBarHeight;
    }
    self.cellHeight = CGRectGetMaxY(self.noticeBodyFrame)+summaryHeight;
}


- (CGSize)stringSizeWithFont:(UIFont *)font str:(NSString*)str maxWidth:(CGFloat)maxWidth maxHeight:(CGFloat)maxHeight
{
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    CGSize maxSize = CGSizeMake(maxWidth, maxHeight);
    attr[NSFontAttributeName] = font;
    return [str boundingRectWithSize:maxSize options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attr context:nil].size;
    
}

@end
