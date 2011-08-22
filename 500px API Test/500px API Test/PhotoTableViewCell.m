//
//  PhotoTableViewCell.m
//  500px API Test
//
//  Created by Ash Furrow on 11-08-21.
//  Copyright 2011 University of New Brunswick. All rights reserved.
//

#import "PhotoTableViewCell.h"

@implementation PhotoTableViewCell

@synthesize photoImageView, nameLabel, categoryRatingLabel, createdDateLabel, photographerNameLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)dealloc
{
    self.photoImageView = nil;
    self.nameLabel = nil;
    self.categoryRatingLabel = nil;
    self.createdDateLabel = nil;
    self.photographerNameLabel = nil;

    [super dealloc];
}

@end
