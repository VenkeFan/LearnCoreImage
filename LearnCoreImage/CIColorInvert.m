//
//  CIColorInvert.m
//  LearnCoreImage
//
//  Created by fan qi on 2018/7/11.
//  Copyright © 2018年 fan qi. All rights reserved.
//

#import "CIColorInvert.h"

@interface CIColorInvert ()

@property (nonatomic, strong) CIImage *inputImage;

@end

@implementation CIColorInvert

#pragma mark - Override

- (CIImage *)outputImage {
    CIFilter *filter = [CIFilter filterWithName:@"CIColorMatrix"
                            withInputParameters:@{kCIInputImageKey: _inputImage,
                                                  @"inputRVector": [CIVector vectorWithX:-1 Y:0 Z:0],
                                                  @"inputGVector": [CIVector vectorWithX:0 Y:-1 Z:0],
                                                  @"inputBVector": [CIVector vectorWithX:0 Y:0 Z:-1],
                                                  @"inputBiasVector": [CIVector vectorWithX:1 Y:1 Z:1]}];
    
    return filter.outputImage;
}

@end
