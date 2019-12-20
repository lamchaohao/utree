//
//  CommentCellViewModel.m
//  utree
//
//  Created by 科研部 on 2019/11/21.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "CommentCellViewModel.h"

@implementation CommentCellViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.headViewFrame = CGRectMake(0, 0, 48, 48);
        self.writerLabelFrame=CGRectMake(8, 12, 60, 20);
        self.timeLabelFrame =CGRectMake(8, 12, 60, 20);
        self.commentDetailFrame =CGRectMake(8, 8, ScreenWidth-140, 320);
        self.commentBodyFrame = CGRectMake(0, 0, ScreenWidth-20, 320);
    }
    return self;
}

-(void)caculateFrameWith:(CommentModel *)comment
{
    self.commentModel = comment;
    
    
    CGFloat textX = circleCellMargin;
    CGFloat textY = CGRectGetMaxY(self.writerLabelFrame) +12+8;
//    CGFloat textW = circleCellWidth - circleCellMargin * 2;
    
    CGSize textSize = [self.commentModel.comment boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.commentDetailFrame), 5000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil].size;
    
    self.commentDetailFrame = (CGRect){{textX,textY},textSize};
    
    self.commentBodyFrame =CGRectMake(circleCellMargin, circleCellMargin, circleCellWidth, CGRectGetMaxY(self.commentDetailFrame)+8);
    
    self.cellHeight = CGRectGetMaxY(self.commentBodyFrame);
    
}



@end
