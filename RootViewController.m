//
//  RootViewController.m
//  BlurDemo
//
//  Created by Sandeep S Kumar on 22/06/14.
//  Copyright (c) 2014 tutsPlus. All rights reserved.
//

#import "RootViewController.h"
#import "UIImage+ImageEffects.h"
#import "SimpleFilters.h"
#import <GPUImage/GPUImage.h>

@interface RootViewController ()

@property UIView *blurMask;
@property UIImageView *blurredBgImage;

@end

@implementation RootViewController

@synthesize blurMask, blurredBgImage;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view.backgroundColor = [UIColor whiteColor];
    
    /*::::::::::::::::::: Create Basic View Components ::::::::::::::::::::::*/
    
    // content view
    [self.view addSubview:[self createContentView]];
    
    // header view
    //[self.view addSubview:[self createHeaderView]];
    
    // slide view
    [self.view addSubview:[self createScrollView]];
    
    /*:::::::::::::::::::::::: Create Blurred View ::::::::::::::::::::::::::*/
    
    // Blurred with UIImage+ImageEffects
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnView:)];
    [self.view addGestureRecognizer:tap];
    
    //UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    //[self.view addGestureRecognizer:gr];
    
    //blurredBgImage.image = [self blurWithImageEffects:[self takeSnapshotOfView:[self createContentView]]];
    
    // Blurred with Core Image
    // blurredBgImage.image = [self blurWithCoreImage:[self takeSnapshotOfView:[self createContentView]]];
    
    // Blurring with GPUImage framework
    // blurredBgImage.image = [self blurWithGPUImage:[self takeSnapshotOfView:[self createContentView]]];

    /*::::::::::::::::::: Create Mask for Blurred View :::::::::::::::::::::*/
    
    //blurMask = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width, 50)];
    //blurMask.backgroundColor = [UIColor whiteColor];
    //blurredBgImage.layer.mask = blurMask.layer;
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    blurMask.frame = CGRectMake(blurMask.frame.origin.x,
                              self.view.frame.size.height - 50 - scrollView.contentOffset.y,
                              blurMask.frame.size.width,
                              blurMask.frame.size.height + scrollView.contentOffset.y);
}

