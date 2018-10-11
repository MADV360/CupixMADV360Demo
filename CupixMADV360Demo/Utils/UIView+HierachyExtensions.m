//
//  UIView+HierachyExtensions.m
//  Madv360_v1
//
//  Created by QiuDong on 2018/4/4.
//  Copyright © 2018年 Cyllenge. All rights reserved.
//

#import "UIView+HierachyExtensions.h"

@implementation UIView (HierachyExtensions)

-(void) traverseMeAndSubviews:(void(^)(UIView*))block {
    if (!block)
        return;
    
    UIView* view = self;
    block(view);
    
    for (UIView* subview in view.subviews)
    {
        block(subview);
    }
}

@end
