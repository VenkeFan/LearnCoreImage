//
//  ViewController.m
//  LearnCoreImage
//
//  Created by fan qi on 2018/7/9.
//  Copyright © 2018年 fan qi. All rights reserved.
//

#import "ViewController.h"
#import <AVKit/AVKit.h>
#import "CIColorInvert.h"

static void RGBtoHSV( float r, float g, float b, float *h, float *s, float *v )
{
    float min, max, delta;
    min = MIN( r, MIN( g, b ));
    max = MAX( r, MAX( g, b ));
    *v = max;               // v
    delta = max - min;
    if( max != 0 )
        *s = delta / max;       // s
    else {
        // r = g = b = 0        // s = 0, v is undefined
        *s = 0;
        *h = -1;
        return;
    }
    if( r == max )
        *h = ( g - b ) / delta;     // between yellow & magenta
    else if( g == max )
        *h = 2 + ( b - r ) / delta; // between cyan & yellow
    else
        *h = 4 + ( r - g ) / delta; // between magenta & cyan
    *h *= 60;               // degrees
    if( *h < 0 )
        *h += 360;
}

static void HSVtoRGB( float *r, float *g, float *b, float h, float s, float v )
{
    int i;
    float f, p, q, t;
    if( s == 0 ) {
        // achromatic (grey)
        *r = *g = *b = v;
        return;
    }
    h /= 60;            // sector 0 to 5
    i = floor( h );
    f = h - i;          // factorial part of h
    p = v * ( 1 - s );
    q = v * ( 1 - s * f );
    t = v * ( 1 - s * ( 1 - f ) );
    switch( i ) {
        case 0:
            *r = v;
            *g = t;
            *b = p;
            break;
        case 1:
            *r = q;
            *g = v;
            *b = p;
            break;
        case 2:
            *r = p;
            *g = v;
            *b = t;
            break;
        case 3:
            *r = p;
            *g = q;
            *b = v;
            break;
        case 4:
            *r = t;
            *g = p;
            *b = v;
            break;
        default:        // case 5:
            *r = v;
            *g = p;
            *b = q;
            break;
    }
}

static void RGBtoHSV2(float rgb[], float hsv[])
{
    RGBtoHSV(rgb[0], rgb[1], rgb[2], &hsv[0], &hsv[1], &hsv[2]);
}

