#import "DeviceUptime.h"
#import <React/RCTLog.h>

#include <sys/sysctl.h>

@implementation DeviceUptime

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(getUptime:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
  resolve([NSString stringWithFormat:@"%ld", [self uptime]]); 
}

/**
 * Get the system up time in seconds
 *
 * Method originally from here:
 * http://stackoverflow.com/questions/12488481/getting-ios-system-uptime-that-doesnt-pause-when-asleep
 */
- (time_t)uptime
{
    struct timeval boottime;
    int mib[2] = {CTL_KERN, KERN_BOOTTIME};
    size_t size = sizeof(boottime);
    time_t now;
    time_t uptime = -1;

    (void) time(&now);

    if (sysctl(mib, 2, &boottime, &size, NULL, 0) != -1 && boottime.tv_sec != 0) {
        uptime = now - (boottime.tv_sec);
    }

    return uptime;
}

@end
