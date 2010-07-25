//
//  UsageExtraAppDelegate.h
//  UsageExtra
//
//  Created by Keith Bauer on 24/07/10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//


@interface UsageExtraAppDelegate : NSObject <NSApplicationDelegate>
{
    NSMenu       *menu;
    NSStatusItem *item;
    
    unsigned long prevUsed;
    unsigned long prevTotal;
}

@property (assign) IBOutlet NSMenu *menu;

- (IBAction)openActivityMonitor:(id)sender;

@end

