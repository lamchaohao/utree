//
//  CFTool.m
//  utree
//
//  Created by 科研部 on 2019/9/25.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "CFTool.h"
#import "UTStudent.h"
@interface CFTool ()

@end

@implementation CFTool

+(UIColor*)color:(NSInteger)idx
{
    //执行颜色数组：
   static  unsigned char colors[][3] = {
        {0xED,0xED,0xED},   //0
        {0xFE,0xCE,0xA8},   //1
        {0xFF,0x84,0x7C},   //2
        {0xE8,0x4a,0x5f},   //3
        {0x2a,0x36,0x3b},   //4
        {0x87,0xce,0xbe},   //5
        {0x87,0xce,0xfa},   //6
        {0x00,0xbf,0xff},   //7
        {0xb0,0xe0,0xe6},   //8
        {0x1e,0x90,0xff},   //9
        {0xa6,0xf6,0xc1},   //10
        {0x31,0xa2,0x9d},   //11
        {0x4c,0x64,0x88},   //12
        {0x60,0x34,0x6e},   //13
        {0xf8,0xe7,0x9c},   //14
        {0x65,0x97,0xbc}    //15
    };
    
    return [UIColor colorWithRed:colors[idx][0]/255.0 green:colors[idx][1]/255.0 blue:colors[idx][2]/255.0 alpha:1];
}

+(UIFont*)font:(CGFloat)size
{
    
    UIFont *font =  [UIFont systemFontOfSize:size];
    return  font;
}

+(NSArray *)generateStudentsWithCapacity:(NSInteger)count
{
    NSArray *firstName = [[NSArray alloc]initWithObjects:@"王",@"赵",@"钱",@"孙",@"李",@"林",@"蓝",@"江",@"冯",@"郭",@"胡",nil];
    NSArray *secondWordName = [[NSArray alloc]initWithObjects:@"风",@"雪",@"护",@"布",@"楷",@"度",@"振",@"中",@"英",@"奋",@"山",@"民", nil];
    NSString *img1=@"https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=3890849514,2356481456&fm=26&gp=0.jpg";
    
    NSString *img2 =@"https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=3079978004,1988958416&fm=26&gp=0.jpg";
    NSString *img3 = @"https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=2074796092,772965255&fm=26&gp=0.jpg";
    
    NSString *img4 = @"https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=3235418159,1155486102&fm=26&gp=0.jpg";
    
    NSString *img5 =@"https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=3596160097,2341119804&fm=26&gp=0.jpg";
    
    NSString *img6 = @"https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=1766531566,1287358215&fm=26&gp=0.jpg";
    
    NSString *img7 =@"https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=3173569510,759255255&fm=15&gp=0.jpg";
    
    NSString *img8 = @"https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=4273792695,2454676093&fm=11&gp=0.jpg";
    
    NSString *img9=@"https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=2851238468,2653826075&fm=26&gp=0.jpg";
    NSString *img10 = @"https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=3240215558,3264545876&fm=26&gp=0.jpg";
    NSString *img11=@"https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=3390282514,1409134585&fm=26&gp=0.jpg";
    NSString *img12=@"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=3047739253,1622211647&fm=26&gp=0.jpg";
    NSString *img13=@"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=3053536160,220854969&fm=26&gp=0.jpg";
    
    
    NSArray *imgs = [NSArray arrayWithObjects:img1,img2,img3,img4,img5,img6,img7,img8 ,img9,img10,img11,img12,img13,nil];
    
    
    NSMutableArray *stuList = [NSMutableArray arrayWithCapacity:count];
    for (int start=0; start<count; start++) {
        char c = (char)(start+65);
        int sencondIndex = arc4random() % 12;
        int thirdIndex = arc4random() % 12;
        NSString *name =[NSString stringWithFormat:@"%c",c];
        NSString *catName = [NSString stringWithFormat:@"%@%@",name,@"联名"];
        if(start>26){
           int dela = start%11;
           NSString *firName= [firstName objectAtIndex:dela];
           catName =[NSString stringWithFormat:@"%@%@%@",firName,[secondWordName objectAtIndex:sencondIndex],[secondWordName objectAtIndex:thirdIndex]];
        }

        UTStudent *stu= [[UTStudent alloc]initWithStuName:catName andScore:35+start*10+start];
        stu.headImgURL = imgs[rand()%imgs.count];
        
        [stuList addObject:stu];
    }
    return stuList;
}

@end
