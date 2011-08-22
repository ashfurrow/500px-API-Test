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
#import "PhotoModel.h"

#define kAPIURLStub @"https://api.500px.com/v1/"

@interface APIHelper (Private)

+(NSString *) signURL:(NSString *)unsignedURL;
+(dispatch_queue_t) backgroundQueue;

+(void)fetchPhotosInBackgroundWithFeature:(NSString *)feature andCallbackBlock:(CallbackBlock)callbackBlock andErrorBlock:(ErrorBlock)errorBlock;

@end

@implementation APIHelper

#pragma mark - Private Methods
+(dispatch_queue_t) backgroundQueue
{
    static dispatch_queue_t queue = NULL;
    if (queue == NULL)
        queue = dispatch_queue_create("com.500px.APIHelper.backgroundqueue", NULL);
    return queue;
}

+(NSString *)signURL:(NSString *)unsignedURL
{
    if ([unsignedURL rangeOfString:@"?"].location == NSNotFound)
        return [NSString stringWithFormat:@"%@?consumer_key=%@", unsignedURL, kAPIConsumerKey];
    return [NSString stringWithFormat:@"%@&consumer_key=%@", unsignedURL, kAPIConsumerKey];
}

+(void)fetchPhotosInBackgroundWithFeature:(NSString *)feature andCallbackBlock:(CallbackBlock)callbackBlock andErrorBlock:(ErrorBlock)errorBlock
{
    dispatch_async([APIHelper backgroundQueue], ^{
        NSURL *url = [NSURL URLWithString:[APIHelper signURL:[NSString stringWithFormat:@"%@photos?feature=%@", kAPIURLStub, feature]]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"GET"];
        
        NSHTTPURLResponse *response;
        NSError *error = nil;
        NSLog(@"Fetching from API");
        NSData *fetchedData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        if (error)
        {
            NSLog(@"Something went wrong fetching from API: %@", error);
            if (errorBlock != NULL)
            {
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    errorBlock(error);
                });
            }
        }
        if ([response statusCode] != 200)
        {
            NSLog(@"Fetching from API returned non-200 response code: %d", [response statusCode]);
        }
        
        NSLog(@"Parsing API response ...");
        
        NSString *fetchedDataString = [[[NSString alloc] initWithData:fetchedData encoding:NSUTF8StringEncoding] autorelease];
        NSArray *fetchedArray = [[fetchedDataString JSONValue] valueForKey:@"photos"];
        NSMutableArray *parsedArray = [NSMutableArray arrayWithCapacity:[fetchedArray count]];
        
        [fetchedArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [parsedArray insertObject:[[[PhotoModel alloc] initWithFetchedDictionary:obj] autorelease] atIndex:idx];
        }];
        
        NSLog(@"Parsing complete. Dispatching callback.");
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            callbackBlock([NSArray arrayWithArray:parsedArray]);
        });
        
    });
}

#pragma mark - Public Methods

+ (void) fetchPopularPhotosWithCallback:(CallbackBlock)callbackBlock andErrorBlock:(ErrorBlock)errorBlock
{
    [APIHelper fetchPhotosInBackgroundWithFeature:@"popular" andCallbackBlock:callbackBlock andErrorBlock:errorBlock];
}

+ (void) fetchUpcomingPhotosWithCallback:(CallbackBlock)callbackBlock andErrorBlock:(ErrorBlock)errorBlock
{
    [APIHelper fetchPhotosInBackgroundWithFeature:@"upcoming" andCallbackBlock:callbackBlock andErrorBlock:errorBlock];
}

+ (void) fetchEditorsChoicePhotosWithCallback:(CallbackBlock)callbackBlock andErrorBlock:(ErrorBlock)errorBlock
{
    [APIHelper fetchPhotosInBackgroundWithFeature:@"editors" andCallbackBlock:callbackBlock andErrorBlock:errorBlock];
}

+ (void) fetchFreshTodayPhotosWithCallback:(CallbackBlock)callbackBlock andErrorBlock:(ErrorBlock)errorBlock
{
    [APIHelper fetchPhotosInBackgroundWithFeature:@"fresh_today" andCallbackBlock:callbackBlock andErrorBlock:errorBlock];
}

+ (void) fetchFreshYesterdayPhotosWithCallback:(CallbackBlock)callbackBlock andErrorBlock:(ErrorBlock)errorBlock
{
    [APIHelper fetchPhotosInBackgroundWithFeature:@"fresh_yesterday" andCallbackBlock:callbackBlock andErrorBlock:errorBlock];
}

+ (void) fetchFreshThisWeekPhotosWithCallback:(CallbackBlock)callbackBlock andErrorBlock:(ErrorBlock)errorBlock
{
    [APIHelper fetchPhotosInBackgroundWithFeature:@"fresh_week" andCallbackBlock:callbackBlock andErrorBlock:errorBlock];
}

@end
