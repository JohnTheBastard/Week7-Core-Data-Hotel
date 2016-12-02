//
//  AutoLayoutTests.m
//  Hotel
//
//  Created by John D Hearn on 11/30/16.
//  Copyright © 2016 Bastardized Productions. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AutoLayout.h"

@interface AutoLayoutTests : XCTestCase
@property(strong, nonatomic)UIViewController *testController;
@property(strong, nonatomic)UIView *testView1;
@property(strong, nonatomic)UIView *testView2;
@property(strong, nonatomic)NSNumber *height;

@end

@implementation AutoLayoutTests

-(void)setUp {
    [super setUp];
    self.testController = [[UIViewController alloc] init];
    self.testView1 = [[UIView alloc] init];
    self.testView2 = [[UIView alloc] init];
    [self.testController.view addSubview:self.testView1];
    [self.testController.view addSubview:self.testView2];

    self.height = [[NSNumber alloc] initWithFloat:40.0];
}

-(void)tearDown {
    self.testController = nil;
    self.testView1 = nil;
    self.testView2 = nil;

    [super tearDown];
}

-(void)testViewControllerNotNil {
    XCTAssertNotNil(self.testController, @"self.testController is nil");

}

-(void)testViewsAreNotEqual {
    XCTAssertNotEqual(self.testView1, self.testView2, @"testView1 is equal to testView2");
}

-(void)testViewClass{
    XCTAssert([self.testView1 isKindOfClass:[UIView class]], @"view1 is not a UIView");
}

-(void)testCreateGenericConstraintFromViewToViewWithAttrAndMult{
    id constraint = [AutoLayout createGenericConstraintFrom:self.testView1
                                                     toView:self.testView2
                                              withAttribute:NSLayoutAttributeTop
                                              andMultiplier:1.0];

    XCTAssert([constraint isMemberOfClass:[NSLayoutConstraint class]],
               @"constraint is not an NSLayoutConstraint Object");
}

-(void)testCreateGenericConstraintFromViewToViewWithAttr{
    id constraint = [AutoLayout createGenericConstraintFrom:self.testView1
                                                     toView:self.testView2
                                              withAttribute:NSLayoutAttributeTop];

    XCTAssert([constraint isMemberOfClass:[NSLayoutConstraint class]],
              @"constraint is not an NSLayoutConstraint Object");
}

-(void)testActivateFullViewConstraintsUsingVFL {
    NSArray *constraints = [AutoLayout activateFullViewConstraintsUsingVFLFor:self.testView1];

    int count = 0;

    for(id constraint in constraints ) {
        if( ![constraint isKindOfClass:[NSLayoutConstraint class]] ) {
            count++;
        }
    }
    XCTAssert(count == 0, @"Array contains %i objects that are not SNLayoutConstraints", count);
}

-(void)testActivateFullViewConstraintsFromViewToView{
    id constraints = [AutoLayout activateFullViewConstraintsFrom:self.testView1
                                                         toView:self.testView2];
    int count = 0;

    for(id constraint in constraints ) {
        if( ![constraint isKindOfClass:[NSLayoutConstraint class]] ) {
            count++;
        }
    }
    XCTAssert(count == 0, @"Array contains %i objects that are not SNLayoutConstraints", count);
}

-(void)testCreateLeadingConstraintFromViewToView{
    id constraint = [AutoLayout createLeadingConstraintFrom:self.testView1
                                                     toView:self.testView2];

    XCTAssert([constraint isMemberOfClass:[NSLayoutConstraint class]],
              @"constraint is not an NSLayoutConstraint Object");
}

-(void)testCreateTrailingConstraintFromViewToView{
    id constraint = [AutoLayout createTrailingConstraintFrom:self.testView1
                                                     toView:self.testView2];

    XCTAssert([constraint isMemberOfClass:[NSLayoutConstraint class]],
              @"constraint is not an NSLayoutConstraint Object");
}


-(void)testCreateEqualHeightConstraintFromViewToView{
    id constraint = [AutoLayout createEqualHeightConstraintFrom:self.testView1
                                                         toView:self.testView2];

    XCTAssert([constraint isMemberOfClass:[NSLayoutConstraint class]],
              @"constraint is not an NSLayoutConstraint Object");
}

-(void)testCreateLeadingConstraintFromViewToViewWithMult{
    id constraint = [AutoLayout createLeadingConstraintFrom:self.testView1
                                                     toView:self.testView2];

    XCTAssert([constraint isMemberOfClass:[NSLayoutConstraint class]],
              @"constraint is not an NSLayoutConstraint Object");
}

-(void)testCreateGenericHeightConstraintForViewWithHeight{
    id constraint = [AutoLayout createGenericHeightConstraintFor:self.testView1
                                                      withHeight:self.height.floatValue];

    XCTAssert([constraint isMemberOfClass:[NSLayoutConstraint class]],
              @"constraint is not an NSLayoutConstraint Object");
}

-(void)testCreateConstraintFromBottomOfViewToTopOfView{
    id constraint = [AutoLayout createConstraintFromBottomOf:self.testView1
                                                     toTopOf:self.testView2];

    XCTAssert([constraint isMemberOfClass:[NSLayoutConstraint class]],
              @"constraint is not an NSLayoutConstraint Object");
}
@end















