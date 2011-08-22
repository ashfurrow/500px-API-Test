//
//  PhotoModel.h
//  500px API Test
//
//  Created by Ash Furrow on 11-08-21.
//  Copyright 2011 University of New Brunswick. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kPhotoModelNameKey          @"name"
#define kPhotoModelCreatedDateKey   @"created_at"
#define kPhotoModelImageURLKey      @"image_url"
#define kPhotoModelRatingKey        @"rating"
#define kPhotoModelIdentiferKey     @"id"
#define kPhotoModelCategoryKey      @"category"
#define kPhotoModelPhotographerNameKeyPath  @"user.fullname"

@interface PhotoModel : NSObject

-(id) initWithFetchedDictionary:(NSDictionary *)fetchedDictionary;
-(NSString *)categoryName;

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *photographerName;
@property (nonatomic, retain) NSString *createdDate;
@property (nonatomic, retain) NSString *imageURL;
@property (nonatomic, retain) NSString *rating;

@property (nonatomic, assign) int identifier;
@property (nonatomic, assign) int category;

@end
