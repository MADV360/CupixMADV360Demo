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
#import "Utils/UIView+HierachyExtensions.h"
#import "MVMediaManager.h"
#import "MadvGLRenderer_iOS.h"
#import "EXIFParser.h"
#import "MadvUtils.h"
#import <iostream>

@interface CameraViewController () <MVCameraClientObserver, MVMediaDataSourceObserver, MVMediaDownloadStatusObserver>

@property (nonatomic, weak) IBOutlet UIButton* connectButton;
@property (nonatomic, weak) IBOutlet UIButton* shootButton;
@property (nonatomic, weak) IBOutlet UIButton* lensSelectButton;
@property (nonatomic, weak) IBOutlet UILabel* voltageLabel;
@property (nonatomic, weak) IBOutlet UILabel* storageLabel;
@property (nonatomic, weak) IBOutlet UIButton* viewModeButton;
@property (nonatomic, weak) IBOutlet UISwitch* stitchingSwitch;

@property (nonatomic, strong) MVCameraDevice* device;

-(IBAction)onConnectButtonClicked:(id)sender;
-(IBAction)onShootButtonClicked:(id)sender;
-(IBAction)onLensSelectButtonClicked:(id)sender;
-(IBAction)onViewModeButtonClicked:(id)sender;
-(IBAction)onStitchingSwitchChanged:(id)sender;

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
    [MVCameraDevice getCameraSettings];
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[MVCameraClient sharedInstance] addObserver:self];//#MADVSDK#
    // #MADVSDK#
    MVMediaManager* mediaManager = [MVMediaManager sharedInstance];
    mediaManager.downloadMediasIntoDocuments = YES;// :Important
    mediaManager.noStitchingAfterPhotoDownloaded = !self.stitchingSwitch.isOn;// :Important to Cupix
    // Add as observer for media manager:
    [mediaManager addMediaDataSourceObserver:self];
    [mediaManager addMediaDownloadStatusObserver:self];
}

-(void) viewWillDisappear:(BOOL)animated {
    [[MVCameraClient sharedInstance] removeObserver:self];//#MADVSDK#
    MVMediaManager* mediaManager = [MVMediaManager sharedInstance];
    [mediaManager removeMediaDataSourceObserver:self];
    [mediaManager removeMediaDownloadStatusObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UIEvents
-(IBAction)onConnectButtonClicked:(id)sender {
    self.stitchingSwitch.enabled = NO;
    self.connectButton.enabled = NO;
    if (0 == self.connectButton.tag)
    {
        [self.connectButton setTitle:@"Connecting..." forState:UIControlStateNormal];
        [[MVCameraClient sharedInstance] connectCamera];//#MADVSDK#
    }
    else if (1 == self.connectButton.tag)
    {
        [self.connectButton setTitle:@"Disconnecting..." forState:UIControlStateNormal];
        [[MVCameraClient sharedInstance] disconnectCamera];//#MADVSDK#
    }
}

-(IBAction)onShootButtonClicked:(id)sender {
    [[MVCameraClient sharedInstance] startShooting];//#MADVSDK#
    self.shootButton.enabled = NO;
    [self.shootButton setTitle:@"Shooting..." forState:UIControlStateNormal];
}

-(IBAction)onLensSelectButtonClicked:(id)sender {
    UIAlertController* ac = [UIAlertController alertControllerWithTitle:nil message:@"Select camera lens" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction* actionBack = [UIAlertAction actionWithTitle:@"Back" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[MVCameraClient sharedInstance] setLensUsageMode:LensUsageModeBack];
    }];
    [ac addAction:actionBack];
    UIAlertAction* actionFront = [UIAlertAction actionWithTitle:@"Front" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[MVCameraClient sharedInstance] setLensUsageMode:LensUsageModeFront];
    }];
    [ac addAction:actionFront];
    UIAlertAction* actionBoth = [UIAlertAction actionWithTitle:@"Both" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[MVCameraClient sharedInstance] setLensUsageMode:LensUsageModeBoth];
    }];
    [ac addAction:actionBoth];
    [self showViewController:ac sender:self];
}

