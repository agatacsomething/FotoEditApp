//
//  BilateralFilters.h
//  BlurDemo
//
//  Created by Agata on 12/16/14.
//  Copyright (c) 2014 tutsPlus. All rights reserved.
//

#ifndef BlurDemo_BilateralFilters_h
#define BlurDemo_BilateralFilters_h


#endif

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

//#import "opencv.hpp"

@interface UIImage (BilateralFilters)

- (UIImage*)bfilter:(UIImage *)image;

@end