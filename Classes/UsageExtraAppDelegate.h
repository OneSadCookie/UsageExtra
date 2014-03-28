
@class                CPUMonitor ;
@interface UsageExtraAppDelegate : NSObject <NSApplicationDelegate>
{
                    NSStatusItem * item;
                      CPUMonitor * cpu;
             LSSharedFileListRef   loginItems;
         LSSharedFileListItemRef   loginItem;
}

@property (weak) IBOutlet NSMenu * menu;

- (IBAction)  openActivityMonitor:(id)x;
- (IBAction)         quitFromMenu:(id)x;

@end
