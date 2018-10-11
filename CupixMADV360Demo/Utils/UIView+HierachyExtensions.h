//
//  UIView+HierachyExtensions.h
//  Madv360_v1
//
//  Created by QiuDong on 2018/4/4.
//  Copyright © 2018年 Cyllenge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (HierachyExtensions)

-(void) traverseMeAndSubviews:(void(^)(UIView*))block;

@end
