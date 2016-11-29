//
//  HotelsViewController.m
//  Hotel
//
//  Created by John D Hearn on 11/28/16.
//  Copyright © 2016 Bastardized Productions. All rights reserved.
//

#import "HotelsViewController.h"
#import "AutoLayout.h"
#import "AppDelegate.h"
#import "RoomsViewController.h"
#import "Hotel+CoreDataClass.h"

@interface HotelsViewController ()<UITableViewDataSource, UITableViewDelegate>
@property(strong, nonatomic)NSArray *dataSource;
@property(strong, nonatomic)UITableView *tableView;

@end

@implementation HotelsViewController

-(void)loadView{
    [super loadView];
    self.tableView = [[UITableView alloc] init];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;

    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:@"cell"];

    [AutoLayout activateFullViewConstraintsUsingVFLFor:self.tableView];
}

-(void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"Hotels"];
}

-(NSArray *)dataSource{
    if(!_dataSource){
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        NSManagedObjectContext *context = delegate.persistentContainer.viewContext;
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Hotel"];
        NSError *fetchError;

        _dataSource = [context executeFetchRequest:request
                                        error:&fetchError];

        if(fetchError){
            NSLog(@"Error fetching hotels from CoreData.");
        }
    }

    return _dataSource;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell"
                                                                 forIndexPath:indexPath];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:@"cell"];
    }

    Hotel *hotel = self.dataSource[indexPath.row];
    cell.textLabel.text = hotel.name;

    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    RoomsViewController *roomsVC = [[RoomsViewController alloc] init];
    roomsVC.hotel = self.dataSource[indexPath.row];
    [self.navigationController pushViewController:roomsVC animated:YES];
    NSLog(@"Hotel Cell Selected");
}

// This is redundant code (see RoomssViewController), should live elsewhere
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIImage *hotelImage = [UIImage imageNamed:@"hotel"];
    UIImageView *headerImageView = [[UIImageView alloc] initWithImage:hotelImage];

//    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,CGRectGetWidth(tableView.frame), kHeaderHeight)];
//    [headerView addSubview:headerImageView];
    headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    headerImageView.clipsToBounds = YES;

    return headerImageView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return kHeaderHeight;
}
@end




