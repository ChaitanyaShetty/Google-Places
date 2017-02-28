//
//  AppDelegate.h
//  GooglePlaces
//
//  Created by test on 2/27/17.
//  Copyright © 2017 com.meheboob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

