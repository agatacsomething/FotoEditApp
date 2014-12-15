//
//  DitherFilters.m
//  BlurDemo
//
//  Created by Agata on 12/14/14.
//  Copyright (c) 2014 tutsPlus. All rights reserved.
//

#import <Foundation/Foundation.h>

@implementation UIImage (DitherFilters)

- (UIImage*)gratedDots:(UIImage *)image{
    
    NSLog(@"trying out gratedDots");
    
    double box=60;
    double ctrx = (box+1)/2;
    double ctry = (box+1)/2;
    double radius = ctrx-1;
    
  //   NSLog(@"trying out gratedDots %f %f", ctrx, ctry);
    
    Byte *circle_mask = (Byte *)malloc(box * box);
    for (int i = 0; i<box; i++){
        for(int j = 0; j<box; j++){
            
            double dist = sqrt(((double)(i+1)-ctrx)*((double)(i+1)-ctrx) + ((double)(j+1)-ctry)*((double)(j+1)-ctry));
           // NSLog(@"dist is %f", dist);
            if (dist < radius){
                circle_mask[i*(int)box+j] = 1;
            }
            else{
                circle_mask[i*(int)box+j] = 0;
            }
            
        //    NSLog(@"double dist is %f", (double)circle_mask[i*(int)box+j]);
            
            
        }
    }
    
    
    
    
    NSUInteger width = image.size.width; //CGImageGetWidth(imageRef);
    NSUInteger height = image.size.height; //CGImageGetHeight(imageRef);
    
    double w = width;
    double h = height;
    
    CGContextRef ctx;
    CGImageRef imageRef = [image CGImage];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    Byte *rawData = (Byte *)malloc(height * width * 4);
    Byte *rawData_copy = (Byte *)malloc(height * width * 4);
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData_copy, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
    
    
    int nw = ceil((double)width/box);
    int nh = ceil((double)height/box);
    
    
    //    int nw = width/z;
    //    int nh = height/z;
    NSLog(@"nh nw %i %i", nw, nh);

//    int ii;
//    int jj;
    int max_pos = 4*h*w;
    
    for(int x = 0; x<nh; x++){
        for(int y =0; y<nw; y++){
            
            //if(x%box ==0 && y%box==0){
            
//            ii =0;
//            jj =0;
            int sqpos=0;
            // int srcpos = i*j*4;
            for(int i=box*x; i<box*(x+1); i++){
                for(int j=box*y; j<box*(y+1); j++){
                    //int sqpos= ii*box+jj;
                    int srcpos = (w*i + j)*4;
                    
                   // NSLog(@"ii jj %i %i", ii, jj);
                    if (srcpos<max_pos){
                    
                        if (circle_mask[sqpos]==1){
                            rawData[(int)(srcpos )] =  (char) rawData_copy[(int)(srcpos )];
                            rawData[(int)(srcpos +1)] =(char) rawData_copy[(int)(srcpos+1 )];
                            rawData[(int)(srcpos +2)] =(char) rawData_copy[(int)(srcpos+2 )] ;
                            rawData[(int)(srcpos +3)] =(char) 255;
                        }
                        
                        else{
                            rawData[(int)(srcpos )] =  (char) 0;
                            rawData[(int)(srcpos +1)] =(char) 0;
                            rawData[(int)(srcpos +2)] =(char) 0;
                            rawData[(int)(srcpos +3)] =(char) 255;
                        }
                    }
                    
                    
                    sqpos+=1;
                }
               // ii +=1;
            }
            //
            //}
            
            
        }
        
        
    }
    
    ctx = CGBitmapContextCreate(rawData,
                                CGImageGetWidth( imageRef ),
                                CGImageGetHeight( imageRef ),
                                8,
                                bytesPerRow,
                                colorSpace,
                                kCGImageAlphaPremultipliedLast );
    CGColorSpaceRelease(colorSpace);
    
    imageRef = CGBitmapContextCreateImage (ctx);
    UIImage* rawImage = [UIImage imageWithCGImage:imageRef];
    //CGImageRelease(imageRef);
    
    CGContextRelease(ctx);
    free(rawData);
    
    return rawImage;
    
    
    
}

