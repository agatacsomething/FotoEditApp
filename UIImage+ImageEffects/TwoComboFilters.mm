//
//  TwoComboFilters.m
//  BlurDemo
//
//  Created by Agata on 12/23/14.
//  Copyright (c) 2014 tutsPlus. All rights reserved.
//

#ifdef __cplusplus
#import "opencv.hpp"
#endif

#import "MatConverter.h"
#import "TwoComboFilters.h"
#import "PopColor_ocv.h"
#import <Foundation/Foundation.h>

@implementation UIImage (TwoComboFilters)

- (UIImage*)tilingFilterWcolorswap:(UIImage *)image{
    
    NSLog(@"trying out tilingFilterWflips");
    
    MatConverter* mc = [[MatConverter alloc] init];
    cv::Mat img_orig = [mc cvMatFromUIImage:image];
    
    int w = image.size.width; //CGImageGetWidth(imageRef);
    int h = image.size.height; //CGImageGetHeight(imageRef);
    
    int num_tiles_x = 2;
    int num_tiles_y = 2;
    int border = 9;
    
    
    cv::Mat img_small;
    cv::Size size_small;
    size_small.width = w/num_tiles_x-border;
    size_small.height = h/num_tiles_y-border;
    
    int buffer =(w-size_small.width*num_tiles_x)/(num_tiles_x+1);
    
    cv::resize(img_orig, img_small, size_small, 0, 0, cv::INTER_LINEAR);
    
    cv::Mat img_new(img_orig.rows,img_orig.cols,CV_8UC4);
    
    std::cout << img_new.type() << img_small.type() << std::endl;
    
    int cw =size_small.width;
    int ch =size_small.height;
    
    //void flip(const Mat& src, Mat& dst, int flipCode)
    
    // void flip(const Mat& src, Mat& dst, int flipCode)
    
    
    PopColor_ocv* pc = [[PopColor_ocv alloc] init];
    cv::Mat color1 = [pc popColorSwitch_ocv:img_small:3];
    color1.copyTo(cv::Mat(img_new, cv::Rect(buffer, buffer, cw, ch)));
    
    cv::Mat color2 = [pc popColorSwitch_ocv:img_small:4];
    color2.copyTo(cv::Mat(img_new, cv::Rect(cw+2*buffer, buffer, cw, ch)));
    
    cv::Mat color3 = [pc popColorSwitch_ocv:img_small:7];
    color3.copyTo(cv::Mat(img_new, cv::Rect(buffer, ch+2*buffer, cw, ch)));
    
    cv::Mat color4 = [pc popColorSwitch_ocv:img_small:9];
    color4.copyTo(cv::Mat(img_new, cv::Rect(cw+2*buffer, ch+2*buffer, cw, ch)));
    
    
//    cv::Mat y_flip;
//    cv::flip(img_small, y_flip, 1);
//    
//    
//    y_flip.copyTo(cv::Mat(img_new, cv::Rect(cw+2*buffer, buffer, cw, ch)));
//    cv::Mat x_flip;
//    cv::flip(img_small, x_flip, 0);
//    x_flip.copyTo(cv::Mat(img_new, cv::Rect(buffer, ch+2*buffer, cw, ch)));
//    cv::Mat xy_flip;
//    cv::flip(img_small, xy_flip, -1);
//    xy_flip.copyTo(cv::Mat(img_new, cv::Rect(cw+2*buffer, ch+2*buffer, cw, ch)));
    
    
    UIImage* outImage = [mc UIImageFromCVMat: img_new];
    
    return outImage;
    
    }

@end
