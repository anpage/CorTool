//
//  CorController.m
//  CorTool
//
//  Created by Frigid on 3/8/10.
//  Copyright 2010 OmniGreat Software Co.. All rights reserved.
//

#import "CorController.h"


@implementation CorController

- (id)init
{
    
    if (self = [super init])
    {
        
        self->Mods = [[NSMutableArray alloc] init];
        
    }
    
    return self;
}

- (void)awakeFromNib
{ 
    
    [self setRunButtonImage];
    
    [self scanMods: NULL];
    
    NSSortDescriptor *NameDescriptor = [[NSSortDescriptor alloc] initWithKey: @"modName" ascending: YES];
    
    [TableView setSortDescriptors: [NSArray arrayWithObject: NameDescriptor]];
    
    [TableView registerForDraggedTypes:[NSArray arrayWithObjects:NSFilenamesPboardType, nil]];
    
}

- (IBAction)runButton: (id)sender
{
    
    CorDirectory *CorDir = [[CorDirectory alloc] init];
    
    NSBundle *CCApp = [CorDir findCCApp];
    
    [self setRunButtonImage];
    
    [[NSWorkspace sharedWorkspace] launchApplication: [CCApp bundlePath]];
    
}

- (IBAction)scanMods: (id)sender
{
 
    CorDirectory *CorDir = [[CorDirectory alloc] init];
    
    NSBundle *CCApp = [CorDir findCCApp];
    
    [self setRunButtonImage];
    
    CorModScanner *ModScanner = [[CorModScanner alloc] init];
    
    [ModScanner setCCApp: CCApp];
    
    [self->Mods setArray: [ModScanner getModArray]];
    
    [self->Mods sortUsingDescriptors: [TableView sortDescriptors]];
    
    [TableView reloadData];
    
}

- (IBAction)addMod: (id)sender
{
    
    CorDirectory *CorDir = [[CorDirectory alloc] init];
    
    NSBundle *CCApp = [CorDir findCCApp];
    
    [self setRunButtonImage];
    
    CorModMover *ModMover = [[CorModMover alloc] init];
    
    [ModMover setCCApp: CCApp];
    
    [ModMover installMod];
    
    [self scanMods: NULL];
    
}

- (IBAction)removeMod: (id)sender
{
    
    CorDirectory *CorDir = [[CorDirectory alloc] init];
    
    NSBundle *CCApp = [CorDir findCCApp];
    
    [self setRunButtonImage];
    
    CorModMover *ModMover = [[CorModMover alloc] init];
    
    [ModMover setCCApp: CCApp];
    
    NSString *ModFolder = [[Mods objectAtIndex: [TableView selectedRow]] objectForKey: @"modFolder"];
    
    NSString *ModName = [[Mods objectAtIndex: [TableView selectedRow]] objectForKey: @"modName"];
    
    [ModMover removeMod: ModFolder modName: ModName];
    
    [self scanMods: NULL];
    
}

- (IBAction)findApp: (id)sender
{
    
    CorDirectory *CorDir = [[CorDirectory alloc] init];
    
    [CorDir findNewCCAppPathAllowDefault: NO];
    
    [self scanMods: NULL];
    
}

- (IBAction)checkButton: (id)sender
{
    
    CorDirectory *CorDir = [[CorDirectory alloc] init];
    
    NSBundle *CCApp = [CorDir findCCApp];
    
    [self setRunButtonImage];
    
    CorModMover *ModMover = [[CorModMover alloc] init];
    
    [ModMover setCCApp: CCApp];
    
    NSString *ModFolder = [[Mods objectAtIndex: [sender selectedRow]] objectForKey: @"modFolder"];
    
    NSNumber *ModIsEnabled = [[Mods objectAtIndex: [sender selectedRow]] objectForKey: @"modIsEnabled"];
    
    if ([ModIsEnabled isEqualToNumber: [NSNumber numberWithInt: 1]])
        [ModMover disableMod: ModFolder];
    else if ([ModIsEnabled isEqualToNumber: [NSNumber numberWithInt: 0]])
        [ModMover enableMod: ModFolder];
    
    [self scanMods: NULL];
}

