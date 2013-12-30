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

-(NSMutableArray*)notes
{
    if (!_notes) {
        _notes = [[NSMutableArray alloc]initWithCapacity:10];
    }
    return _notes;
}

- (void) addNote: (DPNote*) note
{
    //[self.notes insertObject:note atIndex:0];
    [self.notes addObject:note];
}

- (DPNote*) getNote: (NSInteger) index
{
    return [self.notes objectAtIndex:index];
}

- (NSArray*) getNotes
{
    return [self.notes copy];
}

-(void)clearNotes
{
    self.notes = nil;
}

#pragma mark - class Methods
+(int)numberOfSongs
{
    return 5;
}

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
        case 4:
            song.notes = [DPSong getSong4];
            break;
        case 5:
            song.notes = [DPSong getSong5];
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
    
    return [array copy];
}

+ (NSMutableArray*) getSong2
{
    NSMutableArray* array = [[NSMutableArray alloc] initWithCapacity:3];
    
    [array addObject: [DPNote DPNoteAtTime:0.1 freq:kLowFrequency type:kBass]];
    [array addObject: [DPNote DPNoteAtTime:0.3 freq:kLowFrequency type:kCymbol]];
    [array addObject: [DPNote DPNoteAtTime:0.5 freq:kMidFrequency type:kSnare]];
   
    return [array copy];
}

+ (NSMutableArray*) getSong3
{
    NSMutableArray* array = [[NSMutableArray alloc] initWithCapacity:1];
    
    [array addObject: [DPNote DPNoteAtTime:0.1 freq:kMidFrequency type:kSnare]];
    [array addObject: [DPNote DPNoteAtTime:0.3 freq:kMidFrequency type:kBass]];
    [array addObject: [DPNote DPNoteAtTime:0.7 freq:kMidFrequency type:kBass]];
    
    return [array copy];
}

+ (NSMutableArray*) getSong4
{
    NSMutableArray* array = [[NSMutableArray alloc] initWithCapacity:3];
    [array addObject: [DPNote DPNoteAtTime:0.1 freq:kLowFrequency type:kCymbol]];
    [array addObject: [DPNote DPNoteAtTime:0.2 freq:kMidFrequency type:kSnare]];
    [array addObject: [DPNote DPNoteAtTime:0.3 freq:kLowFrequency type:kBass]];
    
    return [array copy];
}

+ (NSMutableArray*) getSong5
{
    NSMutableArray* array = [[NSMutableArray alloc] initWithCapacity:5];
    [array addObject: [DPNote DPNoteAtTime:0.1 freq:kLowFrequency type:kCymbol]];
    [array addObject: [DPNote DPNoteAtTime:0.2 freq:kLowFrequency type:kSnare]];
    [array addObject: [DPNote DPNoteAtTime:0.3 freq:kMidFrequency type:kCymbol]];
    [array addObject: [DPNote DPNoteAtTime:0.4 freq:kLowFrequency type:kBass]];
    [array addObject: [DPNote DPNoteAtTime:0.7 freq:kMidFrequency type:kSnare]];
    
    return [array copy];
}
@end
