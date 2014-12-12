//
//  SimpleFilters.h
//  BlurDemo
//
//  Created by Agata on 11/30/14.
//  Copyright (c) 2014 tutsPlus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
//#import "opencv.hpp"

//using namespace cv;

@interface UIImage (SimpleFilters)

- (UIImage *)convertImageToGrayScale:(UIImage *)image;
- (UIImage *)convertImageToFisheye:(UIImage *)image : (double)z;
- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)size;
- (UIImage *)squareCropImageToSideLength: (UIImage *)sourceImage: (CGFloat) sideLength;
- (UIImage *)flipImage:(UIImage *)image: (int)which_axis;
- (UIImage *)convertImageToGraySquares:(UIImage *)image: (int)z;
- (UIImage *)convertImageToGrayStripes:(UIImage *)image: (int)z;
//- (UIImage *)UIImageFromCVMat:(cv::Mat)cvMat;
@end
