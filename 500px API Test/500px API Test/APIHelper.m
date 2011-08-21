//
//  APIHelper.m
//  500px API Test
//
//  Created by Ash Furrow on 11-08-21.
//  Copyright 2011 Ash Furrow. All rights reserved.
//

#import "APIHelper.h"
#import "APIConstants.h"
#import "NSObject+SBJson.h"

#define kAPIURLStub @"https://api.500px.com/v1/"

@interface APIHelper (Private)

+(NSString *) signURL:(NSString *)unsignedURL;
+(dispatch_queue_t) backgroundQueue;

@end

@implementation APIHelper

#pragma mark - Private Methods

+(dispatch_queue_t) backgroundQueue
{
    static dispatch_queue_t queue = NULL;
    if (queue == NULL)
        queue = dispatch_queue_create("com.500px.backgroundqueue", NULL);
    return queue;
}

+(NSString *)signURL:(NSString *)unsignedURL
{
    if ([unsignedURL rangeOfString:@"?"].location == NSNotFound)
        return [NSString stringWithFormat:@"%@?consumer_key=%@", unsignedURL, kAPIConsumerKey];
    return [NSString stringWithFormat:@"%@&consumer_key=%@", unsignedURL, kAPIConsumerKey];
}

#pragma mark - Public Methods

+ (void) fetchPopularPhotosWithCallback:(CallbackBlock)callbackBlock andErrorBlock:(ErrorBlock)errorblock
{
    dispatch_async([APIHelper backgroundQueue], ^{
        NSURL *url = [NSURL URLWithString:[APIHelper signURL:[NSString stringWithFormat:@"%@photos?feature=editors", kAPIURLStub]]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"GET"];
        
        NSHTTPURLResponse *response;
        NSError *error = nil;
        NSData *fetchedData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        if (error)
        {
            NSLog(@"Something went wrong fetching from API: %@", error);
            if (errorblock != NULL)
            {
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    errorblock(error);
                });
            }
        }
        if ([response statusCode] != 200)
        {
            NSLog(@"Fetching from API returned non-200 response code: %d", [response statusCode]);
        }
        
        NSString *fetchedDataString = [[[NSString alloc] initWithData:fetchedData encoding:NSUTF8StringEncoding] autorelease];
        NSArray *fetchedArray = [[fetchedDataString JSONValue] valueForKey:@"photos"];
        
        NSLog(@"Received the following response:%@", fetchedArray);
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            callbackBlock(fetchedArray);
        });

    });
}

@end
