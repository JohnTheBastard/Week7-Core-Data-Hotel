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
@property(strong, nonatomic)UIDatePicker *startPicker;
@property(strong, nonatomic)UIDatePicker *endPicker;

@end

@implementation DatePickerViewController

-(void)loadView{
    [super loadView];
    [self.view setBackgroundColor:[UIColor lightGrayColor]];
    [self setupDatePickers];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                target:self
                                                                                action:@selector(doneButtonSelected:)];
    [self.navigationItem setRightBarButtonItem:doneButton];

}

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)setupDatePickers{  //TODO: This method is so gross. Needs to be broken apart.
    //Make Labels
    UILabel *startLabel = [[UILabel alloc] init];
    UILabel *endLabel = [[UILabel alloc] init];
    startLabel.textAlignment = NSTextAlignmentLeft;
    endLabel.textAlignment = NSTextAlignmentLeft;
    startLabel.numberOfLines = 1;
    endLabel.numberOfLines = 1;
    // Don't make constraints for me, I'm going to make them
    [startLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [endLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:startLabel];
    [self.view addSubview:endLabel];
    startLabel.text = @"Start Date:";
    [startLabel setFont:[UIFont boldSystemFontOfSize:20]];
    endLabel.text = @"End Date:";
    [endLabel setFont:[UIFont boldSystemFontOfSize:20]];
    CGFloat myMargin = 8.0;
    NSLayoutConstraint *startLead = [AutoLayout createLeadingConstraintFrom:startLabel
                                                                     toView:self.view];
    NSLayoutConstraint *endLead = [AutoLayout createLeadingConstraintFrom:endLabel
                                                                   toView:self.view];
    startLead.constant = myMargin;
    endLead.constant = myMargin;

    //Make Pickers
    self.startPicker = [[UIDatePicker alloc] init];
    self.endPicker = [[UIDatePicker alloc] init];
    self.startPicker.datePickerMode = UIDatePickerModeDate;
    self.endPicker.datePickerMode = UIDatePickerModeDate;
    self.startPicker.backgroundColor = [UIColor darkGrayColor];
    [self.startPicker setValue:[UIColor whiteColor] forKey:@"textColor"];
    self.endPicker.backgroundColor = [UIColor darkGrayColor];
    [self.endPicker setValue:[UIColor whiteColor] forKey:@"textColor"];
    [self.view addSubview:self.startPicker];
    [self.view addSubview:self.endPicker];
    [self.startPicker setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.endPicker setTranslatesAutoresizingMaskIntoConstraints:NO];
    [AutoLayout createLeadingConstraintFrom:self.startPicker toView:self.view];
    [AutoLayout createLeadingConstraintFrom:self.endPicker toView:self.view];
    [AutoLayout createTrailingConstraintFrom:self.startPicker toView:self.view];
    [AutoLayout createTrailingConstraintFrom:self.endPicker toView:self.view];

    NSDate *now = [NSDate date];
    NSDateComponents *oneDay = [[NSDateComponents alloc] init];
    oneDay.day = 1;
    NSDateComponents *oneYear = [[NSDateComponents alloc] init];
    oneYear.year = 1;
    NSDateComponents *oneYearOneDay = [[NSDateComponents alloc] init];
    oneYearOneDay.day = 1;
    oneYearOneDay.year = 1;

    NSCalendar *theCalendar = [NSCalendar currentCalendar];

    NSDate *nowPlusOneDay = [theCalendar dateByAddingComponents:oneDay
                                                         toDate:now
                                                        options:0];
    NSDate *nowPlusOneYear = [theCalendar dateByAddingComponents:oneYear
                                                               toDate:now
                                                              options:0];
    NSDate *nowPlusOneYearOneDay = [theCalendar dateByAddingComponents:oneYear
                                                                toDate:now
                                                               options:0];

    self.startPicker.minimumDate = now;
    self.startPicker.maximumDate = nowPlusOneYear;
    self.endPicker.minimumDate = nowPlusOneDay;
    self.endPicker.maximumDate = nowPlusOneYearOneDay;

    NSDictionary *views = @{@"startLabel":startLabel,
                            @"endLabel":endLabel,
                            @"startPicker":self.startPicker,
                            @"endPicker":self.endPicker};

    NSDictionary *metrics = @{@"topPad":[NSNumber numberWithFloat:kNavBarAndStatusBarHeight + myMargin],
                              @"margin":[NSNumber numberWithFloat:myMargin]};

    NSString *format = @"V:|-topPad-[startLabel][startPicker]-[endLabel][endPicker]|";

    NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:format
                                                                           options:0
                                                                           metrics:metrics
                                                                             views:views];
    [NSLayoutConstraint activateConstraints:verticalConstraints];
}

-(void)doneButtonSelected:(UIBarButtonItem *)sender{
    NSDate *startDate = self.startPicker.date;
    NSDate *endDate = self.endPicker.date;

    NSDate *now = [NSDate date];
    NSDateComponents *oneDay = [[NSDateComponents alloc] init];
    oneDay.day = 1;

    NSCalendar *theCalendar = [NSCalendar currentCalendar];
    NSDate *startDatePlusOneDay = [theCalendar dateByAddingComponents:oneDay
                                                               toDate:startDate
                                                              options:0];

    UIAlertController *alertController;
    if([now timeIntervalSinceReferenceDate] >= [startDatePlusOneDay timeIntervalSinceReferenceDate]){
        alertController = [UIAlertController alertControllerWithTitle:@"Huh?"
                                                              message:@"Your reservation can't begin in the past!"
                                                       preferredStyle:UIAlertControllerStyleAlert];
    } else if([now timeIntervalSinceReferenceDate] > [endDate timeIntervalSinceReferenceDate]){
        alertController = [UIAlertController alertControllerWithTitle:@"Huh?"
                                                              message:@"Please make sure the end date is in the future."
                                                       preferredStyle:UIAlertControllerStyleAlert];

    } else if([startDate timeIntervalSinceReferenceDate] > [endDate timeIntervalSinceReferenceDate]){
        alertController = [UIAlertController alertControllerWithTitle:@"Huh?"
                                                              message:@"Your reservation must be at least one day!"
                                                       preferredStyle:UIAlertControllerStyleAlert];
    }

    if(alertController){
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
    availabilityVC.startDate = self.startPicker.date;
    availabilityVC.endDate = self.endPicker.date;
    [self.navigationController pushViewController:availabilityVC animated:YES];

}

//-(CGFloat)navBarAndStatusBarHeight{
//    //20.0 is StatusBar height
//    return self.navigationController.navigationBar.frame.size.height + 20.0;
//}

@end
