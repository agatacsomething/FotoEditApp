//
//  BilateralFilters.m
//  BlurDemo
//
//  Created by Agata on 12/16/14.
//  Copyright (c) 2014 tutsPlus. All rights reserved.
//
#ifdef __cplusplus
#import "opencv.hpp"
#endif

#import <Foundation/Foundation.h>

@implementation UIImage (MemoryTester)

- (UIImage*)memfilter:(UIImage *)image{
    
    NSLog(@"trying out memfilter");
    
//    int stackInt = 5;
//    int *heapInt = (int*)malloc(5);
//    *heapInt = 5;
//    free(heapInt);
//    std::cout<< *heapInt << std::endl;
//    
    double box=60;
    
    
    NSUInteger width = image.size.width; //CGImageGetWidth(imageRef);
    NSUInteger height = image.size.height; //CGImageGetHeight(imageRef);
    
    int w = width;
    int h = height;
    
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
    int w_leg = 5;
    int w_width = 2*w_leg+1;
    
    NSLog(@"w_width %d", w_width);
    
    cv::Mat G(w_width, w_width, CV_32F);
    G = [self gaussweights:w_leg];
    
    
    double sigma_r = 0.1;
    sigma_r = sigma_r*100;
    
    // cv::Mat img_lab;
   // Mat img(Size(1920, 1080), CV_8UC3);
    CGFloat cols = image.size.width;
    CGFloat rows = image.size.height;
    
 //   cv::Mat cvMat(rows, cols, CV_8UC4);
    
    cv::Mat img_cvmat(rows, cols, CV_32FC3); // 8 bits per component, 4 channels
    cv::Mat B(w, h, CV_32FC3);
    
    std::cout << img_cvmat.size() << std::endl;
    
    //Converting image to cv mat
    int byteIndex=0;
    for(int i = 0; i<h; i++){
        for(int j=0; j<w; j++){
            //            for(int i = 314; i<h; i++){
            //                for(int j=319; j<w; j++){
            
            // cv::Mat * rgbvals = new cv::Mat( cv::Mat::zeros(3, 1, CV_32F) );
            
            // std::cout << img_cvmat.size() << std::endl;
            img_cvmat.at<cv::Vec3f>(i,j)[0] =(double)rawData_copy[byteIndex];
            img_cvmat.at<cv::Vec3f>(i,j)[1] =(double)rawData_copy[byteIndex+1];
            img_cvmat.at<cv::Vec3f>(i,j)[2] =(double)rawData_copy[byteIndex+2];
            
        }
        byteIndex +=4;
    }
    
    cv::Mat img_lab (w, h, CV_32FC3); // 8 bits per component, 3 channels
    
   // std::cout rawData_copy[0] << std::endl;
    
    //img_cvmat *= 1./255;
    cv::cvtColor(img_cvmat, img_lab, CV_RGB2Lab);
    std::cout << img_lab.at<cv::Vec3f>(0,0)[0] << " : " << img_lab.at<cv::Vec3f>(1,0)[0] << " : " << img_lab.at<cv::Vec3f>(2,0)[0] << std::endl;
    
//        double *rgbvals = (double *)malloc(3);
//        rgbvals[0]= (double)rawData_copy[0];
//        rgbvals[1]= (double)rawData_copy[1];
//        rgbvals[2]= (double)rawData_copy[2];
    
    cv::Mat *array = new cv::Mat(3, 1, CV_32FC1);
    
    cv::Mat *rgbvals2 = new cv::Mat(3, 1, CV_32FC1);
    rgbvals2->at<cv::Vec3f>(0,0)[0]= img_cvmat.at<cv::Vec3f>(0,0)[0];
    rgbvals2->at<cv::Vec3f>(1,0)[0]= img_cvmat.at<cv::Vec3f>(0,0)[1];
    rgbvals2->at<cv::Vec3f>(2,0)[0]= img_cvmat.at<cv::Vec3f>(0,0)[2];
    
    //std::cout << img_cvmat.at<cv::Vec3f>(0,0)[0] << " : " << rgbvals2->at<cv::Vec3f>(1,0)[0] << std::endl;
    
        array = [self rgb2lab:rgbvals2];
    
    double hh = (double)(255.0/100.0);
    double gg1 =(img_lab.at<cv::Vec3f>(0,0)[0]);
    double gg2 =(img_lab.at<cv::Vec3f>(0,0)[1]);
    double gg3 =(img_lab.at<cv::Vec3f>(0,0)[2]);
    
    std::cout << hh << " " << gg1 << " " << gg2 << " " << gg3 << std::endl;
    std::cout << hh << " " << array->at<double>(1,1) << " " << array->at<double>(2,1) << " " << array->at<double>(3,1) << std::endl;
    cv::vector<cv::Mat> channels_img(3);
    
    std::cout << img_lab.size() << std::endl;
    
    //Bilateral loop
    for(int i = 0; i<h; i++){
        //    for(int i = 314; i<h; i++){
        //        for(int j=319; j<w; j++){
        for(int j=0; j<w; j++){
            int iMin = MAX(i-w_leg,0);
            int iMax = MIN(i+w_leg,h-1);
            int jMin = MAX(j-w_leg,0);
            int jMax = MIN(j+w_leg,w-1);
            
            //std::cout << iMin << " : " << iMax-iMin+1 << " : " <<  j << " : " << jMin<< " : " << jMax-jMin+1 << std::endl;
            
            cv::Mat I(img_lab, cv::Rect(jMin, iMin, jMax-jMin+1, iMax-iMin+1));
            
            cv::Mat dL(iMax-iMin+1, jMax-jMin+1, CV_32FC1);
            cv::Mat da(iMax-iMin+1, jMax-jMin+1, CV_32FC1);
            cv::Mat db(iMax-iMin+1, jMax-jMin+1, CV_32FC1);
            
            cv::Mat endResult;
            std::cout << dL.rows << " " << dL.cols << " " << dL.depth() << std::endl;
            std::cout<< dL << " : " <<img_lab.at<cv::Vec3f>(i,j)[0] << std::endl;
            
            cv::subtract(dL,img_lab.at<cv::Vec3f>(i,j)[0],dL);
            
            std::cout<< dL << std::endl;
            
            //dL = I.at<cv::Vec3f>[0]-A(i,j,1);
            
//            cv::Mat H  (jMax-jMin+1, iMax-iMin+1, CV_8UC4);
//            // cv::Mat G2 (jMax-jMin+1, iMax-iMin+1, CV_8UC4);
//            cv::Mat F  (jMax-jMin+1, iMax-iMin+1, CV_32F);
//            
//            //            NSLog(@"iMax-iMin %d %d %d : %d %d : %d %d", i,j,iMin, iMin-i+w_leg, jMin-j+w_leg, iMax-iMin+1, jMax-jMin+1);
//            
//            cv::Mat G2(G, cv::Rect(iMin-i+w_leg, jMin-j+w_leg, iMax-iMin+1, jMax-jMin+1));
//            //G2((iMin:iMax)-i+w+1,(jMin:jMax)-j+w+1
//            
//            //NSLog(@"iMax-iMin %d", iMax-iMin);
//            
////            for (int m =0; m<rch1.rows; m++){
////                for(int n=0; n<rch1.cols; n++){
////                    double dL = rch1.at<double>(m,n) - img_lab->at<cv::Vec3f>(i,j)[0];
////                    double dL2 = dL*dL;
////                    double da = gch1.at<double>(m,n) - img_lab->at<cv::Vec3f>(i,j)[1];
////                    //double da = I.data[m, n,1] -img_lab.data[i, j,1];
////                    double da2 = da*da;
////                    //double db = I.data[m, n,2] -img_lab.data[i, j,2];
////                    double db = bch1.at<double>(m,n) - img_lab->at<cv::Vec3f>(i,j)[2];
////                    double db2 = db*db;
////                    
////                    //double da2 = (img_lab.data[i, j,1])*(img_lab.data[i, j,1]);
////                    //double db2 = (img_lab.data[i, j,2])*(img_lab.data[i, j,2]);
////                    
////                    double h = exp(-(dL2+da2+db2)/(2*sigma_r*sigma_r));
////                    double g = G2.at<double>(m,n);
////                    F.at<double>(m,n) =h*g;
////                    
////                }
////                
////                // NSLog(@"iMax-iMin %d %d ", F.rows, F.cols);
////            }
////            
//            
//            
//            std::cout<< i << " : " << j << " : " << cv::sum( F )[0] << std::endl;
//            double norm_F = cv::sum( F )[0];
//            //cv::Mat tempf = F.mul(ch1);
//            //  NSLog(@"iMax-iMin width here %d %d : %d %d : %d %d %f", i,j, ch3.rows, ch3.cols, F.rows, F.cols, norm_F);
//            
//            B.at<cv::Vec3f>(i,j)[0] = cv::sum(F.mul(rch1))[0]/norm_F;
//            B.at<cv::Vec3f>(i,j)[1] = cv::sum(F.mul(gch1))[0]/norm_F;
//            B.at<cv::Vec3f>(i,j)[2] = cv::sum(F.mul(bch1))[0]/norm_F;
//            
//            
//            //            F.refcount = 0;
//            //            F.release();
//            G2.refcount = 0;
//            G2.release();
//            //            H.refcount = 0;
//            //            H.release();
//            //            rch.refcount=0;
//            //            rch.release();
//            //            gch.refcount=0;
//            //            gch.release();
//            //            bch.refcount=0;
//            //            bch.release();
//            //            rch1.refcount=0;
//            //            rch1.release();
//            //            gch1.refcount=0;
//            //            gch1.release();
//            //            bch1.refcount=0;
//            //            bch1.release();
//            
            
            
        }
    }
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

- (cv::Mat*)rgb2lab:(cv::Mat*)rgbvals{
    
    //    double R = double(rgbvals[0]) / 255;
    //    double G = double(rgbvals[1]) / 255;
    //    double B = double(rgbvals[2]) / 255;
    
    double R = (rgbvals->at<cv::Vec3f>(0,0)[0]) / 255.0;
    double G = (rgbvals->at<cv::Vec3f>(1,0)[0]) / 255.0;
    double B = (rgbvals->at<cv::Vec3f>(2,0)[0]) / 255.0;
    
//    std::cout << "stddddd " << rgbvals->at<cv::Vec3f>(0,0)[0] << " : " << R << std::endl;
//    
//    NSLog(@"stfffffff %f %f %f:: %f %f %f", rgbvals->at<double>(0,0), rgbvals->at<double>(0,1), rgbvals->at<double>(0,2), R, G, B);
    
    double T = 0.008856;
    
    double X = (R*0.412453+G*0.357580+B*0.180423)/ 0.950456;;
    double Y = R*0.212671+G*0.715160+B*0.072169;
    double Z = (R*0.019334+G*0.119193+B*0.950227)/ 1.088754;
    
    bool XT = X > T;
    bool YT = Y > T;
    bool ZT = Z > T;
    
    double X3 = pow(X,1.0/3.0);
    double Y3 = pow(Y,1.0/3.0);
    double Z3 = pow(Z,1.0/3.0);
    
    double fX = XT*X3 + (double)(!XT )*(7.787*X*(16.0/116.0));
    double fY = YT*Y3 + (double)(!YT )*(7.787*Y*(16.0/116.0));
    double fZ = ZT*Z3 + (double)(!ZT )*(7.787*Z*(16.0/116.0));
    
    double L = YT * (116.0 * Y3 - 16.0) + (!YT) * (903.3 * Y);
    double a = 500.0 * (fX - fY);
    double b = 200.0 * (fY - fZ);
    
    //    cv::Mat* lab_vals;
    //    lab_vals->create(3, 1, cv::DataType<double>::type);
    
    cv::Mat * lab_vals = new cv::Mat( 3, 1, CV_32FC1 );
    
    //double *lab_vals = (double *)malloc(3);
    lab_vals->at<cv::Vec3f>(0,0)[0]=L;
    lab_vals->at<cv::Vec3f>(1,0)[0]=a;
    lab_vals->at<cv::Vec3f>(2,0)[0]=b;
    
    NSLog(@"chhhh XT, YT, ZT %f %f %f:: %f %f %f", L, a, b, R*255.0, G*255.0, B*255.0);
    
    return lab_vals;
}


- (cv::Mat)gaussweights:(int)pp{
    
    // int pp = 5;
    int pp2 = pp*2+1;
    int p = -pp;
    double sigma_d = 3;
    
    cv::Mat xmesh ( pp2, pp2, CV_64F );
    cv::Mat ymesh ( pp2, pp2, CV_64F );
    cv::Mat *G = new cv::Mat( pp2, pp2, CV_32F );
    
    
    for(int x = 0; x<pp2; x++){
        for(int y = 0; y<pp2; y++){
            xmesh.at<double>(x,y) = p;
            ymesh.at<double>(y,x) = p;
        }
        p=p+1;
    }
    
    
    
    
    for(int x = 0; x<pp2; x++){
        for(int y = 0; y<pp2; y++){
            double x2 = xmesh.at<double>(x,y)*xmesh.at<double>(x,y);
            double y2 = ymesh.at<double>(x,y)*ymesh.at<double>(x,y);
            G->at<double>(x,y) =exp(-(x2+y2)/(2*sigma_d*sigma_d));
        }
    }
    
    
    return *G;
}


@end