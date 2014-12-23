//
//  TwoComboFilters.h
//  BlurDemo
//
//  Created by Agata on 12/23/14.
//  Copyright (c) 2014 tutsPlus. All rights reserved.
//

#ifndef BlurDemo_TwoComboFilters_h
#define BlurDemo_TwoComboFilters_h


#endif

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

//#import "opencv.hpp"

@interface UIImage (DitherFilters)

- (UIImage*)tilingFilterWcolorswap:(UIImage *)image;

@end