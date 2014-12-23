//
//  PopColor_ocv
//  BlurDemo
//
//  Created by Agata on 12/11/14.
//  Copyright (c) 2014 tutsPlus. All rights reserved.
//

#ifndef BlurDemo_PopColor_ocv_h
#define BlurDemo_PopColor_ocv_h


#endif
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface PopColor_ocv : NSObject

// opencvs
- (cv::Mat)popColorSwitch_ocv: (cv::Mat)img_orig : (int)color_scheme;

@end