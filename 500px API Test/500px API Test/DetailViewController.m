//
//  DetailViewController.m
//  500px API Test
//
//  Created by Ash Furrow on 11-08-21.
//  Copyright 2011 Ash Furrow. All rights reserved.
//

#import "DetailViewController.h"

#import "RootViewController.h"
#import "APIHelper.h"

@interface DetailViewController ()
@property (nonatomic, retain) UIPopoverController *popoverController;

@end

@implementation DetailViewController

@synthesize toolbar = _toolbar;
@synthesize detailDescriptionLabel = _detailDescriptionLabel;
@synthesize photosTablView = _photosTablView;
@synthesize popoverController = _myPopoverController;
@synthesize photos = _photos;

#pragma mark - Managing the detail item

- (void)configureViewForSelectedRootRow:(int)selectedRow
{
    [SVProgressHUD showInView:self.view];
    
    __block DetailViewController *blockSelf = self;    //to avoid reference loops
    
    CallbackBlock callbackBlock = ^(NSArray *fetchedArray) {
        [SVProgressHUD dismiss];
        blockSelf.photos = fetchedArray;
        [blockSelf.photosTablView reloadData];
    };
    ErrorBlock errorBlock = ^(NSError *error) {
        NSLog(@"Something horrible happened! %@", error);
    };
    
    // Update the user interface for the detail item.
    
    switch (selectedRow) {
        case kPopularRow:
            [APIHelper fetchPopularPhotosWithCallback:callbackBlock andErrorBlock:errorBlock];
            break;
        case kUpcomingRow:
            [APIHelper fetchUpcomingPhotosWithCallback:callbackBlock andErrorBlock:errorBlock];
            break;
        case kEditorsRow:
            [APIHelper fetchEditorsChoicePhotosWithCallback:callbackBlock andErrorBlock:errorBlock];
            break;
        case kFreshTodayRow:
            [APIHelper fetchFreshTodayPhotosWithCallback:callbackBlock andErrorBlock:errorBlock];
            break;
        case kFreshYesterdayRow:
            [APIHelper fetchFreshYesterdayPhotosWithCallback:callbackBlock andErrorBlock:errorBlock];
            break;
        case kFreshThisWeekRow:
            [APIHelper fetchFreshThisWeekPhotosWithCallback:callbackBlock andErrorBlock:errorBlock];
            break;
        default:
            break;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

#pragma mark - Split view support

- (void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController: (UIPopoverController *)pc
{
    barButtonItem.title = @"Photos";
    NSMutableArray *items = [[self.toolbar items] mutableCopy];
    [items insertObject:barButtonItem atIndex:0];
    [self.toolbar setItems:items animated:YES];
    [items release];
    self.popoverController = pc;
}

// Called when the view is shown again in the split view, invalidating the button and popover controller.
- (void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    NSMutableArray *items = [[self.toolbar items] mutableCopy];
    [items removeObjectAtIndex:0];
    [self.toolbar setItems:items animated:YES];
    [items release];
    self.popoverController = nil;
}

/*
 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
 */

- (void)viewDidUnload
{
	[super viewDidUnload];

	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	self.popoverController = nil;
}

#pragma mark  - UITableView Delegate/Datasource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.photos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PhotoCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.textLabel.text = [[self.photos objectAtIndex:indexPath.row] valueForKey:@"name"];
    
    return cell;
}

#pragma mark - Memory management

- (void)didReceiveMemoryWarning
{
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)dealloc
{
    [_photos release], _photos = nil;
    [_photosTablView release], _photosTablView = nil;
    [_myPopoverController release], _myPopoverController = nil;;
    [_toolbar release], _toolbar = nil;
    [_detailDescriptionLabel release], _detailDescriptionLabel = nil;
    [super dealloc];
}

@end
