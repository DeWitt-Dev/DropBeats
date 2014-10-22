//
//  DPUpdater.m
//  dropBeats
//
//  Created by Spencer Lewson on 12/26/13.
//  Copyright (c) 2013 Michael Dewitt. All rights reserved.
//

#import "DPUpdater.h"
#import "DPUrlConstants.h"
#import "DPMusicFolder.h"

NSString * const kSongsUpdateNotification = @"songUpdate";

@implementation DPUpdater

+(DPUpdater *)sharedClient
{
    static DPUpdater *_sharedClient = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{

        _sharedClient = [[DPUpdater alloc] init];
    });
    
    return _sharedClient;
}

- (BOOL) updateSongs {
   [self startRequest: URL_UPDATE_SONGS
           onSuccess:^(NSMutableData* data) {
               NSError* error;
               
               [DPMusicFolder addSongJsonData:[NSJSONSerialization JSONObjectWithData:data options:kNilOptions
                                    error:&error]];
               
               [[NSNotificationCenter defaultCenter] postNotificationName: kSongsUpdateNotification object:nil];
               [DPMusicFolder saveSongs];
           }
           onFailure:^(NSError* error){
               NSLog(@"Failure");
           }
    ];
    
    return NO;
}

- (void) startRequest: (NSString*) url onSuccess: (SucessBlock) success onFailure: (FailureBlock) failure
{
    self.successBlock = success;
    self.failureBlock = failure;
    
    if (!self.networkHandler)
    {
        self.networkHandler = [[DPNetworkHandler alloc] init];
        self.networkHandler.delegate = self;
    }
    
    [self.networkHandler request:url];
}

- (void) endRequest
{
    self.successBlock = nil;
    self.failureBlock = nil;
}

- (void) requestSuccessful: (NSMutableData*) data
{
    if (self.successBlock)
    {
        self.successBlock(data);
    }
    [self endRequest];
}

- (void) requestUnsuccessful: (NSError*) error
{
    if (self.failureBlock)
    {
        self.failureBlock(error);
    }
    [self endRequest];
}

@end
