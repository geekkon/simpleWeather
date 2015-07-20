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

CGFloat const animationDuration = 0.65;

@interface SWViewController () <SWDataControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *tempLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@property (strong, nonatomic) NSDateFormatter *dateFormatter;

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
        [self updateUI:NO];
    } else {
        self.shouldShowSearchOnStart = YES;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.shouldShowSearchOnStart) {
        [self performSegueWithIdentifier:@"showSearch" sender:nil];
        self.shouldShowSearchOnStart = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Getters

- (NSDateFormatter *)dateFormatter {
    
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.timeStyle = NSDateFormatterShortStyle;
    }
    
    return _dateFormatter;
}

#pragma mark - Private

- (void)updateUI:(BOOL)animated {
    
    self.cityLabel.text = self.city.name;
    
    SWWeather *weather = self.city.weather;
    
    self.tempLabel.text = [NSString stringWithFormat:@"%.0f℃", [weather.temp floatValue]];
    self.iconImageView.image = [UIImage imageNamed:weather.icon];
    self.infoLabel.text = weather.info;
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[weather.updateTime integerValue]];
    
    self.navigationItem.title = [NSString stringWithFormat:@"last update at %@", [self.dateFormatter stringFromDate:date]];
    
    if (animated) {
        __weak SWViewController *weakSealf = self;
        [UIView animateWithDuration:animationDuration animations:^{
            weakSealf.view.alpha = 1.0;
        }];
    }

//    NSLog(@"%@ %@, %@ [%@,%@] %@", self.city.cityID, self.city.name, self.city.country, self.city.lat, self.city.lon, self.weather.temp);
}

#pragma mark - <SWDataManagerDelegate>

- (void)dataController:(SWDataController *)dataController didFetchWeatherForCity:(SWCity *)city {
    
    self.city = city;
    
    __weak SWViewController *weakSealf = self;
    [UIView animateWithDuration:animationDuration animations:^{
        weakSealf.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        [weakSealf updateUI:YES];
    }];
}

@end
