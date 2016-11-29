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
@property(strong, nonatomic)UITextField *nameField;
@property(strong, nonatomic)UITextField *emailField;

@end

@implementation BookViewController
-(void)loadView{
    [super loadView];
    [self.view setBackgroundColor:[UIColor whiteColor]];

    [self setupMessageLabel];
    [self setupNameTextField];
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

    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.numberOfLines = 0;
    [messageLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:messageLabel];
    CGFloat myMargin = 20.0;
    NSLayoutConstraint *leading = [AutoLayout createLeadingConstraintFrom:messageLabel
                                                                   toView:self.view];
    leading.constant = myMargin;

    NSLayoutConstraint *trailing = [AutoLayout createTrailingConstraintFrom:messageLabel
                                                                     toView:self.view];
    trailing.constant = -myMargin;

    [AutoLayout createGenericConstraintFrom:messageLabel
                                     toView:self.view
                              withAttribute:NSLayoutAttributeCenterY];
    messageLabel.text = [NSString stringWithFormat:@"Reservation at:%@\nRoom:%i\nFrom: Today - %@",
                                                   self.room.hotel.name,
                                                   self.room.number,
                                                   self.endDate];
}

-(void)setupNameTextField{
    self.nameField = [[UITextField alloc] init];
    self.nameField.placeholder = @"Please ender your name";
    [self.nameField setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:self.nameField];

    //TODO: make global to VC
    CGFloat myMargin = 20.0;

    NSLayoutConstraint *top = [AutoLayout createGenericConstraintFrom:self.nameField
                                                               toView:self.view
                                                        withAttribute:NSLayoutAttributeTop];
    top.constant = kNavBarAndStatusBarHeight + myMargin;
    NSLayoutConstraint *leading = [AutoLayout createLeadingConstraintFrom:self.nameField
                                                                   toView:self.view];
    leading.constant = myMargin;
    NSLayoutConstraint *trailing = [AutoLayout createTrailingConstraintFrom:self.nameField
                                                                     toView:self.view];
    trailing.constant = -myMargin;

    [self.nameField becomeFirstResponder];

}

-(void)saveButtonSelected:(UIBarButtonItem *)sender{

    //TODO: handle empty text fields

    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = appDelegate.persistentContainer.viewContext;

    Reservation *reservation = [NSEntityDescription insertNewObjectForEntityForName:@"Reservation"
                                                             inManagedObjectContext:context];
    reservation.startDate = [NSDate date];
    reservation.endDate = self.endDate;
    reservation.room = self.room;
    self.room.reservations = [self.room.reservations setByAddingObject:reservation];
    reservation.guest = [NSEntityDescription insertNewObjectForEntityForName:@"Guest"
                                                      inManagedObjectContext:context];
    reservation.guest.name = self.nameField.text;

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





