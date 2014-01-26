//
//  DPNetworkHandler.m
//  dropBeats
//
//  Created by Spencer Lewson on 12/26/13.
//  Copyright (c) 2013 Michael Dewitt. All rights reserved.
//

#import "DPNetworkHandler.h"

/*
@interface DPNetworkHandler()
@property (nonatomic) NSMutableData *data;
@property (nonatomic) NSString* domain;
@end
 */

@implementation DPNetworkHandler

- (void) request: (NSString *) Url
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSURLRequest *theRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:Url]
                                                cachePolicy:NSURLRequestUseProtocolCachePolicy
                                            timeoutInterval:60.0];
    
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    [theConnection start];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.data = [[NSMutableData alloc] init];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self.data appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    self.data = nil;
    [self requestUnsuccessful: [NSError errorWithDomain:self.domain code:NO_CONNECTION_ERROR userInfo:nil]];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self requestSuccessful:self.data];
}

- (void) connection: (NSURLConnection*) connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self requestUnsuccessful: [NSError errorWithDomain:self.domain code:INVALID_CREDENTIALS_ERROR userInfo:nil]];
}

- (BOOL)connectionShouldUseCredentialStorage:(NSURLConnection *)connection
{
    return NO;
}

- (void) requestSuccessful: (NSMutableData*) data
{
    [self.delegate requestSuccessful:data];
    [self onFinish];
}

- (void) requestUnsuccessful: (NSError*) error
{
    [self onFinish];
    [self.delegate requestUnsuccessful:error];
}

- (void) onFinish
{
    self.domain = nil;
    
    if (!self.delegate)
    {
        NSLog(@"DPNetworkHandler: Delegate not set!");
    }
}

@end
