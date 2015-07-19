//
//  SWViewController.m
//  SimpleWeather
//
//  Created by Dim on 14.07.15.
//  Copyright (c) 2015 Dmitriy Baklanov. All rights reserved.
//

#import "SWViewController.h"
#import "SWDataController.h"
#import "SWCity.h"
#import "SWWeather.h"

@interface SWViewController () <SWDataControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *tempLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UILabel *updateLabel;

@property (strong, nonatomic) SWCity *city;

@property (nonatomic) BOOL shouldShowSearchOnStart;

@end

@implementation SWViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[SWDataController defaultController] setDelegate:self];
    
    NSArray *cities = [[SWDataController defaultController] getCities];
    NSLog(@"CITIES %@", cities);
 
    SWCity *city = [[SWDataController defaultController] getCurrentCity];
    
    if (city) {
        self.city = city;
        [self updateUI];
    } else {
        self.shouldShowSearchOnStart = YES;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.shouldShowSearchOnStart) {
        self.shouldShowSearchOnStart = NO;
        [self performSegueWithIdentifier:@"showSearch" sender:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

- (void)updateUI {
    
    self.cityLabel.text = self.city.name;
    
    SWWeather *weather = self.city.weather;
    
    NSLog(@"%@", weather.temp);
    
    self.tempLabel.text = [NSString stringWithFormat:@"%.1f℃", roundf([weather.temp floatValue])];
    self.iconImageView.image = [UIImage imageNamed:weather.icon];
    self.infoLabel.text = weather.info;
    self.updateLabel.text = [NSString stringWithFormat:@"%@", weather.updateTime];
    
    //    [UIView animateWithDuration:3.0
//                          delay:0.0
//                        options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse
//                     animations:^{
//                         self.iconImageView.transform = CGAffineTransformMakeScale(0.9, 0.9);
//                     } completion:nil];
//    
//    NSLog(@"%@ %@, %@ [%@,%@] %@", self.city.cityID, self.city.name, self.city.country, self.city.lat, self.city.lon, self.weather.temp);
}

#pragma mark - <SWDataManagerDelegate>

- (void)dataController:(SWDataController *)dataController didFetchWeatherForCity:(SWCity *)city {
    
    self.city = city;
    
    [self updateUI];
}

@end
