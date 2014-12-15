//
//  DitherFilters.h
//  BlurDemo
//
//  Created by Agata on 12/14/14.
//  Copyright (c) 2014 tutsPlus. All rights reserved.
//

#ifndef BlurDemo_DitherFilters_h
#define BlurDemo_DitherFilters_h


#endif
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

//#import "opencv.hpp"

@interface UIImage (DitherFilters)

- (UIImage*)fixedThreshold:(UIImage *)image;
- (UIImage*)fixedNoisyThreshold:(UIImage *)image;
- (UIImage*)clusteredDots:(UIImage *)image;
- (UIImage*)dotify:(UIImage *)image;
- (UIImage*)gratedDots:(UIImage *)image;



@end