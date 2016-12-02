//
//  BookViewController.m
//  Hotel
//
//  Created by John D Hearn on 11/29/16.
//  Copyright © 2016 Bastardized Productions. All rights reserved.
//

#import <Flurry.h>
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import "BookViewController.h"
#import "AutoLayout.h"
#import "AppDelegate.h"
#import "Hotel+CoreDataClass.h"
#import "Reservation+CoreDataClass.h"
#import "Guest+CoreDataClass.h"

@interface BookViewController ()
@property(strong, nonatomic)UITextField *firstNameField;
@property(strong, nonatomic)UITextField *lastNameField;
@property(strong, nonatomic)UITextField *emailField;
@property(strong, nonatomic)UIButton *crashButton;

@end

@implementation BookViewController
-(void)loadView{
    [super loadView];
    [self.view setBackgroundColor:[UIColor whiteColor]];

    [self setupCrashlytics];
    [self setupMessageLabel];
    [self setupTextFieldsAndButton];
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                                                target:self
                                                                                action:@selector(saveButtonSelected:)];
    [self.navigationItem setRightBarButtonItem:saveButton];

}

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)setupCrashlytics{
    self.crashButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.crashButton.frame = CGRectMake(20, 50, 100, 30);
    [self.crashButton setTitle:@"Crash" forState:UIControlStateNormal];
    [self.crashButton addTarget:self action:@selector(crashButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.crashButton];
    [self.crashButton setTranslatesAutoresizingMaskIntoConstraints:NO];

    NSLayoutConstraint *leading = [AutoLayout createLeadingConstraintFrom:self.crashButton
                                                                   toView:self.view];
    leading.constant = kMargin;

    NSLayoutConstraint *trailing = [AutoLayout createTrailingConstraintFrom:self.crashButton
                                                                     toView:self.view];
    trailing.constant = -kMargin;
}

-(void)setupMessageLabel{
    UILabel *messageLabel = [[UILabel alloc] init];

    messageLabel.textAlignment = NSTextAlignmentLeft;
    messageLabel.numberOfLines = 0;
    [messageLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:messageLabel];

    NSLayoutConstraint *leading = [AutoLayout createLeadingConstraintFrom:messageLabel
                                                                   toView:self.view];
    leading.constant = kMargin;

    NSLayoutConstraint *trailing = [AutoLayout createTrailingConstraintFrom:messageLabel
                                                                     toView:self.view];
    trailing.constant = -kMargin;

    [AutoLayout createGenericConstraintFrom:messageLabel
                                     toView:self.view
                              withAttribute:NSLayoutAttributeCenterY];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;

    messageLabel.text = [NSString stringWithFormat:@"Reservation at %@\nRoom: %i\nCheck-In Date: %@\nCheck-Out Date: %@",
                                                   self.room.hotel.name,
                                                   self.room.number,
                                                   [dateFormatter stringFromDate:self.startDate],
                                                   [dateFormatter stringFromDate:self.endDate]];
}

-(void)setupTextFieldsAndButton{
    self.firstNameField = [[UITextField alloc] init];
    self.lastNameField = [[UITextField alloc] init];
    self.emailField = [[UITextField alloc] init];

    [self setupHelperFor:self.firstNameField
             withMessage:@"Please enter your first name"];
    [self setupHelperFor:self.lastNameField
             withMessage:@"Please enter your last name"];
    [self setupHelperFor:self.emailField
             withMessage:@"Please enter your email address"];



    NSDictionary *views = @{@"first":self.firstNameField,
                            @"last":self.lastNameField,
                            @"email":self.emailField,
                            @"crash":self.crashButton};

    NSDictionary *metrics = @{@"topPad":[NSNumber numberWithFloat:kNavBarAndStatusBarHeight + kMargin],
                              @"margin":[NSNumber numberWithFloat:kMargin]};
    NSString *format = @"V:|-topPad-[first]-[last]-[email]-[crash]";

    NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:format
                                                                           options:0
                                                                           metrics:metrics
                                                                             views:views];
    [NSLayoutConstraint activateConstraints:verticalConstraints];

    [self.firstNameField becomeFirstResponder];
}

-(void)setupHelperFor:(UITextField *)field
            withMessage:(NSString *)placeholder{
    field.placeholder = placeholder;
    [field setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:field];

    NSLayoutConstraint *leading = [AutoLayout createLeadingConstraintFrom:field
                                                                   toView:self.view];
    leading.constant = kMargin;
    NSLayoutConstraint *trailing = [AutoLayout createTrailingConstraintFrom:field
                                                                     toView:self.view];
    trailing.constant = -kMargin;
}

- (IBAction)crashButtonTapped:(id)sender {
    NSMutableString *identifier = [NSMutableString stringWithFormat:@""];

    if(![self.lastNameField.text isEqualToString:@""]){
        [identifier appendString:self.lastNameField.text];
        [identifier appendString:@", "];
    }
    if(![self.firstNameField.text isEqualToString:@""]){
    [identifier appendString:self.firstNameField.text];
    }

    [CrashlyticsKit setUserIdentifier:identifier];
    [CrashlyticsKit setUserEmail:self.emailField.text];
    //[CrashlyticsKit setUserName:@"Test User"];


    [[Crashlytics sharedInstance] crash];
}

-(void)saveButtonSelected:(UIBarButtonItem *)sender{

    //TODO: handle empty text fields

    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = appDelegate.persistentContainer.viewContext;

    Reservation *reservation = [NSEntityDescription insertNewObjectForEntityForName:@"Reservation"
                                                             inManagedObjectContext:context];
    reservation.startDate = self.startDate;
    reservation.endDate = self.endDate;
    reservation.room = self.room;
    self.room.reservations = [self.room.reservations setByAddingObject:reservation];
    reservation.guest = [NSEntityDescription insertNewObjectForEntityForName:@"Guest"
                                                      inManagedObjectContext:context];
    reservation.guest.firstName = self.firstNameField.text;
    reservation.guest.lastName = self.lastNameField.text;
    reservation.guest.email = self.emailField.text;

    NSError *saveError;
    [context save:&saveError];

    if(saveError){
        NSLog(@"There was an error savine new reservation.");
    } else {
        NSLog(@"Saved reservation successfully!");
        [self.navigationController popToRootViewControllerAnimated:YES];

        NSDictionary *parameters = @{@"GuestName":reservation.guest.firstName};
        [Flurry logEvent:@"Reservation_Booked" withParameters:parameters];
    }
}

@end





