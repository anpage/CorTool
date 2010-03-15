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
    
    NSMutableArray *Mods;

}

- (id)init;

- (void)awakeFromNib;

- (IBAction)runButton: (id)sender;

- (IBAction)scanMods: (id)sender;

- (IBAction)addMod: (id)sender;

- (IBAction)removeMod: (id)sender;

- (IBAction)findApp: (id)sender;

- (IBAction)checkButton: (id)sender;

- (IBAction)toggleAll: (id)sender;

- (void)setRunButtonImage;

- (id)tableView:(NSTableView *)aTableView
objectValueForTableColumn:(NSTableColumn *)TableColumn
            row:(NSInteger)RowIndex;

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView;

- (void)tableView:(NSTableView *)aTableView
sortDescriptorsDidChange:(NSSortDescriptor *)OldDescriptors;

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication;


@end
