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
+ (DPSong*) getSong: (int) index WithTolerance: (float) tolerance andDuration: (float) duration
{
    DPSong *song = [[DPSong alloc]init];

    switch (index) {
        case 1:
            song.notes = [DPSong getSong1WithTolerance:tolerance];
            break;
        case 2:
            song.notes = [DPSong getSong2WithTolerance:tolerance];
            break;
        case 3:
            song.notes = [DPSong getSong3WithTolerance:tolerance];
            break;

            
        default:
            break;
    }
    song.duration = duration;
    song.tolerance = tolerance;
    
    return song;
}

+ (NSMutableArray*) getSong1WithTolerance: (float) tolerance
{
    NSMutableArray* array = [[NSMutableArray alloc] initWithCapacity:10];
    
    [array addObject: [DPNote DPNoteWithTime:0.2 freq:0 type:kCymbol tolerance:tolerance]];
    [array addObject: [DPNote DPNoteWithTime:0.4 freq:1 type:kSnare tolerance:tolerance]];
    [array addObject: [DPNote DPNoteWithTime:0.5 freq:0 type:kCymbol tolerance:tolerance]];
    [array addObject: [DPNote DPNoteWithTime:0.6 freq:2 type:kBass tolerance:tolerance]];
    [array addObject: [DPNote DPNoteWithTime:0.7 freq:2 type:kSnare tolerance:tolerance]];
    
    return array;
}

+ (NSMutableArray*) getSong2WithTolerance: (float) tolerance
{
    NSMutableArray* song = [[NSMutableArray alloc] initWithCapacity:10];
    
    [song addObject: [DPNote DPNoteWithTime:0.1 freq:0 type:kCymbol tolerance:tolerance]];
    [song addObject: [DPNote DPNoteWithTime:0.5 freq:1 type:kSnare tolerance:tolerance]];
    [song addObject: [DPNote DPNoteWithTime:0.8 freq:2 type:kSnare tolerance:tolerance]];
    
    return song;
}

+ (NSMutableArray*) getSong3WithTolerance: (float) tolerance
{
    NSMutableArray* song = [[NSMutableArray alloc] initWithCapacity:10];
    
    [song addObject: [DPNote DPNoteWithTime:0.3 freq:0 type:kCymbol tolerance:tolerance]];
    
    return song;
}
@end
