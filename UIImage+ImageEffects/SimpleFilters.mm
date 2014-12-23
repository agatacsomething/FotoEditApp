//
//  SimpleFilters.m
//  BlurDemo
//
//  Created by Agata on 11/30/14.
//  Copyright (c) 2014 tutsPlus. All rights reserved.
//


#ifdef __cplusplus
#import "opencv.hpp"
#endif

#import "SimpleFilters.h"
#import "MatConverter.h"

@implementation UIImage (SimpleFilters)

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    NSLog(@"random size: %f, %f,", size.width, size.width);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return destImage;
}



- (UIImage *)convertImageToGrayScale:(UIImage *)image
{
    // Create image rectangle with current image width/height
    CGRect imageRect = CGRectMake(0, 0, image.size.width, image.size.height);
    
    // Grayscale color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    
    // Create bitmap content with current image size and grayscale colorspace
    CGContextRef context = CGBitmapContextCreate(nil, image.size.width, image.size.height, 8, 0, colorSpace, kCGImageAlphaNone);
    
    // Draw image into current context, with specified rectangle
    // using previously defined context (with grayscale colorspace)
    CGContextDrawImage(context, imageRect, [image CGImage]);
    
    // Create bitmap image info from pixel data in current context
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    
    // Create a new UIImage object
    UIImage *newImage = [UIImage imageWithCGImage:imageRef];
    
    // Release colorspace, context and bitmap information
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    CFRelease(imageRef);
    
    // Return the new grayscale image
    return newImage;
}

