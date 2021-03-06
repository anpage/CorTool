//
//  CorToolAppDelegate.h
//  CorTool
//
//  Created by Frigid on 3/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#if (MAC_OS_X_VERSION_MAX_ALLOWED <= MAC_OS_X_VERSION_10_4)
@interface CorToolAppDelegate : NSObject
#else
@interface CorToolAppDelegate : NSObject <NSApplicationDelegate>
#endif
{
    IBOutlet NSWindow *window;
}

//@property (assign) IBOutlet NSWindow *window;

- (NSWindow *)window;

- (void)setWindow:(NSWindow *)aValue;

@end
