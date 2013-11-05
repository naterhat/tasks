//
//  UIView+Extra.h
//  tasks
//
//  Created by Nate Ramirez on 11/5/13.
//  Copyright (c) 2013 natewire. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extra)

- (CGFloat)y;
- (CGFloat)x;
- (CGFloat)width;
- (CGFloat)height;
- (CGSize)size;
- (CGPoint)position;
- (void)setSize:(CGSize)size;
- (void)setPosition:(CGPoint)position;

@end
