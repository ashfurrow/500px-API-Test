//
//  PhotoModel.m
//  500px API Test
//
//  Created by Ash Furrow on 11-08-21.
//  Copyright 2011 University of New Brunswick. All rights reserved.
//

#import "PhotoModel.h"

@implementation PhotoModel

@synthesize name, identifier, rating, imageURL, createdDate, category;

-(id) initWithFetchedDictionary:(NSDictionary *)fetchedDictionary
{
    if (![self init]) return nil;
    
    self.name = [fetchedDictionary valueForKey:kPhotoModelNameKey];
    self.identifier = [[fetchedDictionary valueForKey:kPhotoModelIdentiferKey] intValue];
    self.rating = [fetchedDictionary valueForKey:kPhotoModelRatingKey];
    self.imageURL = [fetchedDictionary valueForKey:kPhotoModelImageURLKey];
    self.createdDate = [fetchedDictionary valueForKey:kPhotoModelCreatedDateKey];
    self.category = [[fetchedDictionary valueForKey:kPhotoModelCategoryKey] intValue];
    
    return self;
}

-(void)dealloc
{
    self.name = nil;
    self.identifier = -1;
    self.rating = nil;
    self.imageURL = nil;
    self.createdDate = nil;
    self.category = -1;
    
    [super dealloc];
}

@end