- (UIImage*)clusteredDots:(UIImage *)image{
    
    NSLog(@"trying out clusteredDots");
    
    int box=6;
    
    int S[36] = {34, 29, 17, 21, 30, 35, 28, 14, 9, 16, 20, 31, 13, 8, 4, 5, 15, 19, 12, 3, 0, 1, 10, 18, 27, 7, 2, 6, 23, 24, 33, 26, 11, 22, 25, 32};
    
    
    double d = 255/(box*box);
    
    
    NSUInteger width = image.size.width; //CGImageGetWidth(imageRef);
    NSUInteger height = image.size.height; //CGImageGetHeight(imageRef);
    
    double w = width;
    double h = height;
    
    CGContextRef ctx;
    CGImageRef imageRef = [image CGImage];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    Byte *rawData = (Byte *)malloc(height * width * 4);
    Byte *rawData_copy = (Byte *)malloc(height * width * 4);
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData_copy, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
    
    NSInteger *chk_mask;
    
    
    int nw = ceil((double)width/box);
    int nh = ceil((double)height/box);
    
    
    //    int nw = width/z;
    //    int nh = height/z;
    NSLog(@"nh nw %i %i", nw, nh);
    int max_src = w*h*4;
    int srcpos;
    int sqpos;
    int ii;
    int jj;
    
    for(int x = 0; x<nh; x++){
        for(int y =0; y<nw; y++){
            
            //if(x%box ==0 && y%box==0){
                
                ii =0;
                jj =0;
                // int srcpos = i*j*4;
                for(int i=box*x; i<box*(x+1); i++){
                    
                    for(int j=box*y; j<box*(y+1); j++){
                        srcpos = (i*w+j)*4;
                        sqpos = ii*box+jj;
                        
                        if (srcpos<max_src && i<h && j<w){
                            
                            double nr = rawData_copy[(int)(srcpos )]/d;
                            double ng = rawData_copy[(int)(srcpos+1 )]/d;
                            double nb = rawData_copy[(int)(srcpos+2 )]/d;
                            
                            int grey_val = (nr+ng+nb)/3;
                            int grey_val_orig = grey_val*3*d;
                            
                            if (grey_val< S[sqpos]){
                                rawData[(int)(srcpos )] =  (char) grey_val_orig;
                                rawData[(int)(srcpos +1)] =(char) grey_val_orig;
                                rawData[(int)(srcpos +2)] =(char) grey_val_orig;
                                rawData[(int)(srcpos +3)] =(char) 255;
                            }
                            
                            else{
                                rawData[(int)(srcpos )] =  (char) 0;
                                rawData[(int)(srcpos +1)] =(char) 0;
                                rawData[(int)(srcpos +2)] =(char) 0;
                                rawData[(int)(srcpos +3)] =(char) 255;
                            }
                            
                        }
                        jj +=1;
                    }
                    ii +=1;
                }
                //
            //}
            
            
        }
        
        
    }
    
    ctx = CGBitmapContextCreate(rawData,
                                CGImageGetWidth( imageRef ),
                                CGImageGetHeight( imageRef ),
                                8,
                                bytesPerRow,
                                colorSpace,
                                kCGImageAlphaPremultipliedLast );
    CGColorSpaceRelease(colorSpace);
    
    imageRef = CGBitmapContextCreateImage (ctx);
    UIImage* rawImage = [UIImage imageWithCGImage:imageRef];
    //CGImageRelease(imageRef);
    
    CGContextRelease(ctx);
    free(rawData);
    
    return rawImage;
    

    
}


