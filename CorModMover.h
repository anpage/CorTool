//
//  CorModMover.h
//  CorTool
//
//  Created by Frigid on 3/8/10.
//  Copyright 2010 OmniGreat Software Co.. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface CorModMover : NSObject {

    NSBundle *CCApp;
    
}

- (NSBundle *)CCApp;

- (void)setCCApp: (NSBundle *)aValue;

- (void)enableMod: (NSString *)ModFolder;

- (void)disableMod: (NSString *)ModFolder;

- (void)installMod;

- (void)installModFromPath: (NSString *)Path;

- (void)removeMod: (NSString *)ModFolder modName: (NSString *)ModName;

- (void)moveMod: (NSString *)Mod From: (NSString *)Origin To: (NSString *)Destination;

//- (void)dealloc;

@end
