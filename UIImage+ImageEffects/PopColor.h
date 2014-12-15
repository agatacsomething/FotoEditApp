//
//  PopColor
//  BlurDemo
//
//  Created by Agata on 12/11/14.
//  Copyright (c) 2014 tutsPlus. All rights reserved.
//

#ifndef BlurDemo_PopColor_h
#define BlurDemo_PopColor_h


#endif
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

//#import "opencv.hpp"

@interface UIImage (PopColor)

- (UIImage*)popColorMe:(UIImage *)image;
- (UIImage *)popColorEdges:(UIImage *)image;
- (UIImage *)popContrast:(UIImage *)image;
- (UIImage *)popArtSimple:(UIImage *)image;
//- (cv::Mat)cvMatFromUIImage:(UIImage *)image;

@end