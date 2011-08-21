//
//  APIHelper.h
//  500px API Test
//
//  Created by Ash Furrow on 11-08-21.
//  Copyright 2011 Ash Furrow. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^CallbackBlock)(NSArray *fetchedArray);
typedef void (^ErrorBlock)(NSError *error);

@interface APIHelper : NSObject

+ (void) fetchPopularPhotosWithCallback:(CallbackBlock)callbackBlock andErrorBlock:(ErrorBlock)errorBlock;
+ (void) fetchUpcomingPhotosWithCallback:(CallbackBlock)callbackBlock andErrorBlock:(ErrorBlock)errorBlock;
+ (void) fetchEditorsChoicePhotosWithCallback:(CallbackBlock)callbackBlock andErrorBlock:(ErrorBlock)errorBlock;
+ (void) fetchFreshTodayPhotosWithCallback:(CallbackBlock)callbackBlock andErrorBlock:(ErrorBlock)errorBlock;
+ (void) fetchFreshYesterdayPhotosWithCallback:(CallbackBlock)callbackBlock andErrorBlock:(ErrorBlock)errorBlock;
+ (void) fetchFreshThisWeekPhotosWithCallback:(CallbackBlock)callbackBlock andErrorBlock:(ErrorBlock)errorBlock;

@end
