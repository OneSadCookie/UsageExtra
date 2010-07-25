@interface UsageExtraAppDelegate : NSObject <NSApplicationDelegate>
{
    NSMenu       *menu;
    NSStatusItem *item;
    
    LSSharedFileListRef     loginItems;
    LSSharedFileListItemRef loginItem;
    
    unsigned long prevUsed;
    unsigned long prevTotal;
}

@property (assign) IBOutlet NSMenu *menu;

- (IBAction)openActivityMonitor:(id)sender;
- (IBAction)quitFromMenu:(id)sender;

@end
