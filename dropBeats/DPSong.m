//
//  DPSong.m
//  BackDrop
//
//  Created by Spencer Lewson on 10/19/13.
//  Copyright (c) 2013 slewson. All rights reserved.
//

#import "DPSong.h"
#import "DPNote.h"

@interface DPSong()

@property (nonatomic, strong) NSMutableArray* notes;

@end

@implementation DPSong

//+ (instancetype) songFromNotes: (NSMutableArray*) notesArray
//{
//    [self song];
//    self.notes = notesArray;
//    
//    return [self alloc];
//}

+ (instancetype) song
{
    return [[self alloc] init];
}

- (id) init
{
    self.notes = [[NSMutableArray alloc] init];
    
    return self;
}

- (void) addNote: (DPNote*) note
{
    [self.notes addObject:note];
}

- (DPNote*) getNote: (NSInteger) index
{
    return [self.notes objectAtIndex:index];
}

- (NSArray*) getNotes
{
    return self.notes;
}

-(void)clearNotes
{
    self.notes = nil;
}

-(NSMutableArray*)notes
{
    if (!_notes) {
        _notes = [[NSMutableArray alloc]initWithCapacity:10];
    }
    return _notes;
}


#pragma mark - class Methods
+ (DPSong*) getSong: (int) index andDuration: (float) duration
{
    DPSong *song = [[DPSong alloc]init];
    song.duration = duration;
    
    switch (index) {
        case 1:
            song.notes = [DPSong getSong1];
            break;
        case 2:
            song.notes = [DPSong getSong2];
            break;
        case 3:
            song.notes = [DPSong getSong3];
            break;
        default:
            break;
    }
    
    return song;
}

+ (NSMutableArray*) getSong1
{
    NSMutableArray* array = [[NSMutableArray alloc] initWithCapacity:5];
    
    [array addObject: [DPNote DPNoteAtTime:0.2 freq:kMidFrequency type:kSnare]];
    [array addObject: [DPNote DPNoteAtTime:0.4 freq:kLowFrequency type:kSnare]];
    [array addObject: [DPNote DPNoteAtTime:0.5 freq:kMidFrequency type:kCymbol]];
    [array addObject: [DPNote DPNoteAtTime:0.6 freq:kLowFrequency type:kBass]];
    [array addObject: [DPNote DPNoteAtTime:0.7 freq:kLowFrequency type:kCymbol]];
    
    return array;
}

+ (NSMutableArray*) getSong2
{
    NSMutableArray* array = [[NSMutableArray alloc] initWithCapacity:3];
    
    [array addObject: [DPNote DPNoteAtTime:0.1 freq:kLowFrequency type:kBass]];
    [array addObject: [DPNote DPNoteAtTime:0.3 freq:kLowFrequency type:kCymbol]];
    [array addObject: [DPNote DPNoteAtTime:0.5 freq:kMidFrequency type:kSnare]];
   
    return array;
}

+ (NSMutableArray*) getSong3
{
    NSMutableArray* array = [[NSMutableArray alloc] initWithCapacity:1];
    
    [array addObject: [DPNote DPNoteAtTime:0.3 freq:kMidFrequency type:kSnare]];
    
    return array;
}
@end
