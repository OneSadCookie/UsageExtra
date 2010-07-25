#import <mach/mach.h>

#import "UsageExtraAppDelegate.h"

@implementation UsageExtraAppDelegate

- (void)getProcessorUsage:(unsigned long *)outUsed total:(unsigned long *)outTotal cpuCount:(unsigned long *)outCPUCount
{
	natural_t cpuCount;
	processor_info_array_t infoArray;
	mach_msg_type_number_t infoCount;

	kern_return_t error = host_processor_info(mach_host_self(),
		PROCESSOR_CPU_LOAD_INFO, &cpuCount, &infoArray, &infoCount);
	if (error) {
		mach_error("host_processor_info error:", error);
		abort();
	}

	processor_cpu_load_info_data_t* cpuLoadInfo =
		(processor_cpu_load_info_data_t*) infoArray;

	unsigned long totalTicks = 0;
	unsigned long usedTicks = 0;

	for (int cpu=0; cpu<cpuCount; cpu++)
		for (int state=0; state<CPU_STATE_MAX; state++) {
			unsigned long ticks = cpuLoadInfo[cpu].cpu_ticks[state];
			
			if (state != CPU_STATE_IDLE) usedTicks += ticks;
			totalTicks += ticks;
		}

	*outUsed = usedTicks;
	*outTotal = totalTicks;
    *outCPUCount = cpuCount;

	vm_deallocate(mach_task_self(), (vm_address_t)infoArray, infoCount);
}

- (void)update:(id)_
{
    unsigned long used, total, cpuCount;
    [self getProcessorUsage:&used total:&total cpuCount:&cpuCount];
    
    unsigned long diffUsed = used - prevUsed, diffTotal = total - prevTotal;
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"normalizeCPUUsage"])
    {
        diffTotal /= cpuCount;
    }
		
    prevUsed = used;
    prevTotal = total;
    
    [item setTitle:[NSString stringWithFormat:@"%d%%", (int)(100.0 * (double)diffUsed / (double)diffTotal)]];
}

- (void)openAtLogIn
{
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
        (CFURLRef)[[NSBundle mainBundle] bundleURL],
        NULL,
        NULL);
}

- (void)dontOpenAtLogIn
{
    if (!loginItems || !loginItem) return;
    LSSharedFileListItemRemove(loginItems, loginItem);
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSStatusBar *bar = [NSStatusBar systemStatusBar];
    
    item = [[bar statusItemWithLength:NSVariableStatusItemLength] retain];
    [item setTitle:@"CPU%"];
    [item setHighlightMode:YES];
    [item setMenu:menu];
    
    unsigned long cpuCount;
    [self getProcessorUsage:&prevUsed total:&prevTotal cpuCount:&cpuCount];
    [self openAtLogIn];
    [self update:nil];
    
    [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(update:) userInfo:nil repeats:YES];
}

- (void)openActivityMonitor:(id)sender
{
    [[NSWorkspace sharedWorkspace] launchAppWithBundleIdentifier:@"com.apple.ActivityMonitor" options:0 additionalEventParamDescriptor:nil launchIdentifier:NULL];
}

- (IBAction)quitFromMenu:(id)sender
{
    [self dontOpenAtLogIn];
    [NSApp terminate:sender];
}

@synthesize menu;

@end