static void HSVtoRGB2(float hsv[], float rgb[])
{
    HSVtoRGB(&rgb[0], &rgb[1], &rgb[2], hsv[0], hsv[1], hsv[2]);
}

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *img = [UIImage imageNamed:@"1.jpg"];
    CGFloat size = 300;
    CGFloat centerX = CGRectGetWidth(self.view.bounds) * 0.5, centerY = 88 + size * 0.5;
    CGFloat paddingY = 20;

    {
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        imgView.image = img;
        imgView.frame = CGRectMake(0, 0, size, size);
        imgView.center = CGPointMake(centerX, centerY);
        [self.view addSubview:imgView];

        centerY += (CGRectGetHeight(imgView.frame) + paddingY);
    }

    UIImageView *filteredImgView = [[UIImageView alloc] init];
    filteredImgView.contentMode = UIViewContentModeScaleAspectFit;
    filteredImgView.frame = CGRectMake(0, 0, size, size);
    filteredImgView.center = CGPointMake(centerX, centerY);
    [self.view addSubview:filteredImgView];

    {
//        filteredImgView.image = [self filterWithImage:img];
    }
    {
//        filteredImgView.image = [self autoEnhancementFilters:img];
    }
    {
//        filteredImgView.image = [self chromaKeyFilterRecipe:img];
    }
    {
//        filteredImgView.image = [self whiteVignetteForFacesFilterRecipe:img];
    }
    {
//        filteredImgView.image = [self tiltShiftFilterRecipe:img];
    }
    {
//        filteredImgView.image = [self anonymousFacesFilterRecipe:img];
    }
    {
//        __block NSTimeInterval time = 0.0;
//        [NSTimer scheduledTimerWithTimeInterval:1 / 30.0
//                                        repeats:YES
//                                          block:^(NSTimer * _Nonnull timer) {
//                                              time += 1 / 30.0;
//                                              filteredImgView.image = [self pixellateTransitionFilterRecipe:img time:time];
//                                          }];
    }
    {
        filteredImgView.image = [self oldFilmFilterRecipe:img];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Filters

- (UIImage *)filterWithImage:(UIImage *)image {
    CIImage *inputciImage = [[CIImage alloc] initWithImage:image];
    
    CIFilter *filter = [CIFilter filterWithName:@"CISepiaTone"];
    [filter setValue:@(0.8) forKey:kCIInputIntensityKey];
    [filter setValue:inputciImage forKey:kCIInputImageKey];
    
    CIImage *outputciImg = filter.outputImage;
//    UIImage *img = [UIImage imageWithCIImage:outputciImg];
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef imgRef = [context createCGImage:outputciImg fromRect:outputciImg.extent];
    UIImage *img = [UIImage imageWithCGImage:imgRef];
    CGImageRelease(imgRef);
    
    return img;
}

/**
 自动增强
 */
- (UIImage *)autoEnhancementFilters:(UIImage *)image {
    CIImage *inputciImage = [[CIImage alloc] initWithImage:image];
    
//    NSDictionary *options = @{CIDetectorImageOrientation: [inputciImage.properties valueForKey:(__bridge NSString *)kCGImagePropertyOrientation]};
//    NSArray *adjustments = [inputciImage autoAdjustmentFiltersWithOptions:options];
    
    NSArray *adjustments = [inputciImage autoAdjustmentFilters];
    for (CIFilter *filter in adjustments) {
        [filter setValue:inputciImage forKey:kCIInputImageKey];
        inputciImage = filter.outputImage;
    }
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef imgRef = [context createCGImage:inputciImage fromRect:inputciImage.extent];
    UIImage *img = [UIImage imageWithCGImage:imgRef];
    CGImageRelease(imgRef);
    
    return img;
}

/**
 删除图片中的绿色
 */
- (UIImage *)chromaKeyFilterRecipe:(UIImage *)image {
    // 颜色模型: https://blog.ibireme.com/2013/08/12/color-model/
    // Create a Cube Map
    const unsigned int size = 64;
    float *cubeData = (float *)malloc (size * size * size * sizeof (float) * 4);
    float rgb[3], hsv[3], *c = cubeData;
    
    float hueRange = 60.0; // degrees size pie shape that we want to replace
    float hueAngle = 120.0; // 绿色在HSV的Hue值为120度
    float minHueAngle = (hueAngle - hueRange/2.0); // 左右偏差30度
    float maxHueAngle = (hueAngle + hueRange/2.0);
    
    int cubeDataSize = size * size * size * sizeof (float) * 4;
    
    // Populate cube with a simple gradient going from 0 to 1
    for (int z = 0; z < size; z++){
        rgb[2] = ((double)z)/(size-1); // Blue value
        for (int y = 0; y < size; y++){
            rgb[1] = ((double)y)/(size-1); // Green value
            for (int x = 0; x < size; x ++){
                rgb[0] = ((double)x)/(size-1); // Red value
                // Convert RGB to HSV
                // You can find publicly available rgbToHSV functions on the Internet
                RGBtoHSV2(rgb, hsv);
                // Use the hue value to determine which to make transparent
                // The minimum and maximum hue angle depends on
                // the color you want to remove
                float alpha = (hsv[0] > minHueAngle && hsv[0] < maxHueAngle) ? 0.0f: 1.0f;
                
                // Calculate premultiplied alpha values for the cube
                c[0] = rgb[0] * alpha;
                c[1] = rgb[1] * alpha;
                c[2] = rgb[2] * alpha;
                c[3] = alpha;
                c += 4; // advance our pointer into memory for the next color value
            }
        }
    }
    
    CIImage *inputImage = [[CIImage alloc] initWithImage:image];
    // Create memory with the cube data
    NSData *data = [NSData dataWithBytesNoCopy:cubeData
                                        length:cubeDataSize
                                  freeWhenDone:YES];
    CIFilter *colorCube = [CIFilter filterWithName:@"CIColorCube"];
    [colorCube setValue:@(size) forKey:@"inputCubeDimension"];
    // Set data for cube
    [colorCube setValue:data forKey:@"inputCubeData"];
    
    // Remove green from the source image
    [colorCube setValue:inputImage forKey:kCIInputImageKey];
    
    // Destination image
    CIImage *outputImage = colorCube.outputImage;
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef imgRef = [context createCGImage:outputImage fromRect:inputImage.extent];
    UIImage *img = [UIImage imageWithCGImage:imgRef];
    CGImageRelease(imgRef);
    
    return img;
}


/**
 CISourceOverCompositing
 */
- (UIImage *)whiteVignetteForFacesFilterRecipe:(UIImage *)image {
    CIImage *inputImage = [CIImage imageWithCGImage:image.CGImage];
    
    // Find the Face
    NSDictionary *detectorOptions = [[NSDictionary alloc] initWithObjectsAndKeys:CIDetectorAccuracyHigh, CIDetectorAccuracy, nil];
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeFace context:nil options:detectorOptions];
    
    CIFeature *face = [detector featuresInImage:inputImage].firstObject;
    
    CGFloat xCenter = face.bounds.origin.x + face.bounds.size.width / 2.0;
    CGFloat yCenter = face.bounds.origin.y + face.bounds.size.height / 2.0;
    CIVector *center = [CIVector vectorWithX:xCenter Y:yCenter];
    
    // Create a Shade Map
    CIColor *color0 = [[CIColor alloc] initWithColor:[UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0]];
    CIColor *color1 = [[CIColor alloc] initWithColor:[UIColor colorWithWhite:1.0 alpha:0.0]];
    
    CIFilter *filter = [CIFilter filterWithName:@"CIRadialGradient"];
    [filter setValue:@(image.size.width) forKey:@"inputRadius0"];
    [filter setValue:@(face.bounds.size.height + 50) forKey:@"inputRadius1"];
    [filter setValue:color0 forKey:@"inputColor0"];
    [filter setValue:color1 forKey:@"inputColor1"];
    [filter setValue:center forKey:@"inputCenter"];
    
    /*
     这一步官方文档是这么写的，但是实际测试的代码如下，和文档相反！！！？？？
     Set inputImage to the original image.
     Set inputBackgroundImage to the shade map produced in the last step.
     */
    // Blend the Gradient with the Face
    CIFilter *compositingFilter = [CIFilter filterWithName:@"CISourceOverCompositing"];
    [compositingFilter setValue:filter.outputImage forKey:kCIInputImageKey];
    [compositingFilter setValue:inputImage forKey:kCIInputBackgroundImageKey];
    
    CIImage *outputImage = compositingFilter.outputImage;
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef imgRef = [context createCGImage:outputImage fromRect:inputImage.extent];
    UIImage *img = [UIImage imageWithCGImage:imgRef];
    CGImageRelease(imgRef);
    
    return img;
}

