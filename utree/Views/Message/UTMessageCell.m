//
//  UTMessageCell.m
//  utree
//
//  Created by 科研部 on 2019/12/17.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "UTMessageCell.h"
#import "UTMessage.h"
#import "UTMessageFrame.h"
#import "UUAVAudioPlayer.h"
#import "UIImageView+AFNetworking.h"
#import "UIButton+AFNetworking.h"
#import "UUImageAvatarBrowser.h"
#import "UUChatCategory.h"
#import "UTPicBrowserVC.h"


@interface UTMessageCell ()
{

    UIView *_headImageBackView;
    
}

@property (nonatomic, strong) UILabel *dateLabel;
//@property (nonatomic, strong) UILabel *namelabel;
@property (nonatomic, strong) UIButton *headImageButton;
@property (nonatomic, assign) BOOL contentVoiceIsPlaying;

@end

@implementation UTMessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // 1、创建时间
        self.dateLabel = [[UILabel alloc] init];
        self.dateLabel.textAlignment = NSTextAlignmentCenter;
        self.dateLabel.textColor = [UIColor grayColor];
        self.dateLabel.font = ChatTimeFont;
        [self.contentView addSubview:self.dateLabel];
        
        // 2、创建头像
        _headImageBackView = [[UIView alloc]init];
        _headImageBackView.layer.cornerRadius = 22;
        _headImageBackView.layer.masksToBounds = YES;
        _headImageBackView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.4];
        [self.contentView addSubview:_headImageBackView];
        self.headImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.headImageButton.layer.cornerRadius = 20;
        self.headImageButton.layer.masksToBounds = YES;
        [self.headImageButton addTarget:self action:@selector(btnHeadImageClick:)  forControlEvents:UIControlEventTouchUpInside];
        [_headImageBackView addSubview:self.headImageButton];
        
        // 3、创建头像下标
//        self.namelabel = [[UILabel alloc] init];
//        self.namelabel.textColor = [UIColor grayColor];
//        self.namelabel.textAlignment = NSTextAlignmentCenter;
//        self.namelabel.font = ChatTimeFont;
//        self.namelabel.numberOfLines = 0;
//        [self.contentView addSubview:self.namelabel];
        
        // 4、创建内容
        self.btnContent = [UUMessageContentButton buttonWithType:UIButtonTypeCustom];
        [self.btnContent setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.btnContent.titleLabel.font = ChatContentFont;
        self.btnContent.titleLabel.numberOfLines = 0;
        [self.btnContent addTarget:self action:@selector(btnContentClick)  forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.btnContent];
        
        _contentVoiceIsPlaying = NO;
        
    }
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
}

//头像点击
- (void)btnHeadImageClick:(UIButton *)button{
    if ([self.delegate respondsToSelector:@selector(chatCell:headImageDidClick:)])  {
        [self.delegate chatCell:self headImageDidClick:self.messageFrame.message.accountId];
    }
}

- (void)btnContentClick{
    //play audio
    if (self.messageFrame.message.type == UTMessageTypeVoice) {
        [self.delegate onCellMediaClick:self];
    }
    //show the picture
    else if (self.messageFrame.message.type == UTMessageTypePicture)
    {
        if (self.btnContent.backImageView) {
//            [UUImageAvatarBrowser showImage:self.btnContent.backImageView];
//            [UTPicBrowserVC showImage:self.messageFrame.message.picUrl sourceImg:self.btnContent.backImageView];
            
            PYPhotoBrowseView *photoBroseView = [[PYPhotoBrowseView alloc] init];
            // 2.1 设置图片源(UIImageView)数组
            photoBroseView.sourceImgageViews = [NSArray arrayWithObject:self.btnContent.backImageView];
            // 2.2 设置初始化图片下标（即当前点击第几张图片）
            photoBroseView.currentIndex = 0;
            // 3.显示(浏览)
            [photoBroseView show];
        }
        if ([self.delegate isKindOfClass:[UIViewController class]]) {
            [[(UIViewController *)self.delegate view] endEditing:YES];
        }
    }
    // show text and gonna copy that
    else if (self.messageFrame.message.type == UTMessageTypeText)
    {
        [self.btnContent becomeFirstResponder];
        UIMenuController *menu = [UIMenuController sharedMenuController];
        [menu setTargetRect:self.btnContent.frame inView:self.btnContent.superview];
        [menu setMenuVisible:YES animated:YES];
    }
}



