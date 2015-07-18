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
    
    UIBarButtonItem *locationBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:nil action:nil];
    self.navigationItem.leftBarButtonItem = locationBarButtonItem;
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
    
    [self requestCityWithString:searchBar.text];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source


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


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
