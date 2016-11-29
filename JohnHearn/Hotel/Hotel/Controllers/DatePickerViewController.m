//
//  DatePickerViewController.m
//  Hotel
//
//  Created by John D Hearn on 11/29/16.
//  Copyright © 2016 Bastardized Productions. All rights reserved.
//

#import "AutoLayout.h"
#import "DatePickerViewController.h"
#import "AvailabilityViewController.h"

@interface DatePickerViewController ()
@property(strong, nonatomic)UIDatePicker *endPicker;

@end

@implementation DatePickerViewController

-(void)loadView{
    [super loadView];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setupDatePicker];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                target:self
                                                                                action:@selector(doneButtonSelected:)];
    [self.navigationItem setRightBarButtonItem:doneButton];

}

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)setupDatePicker{
    self.endPicker = [[UIDatePicker alloc] init];
    self.endPicker.datePickerMode = UIDatePickerModeDate;
    [self.view addSubview:self.endPicker];

    // Don't make constraints, I'm going to make them
    [self.endPicker setTranslatesAutoresizingMaskIntoConstraints:NO];

    [AutoLayout createLeadingConstraintFrom:self.endPicker toView:self.view];
    [AutoLayout createTrailingConstraintFrom:self.endPicker toView:self.view];

    NSLayoutConstraint *topConstraint = [AutoLayout createGenericConstraintFrom:self.endPicker
                                                                         toView:self.view
                                                                  withAttribute:NSLayoutAttributeTop];
    topConstraint.constant = kNavBarAndStatusBarHeight;
}

-(void)doneButtonSelected:(UIBarButtonItem *)sender{
    NSDate *endDate = self.endPicker.date;

    if([[NSDate date] timeIntervalSinceReferenceDate] > [endDate timeIntervalSinceReferenceDate]){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Huh..."
                                                                                 message:@"Please make sue the end date is in the future."
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action){
                                                             self.endPicker.date = [NSDate date];
                                                         }];

        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }

    AvailabilityViewController *availabilityVC = [[AvailabilityViewController alloc] init];
    //TODO: need a start date too
    availabilityVC.endDate = self.endPicker.date;
    [self.navigationController pushViewController:availabilityVC animated:YES];

}

//-(CGFloat)navBarAndStatusBarHeight{
//    //20.0 is StatusBar height
//    return self.navigationController.navigationBar.frame.size.height + 20.0;
//}

@end
