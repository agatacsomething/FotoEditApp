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

@interface UIImage (PopColor)

// uiimages
- (UIImage*)popColorMe:(UIImage *)image;
- (UIImage *)popColorEdges:(UIImage *)image;
- (UIImage *)popContrast:(UIImage *)image;
- (UIImage *)popArtSimple:(UIImage *)image;
- (UIImage *)popColorSwitch_img:(UIImage *)image;


// opencvs
//- (cv::Mat)popColorSwitch: (cv::Mat)img_orig : (int)color_scheme;

@end