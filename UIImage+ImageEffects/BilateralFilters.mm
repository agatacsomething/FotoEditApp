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

#import "MatConverter.h"
#import <Foundation/Foundation.h>

@implementation UIImage (BilateralFilters)

- (UIImage*)bfilter:(UIImage *)image{
    
    NSLog(@"trying out bfilter");
    

    int w = image.size.width; //CGImageGetWidth(imageRef);
    int h = image.size.height; //CGImageGetHeight(imageRef);
    
    MatConverter* mc = [[MatConverter alloc] init];
    
    cv::Mat img_cvmat = [mc cvMatFromUIImage:image];
    img_cvmat.convertTo(img_cvmat, CV_32FC4);
    img_cvmat = img_cvmat/255.0;
    
    cv::Mat img_lab;
    cv::cvtColor(img_cvmat, img_lab, CV_RGB2Lab);
    std::cout << "image_lab " << img_lab.type() << std::endl;
    
    int w_leg = 5;
    int w_width = 2*w_leg+1;
    
    NSLog(@"w_width %d", w_width);
    
    cv::Mat G = [self gaussweights:w_leg];
    
    
    double sigma_r = 0.1;
    sigma_r = sigma_r*100;
    
   // cv::Mat img_lab;
    cv::Mat B (h, w, CV_32FC3);
    

    
    
  //  Bilateral loop
    for(int i = 0; i<h; i++){
        for(int j=0; j<w; j++){
            int iMin = MAX(i-w_leg,0);
            int iMax = MIN(i+w_leg,h-1);
            int jMin = MAX(j-w_leg,0);
            int jMax = MIN(j+w_leg,w-1);
            
            
           
            
           // std::cout << i << " " << j << std::endl;
           // cv::Mat I(img_lab, cv::Rect(iMin, jMin, jMax-jMin+1, iMax-iMin+1));
            cv::Mat I(img_lab, cv::Rect(jMin, iMin, jMax-jMin+1, iMax-iMin+1));
//            std::cout << img_lab.type()<< " : " << I.type() << " : " << I.total() << " : " << img_lab.elemSize() << std::endl;
            
            // split img:
            cv::vector<cv::Mat> channels_img(3);
            cv::split(I, channels_img);
            cv::Mat rch_I, gch_I, bch_I;
            rch_I = channels_img[0];
            gch_I = channels_img[1];
            bch_I = channels_img[2];
            
            cv::Mat dL (I.size(), CV_32F);
          //  std::cout << img_lab.at<cv::Vec4f>(j,i)[0] << std::endl;
            cv::subtract(rch_I,img_lab.at<cv::Vec3f>(i,j)[0], dL);
            cv::Mat da (I.rows, I.cols, CV_32F);
            cv::subtract(gch_I,img_lab.at<cv::Vec3f>(i,j)[1], da);
            cv::Mat db (I.rows, I.cols, CV_32F);
            cv::subtract(bch_I,img_lab.at<cv::Vec3f>(i,j)[2], db);
            
            
            cv::Mat G2(G, cv::Rect(jMin-j+w_leg, iMin-i+w_leg, jMax-jMin+1, iMax-iMin+1));
            cv::Mat dL2;
            cv::pow(dL,2.0,dL2);
            cv::Mat da2;
            cv::pow(da,2.0,da2);
            cv::Mat db2;
            cv::pow(db,2.0,db2);
            cv::Mat H;
            float sig_r2 = 2*sigma_r*sigma_r;
            cv::exp(-(dL2+da2+db2)/sig_r2,H);
            
            cv::Mat F;
            //std::cout << "rch_i: " << H.size() << " fsize: " <<G2.size() << " new dL " << dL <<std::endl;

            cv::multiply(H, G2, F);
            
            
            CvScalar norm_F = cv::sum(F);
            
            cv::Mat Fr, Fg, Fb;
            cv::multiply(F, rch_I, Fr);
            CvScalar norm_fr = cv::sum(Fr);
           // B.at<cv::Vec3f>(j,i)[0] = norm_fr.val[0]/norm_F.val[0];
            B.at<cv::Vec3f>(i,j)[0] = norm_fr.val[0]/norm_F.val[0];
            cv::multiply(F, gch_I, Fg);
            CvScalar norm_fg = cv::sum(Fg);
           // B.at<cv::Vec3f>(j,i)[1] = norm_fg.val[0]/norm_F.val[0];
            B.at<cv::Vec3f>(i,j)[1] = norm_fg.val[0]/norm_F.val[0];
            cv::multiply(F, bch_I, Fb);
             CvScalar norm_fb = cv::sum(Fb);
           /// B.at<cv::Vec3f>(j,i)[2] = norm_fb.val[0]/norm_F.val[0];
            B.at<cv::Vec3f>(i,j)[2] = norm_fb.val[0]/norm_F.val[0];
            
        
        }
    }

//    cv::Mat img_lab_out (h, w, CV_32FC3);
//    cv::cvtColor(img_lab, img_lab_out, CV_RGB2Lab);
//    UIImage* outImage = [mc UIImageFromCVMat: img_lab_out];
//    
//    return outImage;
    
    
//    cv::Mat img_lab_out;// (h, w, CV_32FC3);
//    cv::cvtColor(B, img_lab_out, CV_Lab2RGB);
//    cv::cvtColor(img_lab_out, img_lab_out, CV_RGB2RGBA);
//    std::cout << img_lab_out.at<cv::Vec3f>(0,0)[3] << "step: " << img_cvmat.step[0] << " step2 : " << img_lab_out.step[0]<< std::endl;
//    img_lab_out = img_lab_out*255.0;
//    img_lab_out.convertTo(img_lab_out, CV_8UC4);
    
    
    cv::Mat gray;
    cv::Mat img_orig = [mc cvMatFromUIImage:image];
    cv::cvtColor(img_orig, gray, CV_RGB2GRAY);
    const int MEDIAN_BLUR_FILTER_SIZE = 7;
    cv::medianBlur(gray, gray, MEDIAN_BLUR_FILTER_SIZE);
    cv::Mat edges;
    const int LAPLACIAN_FILTER_SIZE =5;
    cv::Laplacian(gray, edges, CV_8U, LAPLACIAN_FILTER_SIZE);
    cv::Mat mask;
    const int EDGES_THRESHOLD =80;
    cv::threshold(edges, mask, EDGES_THRESHOLD, 255, cv::THRESH_BINARY_INV);
    
    
    
    cv::vector<cv::Mat> channels_out(3);
    cv::split(B, channels_out);
    cv::Mat BL, Ba, Bb;
    BL = channels_out[0];
    Ba = channels_out[1];
    Bb = channels_out[2];
    
    cv::Mat GX,GY;
    cv::Mat kernelx = (cv::Mat_<float>(1,3)<<-0.5, 0, 0.5);
    cv::Mat kernely = (cv::Mat_<float>(3,1)<<-0.5, 0, 0.5);
    
    std:: cout << kernelx<< std::endl;
    std:: cout << kernely<< std::endl;
    cv::filter2D(BL, GX, -1, kernelx);
    cv::filter2D(BL, GY, -1, kernely);
    
    //std::cout << GX<< std::endl;

    
    
    cv::Mat GX2;
    cv::pow(GX,2.0,GX2);
    cv::Mat GY2;
    cv::pow(GY,2.0,GY2);
    cv::Mat GXY, GS;
    GS = GX2+GY2;
    cv::sqrt(GS, GXY);
   // cv::pow(GS,0.5, GXY);
    
    
    float max_gradient = .2;
    
    //GXY = MIN(onez, zeroz);
    
    //std::cout << GXY<< std::endl;
    std::cout << GXY<< std::endl;
    GXY = cv::threshold(GXY, GXY, max_gradient, max_gradient, cv::THRESH_TRUNC);
   
//    GXY = GXY/max_gradient;
    
    cv::Mat E;
    double min_edge_strength = 0.3;
    cv::threshold(GXY, E, min_edge_strength, 255, cv::THRESH_TOZERO);
    cv::Mat EI;
    cv::subtract(1, E, EI);
    std::cout << E.type() << " : " <<  EI.type() << std::endl;
    
    cv::Mat S = 11*GXY+3;
    cv::Mat qb = B;
    float quant_levels      = 8.0;
    float dq = 100/(quant_levels-1);

    cv::Mat BL2= BL;
    BL2 = (1/dq)*BL;
    BL2.convertTo(BL2, CV_8UC1);
    BL2.convertTo(BL2, CV_32FC1);
    BL2 = dq*BL2;
    
    cv::Mat BL3;
    cv::Mat diffbl ;
    cv::subtract(BL,BL2, diffbl);
    
    cv::multiply(S,diffbl,BL3);
    //cv::multiply(F, bch_I, Fb);
    //float testme = BL2.at<float>(1,1);
    
    for(int i = 0; i<BL2.rows; i++){
        for(int j = 0; j<BL2.cols; j++){
            BL2.at<float>(i,j) = BL2.at<float>(i,j) + (dq/2.0)*tanhf(BL3.at<float>(i,j));
        }
    }
    
    cv::vector<cv::Mat> channels_in(3);
    channels_in[0] = BL2;
    channels_in[1] = Ba;
    channels_in[2] = Bb;
    cv::Mat img_lab_out2;
    cv::merge(channels_in, img_lab_out2);
    
    
    cv::cvtColor(img_lab_out2, img_lab_out2, CV_Lab2RGB);
    
   // BL2 = BL2+(dq/2.0)*tanh(BL3);
    cv::Mat img_lab_out3 (h, w, CV_32FC3);
    //img_lab_out3 = img_lab_out2;
    
    
    for(int i = 0; i<img_lab_out2.rows; i++){
        for(int j = 0; j<img_lab_out2.cols; j++){
            //for (int k = 0; k<3; k++){
               // std::cout << GXY.at<float>(i,j) << std::endl;
                img_lab_out3.at<float>(i,j) = img_lab_out2.at<float>(i,j)*(1-mask.at<int>(i,j));
            //}
        }
    }
    
//        cv::vector<cv::Mat> channels_outp(3);
//        cv::split(img_lab_out2, channels_outp);
//        cv::Mat outR, outB, outG;
//        outR = channels_outp[0];
//        outB = channels_outp[1];
//        outG = channels_outp[2];
//    
//    
////        cv::multiply(outR, EI,outR);
////        cv::multiply(outB, EI,outB);
////        cv::multiply(outG, EI,outG);
//        cv::vector<cv::Mat> channels_final(3);
//        channels_final[0] =outR;
//        channels_final[1] =outG;
//        channels_final[2] =outB;
//        cv::Mat img_lab_out3;
//        cv::merge(channels_final,img_lab_out3);
//    
//    std::cout<< "type 1: " << img_lab_out2.type() << " : " << img_lab_out3.type() << std::endl;
    
    //    cv::Mat img_lab_out;// (h, w, CV_32FC3);
    
    
    
    
    cv::vector<cv::Mat> channels_in2(3);
    channels_in2[0] = mask;
    channels_in2[1] = mask;
    channels_in2[2] = mask;
    //std::cout << GXY << std::endl;
    cv::Mat img_lab_out5 = img_lab_out3;
    //cv::merge(channels_in2, img_lab_out5);
    
        //cv::cvtColor(img_lab_out2, img_lab_out2, CV_Lab2RGB);
        cv::cvtColor(img_lab_out5, img_lab_out5, CV_RGB2RGBA);
        img_lab_out5 = img_lab_out5*255.0;
        img_lab_out5.convertTo(img_lab_out5, CV_8UC4);
    
    UIImage* outImage = [mc UIImageFromCVMat: img_lab_out5];
    
    return outImage;
    
}

