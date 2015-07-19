//
//  SWSearchTableViewController.m
//  SimpleWeather
//
//  Created by Dim on 16.07.15.
//  Copyright (c) 2015 Dmitriy Baklanov. All rights reserved.
//

#import "SWSearchTableViewController.h"
#import "SWDataManager.h"
#import "SWJSONParsedObject.h"

@interface SWSearchTableViewController () <SWDataManagerDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (strong, nonatomic) NSArray *cities;

@end

@implementation SWSearchTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//     self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self.searchBar becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestCityWithString:(NSString *)string {
    
    [[SWDataManager sharedManager] findCitiesByNameWithString:string delegate:self];
    
//    
//    NSString *stringURL = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/find?q=%@&type=like&units=metric", string];
//    
//    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:stringURL]
//                                 completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//                                     
//                                     if (!error) {
//                                         
//                                         NSError *parsingError = nil;
//                                         
//                                         NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data
//                                                                                                    options:0
//                                                                                                      error:&parsingError];
//                                         
//                                         if (parsingError) {
//                                             NSLog(@"Parsing error %@", [error localizedDescription]);
//                                         }
//                                         
//                                         self.cities = [NSMutableArray array];
//                                         
//                                         if ([NSJSONSerialization isValidJSONObject:dictionary]) {
//                                             
//                                             if (dictionary[@"list"]) {
//                                                 
//                                                 NSArray *list = dictionary[@"list"];
//                                                 
//                                                 for (NSDictionary *dt in list) {
//                                                     
//                                                     [self.cities addObject:dt[@"name"]];
//                                                     
//                                                 }
//                                                 
//                                             }
//                                             
//                                             NSLog(@"JSON %@", dictionary);
//                                             
//                                         }
//                                         
//                                         dispatch_async(dispatch_get_main_queue(), ^{
//                                             [self.tableView reloadData];
//                                             
//                                         });
//                                         
//                                         
//                                     } else {
//                                         NSLog(@"Request error %@", [error localizedDescription]);
//                                     }
//                                     
//                                 }] resume];
    
}


#pragma mark - <UISearchBarDelegate>

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    if (searchBar.text.length < 3) {
        [self showAlertWithMessage:@"Please, type at least 3 letters"];
        return;
    }
//    [searchBar resignFirstResponder];
    [self requestCityWithString:searchBar.text];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SWJSONParsedObject *parsedObject = self.cities[indexPath.row];
    
    __weak SWSearchTableViewController *weakSelf = self;
    
    if (self.selectionBlock) {
        weakSelf.selectionBlock(parsedObject);
    }
        
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





#pragma mark - <SWDataManagerDelegate>

- (void)dataManager:(SWDataManager *)dataManger didFindCities:(NSArray *)cities {
    
    self.cities = cities;
    [self.tableView reloadData];
}

#pragma marl - Private

- (void)showAlertWithMessage:(NSString *)message {
    NSLog(@"%@", message);
}

@end
