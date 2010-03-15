//
//  CorDirectory.h
//  CorTool
//
//  Created by Frigid on 3/8/10.
//  Copyright 2010 OmniGreat Software Co.. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface CorDirectory : NSObject {

}

- (NSBundle *)findCCApp;

- (NSString *)findNewCCAppPathAllowDefault: (BOOL)AllowDefault;

- (void)findNewCCApp;

@end
