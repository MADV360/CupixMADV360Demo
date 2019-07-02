//
//  main.m
//  CupixMADV360Demo
//
//  Created by QiuDong on 2018/6/26.
//  Copyright © 2018年 QiuDong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MadvGLRenderer_iOS.h>
#import <MadvGLRendererBase_iOS.h>
#import <JPEGUtils.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
//        NSString* sourceFileName = @"IMG_20170903_180235.JPG";
//        NSString* sourceFilePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:sourceFileName];
//        NSString* destinationFolder = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
//        NSString* destinationFilePath = [[destinationFolder stringByAppendingPathComponent:[[NSUUID new] UUIDString]] stringByAppendingPathExtension:@"jpg"];
//        jpeg_decompress_struct sourceJpegInfo = readImageInfoFromJPEG(sourceFilePath.UTF8String);
//        MadvEXIFExtension sourceMadvExtension = readMadvEXIFExtensionFromJPEG(sourceFilePath.UTF8String);
//        if(sourceMadvExtension.gyroMatrixBytes > 0) {
//            MadvGLRendererBase_iOS::renderJPEGToJPEG(destinationFilePath, sourceFilePath, sourceJpegInfo.image_width, sourceJpegInfo.image_height, NO, &sourceMadvExtension, 0, sourceMadvExtension.cameraParams.gyroMatrix, 3);
//        } else {
//            MadvGLRendererBase_iOS::renderJPEGToJPEG(destinationFilePath, sourceFilePath, sourceJpegInfo.image_width, sourceJpegInfo.image_height, NO, &sourceMadvExtension, 0, NULL, 0);
//        }
//        [self changeFileUrl:[NSURL fileURLWithPath:destinationFilePath]];
        
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
