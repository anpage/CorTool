//
//  CorController.h
//  CorTool
//
//  Created by Frigid on 3/8/10.
//  Copyright 2010 OmniGreat Software Co.. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CorDirectory.h"
#import "CorModScanner.h"
#import "CorModMover.h"


@interface CorController : NSObject
{
    
    IBOutlet NSTableView *TableView;
    
    IBOutlet NSToolbarItem *RunButton;
	
	IBOutlet NSWindow *MainWindow;
    
    IBOutlet NSWindow *PrefsWindow;
	
	IBOutlet NSButton *BundlePackageCheck;
    
    NSMutableArray *Mods;

}

- (id)init;

- (NSWindow *)prefsWindow;

- (void)setPrefsWindow:(NSWindow *)aValue;

- (void)awakeFromNib;

- (IBAction)runButton: (id)sender;

- (IBAction)scanMods: (id)sender;

- (IBAction)addMod: (id)sender;

- (IBAction)removeMod: (id)sender;

- (IBAction)findApp: (id)sender;

- (IBAction)checkButton: (id)sender;

- (IBAction)toggleAll: (id)sender;

- (IBAction)openPrefWindow: (id)sender;

- (IBAction)toggleBundlePackage: (id)sender;

- (void)setRunButtonImage;

- (id)tableView:(NSTableView *)aTableView
objectValueForTableColumn:(NSTableColumn *)TableColumn
            row:(int)RowIndex;

- (int)numberOfRowsInTableView:(NSTableView *)aTableView;

- (void)tableView:(NSTableView *)aTableView
sortDescriptorsDidChange:(NSSortDescriptor *)OldDescriptors;

- (NSDragOperation)tableView:(NSTableView*)tv validateDrop:(id <NSDraggingInfo>)info proposedRow:(int)row proposedDropOperation:(NSTableViewDropOperation)op;

- (BOOL)tableView:(NSTableView *)aTableView acceptDrop:(id <NSDraggingInfo>)info

              row:(int)row dropOperation:(NSTableViewDropOperation)operation;

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication;


@end
