//
//  DPNetworkHandler.h
//  dropBeats
//
//  Created by Spencer Lewson on 12/26/13.
//  Copyright (c) 2013 Michael Dewitt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DPErrorCodes.h"

@protocol DPNetworkHandlerDelegate;

@interface DPNetworkHandler : NSObject
@property (nonatomic) NSMutableData *data;
@property (nonatomic) NSString* domain;
@property (nonatomic) id<DPNetworkHandlerDelegate> delegate;
- (void) request: (NSString*) url;
@end


@protocol DPNetworkHandlerDelegate <NSObject>
- (void) requestSuccessful: (NSMutableData*) data;
- (void) requestUnsuccessful:(NSError*) error;
@end
