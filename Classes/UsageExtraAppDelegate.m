
#import "CPUMonitor.h"
#import "UsageExtraAppDelegate.h"

@implementation UsageExtraAppDelegate

- (void)openAtLogIn {

    loginItems = LSSharedFileListCreate(
        kCFAllocatorDefault,
        kLSSharedFileListSessionLoginItems,
        NULL);
    if (!loginItems) return;
    loginItem = LSSharedFileListInsertItemURL(
        loginItems,
        kLSSharedFileListItemLast,
        NULL,
        NULL,
        (__bridge CFURLRef)[[NSBundle mainBundle] bundleURL],
        NULL,
        NULL);
}

- (void)dontOpenAtLogIn { if (!loginItems || !loginItem) return; LSSharedFileListItemRemove(loginItems, loginItem); }

- (void)applicationDidFinishLaunching:(NSNotification*)n {

    item                = [NSStatusBar.systemStatusBar statusItemWithLength:NSVariableStatusItemLength];
    cpu                 = CPUMonitor.new;
    item.highlightMode  = YES;
    item.menu           = _menu;
    [item bind:@"title" toObject:cpu withKeyPath:@"usage" options:nil];

    [self openAtLogIn];
}

- (void)openActivityMonitor:(id)x {

    [NSWorkspace.sharedWorkspace launchAppWithBundleIdentifier:@"com.apple.ActivityMonitor" options:0 additionalEventParamDescriptor:nil launchIdentifier:NULL];
}

- (IBAction)quitFromMenu:(id)x { [self dontOpenAtLogIn]; [NSApp terminate:x]; }

@end