- (IBAction)toggleAll: (id)sender
{
    
    CorDirectory *CorDir = [[CorDirectory alloc] init];
    
    NSBundle *CCApp = [CorDir findCCApp];
    
    [self setRunButtonImage];
    
    CorModMover *ModMover = [[CorModMover alloc] init];
    
    [ModMover setCCApp: CCApp];
    
    if ([sender selectedSegment] == 0)
    {
        
        for (NSDictionary *Mod in Mods)
        {
            
            NSString *ModFolder = [Mod objectForKey: @"modFolder"];
            
            NSNumber *ModIsEnabled = [Mod objectForKey: @"modIsEnabled"];
            
            if ([ModIsEnabled isEqualToNumber: [NSNumber numberWithInt: 0]])
                [ModMover enableMod: ModFolder]; 
            
        }
        
    }
    else if ([sender selectedSegment] == 1)
    {
        
        for (NSDictionary *Mod in Mods)
        {
            
            NSString *ModFolder = [Mod objectForKey: @"modFolder"];
            
            NSNumber *ModIsEnabled = [Mod objectForKey: @"modIsEnabled"];
            
            if ([ModIsEnabled isEqualToNumber: [NSNumber numberWithInt: 1]])
                [ModMover disableMod: ModFolder];
            
        }
        
    }
    
    [self scanMods: NULL];
    
}

- (void)setRunButtonImage
{
    
    CorDirectory *CorDir = [[CorDirectory alloc] init];
    
    NSBundle *CCApp = [CorDir findCCApp];
    
    NSString *IconFileName = [[CCApp infoDictionary] objectForKey: @"CFBundleIconFile"];
    
    NSImage *IconImage = [[NSImage alloc] initWithContentsOfFile: [CCApp pathForResource: IconFileName ofType: nil]];
    
    [RunButton setImage: IconImage];
    
    //Find the name of the app without the .app extension.
    NSString *AppName = [[[[CCApp bundlePath] lastPathComponent] componentsSeparatedByString: [@"." stringByAppendingString: [[CCApp bundlePath] pathExtension]]] objectAtIndex: 0];
    
    [RunButton setLabel: [@"Run " stringByAppendingString: AppName]]; 
    
}

- (id)tableView:(NSTableView *)aTableView
objectValueForTableColumn:(NSTableColumn *)TableColumn
row:(NSInteger)RowIndex

{
    
    id TheRecord, TheValue;
    
    
    
    NSParameterAssert(RowIndex >= 0 && RowIndex < [self->Mods count]);
    
    TheRecord = [self->Mods objectAtIndex:RowIndex];
    
    TheValue = [TheRecord objectForKey:[TableColumn identifier]];
    
    return TheValue;
    
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView
{

    return [self->Mods count];
    
}

- (void)tableView:(NSTableView *)aTableView
sortDescriptorsDidChange:(NSSortDescriptor *)OldDescriptors
{
    
    [self->Mods sortUsingDescriptors: [aTableView sortDescriptors]];
    [aTableView reloadData];
    
}

- (NSDragOperation)tableView:(NSTableView*)tv validateDrop:(id <NSDraggingInfo>)info proposedRow:(NSInteger)row proposedDropOperation:(NSTableViewDropOperation)op
{
    
    return NSDragOperationEvery;
    
}

- (BOOL)tableView:(NSTableView *)aTableView acceptDrop:(id <NSDraggingInfo>)info

              row:(NSInteger)row dropOperation:(NSTableViewDropOperation)operation
{
    
    NSPasteboard* pboard = [info draggingPasteboard];
    
    NSArray *files = [pboard propertyListForType:NSFilenamesPboardType];
    
    CorDirectory *CorDir = [[CorDirectory alloc] init];
    
    NSBundle *CCApp = [CorDir findCCApp];
    
    [self setRunButtonImage];
    
    CorModMover *ModMover = [[CorModMover alloc] init];
    
    [ModMover setCCApp: CCApp];
    
    for (NSString* ModPath in files)
        [ModMover installModFromPath: ModPath];
    
    [self scanMods: NULL];
    
    return YES;
    
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication
{
    
    return YES;
    
}

@end
