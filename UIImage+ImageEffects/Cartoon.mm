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
#import <Foundation/Foundation.h>

@implementation UIImage (BilateralFilters)

- (UIImage*)cartoonFilter:(UIImage *)image{
    
    NSLog(@"trying out cartoonFilter");
    

    int w = image.size.width; //CGImageGetWidth(imageRef);
    int h = image.size.height; //CGImageGetHeight(imageRef);
    
    cv::Size size;
    size.width = w;
    size.height = h;
    
    MatConverter* mc = [[MatConverter alloc] init];
    
    cv::Mat gray;
    cv::Mat img_orig = [mc cvMatFromUIImage:image];
    img_orig.convertTo(img_orig, CV_8UC3);
    
    cv::vector<cv::Mat> channels(4);
    cv::vector<cv::Mat> channels_out(3);
    cv::split(img_orig, channels);
    cv::Mat R, G, B;
    R=channels[0];
    G=channels[1];
    B=channels[2];
    channels_out[0] = R;
    channels_out[1] = G;
    channels_out[2] = B;
    cv::Mat img_3c;
    cv::merge(channels_out,img_3c);

    
    cv::Size smallsize;
    smallsize.width= w/2;
    smallsize.height= h/2;
    cv::Mat small_image (smallsize, CV_8UC3);
    cv::resize(img_3c,small_image, smallsize, 0,0, cv::INTER_LINEAR);
    
    cv::Mat temp (size, CV_8UC3);
    
    cv::Mat temp2;
    cv::Mat temp3;// = img_3c.clone();
    
    int reps = 7;
    for (int i = 0; i<reps; i++){
        int ksize = 9;
        double sigmaColor = 19;
        double sigmaSpace =7;
        cv::bilateralFilter(img_3c, temp2, ksize, sigmaColor, sigmaSpace);
        cv::bilateralFilter(temp2, img_3c, ksize, sigmaColor, sigmaSpace);
    }
    
    
    cv::cvtColor(temp2, gray, CV_RGB2GRAY);
    const int MEDIAN_BLUR_FILTER_SIZE = 7;
    cv::medianBlur(gray, gray, MEDIAN_BLUR_FILTER_SIZE);
    cv::Mat edges;
    const int LAPLACIAN_FILTER_SIZE =5;
    
    
    cv::Laplacian(gray, edges, CV_8U, LAPLACIAN_FILTER_SIZE);
    
    
//    
//    cv::Mat grad_x, grad_y;
//    cv::Mat abs_grad_x, abs_grad_y;
//    cv::Sobel( gray, grad_x, CV_8U, 1, 0, 3, 1, 0, cv::BORDER_DEFAULT );
//    cv::convertScaleAbs( grad_x, abs_grad_x );
//    
//    /// Gradient Y
//    //Scharr( src_gray, grad_y, ddepth, 0, 1, scale, delta, BORDER_DEFAULT );
//    Sobel( gray, grad_y, CV_8U, 0, 1, 3, 1, 0, cv::BORDER_DEFAULT );
//    convertScaleAbs( grad_y, abs_grad_y );
//    
//     addWeighted( abs_grad_x, 0.5, abs_grad_y, 0.5, 0, edges );
    
    cv::Mat mask;
    const int EDGES_THRESHOLD =100;
    cv::threshold(edges, mask, EDGES_THRESHOLD, 255, cv::THRESH_BINARY_INV);
    
    
    
//    cv::Mat bigImg, dst;
//    //cv::resize(small_image, bigImg, size, 0, 0, cv::INTER_LINEAR);
    temp3.setTo(0);
    temp2.copyTo(temp3, mask);
    cv::Mat temp4;
   // int reps = 7;
//    for (int i = 0; i<reps; i++){
//        int ksize = 9;
//        double sigmaColor = 19;
//        double sigmaSpace =7;
//        cv::bilateralFilter(temp3, temp4, ksize, sigmaColor, sigmaSpace);
//        cv::bilateralFilter(temp4, temp3, ksize, sigmaColor, sigmaSpace);
//    }
//
    UIImage* outImage = [mc UIImageFromCVMat: temp3];
    
    return outImage;
    
}



@end