//
//  CorModScanner.h
//  CorTool
//
//  Created by Frigid on 3/8/10.
//  Copyright 2010 OmniGreat Software Co.. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface CorModScanner : NSObject {
    
    NSBundle *CCApp;

}

@property (readwrite, assign) NSBundle *CCApp;

- (NSArray *)getModArray;

- (NSArray *)scanInFolder: (NSString *)Path withStatus: (BOOL)Enabled;

- (NSString *)valueForEntry: (NSString *)Entry inIniFile: (NSString *)File;

@end