- (UIImage *)takeSnapshotOfView:(UIView *)view
{
    CGFloat reductionFactor = 1;
    UIGraphicsBeginImageContext(CGSizeMake(view.frame.size.width/reductionFactor, view.frame.size.height/reductionFactor));
    [view drawViewHierarchyInRect:CGRectMake(0, 0, view.frame.size.width/reductionFactor, view.frame.size.height/reductionFactor) afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *)blurWithImageEffects: (UIImage *)image : (CGFloat )blur_value
{
    NSLog(@"random number: %f ", blur_value);
    //double bv = blur_value;
   // CGFloat bv = (CGFloat)blur_value;
    //CGFloat bv =blur_value;
    
    if (blur_value<=125){
        CGFloat value = (arc4random() % 40);
        //convertImageToGrayStripes
        return [image convertImageToGrayStripes:[self takeSnapshotOfView:[self createContentView]]:value*5];
    }
    
    else if (blur_value<150 && blur_value>125){
        CGFloat value = (arc4random() % 20);
        //
        return [image convertImageToGraySquares:[self takeSnapshotOfView:[self createContentView]]:value*10];
    }
   // elseif ({
     //   return [image convertImageToGrayScale:[self takeSnapshotOfView:[self createContentView]]];
    //}
    else if (blur_value>=150 && blur_value<175){
        return [image applyBlurWithRadius:blur_value tintColor:[UIColor colorWithWhite:1 alpha:0.2] saturationDeltaFactor:1.5 maskImage:nil];
    }
    
    else if (blur_value>=175 && blur_value<200){
        return [image convertImageToFisheye:[self takeSnapshotOfView:[self createContentView]]:.95];
    }
    
    else{
        int axis2flip;
        
        if(blur_value<100 && blur_value>50) {axis2flip = 1;}
        else if (blur_value>100 && blur_value<150){axis2flip = 2;}
        else {axis2flip = 3;}
        
        return [image flipImage:[self takeSnapshotOfView:[self createContentView]]: axis2flip];

        
    }
    
}

- (UIImage *)blurWithCoreImage:(UIImage *)sourceImage
{
    CIImage *inputImage = [CIImage imageWithCGImage:sourceImage.CGImage];
    
    // Apply Affine-Clamp filter to stretch the image so that it does not look shrunken when gaussian blur is applied
    CGAffineTransform transform = CGAffineTransformIdentity;
    CIFilter *clampFilter = [CIFilter filterWithName:@"CIAffineClamp"];
    [clampFilter setValue:inputImage forKey:@"inputImage"];
    [clampFilter setValue:[NSValue valueWithBytes:&transform objCType:@encode(CGAffineTransform)] forKey:@"inputTransform"];
    
    // Apply gaussian blur filter with radius of 30
    CIFilter *gaussianBlurFilter = [CIFilter filterWithName: @"CIGaussianBlur"];
    [gaussianBlurFilter setValue:clampFilter.outputImage forKey: @"inputImage"];
    [gaussianBlurFilter setValue:@30 forKey:@"inputRadius"];
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgImage = [context createCGImage:gaussianBlurFilter.outputImage fromRect:[inputImage extent]];
    
    // Set up output context.
    UIGraphicsBeginImageContext(self.view.frame.size);
    CGContextRef outputContext = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(outputContext, 1.0, -1.0);
    CGContextTranslateCTM(outputContext, 0, -self.view.frame.size.height);
    
    // Draw base image.
    CGContextDrawImage(outputContext, self.view.frame, cgImage);
    
    // Apply white tint
    CGContextSaveGState(outputContext);
    CGContextSetFillColorWithColor(outputContext, [UIColor colorWithWhite:1 alpha:0.2].CGColor);
    CGContextFillRect(outputContext, self.view.frame);
    CGContextRestoreGState(outputContext);
    
    // Output image is ready.
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return outputImage;
}

- (UIImage *)blurWithGPUImage:(UIImage *)sourceImage
{
    GPUImageGaussianBlurFilter *blurFilter = [[GPUImageGaussianBlurFilter alloc] init];
    blurFilter.blurRadiusInPixels = 30.0;
    
    //    GPUImageBoxBlurFilter *blurFilter = [[GPUImageBoxBlurFilter alloc] init];
    //    blurFilter.blurRadiusInPixels = 20.0;
    
    //    GPUImageiOSBlurFilter *blurFilter = [[GPUImageiOSBlurFilter alloc] init];
    //    blurFilter.saturation = 1.5;
    //    blurFilter.blurRadiusInPixels = 30.0;
    
    
    return [blurFilter imageByFilteringImage: sourceImage];
}

//- (UIView *)createHeaderView
//{
//    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
//    headerView.backgroundColor = [UIColor colorWithRed:229/255.0 green:39/255.0 blue:34/255.0 alpha:0.6];
//    
//    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 40)];
//    title.text = @"Dynamic Blur Demo";
//    title.textColor = [UIColor colorWithWhite:1 alpha:1];
//    [title setFont:[UIFont fontWithName:@"HelveticaNeue" size:20]];
//    [title setTextAlignment:NSTextAlignmentCenter];
//    [headerView addSubview:title];
//    
//    return headerView;
//}

- (UIView *)createContentView
{
    UIView *contentView = [[UIView alloc] initWithFrame:self.view.frame];
    
    UIImageView *contentImage = [[UIImageView alloc] initWithFrame:contentView.frame];
    contentImage.image = [UIImage imageNamed:@"demo-bg"];
    [contentView addSubview:contentImage];
    
//    UIView *metaViewContainer = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 65, 335, 130, 130)];
//    metaViewContainer.backgroundColor = [UIColor whiteColor];
//    metaViewContainer.layer.cornerRadius = 65;
//    [contentView addSubview:metaViewContainer];
//    
//    UILabel *photoTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 54, 130, 18)];
//    photoTitle.text = @"Peach Garden";
//    [photoTitle setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]];
//    [photoTitle setTextAlignment:NSTextAlignmentCenter];
//    photoTitle.textColor = [UIColor colorWithWhite:0.4 alpha:1];
//    [metaViewContainer addSubview:photoTitle];
//    
//    UILabel *photographer = [[UILabel alloc] initWithFrame:CGRectMake(0, 72, 130, 9)];
//    photographer.text = @"by Cas Cornelissen";
//    [photographer setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:9]];
//    [photographer setTextAlignment:NSTextAlignmentCenter];
//    photographer.textColor = [UIColor colorWithWhite:0.4 alpha:1];
//    [metaViewContainer addSubview:photographer];
    
    return contentView;
}

- (UIView *)createScrollView //where image is blurred
{
    UIView *containerView = [[UIView alloc] initWithFrame:self.view.frame];
    
    blurredBgImage = [[UIImageView  alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 568)];
    [blurredBgImage setContentMode:UIViewContentModeScaleToFill];
    [containerView addSubview:blurredBgImage];
    
//    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
//    [containerView addSubview:scrollView];
//    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height*2 - 110);
//    scrollView.pagingEnabled = YES;
//    scrollView.delegate = self;
//    scrollView.bounces = NO;
//    scrollView.showsHorizontalScrollIndicator = NO;
//    scrollView.showsVerticalScrollIndicator = NO;
//    
//    UIView *slideContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 518, self.view.frame.size.width, 508)];
//    slideContentView.backgroundColor = [UIColor clearColor];
//    [scrollView addSubview:slideContentView];
//    
//    UILabel *slideUpLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 6, self.view.frame.size.width, 50)];
//    slideUpLabel.text = @"Photo information";
//    [slideUpLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]];
//    [slideUpLabel setTextAlignment:NSTextAlignmentCenter];
//    slideUpLabel.textColor = [UIColor colorWithWhite:0 alpha:0.5];
//    [slideContentView addSubview:slideUpLabel];
//    
//    UIImageView *slideUpImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 12, 4, 24, 22.5)];
//    slideUpImage.image = [UIImage imageNamed:@"up-arrow.png"];
//    [slideContentView addSubview:slideUpImage];
//    
//    UITextView *detailsText = [[UITextView alloc] initWithFrame:CGRectMake(25, 100, 270, 350)];
//    detailsText.backgroundColor = [UIColor clearColor];
//    detailsText.text = @"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";
//    [detailsText setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:16]];
//    [detailsText setTextAlignment:NSTextAlignmentCenter];
//    detailsText.textColor = [UIColor colorWithWhite:0 alpha:0.6];
//    [slideContentView addSubview:detailsText];
    
    return containerView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tapOnView:(UITapGestureRecognizer *)sender
{
    CGFloat value = (arc4random() % 201);
    //NSLog(@"random number: %i ", value);
    
    CGPoint location = [sender locationInView:self.view];
    
        blurredBgImage.image = [self blurWithImageEffects:[self takeSnapshotOfView:[self createContentView]] : value];
    
    

    NSLog(@"Tap at %1.0f, %1.0f", location.x, location.y);
}

//- (UIImage *)convertImageToGrayScale:(UIImage *)image
//{
//    // Create image rectangle with current image width/height
//    CGRect imageRect = CGRectMake(0, 0, image.size.width, image.size.height);
//    
//    // Grayscale color space
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
//    
//    // Create bitmap content with current image size and grayscale colorspace
//    CGContextRef context = CGBitmapContextCreate(nil, image.size.width, image.size.height, 8, 0, colorSpace, kCGImageAlphaNone);
//    
//    // Draw image into current context, with specified rectangle
//    // using previously defined context (with grayscale colorspace)
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
//    
//    // Return the new grayscale image
//    return newImage;
//}


@end
