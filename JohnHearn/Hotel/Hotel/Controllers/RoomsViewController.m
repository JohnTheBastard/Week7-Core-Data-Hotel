//
//  RoomViewController.m
//  Hotel
//
//  Created by John D Hearn on 11/28/16.
//  Copyright © 2016 Bastardized Productions. All rights reserved.
//

#import "RoomsViewController.h"
#import "AutoLayout.h"
#import "AppDelegate.h"
#import "Hotel+CoreDataClass.h"
#import "Room+CoreDataClass.h"

@interface RoomsViewController ()<UITableViewDataSource, UITableViewDelegate>
@property(strong, nonatomic)NSArray *dataSource;
@property(strong, nonatomic)UITableView * tableView;

@end

@implementation RoomsViewController

-(void)loadView{
    [super loadView];
    self.tableView = [[UITableView alloc] init];
    self.tableView.dataSource = self;
    self.dataSource = self.hotel.rooms.allObjects;
    self.tableView.delegate = self;

    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:@"cell"];

    [AutoLayout activateFullViewConstraintsUsingVFLFor:self.tableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"Rooms"];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell"
                                                                 forIndexPath:indexPath];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:@"cell"];
    }

    Room *room = self.dataSource[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"Room %i ($%.02F per night, %i beds)",room.number,room.rate.floatValue, room.beds];

    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.hotel.rooms.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // Do something
    NSLog(@"Room Cell Selected");
}

// This is redundant code (see HotelsViewController), maybe should live elsewhere
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIImage *roomImage = [UIImage imageNamed:@"room"];
    UIImageView *headerImageView = [[UIImageView alloc] initWithImage:roomImage];

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
