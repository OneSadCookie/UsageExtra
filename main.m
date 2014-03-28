
#import <Cocoa/Cocoa.h>

int main(int argc, char const *argv[])
{
  @autoreleasepool {
    [NSUserDefaults.standardUserDefaults registerDefaults:@{@"normalizeCPUUsage":@YES}];
  }
  return NSApplicationMain(argc, argv);
}
