//
//  AppDelegate.h
//  Hotel
//
//  Created by John D Hearn on 11/28/16.
//  Copyright © 2016 Bastardized Productions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

