//
//  AutoLayout.m
//  Hotel
//
//  Created by John D Hearn on 11/28/16.
//  Copyright © 2016 Bastardized Productions. All rights reserved.
//

#import "AutoLayout.h"

extern CGFloat const KHeaderHeight = 100.0;

@implementation AutoLayout

+(NSLayoutConstraint *)createGenericConstraintFrom:(UIView *)view
                                            toView:(UIView *)superView
                                     withAttribute:(NSLayoutAttribute)attribute
                                     andMultiplier:(CGFloat)multiplier{
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:view
                                                                  attribute:attribute
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:superView
                                                                  attribute:attribute
                                                                 multiplier:multiplier
                                                                   constant:0.0];
    constraint.active = YES;

    return constraint;
}

+(NSLayoutConstraint *)createGenericConstraintFrom:(UIView *)view
                                            toView:(UIView *)superView
                                     withAttribute:(NSLayoutAttribute)attribute{
    return [AutoLayout createGenericConstraintFrom:view
                                            toView:superView
                                     withAttribute:attribute
                                     andMultiplier:1.0];
}

+(NSArray *)activateFullViewConstraintsUsingVFLFor:(UIView *)view{
    NSArray *constraints = [[NSMutableArray alloc] init];
    NSDictionary *viewDictionary = @{@"view": view};
    NSArray *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:viewDictionary];
    NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|"
                                                                           options:0
                                                                           metrics:nil
                                                                             views:viewDictionary];
    constraints = [constraints arrayByAddingObjectsFromArray:horizontalConstraints];
    constraints = [constraints arrayByAddingObjectsFromArray:verticalConstraints];

    [NSLayoutConstraint activateConstraints:constraints];

    return constraints;


}

// Just to show the difference from VFL
+(NSArray *)activateFullViewConstraintsFrom:(UIView *)view
                                     toView:(UIView *)superView{

    NSLayoutConstraint *leadingConstraint = [AutoLayout createGenericConstraintFrom:view
                                                                             toView:superView
                                                                      withAttribute:NSLayoutAttributeLeading];
    NSLayoutConstraint *trailingConstraint = [AutoLayout createGenericConstraintFrom:view
                                                                              toView:superView
                                                                       withAttribute:NSLayoutAttributeTrailing];
    NSLayoutConstraint *topConstraint = [AutoLayout createGenericConstraintFrom:view
                                                                         toView:superView
                                                                  withAttribute:NSLayoutAttributeTop];
    NSLayoutConstraint *bottomConstraint = [AutoLayout createGenericConstraintFrom:view
                                                                            toView:superView
                                                                     withAttribute:NSLayoutAttributeBottom];
    return @[leadingConstraint, trailingConstraint, topConstraint, bottomConstraint];

}

+(NSLayoutConstraint *)createLeadingConstraintFrom:(UIView *)view
                                            toView:(UIView *)superView{
    return [AutoLayout createGenericConstraintFrom:view
                                            toView:superView
                                     withAttribute:NSLayoutAttributeLeading];
}

+(NSLayoutConstraint *)createTrailingConstraintFrom:(UIView *)view
                                             toView:(UIView *)superView{
    return [AutoLayout createGenericConstraintFrom:view
                                            toView:superView
                                     withAttribute:NSLayoutAttributeTrailing];
}

+(NSLayoutConstraint *)createEqualHeightConstraintFrom:(UIView *)view
                                                toView:(UIView *)otherView{
    return [AutoLayout createGenericConstraintFrom:view
                                            toView:otherView
                                     withAttribute:NSLayoutAttributeHeight];
}

+(NSLayoutConstraint *)createLeadingConstraintFrom:(UIView *)view
                                            toView:(UIView *)otherView
                                    withMultiplier:(CGFloat)multiplier{
    return [AutoLayout createGenericConstraintFrom:view
                                            toView:otherView
                                     withAttribute:NSLayoutAttributeHeight
                                     andMultiplier:multiplier];
}

+(NSLayoutConstraint *)createGenericHeightConstraintFor:(UIView *)view
                                             withHeight:(CGFloat)height{
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:view
                                                                  attribute:NSLayoutAttributeHeight
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:nil
                                                                  attribute:NSLayoutAttributeNotAnAttribute
                                                                 multiplier:1.0
                                                                   constant:height];
    constraint.active = YES;
    return constraint;
}

@end
