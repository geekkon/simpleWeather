//
//  SWSearchTableViewController.m
//  SimpleWeather
//
//  Created by Dim on 16.07.15.
//  Copyright (c) 2015 Dmitriy Baklanov. All rights reserved.
//

#import "SWSearchTableViewController.h"
#import "SWDataController.h"
#import "SWSearchController.h"
#import "SWJSONParsedObject.h"

@interface SWSearchTableViewController () <SWSearchControllerDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;

@property (strong, nonatomic) SWSearchController *searchController;

@property (strong, nonatomic) NSArray *cities;

@end

@implementation SWSearchTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.searchController = [[SWSearchController alloc] init];
    self.searchController.delegate = self;
    
    [self.searchBar becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Getters

- (UIActivityIndicatorView *)activityIndicator {
    
    if (!_activityIndicator) {
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _activityIndicator.color = [UIColor darkGrayColor];
        _activityIndicator.hidesWhenStopped = YES;
        _activityIndicator.frame = self.tableView.bounds;
        _activityIndicator.backgroundColor = [UIColor whiteColor];
        [self.tableView addSubview:_activityIndicator];
    }
    
    return _activityIndicator;
}

#pragma mark - <UISearchBarDelegate>

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if (!searchBar.text.length) {
        self.cities = nil;
        [self.tableView reloadData];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    if (searchBar.text.length < 3) {
        [self showAlertWithMessage:@"Please, type at least 3 letters"];
        return;
    }
    
    if (self.cities) {
        self.cities = nil;
        [self.tableView reloadData];
    }
    
    [self.activityIndicator startAnimating];
    [self.searchController findCitiesByNameWithString:searchBar.text];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SWJSONParsedObject *parsedObject = self.cities[indexPath.row];
    
    [[SWDataController defaultController] handleParsedObject:parsedObject];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.cities count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    SWJSONParsedObject *parsedObject = self.cities[indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@, %@", parsedObject.name, parsedObject.country];
    
    return cell;
}

#pragma mark - <WSearchControllerDelegate>

- (void)searchController:(SWSearchController *)searchController didFindCities:(NSArray *)cities {
    
    self.cities = cities;
    [self.tableView reloadData];
    [self.activityIndicator stopAnimating];
}

#pragma marl - Private

- (void)showAlertWithMessage:(NSString *)message {
    
    [[[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

#pragma mark - Actions

- (IBAction)findLocationAction:(UIBarButtonItem *)sender {
    
    if (self.cities) {
        self.cities = nil;
        [self.tableView reloadData];
    }
        
    [self.activityIndicator startAnimating];
    [self.searchController findCityByCurrentLocation];
}

@end
