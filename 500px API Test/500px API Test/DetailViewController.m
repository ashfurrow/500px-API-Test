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
#import "PhotoModel.h"
#import "PhotoTableViewCell.h"

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    backgroundQueue = dispatch_queue_create("com.500px.detailviewcontroller.backgroundqueue", NULL);
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
    
    PhotoTableViewCell *cell = (PhotoTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"PhotoTableViewCell" owner:nil options:nil];
        for (id obj in topLevelObjects)
        {
            if ([obj class] == [PhotoTableViewCell class])
            {
                cell = obj;
                break;
            }
        }
    }
    
    PhotoModel *photo = [self.photos objectAtIndex:indexPath.row];
    
    cell.nameLabel.text = photo.name;
    cell.createdDateLabel.text = photo.createdDate;
    cell.photographerNameLabel.text = @"Photographer name";
    cell.categoryRatingLabel.text = [NSString stringWithFormat:@"%d, Rating: %@", photo.category, photo.rating];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    dispatch_async(backgroundQueue, ^(void) {
        NSURL *url = [NSURL URLWithString:[(PhotoModel *)[self.photos objectAtIndex:indexPath.row] imageURL]];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *image = [UIImage imageWithData:data];
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [cell.imageView setImage:image];
        });
    });
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140.0f;
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
    dispatch_release(backgroundQueue);
    [_photos release], _photos = nil;
    [_photosTablView release], _photosTablView = nil;
    [_myPopoverController release], _myPopoverController = nil;;
    [_toolbar release], _toolbar = nil;
    [_detailDescriptionLabel release], _detailDescriptionLabel = nil;
    [super dealloc];
}

@end
