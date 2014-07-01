//
//  CookieMaskView.h
//  CookieCutter
//
//  Created by Chris Lowe on 6/29/14.
//  Copyright (c) 2014 Chris Lowe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CookieMaskView : UIView
+ (UIBezierPath *)bezierPathForHeartShapeInRect:(CGRect)originalFrame;
+ (UIBezierPath *)bezierPathForStarShapeInRect:(CGRect)originalFrame;
+ (UIBezierPath *)bezierPathForCircleShapeInRect:(CGRect)originalFrame;
@end
