//
//  ViewController.h
//  HomeKitSample
//
//  Created by 石田 勝嗣 on 2014/08/11.
//  Copyright (c) 2014年 石田 勝嗣. All rights reserved.
//

#import <UIKit/UIKit.h>
@import HomeKit;

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UISwitch *light;
@property (weak, nonatomic) IBOutlet UISlider *hue;
@property (weak, nonatomic) IBOutlet UISlider *brightness;
@property (weak, nonatomic) IBOutlet UISlider *saturation;
@property (weak, nonatomic) IBOutlet UILabel *place;

@property (nonatomic) HMAccessory * accessory;

- (void)setAccessories;
- (void)refresh;
@end

