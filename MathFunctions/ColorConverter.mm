//
//  ColorConverter.m
//  BlurDemo
//
//  Created by Agata on 12/16/14.
//  Copyright (c) 2014 tutsPlus. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "ColorConverter.h"

@class ColorConverter;

@implementation NSObject (ColorConverter)

- (double*)rgb2lab:(double *)rgbvals{
    
    double R = double(rgbvals[0]) / 255;
    double G = double(rgbvals[1]) / 255;
    double B = double(rgbvals[2]) / 255;
    
    double T = 0.008856;
    
    double X = (R*0.412453+G*0.357580+B*0.180423)/ 0.950456;;
    double Y = R*0.212671+G*0.715160+B*0.072169;
    double Z = (R*0.019334+G*0.119193+B*0.950227)/ 1.088754;
    
    bool XT = X > T;
    bool YT = Y > T;
    bool ZT = Z > T;
    
    double X3 = pow(X,(double)1/3);
    double Y3 = pow(Y,(double)1/3);
    double Z3 = pow(Y,(double)1/3);
    
    
    double fX = XT*X3 + (double)(!XT )*(7.787*X*(16/116));
    double fY = YT*Y3 + (double)(!YT )*(7.787*Y*(16/116));
    double fZ = ZT*Z3 + (double)(!ZT )*(7.787*Z*(16/116));
    
    double L = YT * (116 * Y3 - 16.0) + (!YT) * (903.3 * Y);
    double a = 500 * (fX - fY);
    double b = 200 * (fY - fZ);
    
    
    
    double *lab_vals = (double *)malloc(3);
    lab_vals[0]=L;
    lab_vals[1]=a;
    lab_vals[2]=b;
    
    NSLog(@"XT, YT, ZT %f %f %f", L, a, b);
    
    return lab_vals;
}

@end

