//
//  DPNote.h
//  BackDrop
//
//  Created by Spencer Lewson on 10/19/13.
//  Copyright (c) 2013 slewson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DPNote : NSObject

typedef enum {
    kSnare,
    kCymbol,
    kBass,
    kGuitar,
    kStrike
} NoteType;

@property (nonatomic) NSInteger time;
@property (nonatomic) NSInteger freq;
@property (nonatomic) NoteType type;

+ (instancetype) DPNoteWithTime: (NSInteger) time freq: (NSInteger) freq type: (NoteType) type;
- (id) initWithTime: (NSInteger) time freq: (NSInteger) freq type: (NoteType) type;


@end
