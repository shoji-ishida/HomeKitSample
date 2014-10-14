//
//  AppDelegate.m
//  HomeKitSample
//
//  Created by 石田 勝嗣 on 2014/08/11.
//  Copyright (c) 2014年 石田 勝嗣. All rights reserved.
//

#import "AppDelegate.h"
@import HomeKit;
#import "ViewController.h"

@interface AppDelegate ()

@property (nonatomic) HMHomeManager* homeManager;
@property (nonatomic) HMAccessoryBrowser* accessoryBrowser;
@property (nonatomic) HMAccessory* accessory;

@end

static NSString *const homeName = @"自宅";
static NSString *const roomName = @"リビング";
static NSString *const accName = @"電灯";

@implementation AppDelegate
            

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.homeManager = [[HMHomeManager alloc] init];
    self.homeManager.delegate = self;

    return YES;
}

- (void)removeAll {
    for (HMHome* home in self.homeManager.homes) {
        NSLog(@"remove %@", home.name);
        [self.homeManager removeHome:home completionHandler:^(NSError *error) {
            if (error) {
                NSLog(@"error removeAll:%@", error);
            } else {
                NSLog(@"success! removeAll");
            }
        }];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)homeManager:(HMHomeManager *)manager  didAddHome:(HMHome *)home {
    NSLog(@"Home added ");
}

- (void)accessoryBrowser:(HMAccessoryBrowser *)browser didFindNewAccessory:(HMAccessory *)accessory {
    NSLog(@"didFindNewAccessory: %@", accessory.debugDescription);
    __weak typeof(self) weakSelf = self;
    [self.homeManager.primaryHome addAccessory:accessory completionHandler:^(NSError *error) {
        if (error) {
            NSLog(@"error addAccessory:%@", error);
        } else {
            NSLog(@"success! addAccessory");
            weakSelf.accessory = accessory;
            [weakSelf setAccessory];
        }
    }];
}

- (void)homeManagerDidUpdatePrimaryHome:(HMHomeManager *)manager {
    NSLog(@"homeManagerDidUpdatePrimaryHome: %@", manager.primaryHome.name);
}

- (void)homeManagerDidUpdateHomes:(HMHomeManager *)manager {
    //[self removeAll];
    //return;
    NSLog(@"homeManagerDidUpdateHomes: %@", manager.homes.debugDescription);
    NSLog(@" %@", manager.primaryHome.rooms.debugDescription);
        
    HMHome *primaryHome = self.homeManager.primaryHome;
    bool found = NO;
    if ([primaryHome.name isEqualToString:homeName]) {
        NSLog(@"%@ already exists", homeName);
        for (HMRoom* room in primaryHome.rooms) {
            if ([room.name isEqualToString:roomName]) {
                NSLog(@"%@ already exists", roomName);
                found = YES;
                break;
            }
        }
        if (!found) {
            [self addRoom];
        }
    } else {
        NSLog(@"%@ does not exist", homeName);
        [self addHome];
        return;
    }
    found = NO;
    for (HMAccessory *acc in primaryHome.accessories) {
        if ([acc.name isEqualToString:accName]) {
            NSLog(@"%@ already exists", accName);
            found = YES;
            self.accessory = acc;
            [self setAccessory];
            break;
        }
    }
    if (!found) {
        [self addAccessory];
    }
}

- (void) addHome {
    [self.homeManager addHomeWithName:homeName
        completionHandler:^(HMHome *home, NSError *error) {
            if (error) {
                NSLog(@"error addHome:%@", error);
                return;
            } else {
                NSLog(@"success! addHome");
            }
        }
     ];
}

- (void) addRoom {
    [self.homeManager.primaryHome addRoomWithName:roomName
        completionHandler:^(HMRoom *room, NSError *error) {
            
            if (error) {
                NSLog(@"error addRoom:%@", error);
            } else {
                NSLog(@"success! addRoom");
            }
        }
     ];
}

- (void) addAccessory {
    NSLog(@"Searching Accessories");
    self.accessoryBrowser = [[HMAccessoryBrowser alloc] init];
    self.accessoryBrowser.delegate = self;
    
    [self.accessoryBrowser startSearchingForNewAccessories];
}

- (void) setAccessory {
    self.accessory.delegate = self;
    //NSLog(@"accessory: %@", self.accessory);
    ViewController *topViewController = (ViewController *)[self.window rootViewController];
    topViewController.accessory = self.accessory;
    [topViewController setAccessories];
    [self setPlace];
    [self.accessoryBrowser stopSearchingForNewAccessories];

}

- (void)accessory:(HMAccessory *)accessory service:(HMService *)service didUpdateValueForCharacteristic:(HMCharacteristic *)characteristic {
    NSLog(@"Value changed: %@", service.name);
    ViewController *topViewController = (ViewController *)[self.window rootViewController];
    topViewController.accessory = self.accessory;
    [topViewController refresh];
}

-(void)setPlace {
    ViewController *topViewController = (ViewController *)[self.window rootViewController];
    UILabel *label = topViewController.place;
    [label setText:([NSString stringWithFormat:@"%@: %@", self.accessory.room.name, self.accessory.name])];
}
@end
