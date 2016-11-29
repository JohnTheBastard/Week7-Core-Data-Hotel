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

@interface RoomsViewController ()<UITableViewDataSource>
@property(strong, nonatomic)NSArray *dataSource;
@property(strong, nonatomic)UITableView * tableView;

@end

@implementation RoomsViewController

-(void)loadView{
    [super loadView];
    self.tableView = [[UITableView alloc] init];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.dataSource = self.hotel.rooms.allObjects;

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
    cell.textLabel.text = [NSString stringWithFormat:@"Room %hd ($%.2F per night)",room.number,room.rate];

    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.hotel.rooms.count;
}

@end
