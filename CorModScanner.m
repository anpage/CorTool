//
//  CorModScanner.m
//  CorTool
//
//  Created by Frigid on 3/8/10.
//  Copyright 2010 OmniGreat Software Co.. All rights reserved.
//

#import "CorModScanner.h"


@implementation CorModScanner

@synthesize CCApp;

- (NSArray *)getModArray
{
    NSFileManager *FileManager = [NSFileManager defaultManager];
    
    if (![FileManager fileExistsAtPath: [[self.CCApp resourcePath] stringByAppendingString: @"/Disabled_Mods/"]])
        [FileManager createDirectoryAtPath: [[self.CCApp resourcePath] stringByAppendingString: @"/Disabled_Mods/"] withIntermediateDirectories: NO attributes: nil error: NULL];
    
    NSArray *EnabledMods = [self scanInFolder: [[self.CCApp resourcePath] stringByAppendingString: @"/"] withStatus: YES];
    
    NSArray *DisabledMods = [self scanInFolder: [[self.CCApp resourcePath] stringByAppendingString: @"/Disabled_Mods/"] withStatus: NO];
    
    NSArray *Mods = [EnabledMods arrayByAddingObjectsFromArray: DisabledMods];
    
    return Mods;
    
}

- (NSArray *)scanInFolder: (NSString *)Path withStatus: (BOOL)Enabled
{
    
    NSArray *BuiltInMods = [[NSArray alloc] initWithObjects: @"Base.rte", @"Browncoats.rte", @"Coalition.rte", @"Dummy.rte", @"Missions.rte", @"Ronin.rte",
                           @"Tutorial.rte", @"Undead.rte", @"Whitebots.rte", @"Wildlife.rte", nil];
    
    NSMutableArray *Mods = [[NSMutableArray alloc] init];
    
    NSFileManager *FileManager = [NSFileManager defaultManager];
    
    if (![FileManager fileExistsAtPath: Path isDirectory: NULL])
        [FileManager createDirectoryAtPath: Path withIntermediateDirectories: NO attributes: nil error: NULL];
    
    NSArray *ModsAtPath = [FileManager contentsOfDirectoryAtPath: Path error: NULL];
    
    for (NSString *ModFolder in ModsAtPath)
    {
        
        BOOL IsBuiltIn = FALSE;
        
        for (NSString *BuiltInMod in BuiltInMods)
        {
            
            if ([ModFolder isEqualToString: BuiltInMod])
                IsBuiltIn = TRUE;
            
        }
        
        if ([[ModFolder pathExtension] isEqualToString: @"rte"] && !IsBuiltIn)
        {
            
            NSString *ModName = [[NSString alloc] init];
            
            NSImage *ModIcon = nil;
            
            ModName = [self valueForEntry: @"ModuleName" inIniFile: [Path stringByAppendingString: [ModFolder stringByAppendingString: @"/index.ini"]]];
            
            if (ModName == nil)
                ModName = [[ModFolder componentsSeparatedByString: [@"." stringByAppendingString: [ModFolder pathExtension]]] objectAtIndex: 0];
            
            /////// Boilerplate code!
            
            NSString *ModIconPath = [[NSString alloc] init];
            
            NSString *FileContents = [NSString stringWithContentsOfFile: [Path stringByAppendingString: [ModFolder stringByAppendingString: @"/index.ini"]] usedEncoding: nil error: NULL];
            
            NSUInteger Length = [FileContents length];
            
            NSUInteger LineStart = 0, LineEnd = 0, ContentsEnd = 0;
            
            NSMutableArray *FileLines = [[NSMutableArray alloc] init];
            
            NSRange CurrentRange;
            
            while (LineEnd < Length)
            {
                
                [FileContents getLineStart: &LineStart end: &LineEnd
                 
                               contentsEnd: &ContentsEnd forRange:NSMakeRange(LineEnd, 0)];
                
                CurrentRange = NSMakeRange(LineStart, ContentsEnd - LineStart);
                
                [FileLines addObject:[FileContents substringWithRange:CurrentRange]];
                
            }    
            
            BOOL HasEntry = NO;
            
            BOOL IconLineFound = NO;
            
            for (NSString *Line in FileLines)
            {
                                
                NSString *FilteredLine = [[Line componentsSeparatedByString: @"//"] objectAtIndex:0];
                
                if (![FilteredLine isEqualToString: @""] && IconLineFound)
                {
                    
                    ModIconPath = [[[FilteredLine componentsSeparatedByString:@"="] objectAtIndex: 1] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
                    break;
                    
                }
                
                if([[[[FilteredLine componentsSeparatedByString: @"="] objectAtIndex:0] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]] isEqualToString: @"IconFile"])
                {
                        
                    HasEntry = YES;
                    
                    IconLineFound = YES;
                    
                }
                
            }
            
            if (!HasEntry)
                ModIconPath = nil;
            
            /////// End boilerplate.
            
            if (ModIconPath != nil && [FileManager fileExistsAtPath: [Path stringByAppendingString: [@"/" stringByAppendingString: ModIconPath]] isDirectory: NULL])
                ModIcon = [self makeTransparent: [[NSImage alloc] initByReferencingFile: [Path stringByAppendingString: [@"/" stringByAppendingString: ModIconPath]]]];
            else
                ModIcon = [[NSImage alloc] initByReferencingFile: [[NSBundle mainBundle] pathForResource: @"noicon" ofType: @"png"]];
                    
            NSMutableDictionary *ModEntry = [[NSMutableDictionary alloc] init];
            
            [ModEntry setObject: [NSNumber numberWithBool: Enabled] forKey: @"modIsEnabled"];
            
            [ModEntry setObject: ModIcon forKey: @"modIcon"];
            
            [ModEntry setObject: ModName forKey: @"modName"];
            
            [ModEntry setObject: ModFolder forKey: @"modFolder"];
            
            [Mods addObject: ModEntry];
            
        }
        
    }
    
    return Mods;
    
}

