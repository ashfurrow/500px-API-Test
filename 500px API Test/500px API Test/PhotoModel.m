//
//  PhotoModel.m
//  500px API Test
//
//  Created by Ash Furrow on 11-08-21.
//  Copyright 2011 University of New Brunswick. All rights reserved.
//

#import "PhotoModel.h"

@implementation PhotoModel

@synthesize name, photographerName, identifier, rating, imageURL, createdDate, category;

-(id) initWithFetchedDictionary:(NSDictionary *)fetchedDictionary
{
    if (![self init]) return nil;
    
    self.photographerName = [fetchedDictionary valueForKeyPath:kPhotoModelPhotographerNameKeyPath];
    
    self.name = [fetchedDictionary valueForKey:kPhotoModelNameKey];
    self.identifier = [[fetchedDictionary valueForKey:kPhotoModelIdentiferKey] intValue];
    self.rating = [fetchedDictionary valueForKey:kPhotoModelRatingKey];
    self.imageURL = [fetchedDictionary valueForKey:kPhotoModelImageURLKey];
    self.createdDate = [fetchedDictionary valueForKey:kPhotoModelCreatedDateKey];
    self.category = [[fetchedDictionary valueForKey:kPhotoModelCategoryKey] intValue];
    
    return self;
}

/*
 From http://developers.500px.com/docs/formats#categories
 */
-(NSString *)categoryName
{
    switch (self.category) {
        case 10:
            return @"Abstract";
        case 11: return @"Animals";
        case 5: return @"Black and White";
        case 1: return @"Celebrities";
        case 9: return @"City and Architecture";
        case 15: return @"Commerical";
        case 16: return @"Concert";
        case 20: return @"Family";
        case 14: return @"Fashion";
        case 2: return @"Film";
        case 24: return @"Fine Arts";
        case 23: return @"Food";
        case 3: return @"Journalism";
        case 8: return @"Landscapes";
        case 12: return @"Macro";
        case 18: return @"Nature";
        case 4: return @"Nude";
        case 7: return @"People";
        case 19: return @"Performing Arts";
        case 17: return @"Sport";
        case 6: return @"Still Life";
        case 21: return @"Street";
        case 13: return @"Travel";
        case 22: return @"Underwater";
        default:
            return @"Uncategorized";
    }
}

-(void)dealloc
{
    self.photographerName = nil;
    self.name = nil;
    self.identifier = -1;
    self.rating = nil;
    self.imageURL = nil;
    self.createdDate = nil;
    self.category = -1;
    
    [super dealloc];
}

@end
