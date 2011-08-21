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

+ (void) fetchPopularPhotosWithCallback:(CallbackBlock)callbackBlock andErrorBlock:(ErrorBlock)errorblock;

@end