- (UIImage *)convertImageToGraySquares:(UIImage *)image: (int)z
{
   // int z = 40;
    if(z==0){
        z = 10;
    }
    
    NSLog(@"trying out grey squares");
    NSUInteger width = image.size.width; //CGImageGetWidth(imageRef);
    NSUInteger height = image.size.height; //CGImageGetHeight(imageRef);
    
    double w = width;
    double h = height;
    
     NSLog(@"trying out grey squares %f", w*h*4);
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
    
    NSInteger *chk_mask;
    
    
    int nw = ceil((double)width/z);
    int nh = ceil((double)height/z);

    
//    int nw = width/z;
//    int nh = height/z;
    NSLog(@"nh nw %i %i", nw, nh);
    int max_src = w*h*4;
    
    for(int x = 0; x<nh; x++){
        for(int y =0; y<nw; y++){

                if(x%2 ==0 && y%2==0){
                    
                        
                       // int srcpos = i*j*4;
                    for(int i=z*x; i<z*(x+1); i++){
                        for(int j=z*y; j<z*(y+1); j++){
                            int srcpos = (i*w+j)*4;
                            
                            if (srcpos<max_src && i<h && j<w){
                                int grey_val = (rawData_copy[(int)(srcpos )] + rawData_copy[(int)(srcpos +1 )] + rawData_copy[(int)(srcpos +2)])/3;
                                rawData[(int)(srcpos )] =  (char) grey_val;
                                rawData[(int)(srcpos +1)] =(char) grey_val;
                                rawData[(int)(srcpos +2)] =(char) grey_val;
                                rawData[(int)(srcpos +3)] =(char) 255;
                            }
                            //byteIndex +=4;
                        }
                    }
                        //
                }
                    
                else if(x%2 ==1 && y%2==1) {
                    for(int i=z*x; i<z*(x+1); i++){
                        for(int j=z*y; j<z*(y+1); j++){
                            int srcpos = (i*w+j)*4;
                            
                            if (srcpos<max_src&& i<h && j<w){
                                int grey_val = (rawData_copy[(int)(srcpos )] + rawData_copy[(int)(srcpos +1 )] + rawData_copy[(int)(srcpos +2)])/3;
                                rawData[(int)(srcpos )] =  (char) grey_val;
                                rawData[(int)(srcpos +1)] =(char) grey_val;
                                rawData[(int)(srcpos +2)] =(char) grey_val;
                                rawData[(int)(srcpos +3)] =(char) 255;
                            }
                        }
                    }
                }
            

                else {
                    for(int i=z*x; i<z*(x+1); i++){
                        for(int j=z*y; j<z*(y+1); j++){
                            int srcpos = (i*w+j)*4;
                            
                            if (srcpos<max_src && i<h && j<w){
                                rawData[(int)(srcpos )] =  (char) rawData_copy[srcpos];
                                rawData[(int)(srcpos +1)] =(char) rawData_copy[srcpos+1];
                                rawData[(int)(srcpos +2)] =(char) rawData_copy[srcpos+2];
                                rawData[(int)(srcpos +3)] =(char) 255;
                            }
                        }
                    }
//                        byteIndex +=4;
                }
            
                //byteIndex +=4;
                    
            
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

- (UIImage *)convertImageToGrayStripes:(UIImage *)image: (int)z
{
    // int z = 40;
    if(z==0){
        z =1;
    }
    
    CGFloat value = (arc4random() % 3);
    int vbars;
    int hbars;
   
    if(value==0) { hbars =1; vbars=0;}
    else if(value==1) { hbars =0; vbars=1;}
    else { hbars =1; vbars=1;}
    
     NSLog(@"trying out grey stripes %f %i %i", value, hbars, vbars);
    
    NSUInteger width = image.size.width; //CGImageGetWidth(imageRef);
    NSUInteger height = image.size.height; //CGImageGetHeight(imageRef);
    
    double w = width;
    double h = height;
    
    NSLog(@"trying out grey squares %f", w*h*4);
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
    
    NSInteger *chk_mask;
    
    
    
    int nw = ceil((double)width/z);
    int nh = ceil((double)height/z);
    
    
    //    int nw = width/z;
    //    int nh = height/z;
    NSLog(@"nh nw %i %i %i", z, nw, nh);
    int max_src = w*h*4;
    
    for(int x = 0; x<nh; x++){
        for(int y =0; y<nw; y++){
            
            if(x%2 ==0){
                
                
                // int srcpos = i*j*4;
                for(int i=z*x; i<z*(x+1); i++){
                    for(int j=0; j<w; j++){
                        int srcpos = (i*w+j)*4;
                        
                        if (srcpos<max_src && i<h && j<w){
                            int grey_val = (rawData_copy[(int)(srcpos )] + rawData_copy[(int)(srcpos +1 )] + rawData_copy[(int)(srcpos +2)])/3;
                            rawData[(int)(srcpos )] =  (char) grey_val;
                            rawData[(int)(srcpos +1)] =(char) grey_val;
                            rawData[(int)(srcpos +2)] =(char) grey_val;
                            rawData[(int)(srcpos +3)] =(char) 255;
                        }
                        //byteIndex +=4;
                    }
                }
                //
            }
            
            else  {
                for(int i=z*x; i<z*(x+1); i++){
                    for(int j=0; j<w; j++){
                        int srcpos = (i*w+j)*4;
                        
                        if (srcpos<max_src&& i<h && j<w){
                            int srcpos = (i*w+j)*4;
                            
                            if (srcpos<max_src && i<h && j<w){
                                rawData[(int)(srcpos )] =  (char) rawData_copy[srcpos];
                                rawData[(int)(srcpos +1)] =(char) rawData_copy[srcpos+1];
                                rawData[(int)(srcpos +2)] =(char) rawData_copy[srcpos+2];
                                rawData[(int)(srcpos +3)] =(char) 255;
                            }
                        }
                    }
                }
            }
            
            
            
            //byteIndex +=4;
            
            
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


- (UIImage *)convertImageToFisheye:(UIImage *)image : (double)z;
{
    NSLog(@"trying out fisheye %f", z);
    NSUInteger width = image.size.width; //CGImageGetWidth(imageRef);
    NSUInteger height = image.size.height; //CGImageGetHeight(imageRef);
    
    NSUInteger num_cols = width;
    
    double w = width;
    double h = height;
    
   // UIImage *image_new = [self imageWithImage: image :csq_size];
    
    CGContextRef ctx;
    CGImageRef imageRef = [image CGImage];
   // CGContextRef ctx = [self createARGBBitmapContextFromImage:imageRef];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGSize imageSize = CGSizeMake(image.size.width, image.size.width);
    UIColor *fillColor = [UIColor blackColor];
    UIGraphicsBeginImageContextWithOptions(imageSize, YES, 0);
    CGContextRef context_black = UIGraphicsGetCurrentContext();
    [fillColor setFill];
    CGContextFillRect(context_black, CGRectMake(0, 0, imageSize.width, imageSize.height));
    UIImage *image_black = UIGraphicsGetImageFromCurrentImageContext();
    CGImageRef imageRef_black = [image_black CGImage];
    
    
    Byte minvalg= 0;
    
    
    Byte *rawData = (Byte *)malloc(height * width * 4);
    for(int k =0; k<height * width * 4; k++){
        //rawData[k]= minvalg;
    }

    
    Byte *rawData_copy = (Byte *)malloc(height * width * 4);
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData_copy, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
    
    
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextDrawImage(context_black, CGRectMake(0, 0, width, height), imageRef_black);
    CGContextRelease(context);
    CGContextRelease(context_black);
    
    //rawData_copy=rawData;
    
    int diff_hw=(height-width)/2;
    
    int test_inds = 6*4;//(0*num_cols+1)*4;
    NSLog(@"trying out fisheye setup, %d, %d, %d, %d", diff_hw, rawData_copy[test_inds], rawData_copy[test_inds+1], rawData_copy[test_inds+2]);
    //575 279 255 32 28
    
    int byteIndex = 0 ;
    for (int y = 0 ; y < h; y++)
    {
        
        double ny = 2.0*y/h-1;
        double ny2 = ny*ny/z;
        //CGFloat na =
        
        for (int x =0; x<w; x++){
       // int grey = (rawData[byteIndex] + rawData[byteIndex+1] + rawData[byteIndex+2]) / 3;
        
    
        
        double nx = 2.0*x/w-1;
        double nx2 = nx*nx/z;

        double r = sqrt(nx2+ny2);
        //NSLog(@"trying out fisheye new radius %f, ", r);
         
            
        if (0.0<=r&&r<=1.0) {
            double nr = sqrt(1.0-r*r);
            nr = (r + (1.0-nr)) / 2.0;
            
            if (nr<=1.0) {

                
                double theta = atan2(ny,nx);
                double nxn = nr*cos(theta);
                double nyn = nr*sin(theta);
                int x2 = (int)(((nxn+1)*w)/2.0);
                int y2 = (int)(((nyn+1)*h)/2.0);
               // NSLog(@"x2 y2 %d %d " , x2, y2);
                int srcpos = (y2*w+x2 -1)*4;
                //int srcpos3 = ((int)y2*num_cols + (int)x2)*4;
               // srcpos= srcpos3;//(int)byteIndex+25*4;
                
                if (srcpos>=0 & srcpos < h*w*4) {
                    
                    rawData[(int)(byteIndex )] =  (char) rawData_copy[srcpos];
                    rawData[(int)(byteIndex +1)] =(char) rawData_copy[srcpos+1];
                    rawData[(int)(byteIndex +2)] =(char) rawData_copy[srcpos+2];
                    rawData[byteIndex+3] = (char)255;
                    
                    if(y>=h/2+1)
                    {
                    //   NSLog(@"rawData_copy[srcpos] vals %d %d %d %d %d %d", srcpos, x2, y2, rawData_copy[srcpos], rawData_copy[srcpos+1], rawData_copy[srcpos+2]);
                        //NSLog(@"rawData[srcpos] vals %d %d %d %d", srcpos, rawData[byteIndex], rawData[byteIndex+1], rawData[byteIndex+2]);
                    }
                  //
                   // if (rawData_copy[srcpos]==43 && rawData_copy[srcpos+1]==38)// 38
                   // {
                //    NSLog(@"rawData_copy[srcpos] vals %d %d %d %d", srcpos, rawData_copy[srcpos], rawData_copy[srcpos+1], rawData_copy[srcpos+2]);
                        double nsc =(srcpos/4+1);
                        double newval = nsc/(double)num_cols;
                        int x_corr = ceil(newval);
                        //int y_corr = (nsc%num_cols);
                        
                        int xc2 = x_corr;
                        int yc2 = (nsc-xc2)/num_cols;
                        
                        int new_sc =(yc2*(int)num_cols +x_corr-1)*4;
                //    NSLog(@"rawData[srcpos] vals %d %d %d %d, %f", srcpos, new_sc, x, y, newval);
                  //  }

                }
                
//                else{
//                    int minval = 0;
//                    rawData[byteIndex] =  (char)minval;
//                    rawData[byteIndex+1] =(char)minval;
//                    rawData[byteIndex+2] = (char)minval;
//                    
//                }
            }
            
//            else{
//                int minval = 0;
//                rawData[byteIndex] =  (char)minval;
//                rawData[byteIndex+1] = (char)minval;
//                rawData[byteIndex+2] = (char)minval;
//            
//            }
        }

                        else{
                            int minval = 0;
                            rawData[byteIndex] =  (char)minval;
                            rawData[byteIndex+1] = (char)minval;
                            rawData[byteIndex+2] = (char)minval;
                            rawData[byteIndex+3] = (char)255;
                        }
            
        
        
        byteIndex += 4;
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

    
    // Create image rectangle with current image width/height
//    CGRect imageRect = CGRectMake(0, 0, image.size.width, image.size.height);
//    
//    CGFloat centerWidth = image.size.width/2;
//    CGFloat centerHeight = image.size.height/2;

    
//    for(int i =0; i<image.size.width; i++){
//        for(int j =0; j<image.size.height; j++){
////            CGFloat nx = (2*i-image.size.width)-1;
////            CGFloat ny = (2*j-image.size.height)-1;
////            CGFloat nx2 = nx*nx;
////            CGFloat ny2 = ny*ny;
//            
//            CGFloat r = sqrt(nx2+ny2);
//            
//            if (0.0<=r&&r<=1.0) {
//                CGFloat nr = sqrt(1.0-r*r);
//                nr = (r + (1.0-nr)) / 2.0;
//                
//                if (nr<=1.0) {
//                    CGFloat theta = atan2(ny,nx);
//                    CGFloat nxn = nr*cos(theta);
//                    CGFloat nyn = nr*sin(theta);
//                    CGFloat x2 = (CGFloat)(((nxn+1)*image.size.width)/2.0);
//                    CGFloat y2 = (CGFloat)(((nyn+1)*image.size.height)/2.0);
//                    CGFloat srcpos = (CGFloat)(y2*image.size.width+x2);
//                    if (srcpos>=0 & srcpos < image.size.width*image.size.height) {
//                        newImage[(CGFloat)(j*image.size.width+i)] = image[srcpos];
//                    }
//                }
//            }
//        }
//    }
    
    // Grayscale color space
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
//    
//    // Create bitmap content with current image size and grayscale colorspace
//    CGContextRef context = CGBitmapContextCreate(nil, image.size.width, image.size.height, 8, 0, colorSpace, kCGImageAlphaNone);
//    
    // Draw image into current context, with specified rectangle
    // using previously defined context (with grayscale colorspace)
//    CGContextDrawImage(context, imageRect, [image CGImage]);
//    
//    // Create bitmap image info from pixel data in current context
//    CGImageRef imageRef = CGBitmapContextCreateImage(context);
//    
//    // Create a new UIImage object
//    UIImage *newImage = [UIImage imageWithCGImage:imageRef];
//    
//    // Release colorspace, context and bitmap information
//    CGColorSpaceRelease(colorSpace);
//    CGContextRelease(context);
//    CFRelease(imageRef);
    
    // Return the new grayscale image
    //return newImage;
}


typedef unsigned char byte;
#define Clamp255(a) (a>255 ? 255 : a)

//+ (UIImage*) fromImage:(UIImage*)source toColourR:(int)colR g:(int)colG b:(int)colB {
//    
//    // Thanks: http://brandontreb.com/image-manipulation-retrieving-and-updating-pixel-values-for-a-uiimage/
//    CGContextRef ctx;
//    CGImageRef imageRef = [source CGImage];
//    NSUInteger width = CGImageGetWidth(imageRef);
//    NSUInteger height = CGImageGetHeight(imageRef);
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//    byte *rawData = malloc(height * width * 4);
//    NSUInteger bytesPerPixel = 4;
//    NSUInteger bytesPerRow = bytesPerPixel * width;
//    NSUInteger bitsPerComponent = 8;
//    CGContextRef context = CGBitmapContextCreate(rawData, width, height,
//                                                 bitsPerComponent, bytesPerRow, colorSpace,
//                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
//    
//    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
//    CGContextRelease(context);
//    
//    int byteIndex = 0;
//    for (int ii = 0 ; ii < width * height ; ++ii)
//    {
//        int grey = (rawData[byteIndex] + rawData[byteIndex+1] + rawData[byteIndex+2]) / 3;
//        
//        rawData[byteIndex] = Clamp255(colR*grey/256);
//        rawData[byteIndex+1] = Clamp255(colG*grey/256);
//        rawData[byteIndex+2] = Clamp255(colB*grey/256);
//        
//        byteIndex += 4;
//    }
//    
//    ctx = CGBitmapContextCreate(rawData,
//                                CGImageGetWidth( imageRef ),
//                                CGImageGetHeight( imageRef ),
//                                8,
//                                bytesPerRow,
//                                colorSpace,
//                                kCGImageAlphaPremultipliedLast );
//    CGColorSpaceRelease(colorSpace);
//    
//    imageRef = CGBitmapContextCreateImage (ctx);
//    UIImage* rawImage = [UIImage imageWithCGImage:imageRef];
//    CGImageRelease(imageRef);
//    
//    CGContextRelease(ctx);
//    free(rawData);
//    
//    return rawImage;
//}

- (CGContextRef) createARGBBitmapContextFromImage:(CGImageRef) inImage {
    
    CGContextRef    context = NULL;
    //CGColorSpaceRef colorSpace;
    void *          bitmapData;
    int             bitmapByteCount;
    int             bitmapBytesPerRow;
    
    // Get image width, height. We'll use the entire image.
    size_t pixelsWide = CGImageGetWidth(inImage);
    size_t pixelsHigh = CGImageGetHeight(inImage);
    
    // Declare the number of bytes per row. Each pixel in the bitmap in this
    // example is represented by 4 bytes; 8 bits each of red, green, blue, and
    // alpha.
    bitmapBytesPerRow   = (pixelsWide * 4);
    bitmapByteCount     = (bitmapBytesPerRow * pixelsHigh);
    
    // Use the generic RGB color space.
    //colorSpace = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    if (colorSpace == NULL)
    {
        fprintf(stderr, "Error allocating color space\n");
        return NULL;
    }
    
    // Allocate memory for image data. This is the destination in memory
    // where any drawing to the bitmap context will be rendered.
    bitmapData = malloc( bitmapByteCount );
    if (bitmapData == NULL)
    {
        fprintf (stderr, "Memory not allocated!");
        CGColorSpaceRelease( colorSpace );
        return NULL;
    }
    
    // Create the bitmap context. We want pre-multiplied ARGB, 8-bits
    // per component. Regardless of what the source image format is
    // (CMYK, Grayscale, and so on) it will be converted over to the format
    // specified here by CGBitmapContextCreate.
    context = CGBitmapContextCreate (bitmapData,
                                     pixelsWide,
                                     pixelsHigh,
                                     8,      // bits per component
                                     bitmapBytesPerRow,
                                     colorSpace,
                                     kCGImageAlphaPremultipliedFirst);
    if (context == NULL)
    {
        free (bitmapData);
        fprintf (stderr, "Context not created!");
    }
    
    // Make sure and release colorspace before returning
    CGColorSpaceRelease( colorSpace );
    
    return context;
}

- (UIImage *)flipImage:(UIImage *)image: (int)which_axis
{
    
    NSLog(@"which axis %d", which_axis);
    CGContextRef ctx;
    CGImageRef imageRef = [image CGImage];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    NSUInteger width = image.size.width; //CGImageGetWidth(imageRef);
    NSUInteger height = image.size.height; //CGImageGetHeight(imageRef);
 
    byte *rawData = (Byte *)malloc(height * width * 4);
    byte *rawData_copy = (Byte *)malloc(height * width * 4);
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
    
    
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
    
    rawData_copy=rawData;
    
    NSLog(@"flipping image");
    
    int num_rows = (int)height;
    int num_cols = (int)width;
    int flipped_x;
    int flipped_y;
    
    int byteIndex = 0;
    for (int ii = 0 ; ii < num_rows ; ++ii)
    {

        for (int jj = 0; jj<num_cols; ++jj){

            if (which_axis==1){
                 flipped_x =ii; //(int)width/2-ii;
                 flipped_y =num_cols-jj;//(int)height/2-jj;
            }
            else if (which_axis==2){
                 flipped_x =num_rows-ii; //(int)width/2-ii;
                 flipped_y =jj;//(int)height/2-jj;
            }
            else{
                // rise over run
                int slope =height/width;
                flipped_x =num_rows-ii; //(int)width/2-ii;
                flipped_y =num_cols-jj;;//(int)height/2-jj;
            }
            
            int srcpos =(flipped_x*(int)num_cols +flipped_y)*4;
            
            rawData[(int)(byteIndex )] =  (char) rawData_copy[srcpos];
            rawData[(int)(byteIndex +1)] =(char) rawData_copy[srcpos+1];
            rawData[(int)(byteIndex +2)] =(char) rawData_copy[srcpos+2];
            
            
            byteIndex += 4;
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

- (UIImage *)pixelator:(UIImage *)image
{

    int z = (arc4random() % 10) +1;
    
    NSLog(@"trying out pixelator ");
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
    
    for(int x = 0; x<nh; x++){
        for(int y =0; y<nw; y++){
            
            int red_val = 0;
            int green_val = 0;
            int blue_val = 0;
            
            for(int i=z*x; i<z*(x+1); i++){
                for(int j=z*y; j<z*(y+1); j++){
                    int srcpos = (i*w+j)*4;
                    
                    if (srcpos <max_src){
                        red_val = red_val + rawData_copy[(int)(srcpos )];
                        green_val = green_val + rawData_copy[(int)(srcpos+1)];
                        blue_val = blue_val + rawData_copy[(int)(srcpos+2)];
                    }
                    
                }
            }
            
            int low_val = z;
            int high_val =z;
            red_val = red_val/(low_val*high_val);
            green_val = green_val/(low_val*high_val);
            blue_val = blue_val/(low_val*high_val);
            
            //NSLog(@"RGB vals %i, %i, %i ",red_val,green_val,blue_val);
            
            for(int i=z*x; i<z*(x+1); i++){
                for(int j=z*y; j<z*(y+1); j++){
                    int srcpos = (i*w+j)*4;
                        
                    if (srcpos<max_src && i<h && j<w){
                        rawData[(int)(srcpos )] =  (char) red_val;
                        rawData[(int)(srcpos +1)] =(char) green_val;
                        rawData[(int)(srcpos +2)] =(char) blue_val;
                        rawData[(int)(srcpos +3)] =(char) 255;
                        }
                        //byteIndex +=4;
                    }
                }
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



- (UIImage *)whitebalance:(UIImage *)image
{
    
    NSLog(@"trying out convertToBlueTone ");
    NSUInteger w = image.size.width; //CGImageGetWidth(imageRef);
    NSUInteger h = image.size.height; //CGImageGetHeight(imageRef);
    
    MatConverter* mc = [[MatConverter alloc] init];
    
    cv::Mat img_cvmat = [mc cvMatFromUIImage:image];
    cv::Mat new_image = cv::Mat::zeros( h,w, CV_8UC4 );
    
    double sum_r= 0;
    double sum_g= 0;
    double sum_b= 0;
    
    for( int y = 0; y < new_image.rows; y++ ){
        for( int x = 0; x < new_image.cols; x++ ){
            sum_r =sum_r + img_cvmat.at<cv::Vec4b>(y, x)[0];
            sum_g =sum_g + img_cvmat.at<cv::Vec4b>(y, x)[1];
            sum_b =sum_b + img_cvmat.at<cv::Vec4b>(y, x)[2];
            
        }
    }

    
    double mean_r= sum_r/(w*h);
    double mean_g= sum_g/(w*h);
    double mean_b= sum_b/(w*h);
    double mean_grey= (mean_r+mean_g+mean_b)/3.0;
    
    double scale_r= MAX(mean_grey,128)/mean_r;
    double scale_g= MAX(mean_grey,128)/mean_g;
    double scale_b= MAX(mean_grey,128)/mean_b;
    
    for( int y = 0; y < new_image.rows; y++ ){
        for( int x = 0; x < new_image.cols; x++ ){
            //for( int c = 0; c < 3; c++ ){

//            int grey_val = (img_cvmat.at<cv::Vec4b>(y,x)[0] + img_cvmat.at<cv::Vec4b>(y,x)[1] + img_cvmat.at<cv::Vec4b>(y,x)[2])/3;
            
            double iR =img_cvmat.at<cv::Vec4b>(y, x)[0];
            double iG =img_cvmat.at<cv::Vec4b>(y, x)[1];
            double iB =img_cvmat.at<cv::Vec4b>(y, x)[2];
            
            int randomNum = rand() % 20 + (-10);
            
//            int outputRed =  MIN(abs(iR +randomNum)*0.8 ,255);
//            int outputGreen= MIN(iG*0.8,255);
//            int outputBlue = MIN(iB,255);
//            int outputRed =  MIN(iG * .393 + iB *.769 + iR* .189,255);
//            int outputGreen= MIN(iG * .349 + iB *.686 + iR* .168,255);
//            int outputBlue = MIN(iG * .272 + iB *.534 + iR* .131,255);
            
            // First, calculate the current lightness.
            double oldL = iR * 0.30 + iG * 0.59 + iB * 0.11;
            
            // Adjust the color components. This changes lightness.
            //iR = MAX(iR - 30, 0);
            
            // Now correct the color back to the old lightness.
//            float newL = iR * 0.30 + iG * 0.59 + iB * 0.11;
//            int outputRed;
//            int outputGreen;
//            int outputBlue;
//            
//            if (newL > 0) {
//                outputRed = iR * oldL / newL;
//                outputGreen = iG * oldL / newL;
//                outputBlue = iB * oldL / newL;
//            }
//            else{
//                outputRed = iR;
//                outputGreen = iG;
//                outputBlue = iB;
//            }
            
            double t = 0.5;
            //MIN(255,MAX(0,color))
//            int outputRed =   MIN(255, MAX((grey_val + t * (iR - grey_val)),0));
//            int outputGreen = MIN(255, MAX((grey_val + t * (iG - grey_val)),0));
//            int outputBlue =  MIN(255, MAX((grey_val + t * (iB - grey_val)),0));

            
            int outputRed =  MIN(iR*scale_r ,255);
            int outputGreen= MIN(iG*scale_g ,255);
            int outputBlue = MIN(iB*scale_b ,255);
            
            new_image.at<cv::Vec4b>(y,x)[0] = outputRed;
            new_image.at<cv::Vec4b>(y,x)[1] = outputGreen;
            new_image.at<cv::Vec4b>(y,x)[2] = outputBlue;
            new_image.at<cv::Vec4b>(y,x)[3] = 255 ;
        }
    }
   // std::cout << new_image.at<cv::Vec4b>(0,0)[0] << " : " << new_image.at<cv::Vec4b>(0,0)[3] << std::endl;
    
    UIImage *rawImage = [mc UIImageFromCVMat:new_image];
    
    
    return rawImage;
    
}




@end
