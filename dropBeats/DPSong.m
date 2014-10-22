//
//  DPSong.m
//  BackDrop
//
//  Created by Spencer Lewson on 10/19/13.
//  Copyright (c) 2013 slewson. All rights reserved.
//

#import "DPSong.h"
#import "DPNote.h"
#import "DPMeasure.h"

@implementation DPSong

- (id) initWithJsonData:(NSMutableDictionary *) song
{
    NSString* title;
    NSInteger level = -1;
    NSInteger tempo = -1;
    TimeSignature signature;
    NSMutableArray* measures = [[NSMutableArray alloc] init];
    song = [song objectForKey:@"song"];
    title = [song objectForKey: @"title"];
    level = [[song objectForKey: @"level"] integerValue];
    tempo = [[song objectForKey: @"tempo"] integerValue];
    signature.beatsPerMeasure = [[[song objectForKey: @"signature"] objectForKey: @"beatsPerMeasure"] integerValue];
    signature.beatValue= [[[song objectForKey: @"signature"] objectForKey: @"beatValue"] integerValue];
    
    for (NSMutableDictionary *measure in [song objectForKey:@"measures"])
    {
        [measures addObject:[[DPMeasure alloc] initWithJsonData: measure]];
    }
    
    return [self initWithTitle:title andLevel:level andTempo:tempo andSignature:signature andMeasures:measures];
}


- (id) initWithTitle:(NSString *)title andLevel:(NSInteger)level andTempo:(NSInteger)tempo andSignature:(TimeSignature)signature andMeasures: (NSMutableArray*) measures
{
    self = [super init];
    self.title = title;
    self.level = level;
    self.tempo = tempo;
    self.signature = signature;
    self.measures = measures;
    
    return self;
}

- (void) encodeWithCoder: (NSCoder *) encoder {
    [encoder encodeObject:self.title forKey: NSStringFromSelector(@selector(title))];
    [encoder encodeInteger:self.level forKey: NSStringFromSelector(@selector(level))];
    [encoder encodeInteger:self.tempo forKey: NSStringFromSelector(@selector(tempo))];
    [encoder encodeInteger:self.signature.beatsPerMeasure forKey:@"bpm"];
    [encoder encodeInteger:self.signature.beatValue forKey:@"bv"];
    [encoder encodeObject:self.measures forKey:NSStringFromSelector(@selector(measures))];
}

- (id) initWithCoder: (NSCoder *) decoder {
    TimeSignature sig;
    NSString* title = [decoder decodeObjectForKey:@"title"];
    NSInteger level = [decoder decodeIntegerForKey:@"level"];
    NSInteger tempo = [decoder decodeIntegerForKey:@"tempo"];
    NSMutableArray* measures = [decoder decodeObjectForKey:@"measures"];
    sig.beatsPerMeasure = [decoder decodeIntForKey:@"bmp"];
    sig.beatValue = [decoder decodeIntForKey:@"bv"];
    return [self initWithTitle:title andLevel:level andTempo:tempo andSignature:sig andMeasures:measures];
}

-(NSUInteger)duration
{
   return ([self.measures count] * self.signature.beatsPerMeasure*60)/self.tempo;
}

- (void) printSong
{
    NSLog(@"Title: %@", self.title);
    NSLog(@"Level: %d", (int)self.level);
    NSLog(@"Tempo: %d", (int)self.tempo);
    
    for (DPMeasure *measure in self.measures)
    {
        [measure printMeasure];
    }
    
}

@end
