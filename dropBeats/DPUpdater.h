//
//  DPUpdater.h
//  dropBeats
//
//  Created by Spencer Lewson on 12/26/13.
//  Copyright (c) 2013 Michael Dewitt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DPNetworkHandler.h"

typedef void (^ SucessBlock)(NSMutableData*);
typedef void (^ FailureBlock)(NSError*);

static NSString const* songsUpdateNotification = @"songUpdate";

@interface DPUpdater : NSObject <DPNetworkHandlerDelegate>
@property (nonatomic, copy) SucessBlock successBlock;
@property (nonatomic, copy) FailureBlock failureBlock;
@property (nonatomic, strong) DPNetworkHandler* networkHandler;

+(DPUpdater *)sharedClient;

- (BOOL) updateSongs;
- (void) startRequest: (NSString*) url onSuccess: (SucessBlock) success onFailure: (FailureBlock) failure;
- (void) endRequest;
- (void) requestSuccessful: (NSMutableData*) data;
- (void) requestUnsuccessful:(NSError*) error;

@end
