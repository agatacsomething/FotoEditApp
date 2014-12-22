//
//  Header.h
//  BlurDemo
//
//  Created by Agata on 12/20/14.
//  Copyright (c) 2014 tutsPlus. All rights reserved.
//

#ifndef MatConverter_Header_h
#define MatConverter_Header_h


#endif


#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

//#import "opencv.hpp"

@interface MatConverter: NSObject

- (cv::Mat)cvMatFromUIImage:(UIImage *)image;
- (UIImage *)UIImageFromCVMat:(cv::Mat)cvMat;

@end