//内容及Frame设置
- (void)setMessageFrame:(UTMessageFrame *)messageFrame
{
    _messageFrame = messageFrame;
    UTMessage *message = messageFrame.message;
    
    // 1、设置时间
    self.dateLabel.text = message.timeForShow;
    self.dateLabel.frame = messageFrame.timeF;
    // 2、设置头像
    _headImageBackView.frame = messageFrame.iconF;
    self.headImageButton.frame = CGRectMake(0, 0, ChatIconWH, ChatIconWH+2);
    [self.headImageButton setBackgroundImageForState:UIControlStateNormal
                                          withURL:[NSURL URLWithString:message.headPicUrl]
                                 placeholderImage:[UIImage imageNamed:@"default_head"]];
    
    // 3、设置下标
//    self.namelabel.text = @" ";//不需要显示
//    self.namelabel.frame = messageFrame.nameF;
    
    // 4、设置内容
    [self.btnContent setTitle:@"" forState:UIControlStateNormal];
    self.btnContent.voiceBackView.hidden = YES;
    self.btnContent.backImageView.hidden = YES;
    
    self.btnContent.frame = messageFrame.contentF;
    
    if (message.from == UTMessageFromMe) {
        self.btnContent.isMyMessage = YES;
        [self.btnContent setTitleColor:[UIColor myColorWithHexString:@"#4D4D4D"] forState:UIControlStateNormal];
        self.btnContent.titleEdgeInsets = UIEdgeInsetsMake(ChatContentTopBottom, ChatContentSmaller, ChatContentTopBottom, ChatContentBiger);
    } else {
        self.btnContent.isMyMessage = NO;
        [self.btnContent setTitleColor:[UIColor myColorWithHexString:@"#4D4D4D"] forState:UIControlStateNormal];
        self.btnContent.titleEdgeInsets = UIEdgeInsetsMake(ChatContentTopBottom, ChatContentBiger, ChatContentTopBottom, ChatContentSmaller);
    }
    
    //背景气泡图
    UIImage *normal;
    if (message.from == UTMessageFromMe) {
        normal = [UIImage uu_imageWithName:@"chat_bubble_green"];
        normal = [normal resizableImageWithCapInsets:UIEdgeInsetsMake(35, 10, 10, 10)];
    }
    else{
        normal = [UIImage uu_imageWithName:@"chat_bubble_white"];
        normal = [normal resizableImageWithCapInsets:UIEdgeInsetsMake(35, 22, 10, 10)];
    }
    [self.btnContent setBackgroundImage:normal forState:UIControlStateNormal];
    [self.btnContent setBackgroundImage:normal forState:UIControlStateHighlighted];
    
    switch (message.type) {
        case UTMessageTypeText:
            [self.btnContent setTitle:message.contentStr forState:UIControlStateNormal];
            break;
        case UTMessageTypePicture:
        {
            self.btnContent.backImageView.hidden = NO;
            if(message.sendStatus==UTStatusSending){
                 self.btnContent.backImageView.image = message.picture;
            }else{
                 [self.btnContent.backImageView sd_setImageWithURL:[NSURL URLWithString:message.picUrl] placeholderImage:[UIImage uu_imageWithColor:[UIColor grayColor]]];
            }
           
            self.btnContent.backImageView.frame = CGRectMake(0, 0, self.btnContent.frame.size.width, self.btnContent.frame.size.height);
            [self makeMaskView:self.btnContent.backImageView withImage:normal];
        }
            break;
        case UTMessageTypeVoice:
        {
            self.btnContent.voiceBackView.hidden = NO;
            self.btnContent.second.textColor = [UIColor myColorWithHexString:@"#4D4D4D"];
            self.btnContent.second.text = [NSString stringWithFormat:@"%@'s",message.voiceDuration];
        }
            break;
            
        default:
            break;
    }
}

- (void)makeMaskView:(UIView *)view withImage:(UIImage *)image
{
    UIImageView *imageViewMask = [[UIImageView alloc] initWithImage:image];
    imageViewMask.frame = CGRectInset(view.frame, 0.0f, 0.0f);
    view.layer.mask = imageViewMask.layer;
}



@end