- (NSString *)valueForEntry: (NSString *)Entry inIniFile: (NSString *)File
{
    
    NSString *Value = [[NSString alloc] init];
    
    NSString *FileContents = [NSString stringWithContentsOfFile: File usedEncoding: nil error: NULL];
    
    NSUInteger Length = [FileContents length];
    
    NSUInteger LineStart = 0, LineEnd = 0, ContentsEnd = 0;
    
    NSMutableArray *FileLines = [[NSMutableArray alloc] init];
    
    NSRange CurrentRange;
    
    while (LineEnd < Length) {
        
        [FileContents getLineStart: &LineStart end: &LineEnd
         
                   contentsEnd: &ContentsEnd forRange:NSMakeRange(LineEnd, 0)];
        
        CurrentRange = NSMakeRange(LineStart, ContentsEnd - LineStart);
        
        [FileLines addObject:[FileContents substringWithRange:CurrentRange]];
        
    }    
    
    BOOL HasEntry = NO;
    
    for (NSString *Line in FileLines)
    {
        
        NSString *FilteredLine = [[Line componentsSeparatedByString: @"//"] objectAtIndex:0];
            
        if ([[[[FilteredLine componentsSeparatedByString: @"="] objectAtIndex:0] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]] isEqualToString: Entry])
        {
            
            HasEntry = YES;
            
            Value = [[[FilteredLine componentsSeparatedByString:@"="] objectAtIndex: 1] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
            
        }
        
    }
    
    if (!HasEntry)
        Value = nil;
             
    return Value;
    
}

- (NSImage *)makeTransparent: (NSImage *)Source
{
    
    CGImageRef SourceImage = [Source CGImageForProposedRect: NULL context: [NSGraphicsContext currentContext] hints: nil];
    
    NSBitmapImageRep *Bitmap = [[NSBitmapImageRep alloc] initWithCGImage: SourceImage];
    
    NSSize ImageSize = [Bitmap size];
    
    int Samples = ImageSize.height * [Bitmap bytesPerRow];
    
    unsigned char *BitmapData = [Bitmap bitmapData];
    
    int SamplesPerPixel = [Bitmap samplesPerPixel];
    
    int StartSample = [Bitmap bitmapFormat] & NSAlphaFirstBitmapFormat ? 1 : 0;
    
    for (int i = StartSample; i < Samples; i = i + SamplesPerPixel) {
        
        if (BitmapData[i] == 255.0 && BitmapData[i + 1] == 0 && BitmapData[i + 2] == 255.0)
        {
            
            BitmapData[i] = 255.0;
            BitmapData[i + 1] = 255.0;
            BitmapData[i + 2] = 255.0;
            
        }
        
    }
    
    NSImage *NewImage = [[NSImage alloc] initWithSize: [Bitmap size]];
    
    [NewImage addRepresentation: Bitmap];
    
    return NewImage;
    
}

@end
