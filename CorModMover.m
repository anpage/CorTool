//
//  CorModMover.m
//  CorTool
//
//  Created by Frigid on 3/8/10.
//  Copyright 2010 OmniGreat Software Co.. All rights reserved.
//

#import "CorModMover.h"


@implementation CorModMover

@synthesize CCApp;

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
                
                [[NSFileManager defaultManager] removeItemAtPath: [[ResourcePath stringByAppendingString: @"/"] stringByAppendingString: [SelectedModPath lastPathComponent]] error: NULL];
                
                [[NSFileManager defaultManager] copyItemAtPath: SelectedModPath toPath: [[ResourcePath stringByAppendingString: @"/"] stringByAppendingString: [SelectedModPath lastPathComponent]] error: NULL];
            
            }
            
        }
        else
            [[NSFileManager defaultManager] copyItemAtPath: SelectedModPath toPath: [[ResourcePath stringByAppendingString: @"/"] stringByAppendingString: [SelectedModPath lastPathComponent]] error: NULL];
        
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
        [[NSFileManager defaultManager] removeItemAtPath: [[[CCApp resourcePath] stringByAppendingString: @"/"] stringByAppendingString: ModFolder] error: NULL];
    
}

- (void)moveMod: (NSString *)Mod From: (NSString *)Origin To: (NSString *)Destination
{
    
    NSFileManager *FileManager = [NSFileManager defaultManager];
    
    if (![FileManager fileExistsAtPath: Destination])
        [FileManager createDirectoryAtPath: Destination withIntermediateDirectories: NO attributes: nil error: NULL];

    
    [FileManager moveItemAtPath: [Origin stringByAppendingString: Mod] toPath: [Destination stringByAppendingString: Mod] error: NULL];
    
}

@end
