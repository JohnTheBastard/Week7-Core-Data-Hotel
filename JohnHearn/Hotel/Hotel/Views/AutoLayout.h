//
//  AutoLayout.h
//  Hotel
//
//  Created by John D Hearn on 11/28/16.
//  Copyright © 2016 Bastardized Productions. All rights reserved.
//

@import UIKit;

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

@end
