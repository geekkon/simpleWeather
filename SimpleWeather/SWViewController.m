//
//  SWViewController.m
//  SimpleWeather
//
//  Created by Dim on 14.07.15.
//  Copyright (c) 2015 Dmitriy Baklanov. All rights reserved.
//

#import "SWViewController.h"
#import "SWDataManager.h"
#import "SWCity.h"
#import "SWWeather.h"


@interface SWViewController () <SWDataManagerDelegate>

@property (strong, nonatomic) SWCity *city;
@property (strong, nonatomic) SWWeather *weather;

@end

@implementation SWViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
 
    SWCity *city = [[SWDataManager sharedManager] fetchCityFromStore];
    
    if (city) {
        
        [[SWDataManager sharedManager] fetchWeatherForCity:city delegate:self];

        
    } else {
        
        NSLog(@"NO CITY");
        // open settings
        [[SWDataManager sharedManager] fetchWeatherForCity:city delegate:self];

        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateUI {
    
    
    NSLog(@"%@ %@, %@ [%@,%@] %@", self.city.cityID, self.city.name, self.city.country, self.city.lat, self.city.lon, self.weather.temp);
}

#pragma mark - <SWDataManagerDelegate>

- (void)dataManager:(SWDataManager *)dataManger didFetchWeather:(SWWeather *)weather forCity:(SWCity *)city {
    
    NSLog(@"%@", [NSThread currentThread]);
    
    self.city = city;
    self.weather = weather;
    
    [self updateUI];
}

@end