/**
 mask CIBlendWithMask
 */
- (UIImage *)tiltShiftFilterRecipe:(UIImage *)image {
    CIImage *inputImage = [CIImage imageWithCGImage:image.CGImage];
    CGFloat height = image.size.height;
    
    // Create a Blurred Version of the image
    CIFilter *blurFilter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [blurFilter setValue:inputImage forKey:kCIInputImageKey];
    [blurFilter setValue:@(10.0) forKey:kCIInputRadiusKey];
    
    // Create Two Linear Gradients
    CIColor *color0 = [[CIColor alloc] initWithColor:[UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:1.0]];
    CIColor *color1 = [[CIColor alloc] initWithColor:[UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:0.0]];
    
    CIFilter *gradientTopFilter = [CIFilter filterWithName:@"CILinearGradient"];
    [gradientTopFilter setValue:[CIVector vectorWithCGPoint:CGPointMake(0, 0.75 * height)] forKey:@"inputPoint0"];
    [gradientTopFilter setValue:[CIVector vectorWithCGPoint:CGPointMake(0, 0.5 * height)] forKey:@"inputPoint1"];
    [gradientTopFilter setValue:color0 forKey:@"inputColor0"];
    [gradientTopFilter setValue:color1 forKey:@"inputColor1"];
    
    CIFilter *gradientBotFilter = [CIFilter filterWithName:@"CILinearGradient"];
    [gradientBotFilter setValue:[CIVector vectorWithCGPoint:CGPointMake(0, 0.25 * height)] forKey:@"inputPoint0"];
    [gradientBotFilter setValue:[CIVector vectorWithCGPoint:CGPointMake(0, 0.5 * height)] forKey:@"inputPoint1"];
    [gradientBotFilter setValue:color0 forKey:@"inputColor0"];
    [gradientBotFilter setValue:color1 forKey:@"inputColor1"];
    
    // Create a Mask from the Linear Gradients
    CIFilter *compositingFilter = [CIFilter filterWithName:@"CIAdditionCompositing"];
    [compositingFilter setValue:gradientTopFilter.outputImage forKey:kCIInputImageKey];
    [compositingFilter setValue:gradientBotFilter.outputImage forKey:kCIInputBackgroundImageKey];
    
    // Combine the Blurred Image, Source Image, and the Gradients
    CIFilter *blendFilter = [CIFilter filterWithName:@"CIBlendWithMask"];
    [blendFilter setValue:blurFilter.outputImage forKey:kCIInputImageKey];
    [blendFilter setValue:inputImage forKey:kCIInputBackgroundImageKey];
    [blendFilter setValue:compositingFilter.outputImage forKey:kCIInputMaskImageKey];
    
    CIImage *outputImage = blendFilter.outputImage;
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef imgRef = [context createCGImage:outputImage fromRect:inputImage.extent];
    UIImage *img = [UIImage imageWithCGImage:imgRef];
    CGImageRelease(imgRef);
    
    return img;
}

