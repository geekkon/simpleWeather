//
//  SWViewController.m
//  SimpleWeather
//
//  Created by Dim on 14.07.15.
//  Copyright (c) 2015 Dmitriy Baklanov. All rights reserved.
//

#import "SWViewController.h"
#import "SWDataManager.h"


@interface SWViewController ()

@end

@implementation SWViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [[SWDataManager sharedManager] fetchWeatherWithCityID:0
//                                          completionBlock:^(BOOL successful, SWWeather *weather, NSError *error) {
//                                              
//                                              NSLog(@"IN CONTROLLER");
//                                              
//                                          }];
    
    [[SWDataManager sharedManager] fetchWeatherWithCityID:0
                                          completionBlock:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
