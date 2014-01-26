//
//  DPMeasure.m
//  dropBeats
//
//  Created by Spencer Lewson on 12/28/13.
//  Copyright (c) 2013 Michael Dewitt. All rights reserved.
//

#import "DPMeasure.h"

@implementation DPMeasure

- (id) initWithJsonData: (NSMutableDictionary*) measure
{
    NSMutableArray *notes = [[NSMutableArray alloc] init];

    for (NSMutableDictionary *note in [measure objectForKey:@"notes"])
    {
        [notes addObject: [[DPNote alloc] initWithJsonData: note]];
    }
    
    return [self initWithNotes: notes];
}

- (id) initWithNotes: (NSMutableArray*) notes
{
    self = [super init];
    self.notes = notes;
    
    return self;
}

- (void) encodeWithCoder: (NSCoder *) encoder {
    [encoder encodeObject:self.notes forKey:@"notes"];
}

- (id) initWithCoder: (NSCoder *) decoder {
    NSMutableArray* notes = [decoder decodeObjectForKey:@"notes"];
    return [self initWithNotes: notes];
}

- (NSMutableArray*) getNotes
{
    return self.notes;
}

- (NSInteger) getTotalLength
{
    NSInteger length = 0;
    
    for (DPNote* n in self.notes)
    {
        length += [n length];
    }
    
    return length;
}

- (void) printMeasure
{
    NSLog(@"----------");
    
    for (DPNote* note in self.notes)
    {
        [note printNote];
    }
}

@end