/**
 马赛克
 */
- (UIImage *)anonymousFacesFilterRecipe:(UIImage *)image {
    CIImage *inputImage = [CIImage imageWithCGImage:image.CGImage];
    CGFloat scale = MAX(image.size.width, image.size.height) / 60;
    
    // Create a Pixellated version of the image
    CIFilter *pixellateFilter = [CIFilter filterWithName:@"CIPixellate"];
    [pixellateFilter setValue:inputImage forKey:kCIInputImageKey];
    [pixellateFilter setValue:@(scale) forKey:kCIInputScaleKey];
    
    // Build a Mask From the Faces Detected in the Image
    NSDictionary *detectorOptions = [[NSDictionary alloc] initWithObjectsAndKeys:CIDetectorAccuracyHigh, CIDetectorAccuracy, nil];
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeFace context:nil options:detectorOptions];
    NSArray<CIFeature *> *features = [detector featuresInImage:inputImage];
    CIImage *maskImage = nil;
    
    for (CIFeature *f in features) {
        CGFloat centerX = f.bounds.origin.x + f.bounds.size.width / 2.0;
        CGFloat centerY = f.bounds.origin.y + f.bounds.size.height / 2.0;
        CGFloat radius = MIN(f.bounds.size.width, f.bounds.size.height) / 1.5;
        
        CIFilter *filter = [CIFilter filterWithName:@"CIRadialGradient"];
        [filter setValue:@(radius) forKey:@"inputRadius0"];
        [filter setValue:@(radius + 1.0) forKey:@"inputRadius1"];
        [filter setValue:[CIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:1.0] forKey:@"inputColor0"];
        [filter setValue:[CIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0] forKey:@"inputColor1"];
        [filter setValue:[CIVector vectorWithX:centerX Y:centerY] forKey:@"inputCenter"];
        
        CIImage *circleImage = filter.outputImage;
        if (nil == maskImage) {
            maskImage = circleImage;
        } else {
            maskImage = [CIFilter filterWithName:@"CISourceOverCompositing"
                             withInputParameters:@{kCIInputImageKey: circleImage,
                                                   kCIInputBackgroundImageKey: maskImage}].outputImage;
        }
    }
    
    // Blend the Pixellated Image, the Mask, and the Original Image
    CIFilter *blendFilter = [CIFilter filterWithName:@"CIBlendWithMask"];
    [blendFilter setValue:pixellateFilter.outputImage forKey:kCIInputImageKey];
    [blendFilter setValue:inputImage forKey:kCIInputBackgroundImageKey];
    [blendFilter setValue:maskImage forKey:kCIInputMaskImageKey];
    
    CIImage *outputImage = blendFilter.outputImage;
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef imgRef = [context createCGImage:outputImage fromRect:inputImage.extent];
    UIImage *img = [UIImage imageWithCGImage:imgRef];
    CGImageRelease(imgRef);
    
    return img;
}

/**
 像素化过渡
 */
- (UIImage *)pixellateTransitionFilterRecipe:(UIImage *)image time:(NSTimeInterval)time {
    CIImage *inputImage = [CIImage imageWithCGImage:image.CGImage];
    CIImage *toImage = [CIImage imageWithCGImage:[UIImage imageNamed:@"green_screen.jpg"].CGImage];
    
    // Create a Dissolve Transition
    CIFilter *dissolveFilter = [CIFilter filterWithName:@"CIDissolveTransition"];
    [dissolveFilter setValue:inputImage forKey:kCIInputImageKey];
    [dissolveFilter setValue:toImage forKey:kCIInputTargetImageKey];
    [dissolveFilter setValue:@(MIN(MAX(2*(time - 0.25), 0), 1)) forKey:kCIInputTimeKey];
    
    // Pixellate the Result of the Transition
    CIFilter *pixellateFilter = [CIFilter filterWithName:@"CIPixellate"];
    [pixellateFilter setValue:dissolveFilter.outputImage forKey:kCIInputImageKey];
    [pixellateFilter setValue:@(90*(1 - 2*ABS(time - 0.5))) forKey:kCIInputScaleKey];
    
    CIImage *outputImage = pixellateFilter.outputImage;
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef imgRef = [context createCGImage:outputImage fromRect:inputImage.extent];
    UIImage *img = [UIImage imageWithCGImage:imgRef];
    CGImageRelease(imgRef);
    
    return img;
}

