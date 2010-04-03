//
//  CorModMover.m
//  CorTool
//
//  Created by Frigid on 3/8/10.
//  Copyright 2010 OmniGreat Software Co.. All rights reserved.
//

#import "CorModMover.h"


@implementation CorModMover


- (NSBundle *)CCApp
{
    
    return CCApp;
    
}

- (void)setCCApp:(NSBundle *)aValue
{
    
    [CCApp autorelease];
    
    CCApp = [aValue retain];
    
}

- (void)enableMod: (NSString *)ModFolder
{
    
    NSString *ResourcePath = [CCApp resourcePath];
    
    [self moveMod:ModFolder From: [ResourcePath stringByAppendingString: @"/Disabled_Mods/"] To: [ResourcePath stringByAppendingString: @"/"]];
    
}

- (void)disableMod: (NSString *)ModFolder
{
    
    NSString *ResourcePath = [CCApp resourcePath];
    
    [self moveMod:ModFolder From: [ResourcePath stringByAppendingString: @"/"] To: [ResourcePath stringByAppendingString: @"/Disabled_Mods/"]];
    
    
}

- (void)installMod
{
    
    NSString *ResourcePath = [CCApp resourcePath];
    
    NSString *SelectedModPath = nil;
    
    BOOL IsValidMod = FALSE;
    
    while (TRUE)
    {
        
        NSOpenPanel *OpenDlg = [NSOpenPanel openPanel];
        
        [OpenDlg setCanChooseFiles:NO];
        
        [OpenDlg setCanChooseDirectories:YES];
        
        [OpenDlg setAllowsMultipleSelection:NO];
        
        [OpenDlg setTitle: @"Select a Mod (.rte) to Install"];
        
        [OpenDlg setDirectory: @"~/Downloads/"];
        
        if ([OpenDlg runModal] == NSFileHandlingPanelOKButton)
            SelectedModPath = [OpenDlg filename];
        else
            SelectedModPath = nil;

        
        if ([[SelectedModPath pathExtension] isEqualToString: @"rte"])
        {
            
            IsValidMod = TRUE;
            
            break;
            
        }
        else if (SelectedModPath == nil)
            break;
        
        NSAlert *Alert = [[NSAlert alloc] init];
        
        [Alert addButtonWithTitle:@"OK"];
        
        [Alert setMessageText:@"Not a Valid Mod"];
        
        [Alert setInformativeText:@"You must select a valid Cortex Command mod that ends in .rte"];
        
        [Alert setAlertStyle:NSWarningAlertStyle];
        
        [Alert runModal];
		
		[Alert release];
        
    }
    
    if (IsValidMod == TRUE)
    {
        
        if ([[NSFileManager defaultManager] fileExistsAtPath: [[ResourcePath stringByAppendingString: @"/"] stringByAppendingString: [SelectedModPath lastPathComponent]]])
        {
            
            NSAlert *Alert = [NSAlert alertWithMessageText:@"Are you sure?" 
                                             defaultButton: @"OK"
                                           alternateButton: @"Cancel"
                                               otherButton: nil
                                 informativeTextWithFormat: @"A mod already exists at \"%@\". Do you want to overwrite it?", [SelectedModPath lastPathComponent]];
            
            if ([Alert runModal] == NSAlertDefaultReturn)
            {
                
                [[NSFileManager defaultManager] removeFileAtPath: [[ResourcePath stringByAppendingString: @"/"] stringByAppendingString: [SelectedModPath lastPathComponent]] handler: nil];
                
                [[NSFileManager defaultManager] copyPath: SelectedModPath toPath: [[ResourcePath stringByAppendingString: @"/"] stringByAppendingString: [SelectedModPath lastPathComponent]] handler: nil];
				
            }
            
        }
        else
            [[NSFileManager defaultManager] copyPath: SelectedModPath toPath: [[ResourcePath stringByAppendingString: @"/"] stringByAppendingString: [SelectedModPath lastPathComponent]] handler: nil];
        
    }
    
}

- (void)installModFromPath: (NSString *)Path
{
    
    NSString *ResourcePath = [CCApp resourcePath];
    
    if ([[Path pathExtension] isEqualToString: @"rte"])
    {
        
        if ([[NSFileManager defaultManager] fileExistsAtPath: [[ResourcePath stringByAppendingString: @"/"] stringByAppendingString: [Path lastPathComponent]]])
        {
            
            NSAlert *Alert = [NSAlert alertWithMessageText:@"Are you sure?" 
                                             defaultButton: @"OK"
                                           alternateButton: @"Cancel"
                                               otherButton: nil
                                 informativeTextWithFormat: @"A mod already exists at \"%@\". Do you want to overwrite it?", [Path lastPathComponent]];
            
            if ([Alert runModal] == NSAlertDefaultReturn)
            {
                
                [[NSFileManager defaultManager] removeFileAtPath: [[ResourcePath stringByAppendingString: @"/"] stringByAppendingString: [Path lastPathComponent]] handler: nil];
                
                [[NSFileManager defaultManager] copyPath: Path toPath: [[ResourcePath stringByAppendingString: @"/"] stringByAppendingString: [Path lastPathComponent]] handler: nil];
                
            }
            
        }
        else
            [[NSFileManager defaultManager] copyPath: Path toPath: [[ResourcePath stringByAppendingString: @"/"] stringByAppendingString: [Path lastPathComponent]] handler: nil];
        
    }
    else
    {
        
        NSAlert *Alert = [[NSAlert alloc] init];
        
        [Alert addButtonWithTitle:@"OK"];
        
        [Alert setMessageText:@"Not a Valid Mod"];
        
        [Alert setInformativeText:@"You must select a valid Cortex Command mod that ends in .rte"];
        
        [Alert setAlertStyle:NSWarningAlertStyle];
        
        [Alert runModal];
		
		[Alert release];
        
    }
    
}

- (void)removeMod: (NSString *)ModFolder modName: (NSString *)ModName
{
    
    NSAlert *Alert = [NSAlert alertWithMessageText:@"Are you sure?" 
                                      defaultButton: @"OK"
                                    alternateButton: @"Cancel"
                                        otherButton: nil
                          informativeTextWithFormat: @"You are about to permanently delete the mod \"%@\" from your Cortex Command app.", ModName];
    
    if ([Alert runModal] == NSAlertDefaultReturn)
        [[NSFileManager defaultManager] removeFileAtPath: [[[CCApp resourcePath] stringByAppendingString: @"/"] stringByAppendingString: ModFolder] handler: nil];
    
}

- (void)moveMod: (NSString *)Mod From: (NSString *)Origin To: (NSString *)Destination
{
    
    NSFileManager *FileManager = [[NSFileManager defaultManager] autorelease];
    
    if (![FileManager fileExistsAtPath: Destination])
        [FileManager createDirectoryAtPath: Destination attributes: nil];

    
    [FileManager movePath: [Origin stringByAppendingString: Mod] toPath: [Destination stringByAppendingString: Mod] handler: nil];
    
}

@end
