//
//  LookupViewController.m
//  Hotel
//
//  Created by John D Hearn on 11/30/16.
//  Copyright © 2016 Bastardized Productions. All rights reserved.
//

#import "LookupViewController.h"
#import "AutoLayout.h"
#import "AppDelegate.h"
#import "Room+CoreDataClass.h"
#import "Hotel+CoreDataClass.h"
#import "Reservation+CoreDataClass.h"
#import "BookViewController.h"
#import "Guest+CoreDataClass.h"

@interface LookupViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
@property(strong, nonatomic)UITableView *tableView;
@property(strong, nonatomic)UISearchBar *searchBar;
@property(strong, nonatomic)NSFetchRequest *reservationRequest;
@property(strong, nonatomic)NSManagedObjectContext *context;
@property(strong, nonatomic)NSFetchedResultsController *foundReservations;
@end


@implementation LookupViewController
-(void)loadView{
    [super loadView];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setupSearchBarAndTableView];
    [self setupContextAndFetchRequest];
    [self setTitle:@"Reservations"];
    [self.navigationController.navigationItem.leftBarButtonItem setTitle:@"Back"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}

-(void)setupContextAndFetchRequest{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.context = appDelegate.persistentContainer.viewContext;

    self.reservationRequest = [NSFetchRequest fetchRequestWithEntityName:@"Reservation"];
    self.reservationRequest.sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey:@"room.hotel.name" ascending:YES],
                                 [NSSortDescriptor sortDescriptorWithKey:@"room.number" ascending:YES] ];
}

-(void)setupSearchBarAndTableView{
    //TODO: Lots of redundant code from other VCs with tableviews,
    //      find a way to refactor
    self.searchBar = [[UISearchBar alloc] init];
    self.searchBar.delegate = self;
    self.searchBar.placeholder = @"please enter your email";
    [self.searchBar setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:self.searchBar];

    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];

    //Constraints
    [AutoLayout createLeadingConstraintFrom:self.searchBar toView:self.view];
    [AutoLayout createTrailingConstraintFrom:self.searchBar toView:self.view];
    [AutoLayout createLeadingConstraintFrom:self.tableView toView:self.view];
    [AutoLayout createTrailingConstraintFrom:self.tableView toView:self.view];

    NSDictionary *views = @{@"searchBar":self.searchBar,
                            @"tableView":self.tableView};
    NSDictionary *metrics = @{@"topPad":[NSNumber numberWithFloat:kNavBarAndStatusBarHeight],
                              @"margin":[NSNumber numberWithFloat:kMargin]};

    NSString *format = @"V:|-topPad-[searchBar][tableView]|";

    NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:format
                                                                           options:0
                                                                           metrics:metrics
                                                                             views:views];
    [NSLayoutConstraint activateConstraints:verticalConstraints];

    [self.searchBar becomeFirstResponder];
}

-(NSFetchedResultsController *)foundReservations{

    NSLog(@"Computing foundReservations on: %@", self.searchBar.text);

    if(![self.searchBar.text isEqualToString:@""]){

        self.reservationRequest.predicate = [NSPredicate predicateWithFormat:@"guest.email == %@",
                                                                             self.searchBar.text];
        if(!_foundReservations){
            _foundReservations = [[NSFetchedResultsController alloc] initWithFetchRequest:self.reservationRequest
                                                                     managedObjectContext:self.context
                                                                       sectionNameKeyPath:@"guest.email"
                                                                                cacheName:nil];
        } else {
            _foundReservations.fetchRequest.predicate = self.reservationRequest.predicate;
        }

        NSError *requestError;
        [_foundReservations performFetch:&requestError];

        if(requestError){
            NSLog(@"There was an issue with requesting available rooms.");
            return nil;
        }
    }
    return _foundReservations;
}

//MARK: Protocol Methods
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"
                                                            forIndexPath:indexPath];

    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:@"cell"];
    }

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterShortStyle;

    Reservation *reservation = [self.foundReservations objectAtIndexPath:indexPath];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.text = [NSString stringWithFormat:@"Room: %i\n%@ through %@",
                                                     reservation.room.number,
                                                     [dateFormatter stringFromDate:reservation.startDate],
                                                     [dateFormatter stringFromDate:reservation.endDate]];
    return cell;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    id<NSFetchedResultsSectionInfo> sectionInfo = [[self.foundReservations sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.foundReservations.sections.count;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    id<NSFetchedResultsSectionInfo> sectionInfo = [[self.foundReservations sections] objectAtIndex:section];
    Reservation *reservation = [[sectionInfo objects] objectAtIndex:section];
    return [NSString stringWithFormat:@"%@ Reservation",reservation.room.hotel.name];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Reservation *reservation = [self.foundReservations objectAtIndexPath:indexPath];

    BookViewController *bookVC = [[BookViewController alloc] init];
    bookVC.room = reservation.room;
    bookVC.startDate = reservation.startDate;
    bookVC.endDate = reservation.endDate;

    [self.navigationController pushViewController:bookVC animated:YES];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    if(self.searchBar.text){
        //[self foundReservations];
        [self.tableView reloadData];
    }

}

//-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{}

@end
