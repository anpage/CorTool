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
    
    if (self == [super init])
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
	
	NSString *BundlePackage = [[NSUserDefaults standardUserDefaults] stringForKey: @"BundlePackage"];
	
	if ([BundlePackage isEqualToString: @"True"])
	{
		[BundlePackageCheck setState: NSOnState];
	}
	else if ([BundlePackage isEqualToString: @"False"])
	{
		[BundlePackageCheck	setState: NSOffState];
	}
	else
	{
		[[NSUserDefaults standardUserDefaults] setObject: @"True" forKey: @"BundlePackage"];
	}
	
	[NameDescriptor release];
    
}

- (NSWindow *)prefsWindow
{
    
    return PrefsWindow;
    
}

- (void)setPrefsWindow:(NSWindow *)aValue
{
    
    [PrefsWindow autorelease];
    
    PrefsWindow = [aValue retain];
    
}

- (IBAction)runButton: (id)sender
{
    NSAutoreleasePool *Pool = [[NSAutoreleasePool alloc] init];
	
    CorDirectory *CorDir = [[[CorDirectory alloc] init] autorelease];
    
    NSBundle *CCApp = [CorDir findCCApp];
    
    [self setRunButtonImage];
    
    [[NSWorkspace sharedWorkspace] launchApplication: [CCApp bundlePath]];
	
	[Pool release];
    
}

- (IBAction)scanMods: (id)sender
{
	
	NSAutoreleasePool *Pool = [[NSAutoreleasePool alloc] init];
	
    CorDirectory *CorDir = [[[CorDirectory alloc] init] autorelease];
    
    NSBundle *CCApp = [CorDir findCCApp];
    
    [self setRunButtonImage];
    
    CorModScanner *ModScanner = [[[CorModScanner alloc] init] autorelease];
    
    [ModScanner setCCApp: CCApp];
    
    [self->Mods setArray: [ModScanner getModArray]];
    
    [self->Mods sortUsingDescriptors: [TableView sortDescriptors]];
    
    [TableView reloadData];
    
	[Pool release];
	
}

- (IBAction)addMod: (id)sender
{
    
	NSAutoreleasePool *Pool = [[NSAutoreleasePool alloc] init];
	
    CorDirectory *CorDir = [[[CorDirectory alloc] init] autorelease];
    
    NSBundle *CCApp = [CorDir findCCApp];
    
    [self setRunButtonImage];
    
    CorModMover *ModMover = [[[CorModMover alloc] init] autorelease];
    
    [ModMover setCCApp: CCApp];
    
    [ModMover installMod];
    
    [self scanMods: NULL];
    
	[Pool release];
	
}

- (IBAction)removeMod: (id)sender
{
    
	NSAutoreleasePool *Pool = [[NSAutoreleasePool alloc] init];
	
    CorDirectory *CorDir = [[[CorDirectory alloc] init] autorelease];
    
    NSBundle *CCApp = [CorDir findCCApp];
    
    [self setRunButtonImage];
    
    CorModMover *ModMover = [[[CorModMover alloc] init] autorelease];
    
    [ModMover setCCApp: CCApp];
    
    NSString *ModFolder = [[Mods objectAtIndex: [TableView selectedRow]] objectForKey: @"modFolder"];
    
    NSString *ModName = [[Mods objectAtIndex: [TableView selectedRow]] objectForKey: @"modName"];
    
    [ModMover removeMod: ModFolder modName: ModName];
    
    [self scanMods: NULL];
	
	[Pool release];
    
}

- (IBAction)findApp: (id)sender
{
    
	NSAutoreleasePool *Pool = [[NSAutoreleasePool alloc] init];
	
    CorDirectory *CorDir = [[[CorDirectory alloc] init] autorelease];
    
    [CorDir findNewCCAppPathAllowDefault: NO];
    
    [self scanMods: NULL];
	
	[Pool release];
    
}

