//
//  RootViewController.h
//  500px API Test
//
//  Created by Ash Furrow on 11-08-21.
//  Copyright 2011 Ash Furrow. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

enum
{
    kPopularRow = 0,
    kUpcomingRow,
    kEditorsRow,
    kFreshTodayRow,
    kFreshYesterdayRow,
    kFreshThisWeekRow,
    kNumRootRows
};

@interface RootViewController : UITableViewController
{
    NSArray *photos;
}

@property (nonatomic, retain) IBOutlet DetailViewController *detailViewController;

@end
