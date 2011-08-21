//
//  APIHelper.m
//  500px API Test
//
//  Created by Ash Furrow on 11-08-21.
//  Copyright 2011 Ash Furrow. All rights reserved.
//

#import "APIHelper.h"

#define kAPIURLStub @"https://api.500px.com/v1/"

@interface APIHelper (Private)

+(NSString *)signURL:(NSString *)unsignedURL;

@end

@implementation APIHelper

#pragma mark - Private Methods

+(NSString *)signURL:(NSString *)unsignedURL
{
    if ([unsignedURL rangeOfString:@"?"].location == NSNotFound)
        return [NSString stringWithFormat:@"%@?consumer_key=%@", unsignedURL, kAPIConsumerKey];
    return [NSString stringWithFormat:@"%@&consumer_key=%@", unsignedURL, kAPIConsumerKey];
}

#pragma mark - Public Methods

+ (NSArray *) fetchSomeData
{
    NSURL *url = [NSURL URLWithString:[APIHelper signURL:[NSString stringWithFormat:@"%@photos?feature=editors", kAPIURLStub]]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    
    NSHTTPURLResponse *response;
    NSError *error = nil;
    NSData *fetchedData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if (error)
    {
        NSLog(@"Something went wrong fetching from API: %@", error);
        return nil;
    }
    if ([response statusCode] != 200)
    {
        NSLog(@"Fetching from API returned non-200 response code: %d", [response statusCode]);
    }
    
    NSLog(@"Received the following response: \n%@Data:\n%@", response, fetchedData);
    
    return nil;
}

@end
