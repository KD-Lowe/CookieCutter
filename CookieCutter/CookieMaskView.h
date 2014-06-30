//
//  CookieMaskView.h
//  CookieCutter
//
//  Created by Chris Lowe on 6/29/14.
//  Copyright (c) 2014 Chris Lowe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CookieMaskView : UIView
+ (UIBezierPath *)heartShape:(CGRect)originalFrame;
+ (UIBezierPath *)starShape:(CGRect)originalFrame;
@end
