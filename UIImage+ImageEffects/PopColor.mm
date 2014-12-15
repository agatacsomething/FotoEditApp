//
//  PopColor.m
//  BlurDemo
//
//  Created by Agata on 12/13/14.
//  Copyright (c) 2014 tutsPlus. All rights reserved.
//
#include "PopColor.h"
#include "KmeansFilter.h"


@implementation UIImage (PopColor)

- (UIImage *)popColorMe:(UIImage *)image
{
    
    CGFloat red_value;
    CGFloat green_value;
    CGFloat blue_value;
    int which_rgb = (arc4random() % 7);
    
    
    
    switch(which_rgb){
        case 0:
            red_value = (arc4random() % 255);
            green_value = (arc4random() % 255);
            blue_value = (arc4random() % 255);
            break;
        case 1:
            red_value = 255;
            green_value = 0;
            blue_value = 0;
            break;
        case 2:
            red_value = 0;
            green_value = 255;
            blue_value = 0;
            break;
        case 3:
            red_value = 0;
            green_value = 0;
            blue_value = 255;
            break;
        case 4:
            red_value = 255;
            green_value = 255;
            blue_value = 0;
            break;
        case 5:
            red_value = 255;
            green_value = 0;
            blue_value = 255;
            break;
        default:
            red_value = 0;
            green_value = 255;
            blue_value = 255;
            break;
    }
    
    

    


    
    NSLog(@"trying out popcolor %f %f %f", red_value, green_value, blue_value);
    
    NSUInteger width = image.size.width; //CGImageGetWidth(imageRef);
    NSUInteger height = image.size.height; //CGImageGetHeight(imageRef);
    
    double w = width;
    double h = height;
    
    //NSLog(@"trying out grey squares %f", w*h*4);
    // UIImage *image_new = [self imageWithImage: image :csq_size];
    
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
    
    
    
//    int nw = ceil((double)width/z);
//    int nh = ceil((double)height/z);
    
    
    //    int nw = width/z;
    //    int nh = height/z;
//    NSLog(@"nh nw %i %i %i", z, nw, nh);
    int byteIndex=0;
    
    for(int x = 0; x<h; x++){
        for(int y =0; y<w; y++){
            
            double sq_red = (rawData[(int)(byteIndex )]-red_value)*(rawData[(int)(byteIndex )]-red_value);
            double sq_green = (rawData[(int)(byteIndex+1 )]-green_value)*(rawData[(int)(byteIndex+1 )]-green_value);
            double sq_blue = (rawData[(int)(byteIndex+2 )]-blue_value)*(rawData[(int)(byteIndex+2 )]-blue_value);
            
            double dist_target = sqrt(sq_red+sq_green+sq_blue);
            //NSLog(@"dist_target %f", dist_target);
            
            if (dist_target<150){
                rawData[(int)(byteIndex )] =  (char) rawData_copy[(int)(byteIndex )];
                rawData[(int)(byteIndex +1)] =(char) rawData_copy[(int)(byteIndex+1 )];
                rawData[(int)(byteIndex +2)] =(char) rawData_copy[(int)(byteIndex+2 )];
                rawData[(int)(byteIndex +3)] =(char) 255;
            }
            else{
                int grey_val = (rawData_copy[(int)(byteIndex )] + rawData_copy[(int)(byteIndex +1 )] + rawData_copy[(int)(byteIndex +2)])/3;
                rawData[(int)(byteIndex )] =  (char) grey_val;
                rawData[(int)(byteIndex +1)] =(char) grey_val;
                rawData[(int)(byteIndex +2)] =(char) grey_val;
                rawData[(int)(byteIndex +3)] =(char) 255;
            }

            
            byteIndex +=4;
            
            
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

- (UIImage *)popColorEdges:(UIImage *)image
{
    
    CGFloat red_value;
    CGFloat green_value;
    CGFloat blue_value;
    int which_rgb = (arc4random() % 7);
    
    
    
    switch(which_rgb){
        case 0:
            red_value = (arc4random() % 255);
            green_value = (arc4random() % 255);
            blue_value = (arc4random() % 255);
            break;
        case 1:
            red_value = 255;
            green_value = 0;
            blue_value = 0;
            break;
        case 2:
            red_value = 0;
            green_value = 255;
            blue_value = 0;
            break;
        case 3:
            red_value = 0;
            green_value = 0;
            blue_value = 255;
            break;
        case 4:
            red_value = 255;
            green_value = 255;
            blue_value = 0;
            break;
        case 5:
            red_value = 255;
            green_value = 0;
            blue_value = 255;
            break;
        default:
            red_value = 0;
            green_value = 255;
            blue_value = 255;
            break;
    }
    
    
    
    
    
  //  (UIImage*)image_edges = [UIImage cannyFilter:image];
    
    NSLog(@"trying out popcolor %f %f %f", red_value, green_value, blue_value);
    
    NSUInteger width = image.size.width; //CGImageGetWidth(imageRef);
    NSUInteger height = image.size.height; //CGImageGetHeight(imageRef);
    
    double w = width;
    double h = height;
    
    //NSLog(@"trying out grey squares %f", w*h*4);
    // UIImage *image_new = [self imageWithImage: image :csq_size];
    
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
    
    
    
    //    int nw = ceil((double)width/z);
    //    int nh = ceil((double)height/z);
    
    
    //    int nw = width/z;
    //    int nh = height/z;
    //    NSLog(@"nh nw %i %i %i", z, nw, nh);
    int byteIndex=0;
    
    for(int x = 0; x<h; x++){
        for(int y =0; y<w; y++){
            
            double sq_red = (rawData[(int)(byteIndex )]-red_value)*(rawData[(int)(byteIndex )]-red_value);
            double sq_green = (rawData[(int)(byteIndex+1 )]-green_value)*(rawData[(int)(byteIndex+1 )]-green_value);
            double sq_blue = (rawData[(int)(byteIndex+2 )]-blue_value)*(rawData[(int)(byteIndex+2 )]-blue_value);
            
            double dist_target = sqrt(sq_red+sq_green+sq_blue);
            //NSLog(@"dist_target %f", dist_target);
            
            if (dist_target<150){
                rawData[(int)(byteIndex )] =  (char) rawData_copy[(int)(byteIndex )];
                rawData[(int)(byteIndex +1)] =(char) rawData_copy[(int)(byteIndex+1 )];
                rawData[(int)(byteIndex +2)] =(char) rawData_copy[(int)(byteIndex+2 )];
                rawData[(int)(byteIndex +3)] =(char) 255;
            }
            else{
                int grey_val = (rawData_copy[(int)(byteIndex )] + rawData_copy[(int)(byteIndex +1 )] + rawData_copy[(int)(byteIndex +2)])/3;
                rawData[(int)(byteIndex )] =  (char) grey_val;
                rawData[(int)(byteIndex +1)] =(char) grey_val;
                rawData[(int)(byteIndex +2)] =(char) grey_val;
                rawData[(int)(byteIndex +3)] =(char) 255;
            }
            
            
            byteIndex +=4;
            
            
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

- (UIImage *)popContrast:(UIImage *)image
{
    
    int z = (arc4random() % 20)+5;
    
    double contrast = z*.25;
    
    NSLog(@"trying out popColorSin %f", contrast);
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
    
    
    
    int nw = ceil((double)width/z);
    int nh = ceil((double)height/z);
    
    
    //    int nw = width/z;
    //    int nh = height/z;
    NSLog(@"nh nw %i %i", nw, nh);
    int max_src = w*h*4;
    double R =0;
    double G =0;
    double B =0;
    
    for(int x = 0; x<h; x++){
        for(int y =0; y<w; y++){
            
//            double red_val = rawData[(int)(srcpos )];
//            int green_val = 0;
//            int blue_val = 0;
            
            int srcpos = (x*w+y)*4;
            
            R = rawData_copy[(int)(srcpos )];
            G = rawData_copy[(int)(srcpos +1)];
            B = rawData_copy[(int)(srcpos +2)];
//            R = (double)(((R / 255.0) - 0.5) * contrast);
//            G = (double)(((G / 255.0) - 0.5) * contrast);
//            B = (double)(((B / 255.0) - 0.5) * contrast);
            
            R = (double)(((((R / 255.0) - 0.5) * contrast) + 0.5) * 255.0);
            G = (double)(((((G / 255.0) - 0.5) * contrast) + 0.5) * 255.0);
            B = (double)(((((B / 255.0) - 0.5) * contrast) + 0.5) * 255.0);
            
           // NSLog(@"RGB vals %f, %f, %f ",R,G,B);
            
            if(R < 0) { R = 0; }
            else if(R > 255) { R = 255; }
            
            
            
            if(G < 0) { G = 0; }
            else if(G > 255) { G = 255; }
            
            
            
            if(B < 0) { B = 0; }
            else if(B > 255) { B = 255; }
            
           // NSLog(@"RGB vals %i, %i, %i ",R,G,B);
            
            rawData[(int)(srcpos )] =  (char) R;
            rawData[(int)(srcpos +1)] =(char) G;
            rawData[(int)(srcpos +2)] =(char) B;
            rawData[(int)(srcpos +3)] =(char) 255;
            
            //NSLog(@"RGB vals %i, %i, %i ",red_val,green_val,blue_val);
            
                        //
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


- (UIImage *)popArtSimple:(UIImage *)image
{
    
    
    double threshold = 127.5;
    
    
    NSLog(@"trying out popColorSin ");
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
    
    
    double error_red;
    double error_green;
    double error_blue;
    int srcpos;
    
    for(int x = 0; x<h-1; x++){
        
        srcpos= x*w*4;
       // NSLog(@"src pose is start : %i", srcpos);
        
        outImg[(int)(srcpos )] =   (char) 255* (rawData_copy[srcpos]>=threshold);
        outImg[(int)(srcpos+1 )] = (char) 255* (rawData_copy[srcpos+1]>=threshold);
        outImg[(int)(srcpos+2 )] = (char) 255* (rawData_copy[srcpos+2]>=threshold);
        
        error_red = -outImg[(int)(srcpos )] + rawData_copy[srcpos];
        error_green = -outImg[(int)(srcpos+1 )] + rawData_copy[srcpos+1];
        error_blue = -outImg[(int)(srcpos+2 )] + rawData_copy[srcpos+2];

        srcpos= (x*w +1 )*4;
        
        rawData[(int)(srcpos )] =   (char)(7/16) * error_red + rawData_copy[srcpos];
        rawData[(int)(srcpos+1 )] = (char)(7/16) * error_green + rawData_copy[srcpos+1];
        rawData[(int)(srcpos+2 )] = (char)(7/16) * error_blue + rawData_copy[srcpos+2];
        
        srcpos= ((x+1)*w +1 )*4;
       //r NSLog(@"src pose is : %i", srcpos);
        
        rawData[(int)(srcpos )] =   (char)(1/16) * error_red + rawData_copy[srcpos];
        rawData[(int)(srcpos+1 )] = (char)(1/16) * error_green + rawData_copy[srcpos+1];
        rawData[(int)(srcpos+2 )] = (char)(1/16) * error_blue + rawData_copy[srcpos+2];
        
        srcpos= ((x+1)*w )*4;
        
        rawData[(int)(srcpos )] = (char)(5/16) * error_red + rawData_copy[srcpos];
        rawData[(int)(srcpos+1 )] = (char)(5/16) * error_green + rawData_copy[srcpos+1];
        rawData[(int)(srcpos+2 )] = (char)(5/16) * error_blue + rawData_copy[srcpos+2];
        
//        outImg(rows,1) =255*(y(rows,1)>=T);
//        error = -outImg(rows,1) + y(rows,1);
//        y(rows,1+1) = 7/16 * error + y(rows,1+1);
//        y(rows+1,1+1) = 1/16 * error + y(rows+1,1+1);
//        y(rows+1,1) = 5/16 * error + y(rows+1,1);
        
        
        for(int y =1; y<w-1; y++){
            srcpos= (x*w + y)*4;
            
            
            
//            outImg(rows,cols) =255*(y(rows,cols)>=T);
//            error = -outImg(rows,cols) + y(rows,cols);
//            y(rows,cols+1) = 7/16 * error + y(rows,cols+1);
//            y(rows+1,cols+1) = 1/16 * error + y(rows+1,cols+1);
//            y(rows+1,cols) = 5/16 * error + y(rows+1,cols);
//            y(rows+1,cols-1) = 3/16 * error + y(rows+1,cols-1);
            
            outImg[(int)(srcpos )] =   (char) 255* (rawData_copy[srcpos]>=threshold);
            outImg[(int)(srcpos+1 )] = (char) 255* (rawData_copy[srcpos+1]>=threshold);
            outImg[(int)(srcpos+2 )] = (char) 255* (rawData_copy[srcpos+2]>=threshold);
            
            error_red =   -outImg[(int)(srcpos )] + rawData_copy[srcpos];
            error_green = -outImg[(int)(srcpos+1 )] + rawData_copy[srcpos+1];
            error_blue =  -outImg[(int)(srcpos+2 )] + rawData_copy[srcpos+2];
            
            srcpos= (x*w + (y+1) )*4;
            
            rawData[(int)(srcpos )] = (char)(7/16) * error_red + rawData_copy[srcpos];
            rawData[(int)(srcpos+1 )] = (char)(7/16) * error_green + rawData_copy[srcpos+1];
            rawData[(int)(srcpos+2 )] = (char)(7/16) * error_blue + rawData_copy[srcpos+2];
            
            srcpos= ((x+1)*w + (y+1))*4;
            
            rawData[(int)(srcpos )] = (char)(1/16) * error_red + rawData_copy[srcpos];
            rawData[(int)(srcpos+1 )] = (char)(1/16) * error_green + rawData_copy[srcpos+1];
            rawData[(int)(srcpos+2 )] = (char)(1/16) * error_blue + rawData_copy[srcpos+2];
            
            srcpos= ((x+1)*w +y )*4;
            
            rawData[(int)(srcpos )] = (char)(5/16) * error_red + rawData_copy[srcpos];
            rawData[(int)(srcpos+1 )] = (char)(5/16) * error_green + rawData_copy[srcpos+1];
            rawData[(int)(srcpos+2 )] = (char)(5/16) * error_blue + rawData_copy[srcpos+2];
            
            srcpos= ((x+1)*w +(y-1) )*4;
            
            rawData[(int)(srcpos )] = (char)(3/16) * error_red + rawData_copy[srcpos];
            rawData[(int)(srcpos+1 )] = (char)(3/16) * error_green + rawData_copy[srcpos+1];
            rawData[(int)(srcpos+2 )] = (char)(3/16) * error_blue + rawData_copy[srcpos+2];
           
        }
        
//        %Right Boundary of Image
//        outImg(rows,N) =255*(y(rows,N)>=T);
//        error = -outImg(rows,N) + y(rows,N);
//        y(rows+1,N) = 5/16 * error + y(rows+1,N);
//        y(rows+1,N-1) = 3/16 * error + y(rows+1,N-1);
        
//        srcpos= (x*w + w)*4;
//        
//        outImg[(int)(srcpos )] =   (char) 255* (rawData_copy[srcpos]>=threshold);
//        outImg[(int)(srcpos+1 )] = (char) 255* (rawData_copy[srcpos+1]>=threshold);
//        outImg[(int)(srcpos+2 )] = (char) 255* (rawData_copy[srcpos+2]>=threshold);
//        
//        error_red =   -outImg[(int)(srcpos )] + rawData_copy[srcpos];
//        error_green = -outImg[(int)(srcpos+1 )] + rawData_copy[srcpos+1];
//        error_blue =  -outImg[(int)(srcpos+2 )] + rawData_copy[srcpos+2];
//        
//        srcpos= ((x+1)*w +w )*4;
//        
//        rawData[(int)(srcpos )] =   (char)(5/16) * error_red + rawData_copy[srcpos];
//        rawData[(int)(srcpos+1 )] = (char)(5/16) * error_green + rawData_copy[srcpos+1];
//        rawData[(int)(srcpos+2 )] = (char)(5/16) * error_blue + rawData_copy[srcpos+2];
//        
//        srcpos= ((x+1)*w +(w-1) )*4;
//        
//        rawData[(int)(srcpos )] =   (char)(3/16) * error_red + rawData_copy[srcpos];
//        rawData[(int)(srcpos+1 )] = (char)(3/16) * error_green + rawData_copy[srcpos+1];
//        rawData[(int)(srcpos+2 )] = (char)(3/16) * error_blue + rawData_copy[srcpos+2];
        
    }
    
//    %Bottom & Left Boundary of Image
//    rows = M;
//    outImg(rows,1) =255*(y(rows,1)>=T);
//    error = -outImg(rows,1) + y(rows,1);
//    y(rows,1+1) = 7/16 * error + y(rows,1+1);
//    
//    %Bottom & Center of Image
//    for cols = 2:N-1
//        outImg(rows,cols) =255*(y(rows,cols)>=T);
//    error = -outImg(rows,cols) + y(rows,cols);
//    y(rows,cols+1) = 7/16 * error + y(rows,cols+1);
//    end
//    
//    %Thresholding
//    outImg(rows,N) =255*(y(rows,N)>=T);
//    
//    outImg = im2bw(uint8(outImg));
//    
    

    
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
