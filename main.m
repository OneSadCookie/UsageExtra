#import <Cocoa/Cocoa.h>

int main(int argc, char const *argv[])
{
    id pool = [[NSAutoreleasePool alloc] init];
    [[NSUserDefaults standardUserDefaults] registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
        [NSNumber numberWithBool:YES], @"normalizeCPUUsage",
        nil]];
    [pool drain];

    return NSApplicationMain(argc, argv);
}
