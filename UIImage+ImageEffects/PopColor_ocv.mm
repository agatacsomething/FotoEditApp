//
//  PopColor.m
//  BlurDemo
//
//  Created by Agata on 12/13/14.
//  Copyright (c) 2014 tutsPlus. All rights reserved.
//

#include "PopColor_ocv.h"
#ifdef __cplusplus
#import "opencv.hpp"
#endif

#import "MatConverter.h"
#import <Foundation/Foundation.h>

@implementation PopColor_ocv

- (cv::Mat)popColorSwitch_ocv: (cv::Mat)img_orig : (int)color_scheme{
    
    std::cout << "trying out popcolorswitch: " << color_scheme<< std::endl;
    
    //int color_scheme =0;
    if (color_scheme ==99){
        color_scheme = (arc4random() % 10);
    }
    
    int width = img_orig.cols; //CGImageGetWidth(imageRef);
    int height = img_orig.rows; //CGImageGetHeight(imageRef);
    
    int w = width;
    int h = height;
    int srcpos;
    
    
    cv::Mat img_new ( h,w, img_orig.type());
    
    //std::cout << img_new.size() << " : " << img_orig.size() << std::endl;
    
    for(int x = 0; x<h; x++){
        for(int y =0; y<w; y++){
            
            srcpos = (x*w + y)*4;
            
            switch (color_scheme){
                case 0:{
                    img_new.data[srcpos  ] =  img_orig.data[srcpos ];
                    img_new.data[srcpos+1] =  img_orig.data[srcpos+1 ];
                    img_new.data[srcpos  ] =  img_orig.data[srcpos+2 ];
                    img_new.data[srcpos+3] =255;
                    break;
                }
                    
                    //reds and yellows
                case 1: {
                    img_new.data[srcpos  +1] =  img_orig.data[srcpos ];
                    img_new.data[srcpos  ] =  img_orig.data[srcpos+1 ];
                    img_new.data[srcpos  ] =  img_orig.data[srcpos+2 ];
                    img_new.data[srcpos  ] =255;
                    break;
                }
                    
                    //green, yellow, red
                case 2:{
                    img_new.data[srcpos  ] =  img_orig.data[srcpos ];
                    img_new.data[srcpos  ] =  img_orig.data[srcpos+1 ];
                    img_new.data[srcpos  +1] =  img_orig.data[srcpos+2 ];
                    img_new.data[srcpos  +3] =255;
                    break;
                }
                    
                    //reds and blues
                case 3: {
                    img_new.data[srcpos  ] =  img_orig.data[srcpos ];
                    img_new.data[srcpos  ] =  img_orig.data[srcpos+1 ];
                    img_new.data[srcpos  +2] =  img_orig.data[srcpos+2 ];
                    img_new.data[srcpos  +3] =255;
                    break;
                }
                    
                    //blues and purples
                case 4:{
                    img_new.data[srcpos  +2] =  img_orig.data[srcpos ];
                    img_new.data[srcpos  +1] =  img_orig.data[srcpos+1 ];
                    img_new.data[srcpos  ] =  img_orig.data[srcpos+2 ];
                    img_new.data[srcpos  +3] =255;
                    break;
                }
                    
                    //white, blues, purples
                case 5:{
                    img_new.data[srcpos  +2] =  img_orig.data[srcpos ];
                    img_new.data[srcpos  ] =  img_orig.data[srcpos+1 ];
                    img_new.data[srcpos  +1] =  img_orig.data[srcpos+2 ];
                    img_new.data[srcpos  +3] =255;
                    break;
                }
                    
                    //reds and whites
                case 6:{
                    img_new.data[srcpos  ] =  img_orig.data[srcpos ];
                    img_new.data[srcpos  +1 ] =  img_orig.data[srcpos+1 ];
                    img_new.data[srcpos  +1] =  img_orig.data[srcpos+2 ];
                    img_new.data[srcpos  +3] =255;
                    break;
                }
                    
                    //white, blues/gree, red
                case 7:{
                    img_new.data[srcpos  +1] =  img_orig.data[srcpos ];
                    img_new.data[srcpos   ] =  img_orig.data[srcpos+1 ];
                    img_new.data[srcpos  +1] =  img_orig.data[srcpos+2 ];
                    img_new.data[srcpos  +3] =255;
                    break;
                }
                    
                    //old photo-ish
                case 8:{
                    img_new.data[srcpos  ] =  128;
                    img_new.data[srcpos  +1 ] =  img_orig.data[srcpos+1 ];
                    img_new.data[srcpos  +2] =  img_orig.data[srcpos+2 ];
                    img_new.data[srcpos  +3] =255;
                    break;
                }
                    
                    // greens and purples
                case 9:{
                    int r =img_orig.data[srcpos];
                    int b =img_orig.data[srcpos+2];
                    img_new.data[srcpos  ] = std::min(r, b);
                    img_new.data[srcpos+1] = img_orig.data[srcpos+1 ];//-img_orig.data[srcpos+1];
                    img_new.data[srcpos+2] = img_orig.data[srcpos+2 ];
                    img_new.data[srcpos+3] = 255;
                    break;
                }
            }
            
        }
        
        // sqpos +=4;
    }
    
    
    //UIImage* outImage = [mc UIImageFromCVMat: img_new];
    
    return img_new;
    
}


@end