/**
 怀旧过滤
 */
- (UIImage *)oldFilmFilterRecipe:(UIImage *)image {
    CIImage *inputImage = [CIImage imageWithCGImage:image.CGImage];
    
    // Apply Sepia to the Video Image
    CIFilter *sepiaFilter = [CIFilter filterWithName:@"CISepiaTone"];
    [sepiaFilter setValue:inputImage forKey:kCIInputImageKey];
    [sepiaFilter setValue:@(1.0) forKey:kCIInputIntensityKey];
    
    // Create Randomly Varying White Specks
    CIFilter *whiteFilter = [CIFilter filterWithName:@"CIRandomGenerator"];
    
    CIFilter *matrixFilter = [CIFilter filterWithName:@"CIColorMatrix"];
    [matrixFilter setValue:whiteFilter.outputImage forKey:kCIInputImageKey];
    [matrixFilter setValue:[CIVector vectorWithX:0 Y:1 Z:0 W:0] forKey:@"inputRVector"];
    [matrixFilter setValue:[CIVector vectorWithX:0 Y:1 Z:0 W:0] forKey:@"inputGVector"];
    [matrixFilter setValue:[CIVector vectorWithX:0 Y:1 Z:0 W:0] forKey:@"inputBVector"];
    [matrixFilter setValue:[CIVector vectorWithX:0 Y:0 Z:0 W:0] forKey:@"inputBiasVector"];
    
    CIFilter *compositingFilter = [CIFilter filterWithName:@"CISourceOverCompositing"];
    [compositingFilter setValue:matrixFilter.outputImage forKey:kCIInputImageKey];
    [compositingFilter setValue:sepiaFilter.outputImage forKey:kCIInputBackgroundImageKey];
    
    // Create Randomly Varying Dark Scratches
    CIFilter *blackFilter = [CIFilter filterWithName:@"CIRandomGenerator"];
    
    CIFilter *transformFilter = [CIFilter filterWithName:@"CIAffineTransform"];
    [transformFilter setValue:blackFilter.outputImage forKey:kCIInputImageKey];
    CGAffineTransform transform = CGAffineTransformMakeScale(1.5, 25);
    [transformFilter setValue:[NSValue valueWithBytes:&transform
                                             objCType:@encode(CGAffineTransform)]
                       forKey:kCIInputTransformKey];
    
    matrixFilter = [CIFilter filterWithName:@"CIColorMatrix"];
    [matrixFilter setValue:transformFilter.outputImage forKey:kCIInputImageKey];
    [matrixFilter setValue:[CIVector vectorWithX:4 Y:0 Z:0 W:0] forKey:@"inputRVector"];
    [matrixFilter setValue:[CIVector vectorWithX:0 Y:0 Z:0 W:0] forKey:@"inputGVector"];
    [matrixFilter setValue:[CIVector vectorWithX:0 Y:0 Z:0 W:0] forKey:@"inputBVector"];
    [matrixFilter setValue:[CIVector vectorWithX:0 Y:0 Z:0 W:0] forKey:@"inputAVector"];
    [matrixFilter setValue:[CIVector vectorWithX:0 Y:1 Z:1 W:1] forKey:@"inputBiasVector"];
    
    CIFilter *componentFilter = [CIFilter filterWithName:@"CIMinimumComponent"];
    [componentFilter setValue:matrixFilter.outputImage forKey:kCIInputImageKey];
    
    // Composite the Specks and Scratches to the Sepia Video Image
    CIFilter *mutComFilter = [CIFilter filterWithName:@"CIMultiplyCompositing"];
    [mutComFilter setValue:compositingFilter.outputImage forKey:kCIInputBackgroundImageKey];
    [mutComFilter setValue:componentFilter.outputImage forKey:kCIInputImageKey];
    
    // Destination image
    CIImage *outputImage = mutComFilter.outputImage;
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef imgRef = [context createCGImage:outputImage fromRect:inputImage.extent];
    UIImage *img = [UIImage imageWithCGImage:imgRef];
    CGImageRelease(imgRef);
//    context.inputImageMaximumSize
//    context.outputImageMaximumSize
    
    return img;
}

@end
