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

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (strong, nonatomic) SWCity *city;
@property (strong, nonatomic) SWWeather *weather;

@property (strong, nonatomic) UISearchController *searchController;

@end

@implementation SWViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    NSArray *cities = [[SWDataManager sharedManager] fetchCiries];
    NSLog(@"CITIES %@", cities);
 
    SWCity *city = [[SWDataManager sharedManager] fetchCityFromStore];
    
    if (city) {
//        [[SWDataManager sharedManager] fetchWeatherForCity:city delegate:self];
        [[SWDataManager sharedManager] fetchWeatherForCityID:city.cityID delegate:self];
    } else {
        // open city picker
        

        
//        [self openCityPicker];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateUI {
    
    self.iconImageView.image = [UIImage imageNamed:self.weather.icon];
    
    [UIView animateWithDuration:3.0
                          delay:0.0
                        options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse
                     animations:^{
                         self.iconImageView.transform = CGAffineTransformMakeScale(0.9, 0.9);
                     } completion:nil];
    
    NSLog(@"%@ %@, %@ [%@,%@] %@", self.city.cityID, self.city.name, self.city.country, self.city.lat, self.city.lon, self.weather.temp);
}

- (void)openCityPicker {
    
    NSNumber *cityID = @2172797;
//    NSNumber *cityID = @91597;

    
    [[SWDataManager sharedManager] fetchWeatherForCityID:cityID delegate:self];
}


#pragma mark - <SWDataManagerDelegate>

- (void)dataManager:(SWDataManager *)dataManger didFetchWeather:(SWWeather *)weather forCity:(SWCity *)city {
    
    self.city = city;
    self.weather = weather;
    
    [self updateUI];
}

#pragma mark - Sugue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([[segue identifier] isEqualToString:@"showSearch"]) {

    }
}

@end
