//
//  BookViewController.m
//  Hotel
//
//  Created by John D Hearn on 11/29/16.
//  Copyright © 2016 Bastardized Productions. All rights reserved.
//

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

@end

@implementation BookViewController
-(void)loadView{
    [super loadView];
    [self.view setBackgroundColor:[UIColor whiteColor]];

    [self setupMessageLabel];
    [self setupTextFields];
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                                                target:self
                                                                                action:@selector(saveButtonSelected:)];
    [self.navigationItem setRightBarButtonItem:saveButton];

}

- (void)viewDidLoad {
    [super viewDidLoad];
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

-(void)setupTextFields{
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
                            @"email":self.emailField};
    NSDictionary *metrics = @{@"topPad":[NSNumber numberWithFloat:kNavBarAndStatusBarHeight + kMargin],
                              @"margin":[NSNumber numberWithFloat:kMargin]};
    NSString *format = @"V:|-topPad-[first]-[last]-[email]";

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
    }
}

@end





