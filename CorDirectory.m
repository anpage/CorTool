//
//  CorDirectory.m
//  CorTool
//
//  Created by Frigid on 3/8/10.
//  Copyright 2010 OmniGreat Software Co.. All rights reserved.
//

#import "CorDirectory.h"


@implementation CorDirectory

- (NSBundle *)findCCApp
{   
    
    NSBundle *CCApp = nil;
    
    NSString *CCAppPath = nil;
    
    NSString *Key = [[NSString alloc] initWithString:@"CorCCAppPath"];
    
    NSString *DefaultCCAppPath = [[NSUserDefaults standardUserDefaults] stringForKey:Key];
    
    if (DefaultCCAppPath != nil && [[[NSFileManager alloc] init] fileExistsAtPath: DefaultCCAppPath])
    {
        
        CCAppPath = [[NSString alloc] initWithString:DefaultCCAppPath];
        
    }
    else 
    {
        
        CCAppPath = [self findNewCCAppPathAllowDefault: YES];
        
        if (CCAppPath == nil)
            [NSApp terminate: NULL];
        
    }
    
    CCApp = [[NSBundle alloc] initWithPath:CCAppPath];
    
    return CCApp;
    
}

- (NSString *)findNewCCAppPathAllowDefault: (BOOL)AllowDefault
{
    NSString *CCAppPath = nil;
    
    NSString *Key = [[NSString alloc] initWithString:@"CorCCAppPath"];
    
    NSArray *DefaultApps = [[NSArray alloc] initWithObjects: @"/Applications/Cortex Command b23.app", @"/Applications/Cortex Command.app", nil];
    
    for (NSString *DefaultPath in DefaultApps)
    {
        
        if (AllowDefault && [[[NSFileManager alloc] init] fileExistsAtPath: DefaultPath])
            CCAppPath = DefaultPath;
        
    }
    
    if (CCAppPath == nil)
    {
        if (AllowDefault == YES)
        {
            
            NSAlert *Alert = [NSAlert alertWithMessageText:@"Select a Cortex Command App" 
                                             defaultButton: @"OK"
                                           alternateButton: nil
                                               otherButton: nil
                                 informativeTextWithFormat: @"You need to select the Cortex Command app file that you would like to modify."];
            
            [Alert runModal];
            
        }
        
        while (TRUE)
        {
            
            NSOpenPanel *OpenDlg = [NSOpenPanel openPanel];
            
            [OpenDlg setCanChooseFiles:YES];
            
            [OpenDlg setAllowsMultipleSelection:NO];
            
            [OpenDlg setTitle: @"Select a Cortex Command App to Modify"];
            
            if ([OpenDlg runModalForDirectory: @"/Applications" file:NULL types: [NSArray arrayWithObject: @"app"]] == NSOKButton)
                CCAppPath = [OpenDlg filename];
            else
                CCAppPath = nil;
            
            NSLog(@"%@", CCAppPath);
            
            if (CCAppPath == nil || [[[[NSBundle alloc] initWithPath:CCAppPath] bundleIdentifier] isEqualToString: @"com.datarealms.cortexcommand"])
                break;
            
            NSAlert *Alert = [[NSAlert alloc] init];
            
            [Alert addButtonWithTitle:@"OK"];
            
            [Alert setMessageText:@"Not a Cortex Command App"];
            
            [Alert setInformativeText:@"You must select a proper Cortex Command application bundle for CorTool to modify."];
            
            [Alert setAlertStyle:NSWarningAlertStyle];
            
            [Alert runModal];
            
        }
        
    }
    
    if (CCAppPath != nil)
    {
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        [defaults setObject:CCAppPath forKey:Key];
        
        [defaults synchronize];
        
    }    
    
    return CCAppPath;
    
}

- (void)findNewCCApp
{
    
    
    
}

@end
