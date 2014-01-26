//
//  DPMeasure.h
//  dropBeats
//
//  Created by Spencer Lewson on 12/28/13.
//  Copyright (c) 2013 Michael Dewitt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DPNote.h"

@interface DPMeasure : NSObject <NSCoding>

@property NSMutableArray* notes;

- (id) initWithJsonData: (NSMutableDictionary*) measure;
- (id) initWithNotes: (NSMutableArray*) notes;

- (NSMutableArray*) getNotes;
- (NSInteger) getTotalLength;

- (void) printMeasure;

- (void) encodeWithCoder: (NSCoder *) encoder;
- (id) initWithCoder: (NSCoder *) decoder;

@end
