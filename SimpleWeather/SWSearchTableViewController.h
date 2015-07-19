//
//  SWSearchTableViewController.h
//  SimpleWeather
//
//  Created by Dim on 16.07.15.
//  Copyright (c) 2015 Dmitriy Baklanov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SWJSONParsedObject;

typedef void (^SelectionBlock)(SWJSONParsedObject *parsedObject);

@interface SWSearchTableViewController : UITableViewController

@property (copy, nonatomic) SelectionBlock selectionBlock;

@end
