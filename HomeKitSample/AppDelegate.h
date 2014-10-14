//
//  AppDelegate.h
//  HomeKitSample
//
//  Created by 石田 勝嗣 on 2014/08/11.
//  Copyright (c) 2014年 石田 勝嗣. All rights reserved.
//

#import <UIKit/UIKit.h>
@import HomeKit;

@interface AppDelegate : UIResponder <UIApplicationDelegate, HMHomeManagerDelegate, HMAccessoryBrowserDelegate, HMAccessoryDelegate>

@property (strong, nonatomic) UIWindow *window;


@end

