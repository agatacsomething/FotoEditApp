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
    
    NSLog(@"trying out tilingFilter");
    
    MatConverter* mc = [[MatConverter alloc] init];
    cv::Mat img_orig = [mc cvMatFromUIImage:image];
    
    int w = image.size.width; //CGImageGetWidth(imageRef);
    int h = image.size.height; //CGImageGetHeight(imageRef);
    
    int num_tiles_x = 2;
    int num_tiles_y = 3;
    int total_tiles = num_tiles_x*num_tiles_y;
    int border = 5;
    int total_black = border*2;
    //int buffer =total_black/(num_tiles_x+1);
    

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
    
    for(int i =0 ; i<num_tiles_x; i++){
        for(int j =0 ; j<num_tiles_y; j++){
            img_small.copyTo(cv::Mat(img_new, cv::Rect(i*(cw+(buffer))+buffer, j*(ch+(buffer))+buffer, cw, ch)));
        }
    }
    
    UIImage* outImage = [mc UIImageFromCVMat: img_new];
    
    return outImage;
    
}

- (UIImage*)tilingFilterWflips:(UIImage *)image{
    
    NSLog(@"trying out tilingFilterWflips");
    
    MatConverter* mc = [[MatConverter alloc] init];
    cv::Mat img_orig = [mc cvMatFromUIImage:image];
    
    int w = image.size.width; //CGImageGetWidth(imageRef);
    int h = image.size.height; //CGImageGetHeight(imageRef);
    
    int num_tiles_x = 2;
    int num_tiles_y = 2;
    int total_tiles = num_tiles_x*num_tiles_y;
    int border = 5;
    int total_black = border*2;
    //int buffer =total_black/(num_tiles_x+1);
    
    
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

    img_small.copyTo(cv::Mat(img_new, cv::Rect(buffer, buffer, cw, ch)));
    cv::Mat y_flip;
    cv::flip(img_small, y_flip, 1);
    y_flip.copyTo(cv::Mat(img_new, cv::Rect(cw+2*buffer, buffer, cw, ch)));
    cv::Mat x_flip;
    cv::flip(img_small, x_flip, 0);
    x_flip.copyTo(cv::Mat(img_new, cv::Rect(buffer, ch+2*buffer, cw, ch)));
    cv::Mat xy_flip;
    cv::flip(img_small, xy_flip, -1);
    xy_flip.copyTo(cv::Mat(img_new, cv::Rect(cw+2*buffer, ch+2*buffer, cw, ch)));


//    img_small.copyTo(cv::Mat(img_new, cv::Rect(i*(cw+(buffer))+buffer, j*(ch+(buffer))+buffer, cw, ch)));

    //img_small.copyTo(cv::Mat(cv::flip(img_new, img_new, 1), cv::Rect(buffer, ch+2*buffer, cw, ch));


    
//    for(int i =0 ; i<num_tiles_x; i++){
//        for(int j =0 ; j<num_tiles_y; j++){
//        }
//    }
    
    UIImage* outImage = [mc UIImageFromCVMat: img_new];
    
    return outImage;
    
}



@end