- (IBAction)checkButton: (id)sender
{
    
	NSAutoreleasePool *Pool = [[NSAutoreleasePool alloc] init];
	
    CorDirectory *CorDir = [[[CorDirectory alloc] init] autorelease];
    
    NSBundle *CCApp = [CorDir findCCApp];
    
    [self setRunButtonImage];
    
    CorModMover *ModMover = [[[CorModMover alloc] init] autorelease];
    
    [ModMover setCCApp: CCApp];
    
    NSString *ModFolder = [[Mods objectAtIndex: [sender selectedRow]] objectForKey: @"modFolder"];
    
    NSNumber *ModIsEnabled = [[Mods objectAtIndex: [sender selectedRow]] objectForKey: @"modIsEnabled"];
    
    if ([ModIsEnabled isEqualToNumber: [NSNumber numberWithInt: 1]])
        [ModMover disableMod: ModFolder];
    else if ([ModIsEnabled isEqualToNumber: [NSNumber numberWithInt: 0]])
        [ModMover enableMod: ModFolder];
    
    [self scanMods: NULL];
	
	[Pool release];
}

- (IBAction)toggleAll: (id)sender
{
    NSAutoreleasePool *Pool = [[NSAutoreleasePool alloc] init];
	
    CorDirectory *CorDir = [[[CorDirectory alloc] init] autorelease];
    
    NSBundle *CCApp = [CorDir findCCApp];
    
    [self setRunButtonImage];
    
    CorModMover *ModMover = [[[CorModMover alloc] init] autorelease];
    
    [ModMover setCCApp: CCApp];
    
	for (int i = 0; i < [Mods count]; i++)
	{
		
		NSDictionary *Mod = [Mods objectAtIndex: i];
		
		NSString *ModFolder = [Mod objectForKey: @"modFolder"];
		
		NSNumber *ModIsEnabled = [Mod objectForKey: @"modIsEnabled"];
		
		if ([sender selectedSegment] == 0)
		{
			
			if ([ModIsEnabled isEqualToNumber: [NSNumber numberWithInt: 0]])
			{
				
				[ModMover enableMod: ModFolder];
				
			}
			
		}
		else if ([sender selectedSegment] == 1)
		{
			
			if ([ModIsEnabled isEqualToNumber: [NSNumber numberWithInt: 1]])
			{
				
				[ModMover disableMod: ModFolder];
				
			}
			
		}
		
	}
    
    [self scanMods: NULL];
	
	[Pool release];
    
}

- (IBAction)openPrefWindow: (id)sender
{
    
    if (PrefsWindow == nil)
    {
        if (![NSBundle loadNibNamed:@"Preferences" owner:self])
        {
            NSLog(@"Warning! Could not load Preferences nib file.\n");
        }
        [PrefsWindow release];
    }
    
    [PrefsWindow makeKeyAndOrderFront:self];

}

- (IBAction)toggleBundlePackage: (id)sender;
{
	
	NSString *InfoPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingString: @"/Contents/Info.plist"];
	
	NSDictionary *InfoPlist = [NSDictionary dictionaryWithContentsOfFile: InfoPath];
	
	NSMutableDictionary *MutablePlist = [[NSMutableDictionary alloc] init];
	
	[MutablePlist addEntriesFromDictionary: InfoPlist];
	
	if ([sender state] == NSOnState)
	{
				
		NSArray *BDTValues = [NSArray arrayWithObjects: [NSArray arrayWithObject: @"rte"], @"RTE Mod Folder", @"Default", @"1", @"Viewer", @"RTEMOD", nil];
		
		NSArray *BDTKeys = [NSArray arrayWithObjects: @"CFBundleTypeExtensions", @"CFBundleTypeName",  @"LSHandlerRank", @"LSTypeIsPackage", @"CFBundleTypeRole", @"CFBundleTypeIconFile", nil];
		
		NSDictionary *BDTDict = [NSDictionary dictionaryWithObjects: BDTValues forKeys: BDTKeys];
		
		NSArray *BDTArray = [NSArray arrayWithObject: BDTDict];
		
		[MutablePlist setObject: BDTArray forKey: @"CFBundleDocumentTypes"];
		
	}
	else if ([sender state] == NSOffState)
	{
		
		[MutablePlist removeObjectForKey: @"CFBundleDocumentTypes"];
		
	}
	
	[MutablePlist writeToFile: InfoPath atomically: YES];
	
	[MutablePlist release];

}

