//
//  KmeansFilter.m
//  BlurDemo
//
//  Created by Agata on 12/11/14.
//  Copyright (c) 2014 tutsPlus. All rights reserved.
//


//#ifdef __cplusplus
//#import "opencv.hpp"
//#endif


#import <Foundation/Foundation.h>

@implementation UIImage (KmeansFilter)

- (UIImage*)cannyFilter:(UIImage *)image{
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
    CGFloat cols = image.size.width;
    CGFloat rows = image.size.height;
    
    cv::Mat cvMat_src(rows, cols, CV_8UC4); // 8 bits per component, 4 channels
    
    
    CGContextRef contextRef = CGBitmapContextCreate(
                                                    cvMat_src.data,                 // Pointer to  data
                                                    cols,                       // Width of bitmap
                                                    rows,                       // Height of bitmap
                                                    8,                          // Bits per component
                                                    cvMat_src.step[0],              // Bytes per row
                                                    colorSpace,                 // Colorspace
                                                    kCGImageAlphaNoneSkipLast |
                                                    kCGBitmapByteOrderDefault); // Bitmap info flags
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
    CGContextRelease(contextRef);
    CGColorSpaceRelease(colorSpace);

    cv::Mat cvMat_grey, dst, detected_edges;
    int lowThreshold= 20;
    int ratio = 3;
    int kernel_size = 3;
    
    dst.create( cvMat_src.size(), cvMat_src.type() );
    
    cv::cvtColor( cvMat_src, cvMat_grey, CV_BGR2GRAY );
    
    cv::blur( cvMat_grey, detected_edges, cv::Size(3,3) );
    
    cv::Canny( detected_edges, detected_edges, lowThreshold, lowThreshold*ratio, kernel_size );
    
    CGContextRef ctx;
    CGImageRef imageRef = [image CGImage];
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
  //  CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    Byte *rawData = (Byte *)malloc(height * width * 4);
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
    
    int byteIndex = 0;
    NSLog(@"detected_edges %f", detected_edges.at<uchar>(1,1));
    
    for(int ii = 0 ; ii <  height ; ++ii)
    {
        for(int jj = 0 ; jj < width  ; ++jj){
            rawData[byteIndex] = (char)detected_edges.at<uchar>(ii,jj);
            rawData[byteIndex+1] = (char)detected_edges.at<uchar>(ii,jj);
            rawData[byteIndex+2] = (char)detected_edges.at<uchar>(ii,jj);
            rawData[byteIndex+3] = 255;
        
        byteIndex += 4;
        }
    }
    
    ctx = CGBitmapContextCreate(rawData,
                                CGImageGetWidth( imageRef ),
                                CGImageGetHeight( imageRef ),
                                8,
                                bytesPerRow,
                                colorSpace,
                                kCGImageAlphaPremultipliedLast );
    CGColorSpaceRelease(colorSpace);
    
    imageRef = CGBitmapContextCreateImage (ctx);
    UIImage* rawImage = [UIImage imageWithCGImage:imageRef];
    //CGImageRelease(imageRef);
    
    CGContextRelease(ctx);
    free(rawData);
    
    return rawImage;
}

- (UIImage*)kmeansFilter:(UIImage *)image: (int) clusterCount {
    NSLog(@"kmeans filter start");
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
    CGFloat cols = image.size.width;
    CGFloat rows = image.size.height;
    
    cv::Mat cvMat(rows, cols, CV_8UC4); // 8 bits per component, 4 channels

    
    CGContextRef contextRef = CGBitmapContextCreate(
                                                    cvMat.data,                 // Pointer to  data
                                                    cols,                       // Width of bitmap
                                                    rows,                       // Height of bitmap
                                                    8,                          // Bits per component
                                                    cvMat.step[0],              // Bytes per row
                                                    colorSpace,                 // Colorspace
                                                    kCGImageAlphaNoneSkipLast |
                                                    kCGBitmapByteOrderDefault); // Bitmap info flags
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
    CGContextRelease(contextRef);
    CGColorSpaceRelease(colorSpace);
    
    const int iters = 100;
    cv::cvtColor(cvMat , cvMat , CV_RGBA2RGB);
    cv::Mat samples(cvMat.rows*cvMat.cols, 3, CV_32F);
    
    for (int y = 0; y<cvMat.rows; y++){
        for (int x = 0; x<cvMat.cols; x++){
            for (int z = 0; z<3; z++){
                samples.at<float>(y+x*cvMat.rows,z)= cvMat.at<cv::Vec3b>(y,x)[z];
                
            }
        }
    }
    
    cv::Mat labels;
    int attempts = 5;
    cv::Mat centers;
    NSLog(@"here ok");
    kmeans(samples, clusterCount, labels, cv::TermCriteria(CV_TERMCRIT_ITER|CV_TERMCRIT_EPS, 100, 0.01), attempts, cv::KMEANS_PP_CENTERS, centers );
    NSLog(@"kmeans here ok");
    
    
    cv::Mat new_image( cvMat.rows, cvMat.cols, cvMat.type());
    
    
    for( int y = 0; y < cvMat.rows; y++ ){
        for( int x = 0; x < cvMat.cols; x++ )
        {
            int cluster_idx = labels.at<int>(y + x*cvMat.rows,0);
            new_image.at<cv::Vec3b>(y,x)[0] = centers.at<float>(cluster_idx, 0);
            new_image.at<cv::Vec3b>(y,x)[1] = centers.at<float>(cluster_idx, 1);
            new_image.at<cv::Vec3b>(y,x)[2] = centers.at<float>(cluster_idx, 2);
        }
    }
    
    NSData *data = [NSData dataWithBytes:new_image.data length:new_image.elemSize()*new_image.total()];
  //  CGColorSpaceRef colorSpace;
    
    if (cvMat.elemSize() == 1) {
        colorSpace = CGColorSpaceCreateDeviceGray();
    } else {
        colorSpace = CGColorSpaceCreateDeviceRGB();
    }
    
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    
    // Creating CGImage from cv::Mat
    CGImageRef imageRef = CGImageCreate(
                                        new_image.cols,                                 //width
                                        new_image.rows,                                 //height
                                        8,                                          //bits per component
                                        8 * new_image.elemSize(),                       //bits per pixel
                                        new_image.step[0],                              //bytesPerRow
                                        colorSpace,                                 //colorspace
                                        kCGImageAlphaNone|kCGBitmapByteOrderDefault,// bitmap info
                                        provider,                                   //CGDataProviderRef
                                        NULL,                                       //decode
                                        false,                                      //should interpolate
                                        kCGRenderingIntentDefault                   //intent
                                        );
    
    
    // Getting UIImage from CGImage
    UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    
    return finalImage;
}



@end