- (UIImage*)fixedNoisyThreshold:(UIImage *)image{

    int which_color = (arc4random() % 3);
    double threshold = (arc4random() % 127) -0.5;

    


    NSLog(@"trying out fixedThreshold %i", which_color);
    NSUInteger width = image.size.width; //CGImageGetWidth(imageRef);
    NSUInteger height = image.size.height; //CGImageGetHeight(imageRef);

    double w = width;
    double h = height;


    CGContextRef ctx;
    CGImageRef imageRef = [image CGImage];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();

    Byte *rawData = (Byte *)malloc(height * width * 4);
    Byte *rawData_copy = (Byte *)malloc(height * width * 4);
    Byte *outImg = (Byte *)malloc(height * width * 4);
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData_copy, width, height,
                                             bitsPerComponent, bytesPerRow, colorSpace,
                                             kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);


    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);

    int srcpos;

    for(int x = 0; x<h; x++){
        for(int y =0; y<w; y++){
            srcpos= (x*w + y)*4;
        
            int noise = (arc4random() % 50);
            
            int grey_val = (rawData_copy[(int)(srcpos )] + rawData_copy[(int)(srcpos +1 )] + rawData_copy[(int)(srcpos +2)] + noise)/3;
            
            
            if (which_color==0){
                if  (grey_val>threshold){
                    rawData[(int)(srcpos )] = (char)rawData_copy[(int)(srcpos )];
                    rawData[(int)(srcpos+1 )] = (char)rawData_copy[(int)(srcpos+1 )];
                    rawData[(int)(srcpos+2 )] = (char)rawData_copy[(int)(srcpos+2 )];
                    rawData[(int)(srcpos+3 )] = (char)255;
                }
            
                else{
                    rawData[(int)(srcpos )] = (char)0;
                    rawData[(int)(srcpos+1 )] = (char)0;
                    rawData[(int)(srcpos+2 )] = (char)0;
                    rawData[(int)(srcpos+3 )] = (char)255;
                }
            }
            else if (which_color==1){
                if  (grey_val>threshold){
                    rawData[(int)(srcpos )] = (char)grey_val;
                    rawData[(int)(srcpos+1 )] = (char)grey_val;
                    rawData[(int)(srcpos+2 )] = (char)grey_val;
                    rawData[(int)(srcpos+3 )] = (char)255;
                }
                
                else{
                    rawData[(int)(srcpos )] = (char)0;
                    rawData[(int)(srcpos+1 )] = (char)0;
                    rawData[(int)(srcpos+2 )] = (char)0;
                    rawData[(int)(srcpos+3 )] = (char)255;
                }
            }
            else{
                if  (grey_val>127.5){
                    rawData[(int)(srcpos )] = (char)255;
                    rawData[(int)(srcpos+1 )] = (char)255;
                    rawData[(int)(srcpos+2 )] = (char)255;
                    rawData[(int)(srcpos+3 )] = (char)255;
                }
                
                else{
                    rawData[(int)(srcpos )] = (char)0;
                    rawData[(int)(srcpos+1 )] = (char)0;
                    rawData[(int)(srcpos+2 )] = (char)0;
                    rawData[(int)(srcpos+3 )] = (char)255;
                }
            }
        
        }
    

    
    }

    ctx = CGBitmapContextCreate(rawData,
                            CGImageGetWidth( imageRef ),
                            CGImageGetHeight( imageRef ),
                            8,
                            bytesPerRow,
                            colorSpace,
                            kCGImageAlphaPremultipliedLast );
    CGColorSpaceRelease(colorSpace);

    imageRef = CGBitmapContextCreateImage (ctx);
    UIImage* rawImage = [UIImage imageWithCGImage:imageRef];
    //CGImageRelease(imageRef);
    
    CGContextRelease(ctx);
    free(rawData);

return rawImage;

}

