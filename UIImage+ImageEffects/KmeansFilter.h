//
//  KmeansFilter.h
//  BlurDemo
//
//  Created by Agata on 12/11/14.
//  Copyright (c) 2014 tutsPlus. All rights reserved.
//

#ifndef BlurDemo_KmeansFilter_h
#define BlurDemo_KmeansFilter_h


#endif
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

//#import "opencv.hpp"

@interface UIImage (KmeansFilter)
- (UIImage*)kmeansFilter:(UIImage *)image: (int) clusterCount;
- (UIImage*)cannyFilter:(UIImage *)image;
//- (cv::Mat)cvMatFromUIImage:(UIImage *)image;

@end