-(IBAction)onViewModeButtonClicked:(id)sender {
    if (!self.glView) return;
    switch (self.glView.panoramaMode)
    {
        case PanoramaDisplayModeStereoGraphic:
            self.glView.panoramaMode = PanoramaDisplayModeSphere;
            [self.viewModeButton setTitle:@"ViewMode:Sphere" forState:UIControlStateNormal];
            break;
        case PanoramaDisplayModeSphere:
            self.glView.panoramaMode = PanoramaDisplayModeLittlePlanet;
            [self.viewModeButton setTitle:@"ViewMode:Planet" forState:UIControlStateNormal];
            break;
        case PanoramaDisplayModeLittlePlanet:
            self.glView.panoramaMode = PanoramaDisplayModeCrystalBall;
            [self.viewModeButton setTitle:@"ViewMode:CrystalBall" forState:UIControlStateNormal];
            break;
        case PanoramaDisplayModeCrystalBall:
            self.glView.panoramaMode = PanoramaDisplayModeFromCubeMap;
            [self.viewModeButton setTitle:@"ViewMode:Panorama" forState:UIControlStateNormal];
            break;
        case PanoramaDisplayModeFromCubeMap:
            self.glView.panoramaMode = PanoramaDisplayModeStereoGraphic;
            [self.viewModeButton setTitle:@"ViewMode:StereoGraphic" forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}

-(IBAction)onStitchingSwitchChanged:(id)sender {
    //NSLog(@"#NoStitch# self.stitchingSwitch.isOn=%d", self.stitchingSwitch.isOn);
    MVMediaManager* mediaManager = [MVMediaManager sharedInstance];
    mediaManager.noStitchingAfterPhotoDownloaded = !self.stitchingSwitch.isOn;
}

#pragma mark MVCameraClientObserver

-(void) didConnectSuccess:(MVCameraDevice *)device {
    [self setContentPath:@"rtsp://192.168.42.1/live" parameters:nil];//#MADVSDK#
    self.connectButton.tag = 1;
    self.connectButton.enabled = YES;
    self.stitchingSwitch.enabled = NO;
    [self.connectButton setTitle:@"Disconnect" forState:UIControlStateNormal];
    self.shootButton.hidden = NO;
    self.lensSelectButton.enabled = YES;
    self.voltageLabel.text = [NSString stringWithFormat:@"Voltage:%d%%%@", device.voltagePercent, (device.isCharging? @" Charging":@"")];
    MVCameraClient* cameraClient = [MVCameraClient sharedInstance];
    if (cameraClient.storageMounted != StorageMountStateNO)
    {
        self.storageLabel.text = [NSString stringWithFormat:@"free/total : %d/%d", cameraClient.freeStorage, cameraClient.totalStorage];
    }
    else
    {
        self.storageLabel.text = @"No SDCard";
    }
    [self.viewModeButton setTitle:@"ViewMode:StereoGraphic" forState:UIControlStateNormal];
    
    if (!self.stitchingSwitch.isOn)
    {
        [cameraClient setSettingOption:10 paramUID:3];
    }
}

-(void) didConnectFail:(NSString *)errorMessage {
    [self didDisconnect:CameraDisconnectReasonUnknown];
}

-(void) didDisconnect:(CameraDisconnectReason)reason {
    self.connectButton.tag = 0;
    self.connectButton.enabled = YES;
    [self.connectButton setTitle:@"Connect" forState:UIControlStateNormal];
    self.shootButton.hidden = YES;
    self.stitchingSwitch.enabled = YES;
    self.lensSelectButton.enabled = NO;
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

-(void) didStorageMountedStateChanged:(StorageMountState)mounted {
    NSLog(@"didStorageMountedStateChanged : SD card mounted = %d", mounted);
    MVCameraClient* cameraClient = [MVCameraClient sharedInstance];
    if (mounted != StorageMountStateNO)
    {
        self.storageLabel.text = [NSString stringWithFormat:@"free/total : %d/%d", cameraClient.freeStorage, cameraClient.totalStorage];
    }
    else
    {
        self.storageLabel.text = @"No SDCard";
    }
}

-(void) didStorageStateChanged:(StorageState)newState oldState:(StorageState)oldState {
    
}

-(void) didStorageTotalFreeChanged:(int)total free:(int)free {
    self.storageLabel.text = [NSString stringWithFormat:@"free/total : %d/%d", free, total];
}

-(void) didVoltagePercentChanged:(int)percent isCharging:(BOOL)isCharging {
    self.voltageLabel.text = [NSString stringWithFormat:@"Voltage:%d%%%@", percent, (isCharging? @" Charging":@"")];
}

#pragma mark    MVMediaDataSourceObserver

-(void)didCameraMediasReloaded:(NSArray<MVMedia *> *) medias dataSetEvent:(DataSetEvent)dataSetEvent errorCode:(int)errorCode {
    if (dataSetEvent == DataSetEventAddNew)
    {// As new picture file(s) generated by the camera, immediately start downloading:
        NSLog(@"addDownloadingOfMedias : %@", medias);
        [[MVMediaManager sharedInstance] addDownloadingOfMedias:@[medias[0]] completion:^{
            NSLog(@"#MADVSDK# didCameraMediasReloaded : Batch downloading started");
        } progressBlock:^(int completedCount, int totalCount, BOOL *cancel) {
            NSLog(@"#MADVSDK# didCameraMediasReloaded : Batch downloading progress : %d/%d", completedCount, totalCount);
        }];
    }
}

-(void) didLocalMediasReloaded:(NSArray<MVMedia *> *) medias dataSetEvent:(DataSetEvent)dataSetEvent {
    
}

-(void)didFetchThumbnailImage:(UIImage *)image ofMedia:(MVMedia*)media error:(int)error {
    
}

-(void)didFetchMediaInfo:(MVMedia *)media error:(int)error {
    
}

- (void) didFetchRecentMediaThumbnail:(MVMedia*)media image:(UIImage*)image error:(int)error {
    
}

#pragma mark    MVMediaDownloadStatusObserver

- (void) didDownloadStatusChange:(int)downloadStatus errorCode:(int)errorCode ofMedia:(MVMedia*)media {
    if (!errorCode && downloadStatus == MVMediaDownloadStatusFinished)
    {// When a media file has been successfully downloaded, get its local file name(relative to sandbox document directory) from this callback
        //To download files into sandbox from camera, "Application supports iTunes file sharing" and "App Transport Security Settings"->"Allow Arbitrary Loads" in Info.plist should all be set to YES
        /*
        NSLog(@"#MADVSDK# didDownloadStatusChange : Media dowloading finished, stitched is '%@', original is '%@'", media.localPath, [MVPanoRenderer preStitchPictureFileName:media.cameraUUID fileName:media.localPath]);
        if (![media.localPath.pathExtension.lowercaseString isEqualToString:@"jpg"]) return;
        
        NSString* documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        NSString *sourcePath, *destPath;
        MVMediaManager* mediaManager = [MVMediaManager sharedInstance];
        if (!mediaManager.noStitchingAfterPhotoDownloaded)
        {
            sourcePath = [[[documentPath stringByAppendingPathComponent:media.localPath] stringByAppendingPathExtension:media.cameraUUID] stringByAppendingPathExtension:@"prestitch.jpg"];
            destPath = [[documentPath stringByAppendingPathComponent:media.localPath] stringByAppendingPathExtension:@"stitched.jpg"];
        }
        else
        {
            sourcePath = [documentPath stringByAppendingPathComponent:media.localPath];
            destPath = [sourcePath stringByAppendingPathExtension:@"stitched.jpg"];
        }
        NSString* tempLUTDirectory = makeTempLUTDirectory(sourcePath);
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            renderMadvJPEGToJPEG(destPath, sourcePath, tempLUTDirectory, 0, 0, false);
             [[NSFileManager defaultManager] removeItemAtPath:sourcePath error:nil];
        });
        //*/
    }
}

- (void) didDownloadProgressChange:(NSInteger)downloadedBytes totalBytes:(NSInteger)totalBytes ofMedia:(MVMedia*)media {
    NSLog(@"#MADVSDK# didDownloadProgressChange : Media(%@) dowloading progress %.2f%%", media.localPath, 100.f*downloadedBytes/totalBytes);
}

- (void) didBatchDownloadStatusChange:(int)downloadStatus ofMedias:(NSArray<MVMedia *>*)medias {
    
}

- (void) didDownloadingsHung {
    
}

- (void) didReceiveStorageWarning {
    
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
