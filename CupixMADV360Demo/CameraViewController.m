//
//  CameraViewController.m
//  CupixMADV360Demo
//
//  Created by QiuDong on 2018/6/26.
//  Copyright © 2018年 QiuDong. All rights reserved.
//

#import "CameraViewController.h"
#import "MVGLView_ExternC.h"
#import "MadvGLRenderer.h"
#import "MVCameraClient.h"
#import "MVMedia.h"
#import "UIView+HierachyExtensions.h"

@interface CameraViewController () <MVCameraClientObserver>

@property (nonatomic, weak) IBOutlet UIButton* connectButton;
@property (nonatomic, weak) IBOutlet UIButton* shootButton;

@property (nonatomic, strong) MVCameraDevice* device;

-(IBAction)onConnectButtonClicked:(id)sender;
-(IBAction)onShootButtonClicked:(id)sender;

@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    /*
    MVGLView* glView = [[MVGLView alloc] initWithFrame:self.view.bounds lutPath:nil lutSrcSizeL:CGSizeMake(DEFAULT_LUT_VALUE_WIDTH, DEFAULT_LUT_VALUE_HEIGHT) lutSrcSizeR:CGSizeMake(DEFAULT_LUT_VALUE_WIDTH, DEFAULT_LUT_VALUE_HEIGHT) outputVideoBaseName:nil encoderQualityLevel:MVQualityLevelOther forCapturing:NO];
    self.glView = glView;
    [self.view addSubview:glView];
    
    NSString* testJpegPath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"jpg"];
    [self.glView.glRenderLoop drawJPEG:testJpegPath];
    [self.glView.glRenderLoop setPanoramaMode:PanoramaDisplayModeStereoGraphic];
    //*/
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[MVCameraClient sharedInstance] addObserver:self];//#MADVSDK#
}

-(void) viewWillDisappear:(BOOL)animated {
    [[MVCameraClient sharedInstance] removeObserver:self];//#MADVSDK#
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UIEvents
-(IBAction)onConnectButtonClicked:(id)sender {
    if (0 == self.connectButton.tag)
    {
        self.connectButton.enabled = NO;
        [self.connectButton setTitle:@"Connecting..." forState:UIControlStateNormal];
        [[MVCameraClient sharedInstance] connectCamera];//#MADVSDK#
    }
    else if (1 == self.connectButton.tag)
    {
        self.connectButton.enabled = NO;
        [self.connectButton setTitle:@"Disconnecting..." forState:UIControlStateNormal];
        [[MVCameraClient sharedInstance] disconnectCamera];//#MADVSDK#
    }
}

-(IBAction)onShootButtonClicked:(id)sender {
    [[MVCameraClient sharedInstance] startShooting];//#MADVSDK#
    self.shootButton.enabled = NO;
    [self.shootButton setTitle:@"Shooting..." forState:UIControlStateNormal];
}

#pragma mark MVCameraClientObserver

-(void) didConnectSuccess:(MVCameraDevice *)device {
    [self setContentPath:@"rtsp://192.168.42.1/live" parameters:nil];//#MADVSDK#
    self.connectButton.tag = 1;
    self.connectButton.enabled = YES;
    [self.connectButton setTitle:@"Disconnect" forState:UIControlStateNormal];
    self.shootButton.hidden = NO;
}

-(void) didConnectFail:(NSString *)errorMessage {
    [self didDisconnect:CameraDisconnectReasonUnknown];
}

-(void) didDisconnect:(CameraDisconnectReason)reason {
    self.connectButton.tag = 0;
    self.connectButton.enabled = YES;
    [self.connectButton setTitle:@"Connect" forState:UIControlStateNormal];
    self.shootButton.hidden = YES;
}

-(void) didCameraModeChange:(CameraMode)mode subMode:(CameraSubMode)subMode param:(NSInteger)param {
    if (mode != CameraModePhoto || subMode != CameraSubmodePhotoNormal)
    {
        //#MADVSDK# Change to Normal Photo Shooting mode if the camera is not at it:
        [[MVCameraClient sharedInstance] setCameraMode:CameraModePhoto subMode:CameraSubmodePhotoNormal param:0];
    }
}

-(void) didEndShooting:(NSString *)remoteFilePath videoDurationMills:(NSInteger)videoDurationMills error:(int)error errMsg:(NSString *)errMsg {
    self.shootButton.enabled = YES;
    [self.shootButton setTitle:@"Shoot" forState:UIControlStateNormal];
}

#pragma mark    MVKxMovieViewController Callbacks

- (void) didSetupPresentView:(UIView*)newGLView {
    //#MADVSDK# Find the glView in view hierachy and bring it to back, in order to avoid occlusion:
    __block MVGLView* presentView = nil;
    [self.view traverseMeAndSubviews:^(UIView* view) {
        if ([view isKindOfClass:MVGLView.class])
        {
            presentView = (MVGLView*)view;
        }
    }];
    if (!presentView)
    {
        presentView = (MVGLView*)newGLView;
        [self.view addSubview:presentView];
    }
    [self.view sendSubviewToBack:presentView];
    
    presentView.contentMode = UIViewContentModeScaleAspectFit;
    presentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
}

@end
