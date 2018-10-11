//
//  ImageViewController.m
//  CupixMADV360Demo
//
//  Created by QiuDong on 2018/6/26.
//  Copyright © 2018年 QiuDong. All rights reserved.
//

#import "ImageViewController.h"
#import "MVGLView_ExternC.h"
#import "MadvGLRenderer.h"
#import "MVCameraClient.h"
#import "MVMedia.h"
#import "Utils/UIView+HierachyExtensions.h"

@interface ImageViewController ()

@property (nonatomic, strong) MVGLView* glView;

@end

@implementation ImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //*
    MVGLView* glView = [[MVGLView alloc] initWithFrame:self.view.bounds lutPath:nil lutSrcSizeL:CGSizeMake(DEFAULT_LUT_VALUE_WIDTH, DEFAULT_LUT_VALUE_HEIGHT) lutSrcSizeR:CGSizeMake(DEFAULT_LUT_VALUE_WIDTH, DEFAULT_LUT_VALUE_HEIGHT) outputVideoBaseName:nil encoderQualityLevel:MVQualityLevelOther forCapturing:NO];
    self.glView = glView;
    glView.contentMode = UIViewContentModeScaleAspectFit;
    glView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    [self.view addSubview:glView];
    
    NSString* testJpegPath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"jpg"];
    [self.glView.glRenderLoop drawJPEG:testJpegPath];
    [self.glView.glRenderLoop setPanoramaMode:PanoramaDisplayModeStereoGraphic];
    //*/
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
