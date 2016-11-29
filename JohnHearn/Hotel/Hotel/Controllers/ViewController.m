//
//  ViewController.m
//  Hotel
//
//  Created by John D Hearn on 11/28/16.
//  Copyright © 2016 Bastardized Productions. All rights reserved.
//

#import "ViewController.h"
#import "HotelsViewController.h"
#import "Hotel+CoreDataClass.h"
#import "Autolayout.h"
#import "DatePickerViewController.h"


@interface ViewController ()

@end

@implementation ViewController

-(void)loadView{
    [super loadView];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.navigationItem setTitle:@"Hotel Manager"];
    [self setupCustomLayout];
}

-(void)setupCustomLayout{
    CGFloat navigationBarHeight = CGRectGetHeight(self.navigationController.navigationBar.frame);
    CGFloat statusBarHeight = 20.0;
    CGFloat buttonHeight = (self.view.frame.size.height - navigationBarHeight - statusBarHeight) / 3;

    UIButton *browseButton = [self createButtonWithTitle:@"Browse"
                                      andBackgroundColor:[UIColor colorWithRed:1.0
                                                                         green:1.0
                                                                          blue:0.75
                                                                         alpha:1.0]];
    UIButton *bookButton = [self createButtonWithTitle:@"Book"
                                    andBackgroundColor:[UIColor colorWithRed:1.0
                                                                       green:0.9
                                                                        blue:0.76
                                                                       alpha:1.0]];
    UIButton *lookupButton = [self createButtonWithTitle:@"Lookup"
                                      andBackgroundColor:[UIColor colorWithRed:0.85
                                                                         green:1.0
                                                                          blue:0.75
                                                                         alpha:1.0]];
    [AutoLayout createLeadingConstraintFrom:browseButton toView:self.view];
    [AutoLayout createTrailingConstraintFrom:browseButton toView:self.view];
    [AutoLayout createLeadingConstraintFrom:bookButton toView:self.view];
    [AutoLayout createTrailingConstraintFrom:bookButton toView:self.view];
    [AutoLayout createLeadingConstraintFrom:lookupButton toView:self.view];
    [AutoLayout createTrailingConstraintFrom:lookupButton toView:self.view];

    NSLayoutConstraint *browseButtonTopConstraint = [AutoLayout createGenericConstraintFrom:browseButton
                                                                                     toView:self.view
                                                                              withAttribute:NSLayoutAttributeTop];
    browseButtonTopConstraint.constant = navigationBarHeight + statusBarHeight;

    [AutoLayout createGenericHeightConstraintFor:browseButton withHeight:buttonHeight];
    [AutoLayout createGenericHeightConstraintFor:lookupButton withHeight:buttonHeight];
    [AutoLayout createGenericHeightConstraintFor:bookButton withHeight:buttonHeight];

    NSDictionary *buttonDictionary = @{@"browse":browseButton,@"book":bookButton,@"lookup":lookupButton};

    NSArray *buttonConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[browse][book][lookup]"
                                                                         options:0
                                                                         metrics:nil
                                                                           views:buttonDictionary];
    [NSLayoutConstraint activateConstraints:buttonConstraints];
    
    [browseButton addTarget:self
                     action:@selector(browseButtonSelected:)
           forControlEvents:UIControlEventTouchUpInside];

    [bookButton addTarget:self
                   action:@selector(bookButtonSelected:)
         forControlEvents:UIControlEventTouchUpInside];
}

-(UIButton *)createButtonWithTitle:(NSString *)title
                andBackgroundColor:(UIColor *)color{
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:title forState:UIControlStateNormal];
    [button setBackgroundColor:color];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTranslatesAutoresizingMaskIntoConstraints:NO];

    [self.view addSubview:button];
    return button;
}

-(void)browseButtonSelected:(UIButton *)sender{
    HotelsViewController *hotelsVC = [[HotelsViewController alloc] init];
    [self.navigationController pushViewController:hotelsVC animated:YES];
    NSLog(@"Browse Button Pressed");
}


-(void)bookButtonSelected:(UIButton *)sender{
    DatePickerViewController *datePickerVC = [[DatePickerViewController alloc] init];
    [self.navigationController pushViewController:datePickerVC animated:YES];
    NSLog(@"Book Button Pressed");
}

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
