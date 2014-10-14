//
//  ViewController.m
//  HomeKitSample
//
//  Created by 石田 勝嗣 on 2014/08/11.
//  Copyright (c) 2014年 石田 勝嗣. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic) HMCharacteristic* powerState;
@property (nonatomic) HMCharacteristic* hueState;
@property (nonatomic) HMCharacteristic* brightnessState;
@property (nonatomic) HMCharacteristic* saturationState;


@end

@implementation ViewController
            
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    [self.light addTarget:self action:@selector(lightChanged:)
         forControlEvents:UIControlEventValueChanged];
    [self.hue addTarget:self action:@selector(hueChanged:)
              forControlEvents:UIControlEventValueChanged];
    [self.brightness addTarget:self action:@selector(brightnessChanged:)
         forControlEvents:UIControlEventValueChanged];
    [self.saturation addTarget:self action:@selector(saturationChanged:)
              forControlEvents:UIControlEventValueChanged];
}

- (void)lightChanged:(UISwitch*) sw {
    NSLog(@"Light changed %d", sw.on);
    [self.powerState writeValue:([NSNumber numberWithBool:(sw.on)]) completionHandler:^(NSError *error) {
        if (error) {
            NSLog(@"error: %@", error);
        }
    }];
}

- (void)hueChanged:(UISlider*) slider {
    NSLog(@"Hue changed %f", slider.value);
    [self.hueState writeValue:([NSNumber numberWithFloat:(slider.value)]) completionHandler:^(NSError *error) {
        if (error) {
            NSLog(@"error: %@", error);
        }
    }];
}

- (void)brightnessChanged:(UISlider*) slider {
    NSLog(@"Brightness changed %f", slider.value);
    [self.brightnessState writeValue:([NSNumber numberWithFloat:(slider.value)]) completionHandler:^(NSError *error) {
        if (error) {
            NSLog(@"error: %@", error);
        }
    }];
}

- (void)saturationChanged:(UISlider*) slider {
    NSLog(@"Saturation changed %f", slider.value);
    [self.saturationState writeValue:([NSNumber numberWithFloat:(slider.value)]) completionHandler:^(NSError *error) {
        if (error) {
            NSLog(@"error: %@", error);
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setAccessories {
    NSLog(@"accessory: %@", self.accessory);
    for (HMService* service in self.accessory.services) {
        NSLog(@"service: %@", service.name);
        for (HMCharacteristic* characteristic in service.characteristics) {
            if ([characteristic.characteristicType isEqualToString:(HMCharacteristicTypePowerState)]) {
                BOOL val = [characteristic.value boolValue];
                NSLog(@"PowerState: %d", val);
                self.powerState = characteristic;
                [characteristic enableNotification:(YES) completionHandler:^(NSError *error) {
                    if (error) {
                        NSLog(@"error: %@", error);
                    }
                }];
                //[self.light setOn:val animated:(YES)];
            } else if ([characteristic.characteristicType isEqualToString:(HMCharacteristicTypeHue)]) {
                NSLog(@"Hue: %f", [characteristic.value floatValue]);
                self.hueState = characteristic;
                [characteristic enableNotification:(YES) completionHandler:^(NSError *error) {
                    if (error) {
                        NSLog(@"error: %@", error);
                    }
                }];
            } else if ([characteristic.characteristicType isEqualToString:(HMCharacteristicTypeSaturation)]) {
                NSLog(@"Saturation: %f", [characteristic.value floatValue]);
                self.saturationState = characteristic;
                [characteristic enableNotification:(YES) completionHandler:^(NSError *error) {
                    if (error) {
                        NSLog(@"error: %@", error);
                    }
                }];
            } else if ([characteristic.characteristicType isEqualToString:(HMCharacteristicTypeBrightness)]) {
                NSLog(@"Brightness: %d", [characteristic.value intValue]);
                self.brightnessState = characteristic;
                [characteristic enableNotification:(YES) completionHandler:^(NSError *error) {
                    if (error) {
                        NSLog(@"error: %@", error);
                    }
                }];
            }
        }
    }
    [self refresh];
}

- (IBAction)resetPushed:(id)sender {
}

- (void)refresh {
    [self.light setOn:[self.powerState.value boolValue] animated:(YES)];
    [self.hue setValue:[self.hueState.value floatValue] animated:(YES)];
    [self.brightness setValue:[self.brightnessState.value intValue] animated:(YES)];
    [self.saturation setValue:[self.saturationState.value floatValue] animated:(YES)];
}
@end
