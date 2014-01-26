//
//  DPNote.m
//  BackDrop
//
//  Created by Spencer Lewson on 10/19/13.
//  Copyright (c) 2013 slewson. All rights reserved.
//

#import "DPNote.h"

@implementation DPNote

- (id) initWithJsonData: (NSMutableDictionary*) note
{
    NSInteger length = [[note objectForKey: @"length"] integerValue];
    FrequencyRange range = [self parseFrequencyRange:[note objectForKey: @"frequency"]];
    NoteType type = [self parseNoteType: [note objectForKey: @"instrument"]];
    
    return [self initWithType:type andFreq:range andLength:length];
}

- (id) initWithType: (NoteType) type andFreq: (FrequencyRange) freq andLength: (NSInteger) length;
{
    self = [super init];
    self.freq = freq;
    self.type = type;
    self.length = length;
    
    return self;
}

- (void) encodeWithCoder: (NSCoder *) encoder {
    [encoder encodeInt:self.freq forKey:@"freq"];
    [encoder encodeInt:self.type forKey:@"type"];
    [encoder encodeInteger:self.length forKey:@"length"];
}

- (id) initWithCoder: (NSCoder *) decoder {
    FrequencyRange freq = [decoder decodeIntForKey:@"freq"];
    NoteType note = [decoder decodeIntForKey:@"type"];
    NSInteger length = [decoder decodeIntegerForKey:@"length"];
    return [self initWithType:note andFreq:freq andLength:length];
}

- (NoteType) parseNoteType: (NSString*) nt
{
    NoteType noteType = 0;
    
    if ([@"bass" isEqualToString: nt])
    {
        noteType = kBass;
    }
    else if ([@"cymbal" isEqualToString: nt])
    {
        noteType = kCymbol;
    }
    else if ([@"guitar" isEqualToString: nt])
    {
        noteType = kGuitar;
    }
    else if ([@"rest" isEqualToString: nt])
    {
        noteType = kRest;
    }
    else if ([@"snare" isEqualToString: nt])
    {
        noteType = kSnare;
    }
    else if ([@"strike" isEqualToString: nt])
    {
        noteType = kStrike;
    }
    else
    {
        NSLog(@"Error parsing note type");
    }
    
    return noteType;
}

- (FrequencyRange) parseFrequencyRange: (NSString*) fr
{
    FrequencyRange freqRange = 0;
    
    if ([@"low" isEqualToString: fr])
    {
        freqRange = kLowFrequency;
    }
    else if ([@"mid" isEqualToString: fr])
    {
        freqRange = kMidFrequency;
    }
    else if ([@"high" isEqualToString: fr])
    {
        freqRange = kHighFrequency;
    }
    else if ([@"none" isEqualToString:fr])
    {
        
    }
    else
    {
        NSLog(@"Error parsing frequency range: %s", fr);
    }
    
    return freqRange;
}

-(BOOL)isEqualToNote:(DPNote*) note
{
    return self.type == note.type && self.freq == note.freq;
}

- (void) printNote
{
    NSLog(@"Type: %d, Freq: %d, Length: %d", self.type, self.freq, self.length);
}

@end
