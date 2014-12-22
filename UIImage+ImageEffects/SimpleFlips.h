//
//  Cartoon.h
//  BlurDemo
//
//  Created by Agata on 12/21/14.
//  Copyright (c) 2014 tutsPlus. All rights reserved.
//

#ifndef BlurDemo_SimpleFlips_h
#define BlurDemo_Cartoon_h


#endif


#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

//#import "opencv.hpp"

@interface UIImage (SimpleFlips)

- (UIImage*)centerFlip:(UIImage *)image;
- (UIImage*)tilingFilter:(UIImage *)image;


@end