- (UIImage*)fixedThreshold:(UIImage *)image{
    
    int which_color = (arc4random() % 3);
    double threshold = (arc4random() % 127) -0.5;
    
    
    
    
    NSLog(@"trying out fixedThreshold %i", which_color);
    NSUInteger width = image.size.width; //CGImageGetWidth(imageRef);
    NSUInteger height = image.size.height; //CGImageGetHeight(imageRef);
    
    double w = width;
    double h = height;
    
    
    CGContextRef ctx;
    CGImageRef imageRef = [image CGImage];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    Byte *rawData = (Byte *)malloc(height * width * 4);
    Byte *rawData_copy = (Byte *)malloc(height * width * 4);
    Byte *outImg = (Byte *)malloc(height * width * 4);
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData_copy, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
    
    int srcpos;
    
    for(int x = 0; x<h; x++){
        for(int y =0; y<w; y++){
            srcpos= (x*w + y)*4;
            
            int grey_val = (rawData_copy[(int)(srcpos )] + rawData_copy[(int)(srcpos +1 )] + rawData_copy[(int)(srcpos +2)])/3;
            
            
            if (which_color==0){
                if  (grey_val>threshold){
                    rawData[(int)(srcpos )] = (char)rawData_copy[(int)(srcpos )];
                    rawData[(int)(srcpos+1 )] = (char)rawData_copy[(int)(srcpos+1 )];
                    rawData[(int)(srcpos+2 )] = (char)rawData_copy[(int)(srcpos+2 )];
                    rawData[(int)(srcpos+3 )] = (char)255;
                }
                
                else{
                    rawData[(int)(srcpos )] = (char)0;
                    rawData[(int)(srcpos+1 )] = (char)0;
                    rawData[(int)(srcpos+2 )] = (char)0;
                    rawData[(int)(srcpos+3 )] = (char)255;
                }
            }
            else if (which_color==1){
                if  (grey_val>threshold){
                    rawData[(int)(srcpos )] = (char)grey_val;
                    rawData[(int)(srcpos+1 )] = (char)grey_val;
                    rawData[(int)(srcpos+2 )] = (char)grey_val;
                    rawData[(int)(srcpos+3 )] = (char)255;
                }
                
                else{
                    rawData[(int)(srcpos )] = (char)0;
                    rawData[(int)(srcpos+1 )] = (char)0;
                    rawData[(int)(srcpos+2 )] = (char)0;
                    rawData[(int)(srcpos+3 )] = (char)255;
                }
            }
            else{
                if  (grey_val>127.5){
                    rawData[(int)(srcpos )] = (char)255;
                    rawData[(int)(srcpos+1 )] = (char)255;
                    rawData[(int)(srcpos+2 )] = (char)255;
                    rawData[(int)(srcpos+3 )] = (char)255;
                }
                
                else{
                    rawData[(int)(srcpos )] = (char)0;
                    rawData[(int)(srcpos+1 )] = (char)0;
                    rawData[(int)(srcpos+2 )] = (char)0;
                    rawData[(int)(srcpos+3 )] = (char)255;
                }
            }
            
        }
        
        
        
    }
    
    ctx = CGBitmapContextCreate(rawData,
                                CGImageGetWidth( imageRef ),
                                CGImageGetHeight( imageRef ),
                                8,
                                bytesPerRow,
                                colorSpace,
                                kCGImageAlphaPremultipliedLast );
    CGColorSpaceRelease(colorSpace);
    
    imageRef = CGBitmapContextCreateImage (ctx);
    UIImage* rawImage = [UIImage imageWithCGImage:imageRef];
    //CGImageRelease(imageRef);
    
    CGContextRelease(ctx);
    free(rawData);
    
    return rawImage;
    
}

- (UIImage*)dotify:(UIImage *)image{
    
    NSLog(@"trying out dotify");
    NSUInteger width = image.size.width; //CGImageGetWidth(imageRef);
    NSUInteger height = image.size.height; //CGImageGetHeight(imageRef);
    
    double w = width;
    double h = height;
    
    
    CGContextRef ctx;
    CGImageRef imageRef = [image CGImage];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    Byte *rawData = (Byte *)malloc(height * width * 4);
    Byte *rawData_copy = (Byte *)malloc(height * width * 4);
    Byte *outImg = (Byte *)malloc(height * width * 4);
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData_copy, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
    
    int srcpos;
    
    for(int x = 0; x<h; x++){
        for(int y =0; y<w; y++){
            srcpos= (x*w + y)*4;
            
            int grey_val = (rawData_copy[(int)(srcpos )] + rawData_copy[(int)(srcpos +1 )] + rawData_copy[(int)(srcpos +2)])/3;
            
            if  (x%3==0 && y%3==0){
                rawData[(int)(srcpos )] = (char)0;
                rawData[(int)(srcpos+1 )] = (char)0;
                rawData[(int)(srcpos+2 )] = (char)0;
                rawData[(int)(srcpos+3 )] = (char)255;
            }
            
            else{
                rawData[(int)(srcpos )] = (char)rawData_copy[(int)(srcpos )];
                rawData[(int)(srcpos+1 )] = (char)rawData_copy[(int)(srcpos+1 )];
                rawData[(int)(srcpos+2 )] = (char)rawData_copy[(int)(srcpos+2 )];
                rawData[(int)(srcpos+3 )] = (char)255;

            }
        }
    }
    
    ctx = CGBitmapContextCreate(rawData,
                                CGImageGetWidth( imageRef ),
                                CGImageGetHeight( imageRef ),
                                8,
                                bytesPerRow,
                                colorSpace,
                                kCGImageAlphaPremultipliedLast );
    CGColorSpaceRelease(colorSpace);
    
    imageRef = CGBitmapContextCreateImage (ctx);
    UIImage* rawImage = [UIImage imageWithCGImage:imageRef];
    //CGImageRelease(imageRef);
    
    CGContextRelease(ctx);
    free(rawData);
    
    return rawImage;
    
}

@end