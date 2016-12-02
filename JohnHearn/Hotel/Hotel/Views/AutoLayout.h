//
//  AutoLayout.h
//  Hotel
//
//  Created by John D Hearn on 11/28/16.
//  Copyright © 2016 Bastardized Productions. All rights reserved.
//

@import UIKit;

static CGFloat const kHeaderHeight = 100.0;
static CGFloat const kNavBarAndStatusBarHeight = 64.0;
static CGFloat const kMargin = 20.0;


@interface AutoLayout : NSObject

+(NSLayoutConstraint *)createGenericConstraintFrom:(UIView *)view
                                            toView:(UIView *)superView
                                     withAttribute:(NSLayoutAttribute)attribute
                                     andMultiplier:(CGFloat)multiplier;

+(NSLayoutConstraint *)createGenericConstraintFrom:(UIView *)view
                                            toView:(UIView *)superView
                                     withAttribute:(NSLayoutAttribute)attribute;

+(NSArray *)activateFullViewConstraintsUsingVFLFor:(UIView *)view;

// Just to show the difference from VFL
+(NSArray *)activateFullViewConstraintsFrom:(UIView *)view
                                     toView:(UIView *)superView;

+(NSLayoutConstraint *)createLeadingConstraintFrom:(UIView *)view
                                            toView:(UIView *)superView;

+(NSLayoutConstraint *)createTrailingConstraintFrom:(UIView *)view
                                             toView:(UIView *)superView;

+(NSLayoutConstraint *)createEqualHeightConstraintFrom:(UIView *)view
                                                toView:(UIView *)otherView;

+(NSLayoutConstraint *)createLeadingConstraintFrom:(UIView *)view
                                            toView:(UIView *)otherView
                                    withMultiplier:(CGFloat)multiplier;

+(NSLayoutConstraint *)createGenericHeightConstraintFor:(UIView *)view
                                             withHeight:(CGFloat)height;

+(NSLayoutConstraint *)createConstraintFromBottomOf:(UIView *)view
                                            toTopOf:(UIView *)otherView;
@end
