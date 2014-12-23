//
//  ColorConverter.m
//  BlurDemo
//
//  Created by Agata on 12/16/14.
//  Copyright (c) 2014 tutsPlus. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "ColorConverter.h"
#import "MatConverter.h"

@class ColorConverter;

@implementation NSObject (ColorConverter)

- (UIImage *)convertToSepia:(UIImage *)image
{
    
    NSLog(@"trying out convertToSepia ");
    NSUInteger w = image.size.width; //CGImageGetWidth(imageRef);
    NSUInteger h = image.size.height; //CGImageGetHeight(imageRef);
    
    MatConverter* mc = [[MatConverter alloc] init];
    
    cv::Mat img_cvmat = [mc cvMatFromUIImage:image];
    cv::Mat new_image = cv::Mat::zeros( h,w, CV_8UC4 );
    
    for( int y = 0; y < new_image.rows; y++ ){
        for( int x = 0; x < new_image.cols; x++ ){
            //for( int c = 0; c < 3; c++ ){
            int grey_val = (img_cvmat.at<cv::Vec4b>(y,x)[0] + img_cvmat.at<cv::Vec4b>(y,x)[1] + img_cvmat.at<cv::Vec4b>(y,x)[2])/3;
            
            double iR =img_cvmat.at<cv::Vec4b>(y, x)[0];
            double iG =img_cvmat.at<cv::Vec4b>(y, x)[1];
            double iB =img_cvmat.at<cv::Vec4b>(y, x)[2];
            
            int outputRed =  MIN(iR * .393 + iG *.769 + iB* .189,255);
            int outputGreen= MIN(iR * .349 + iG *.686 + iB* .168,255);
            int outputBlue = MIN(iR * .272 + iG *.534 + iB* .131,255);
            
            new_image.at<cv::Vec4b>(y,x)[0] = outputRed;
            new_image.at<cv::Vec4b>(y,x)[1] = outputGreen;
            new_image.at<cv::Vec4b>(y,x)[2] = outputBlue;
            new_image.at<cv::Vec4b>(y,x)[3] = 255 ;
        }
    }
    std::cout << new_image.at<cv::Vec4b>(0,0)[0] << " : " << new_image.at<cv::Vec4b>(0,0)[3] << std::endl;
    
    UIImage *rawImage = [mc UIImageFromCVMat:new_image];
    
    
    return rawImage;
    
}


- (double*)rgb2lab:(double *)rgbvals{
    
    double R = double(rgbvals[0]) / 255;
    double G = double(rgbvals[1]) / 255;
    double B = double(rgbvals[2]) / 255;
    
    double T = 0.008856;
    
    double X = (R*0.412453+G*0.357580+B*0.180423)/ 0.950456;;
    double Y = R*0.212671+G*0.715160+B*0.072169;
    double Z = (R*0.019334+G*0.119193+B*0.950227)/ 1.088754;
    
    bool XT = X > T;
    bool YT = Y > T;
    bool ZT = Z > T;
    
    double X3 = pow(X,(double)1/3);
    double Y3 = pow(Y,(double)1/3);
    double Z3 = pow(Y,(double)1/3);
    
    
    double fX = XT*X3 + (double)(!XT )*(7.787*X*(16/116));
    double fY = YT*Y3 + (double)(!YT )*(7.787*Y*(16/116));
    double fZ = ZT*Z3 + (double)(!ZT )*(7.787*Z*(16/116));
    
    double L = YT * (116 * Y3 - 16.0) + (!YT) * (903.3 * Y);
    double a = 500 * (fX - fY);
    double b = 200 * (fY - fZ);
    
    
    
    double *lab_vals = (double *)malloc(3);
    lab_vals[0]=L;
    lab_vals[1]=a;
    lab_vals[2]=b;
    
    NSLog(@"XT, YT, ZT %f %f %f", L, a, b);
    
    return lab_vals;
}

@end

