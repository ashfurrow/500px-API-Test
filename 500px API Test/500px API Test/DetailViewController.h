//
//  DetailViewController.h
//  500px API Test
//
//  Created by Ash Furrow on 11-08-21.
//  Copyright 2011 Ash Furrow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController <UIPopoverControllerDelegate, UISplitViewControllerDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain) IBOutlet UITableView *photosTablView;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *detailDescriptionLabel;
@property (nonatomic, retain) NSArray *photos;

- (void)configureViewForSelectedRootRow:(int)selectedRow;

@end