//- (cv::Mat*)rgb2lab:(cv::Mat*)rgbvals{
//    
////    double R = double(rgbvals[0]) / 255;
////    double G = double(rgbvals[1]) / 255;
////    double B = double(rgbvals[2]) / 255;
//    
//    double R = double(rgbvals->data[0]) / 255;
//    double G = double(rgbvals->data[1]) / 255;
//    double B = double(rgbvals->data[2]) / 255;
//    
//    double T = 0.008856;
//    
//    double X = (R*0.412453+G*0.357580+B*0.180423)/ 0.950456;;
//    double Y = R*0.212671+G*0.715160+B*0.072169;
//    double Z = (R*0.019334+G*0.119193+B*0.950227)/ 1.088754;
//    
//    bool XT = X > T;
//    bool YT = Y > T;
//    bool ZT = Z > T;
//    
//    double X3 = pow(X,(double)1/3);
//    double Y3 = pow(Y,(double)1/3);
//    double Z3 = pow(Y,(double)1/3);
//    
//
//    double fX = XT*X3 + (double)(!XT )*(7.787*X*(16/116));
//    double fY = YT*Y3 + (double)(!YT )*(7.787*Y*(16/116));
//    double fZ = ZT*Z3 + (double)(!ZT )*(7.787*Z*(16/116));
//    
//    double L = YT * (116 * Y3 - 16.0) + (!YT) * (903.3 * Y);
//    double a = 500 * (fX - fY);
//    double b = 200 * (fY - fZ);
//    
////    cv::Mat* lab_vals;
////    lab_vals->create(3, 1, cv::DataType<double>::type);
//    
//    cv::Mat * lab_vals = new cv::Mat( cv::Mat::zeros(3, 1, CV_32F) );
//    
//    //double *lab_vals = (double *)malloc(3);
//    lab_vals->data[0]=L;
//    lab_vals->data[1]=a;
//    lab_vals->data[2]=b;
//    
//     NSLog(@"chhh kasjdlfkja XT, YT, ZT %f %f %f:: %f %f %f", L, a, b, (double)lab_vals->data[0], (double)lab_vals->data[1], (double)lab_vals->data[2]);
//    
//    return lab_vals;
//}

- (cv::Mat)gaussweights:(int)pp{
    
   // int pp = 5;
    int pp2 = pp*2+1;
    int p = -pp;
    double sigma_d = 3;

    cv::Mat xmesh ( pp2, pp2, CV_32F );
    cv::Mat ymesh ( pp2, pp2, CV_32F );
    cv::Mat G( pp2, pp2, CV_32F );
    
    
    for(int x = 0; x<pp2; x++){
        for(int y = 0; y<pp2; y++){
            xmesh.at<float>(x,y) = p;
            ymesh.at<float>(y,x) = p;
        }
        p=p+1;
    }
    
    
    
    
    for(int x = 0; x<pp2; x++){
        for(int y = 0; y<pp2; y++){
            float x2 = xmesh.at<float>(x,y)*xmesh.at<float>(x,y);
            float y2 = ymesh.at<float>(x,y)*ymesh.at<float>(x,y);
            G.at<float>(x,y) =exp(-(x2+y2)/(2*sigma_d*sigma_d));
        }
    }
    

    return G;
}


@end