- (void)setRunButtonImage
{
    
	NSAutoreleasePool *Pool = [[NSAutoreleasePool alloc] init];
	
    CorDirectory *CorDir = [[[CorDirectory alloc] init] autorelease];
    
    NSBundle *CCApp = [CorDir findCCApp];
    
    NSString *IconFileName = [[CCApp infoDictionary] objectForKey: @"CFBundleIconFile"];
    
    NSImage *IconImage = [[[NSImage alloc] initWithContentsOfFile: [CCApp pathForResource: IconFileName ofType: nil]] autorelease];
    
    [RunButton setImage: IconImage];
    
    //Find the name of the app without the .app extension.
    NSString *AppName = [[[[CCApp bundlePath] lastPathComponent] componentsSeparatedByString: [@"." stringByAppendingString: [[CCApp bundlePath] pathExtension]]] objectAtIndex: 0];
    
    [RunButton setLabel: [@"Run " stringByAppendingString: AppName]]; 
    
	[Pool release];
}

- (id)tableView:(NSTableView *)aTableView
objectValueForTableColumn:(NSTableColumn *)TableColumn
row:(int)RowIndex
{
    
    id Record;
	
	id Value;
    
    NSParameterAssert(RowIndex >= 0 && RowIndex < [self->Mods count]);
    
    Record = [self->Mods objectAtIndex:RowIndex];
    
    Value = [Record objectForKey:[TableColumn identifier]];
    
    return Value;
    
}

- (int)numberOfRowsInTableView:(NSTableView *)aTableView
{

    return [self->Mods count];
    
}

- (void)tableView:(NSTableView *)aTableView
sortDescriptorsDidChange:(NSSortDescriptor *)OldDescriptors
{
    
    [self->Mods sortUsingDescriptors: [aTableView sortDescriptors]];
	
    [aTableView reloadData];
    
}

- (NSDragOperation)tableView: (NSTableView*)tv
				validateDrop: (id <NSDraggingInfo>)info
				 proposedRow: (int)row
	   proposedDropOperation: (NSTableViewDropOperation)op
{
	
	[TableView setDropRow: -1 dropOperation: NSTableViewDropOn];
    
    return NSDragOperationEvery;
    
}

- (BOOL)tableView: (NSTableView *)aTableView
	   acceptDrop: (id <NSDraggingInfo>)info
			  row: (int)row
	dropOperation: (NSTableViewDropOperation)operation
{
    
	NSAutoreleasePool *Pool = [[NSAutoreleasePool alloc] init];
	
    NSPasteboard* PasteBoard = [info draggingPasteboard];
    
    NSArray *Files = [PasteBoard propertyListForType: NSFilenamesPboardType];
    
    CorDirectory *CorDir = [[[CorDirectory alloc] init] autorelease];
    
    NSBundle *CCApp = [CorDir findCCApp];
    
    [self setRunButtonImage];
    
    CorModMover *ModMover = [[[CorModMover alloc] init] autorelease];
    
    [ModMover setCCApp: CCApp];
		
	for (int i = 0; i < [Files count]; i++)
	{
		
		NSString *ModPath = [Files objectAtIndex: i];
		
        [ModMover installModFromPath: ModPath];
		
	}
    
    [self scanMods: NULL];
	
	[Pool release];
    
    return YES;
    
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication
{
    
    return YES;
    
}

@end
