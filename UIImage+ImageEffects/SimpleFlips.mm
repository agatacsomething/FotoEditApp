//
//  BilateralFilters.m
//  BlurDemo
//
//  Created by Agata on 12/16/14.
//  Copyright (c) 2014 tutsPlus. All rights reserved.
//
#ifdef __cplusplus
#import "opencv.hpp"
#endif

#import "MatConverter.h"
#import "SimpleFlips.h"
#import <Foundation/Foundation.h>

@implementation UIImage (SimpleFlips)

- (UIImage*)centerFlip:(UIImage *)image{
    
    NSLog(@"trying out centerFlip");
    
    
    int w = image.size.width; //CGImageGetWidth(imageRef);
    int h = image.size.height; //CGImageGetHeight(imageRef);
    int center_x = w/2;
    int halfwidth= 20;
    int low_bound =center_x-halfwidth;
    int upper_bound =center_x+halfwidth;
    
    MatConverter* mc = [[MatConverter alloc] init];
    cv::Mat img_orig = [mc cvMatFromUIImage:image];
    
    cv::Mat img_new(img_orig.rows,img_orig.cols,CV_8UC3);
    
    std::cout << img_orig.type() << std::endl;

    for(int i = 0; i<img_orig.rows; i++){
        for(int j = 0; j<img_orig.cols; j++){
           for (int k = 0 ; k<3; k++){
               if (j<low_bound || j>upper_bound){
                   img_new.at<cv::Vec3b>(i,j)[k] = img_orig.at<cv::Vec4b>(i,j)[k];
               }
               else{
                   img_new.at<cv::Vec3b>(i,j)[k] = img_orig.at<cv::Vec4b>(h-i,j)[k];
               }
            }
        }
    }

    UIImage* outImage = [mc UIImageFromCVMat: img_new];
    
    return outImage;
    
}

- (UIImage*)tilingFilter:(UIImage *)image{
    
    NSLog(@"trying out centerFlip");
    
    
    //resize(src, dst, dst.size(), 0, 0, interpolation);
    
    int w = image.size.width; //CGImageGetWidth(imageRef);
    int h = image.size.height; //CGImageGetHeight(imageRef);
    int center_x = w/2;
    int halfwidth= 20;
    int low_bound =center_x-halfwidth;
    int upper_bound =center_x+halfwidth;
    
    MatConverter* mc = [[MatConverter alloc] init];
    cv::Mat img_orig = [mc cvMatFromUIImage:image];
    
    cv::Mat img_new(img_orig.rows,img_orig.cols,CV_8UC3);
    
    std::cout << img_orig.type() << std::endl;
    
    for(int i = 0; i<img_orig.rows; i++){
        for(int j = 0; j<img_orig.cols; j++){
            for (int k = 0 ; k<3; k++){
                if (j<low_bound || j>upper_bound){
                    img_new.at<cv::Vec3b>(i,j)[k] = img_orig.at<cv::Vec4b>(i,j)[k];
                }
                else{
                    img_new.at<cv::Vec3b>(i,j)[k] = img_orig.at<cv::Vec4b>(h-i,j)[k];
                }
            }
        }
    }
    
    UIImage* outImage = [mc UIImageFromCVMat: img_new];
    
    return outImage;
    
}



@end