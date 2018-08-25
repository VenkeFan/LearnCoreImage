//
//  MTKViewController.m
//  LearnCoreImage
//
//  Created by fan qi on 2018/7/10.
//  Copyright © 2018年 fan qi. All rights reserved.
//

#import "MTKViewController.h"
#import <Metal/Metal.h>
#import <MetalKit/MetalKit.h>

@interface MTKViewController () <MTKViewDelegate> {
    id<MTLDevice> _device;
    id<MTLCommandQueue> _commandQueue;
    id<MTLTexture> _sourceTexture;
    
    CIContext *_context;
    CIFilter *_filter;
    CGColorSpaceRef _colorSpace;
}

@end

@implementation MTKViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    _colorSpace = CGColorSpaceCreateDeviceRGB();
    
    _device = MTLCreateSystemDefaultDevice();
    _commandQueue = [_device newCommandQueue];
    
    MTKView *view = (MTKView *)self.view;
    view.delegate = self;
    view.device = _device;
    view.framebufferOnly = NO;
    
    _context = [CIContext contextWithMTLDevice:_device];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - MTKViewDelegate

- (void)mtkView:(MTKView *)view drawableSizeWillChange:(CGSize)size {
    
}

- (void)drawInMTKView:(MTKView *)view {
    
}

@end
