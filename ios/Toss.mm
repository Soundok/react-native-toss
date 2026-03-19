#import "Toss.h"

#if __has_include(<Toss/Toss-Swift.h>)
#import <Toss/Toss-Swift.h>
#else
#import "Toss-Swift.h"
#endif

@implementation Toss

+ (NSString *)moduleName
{
  return @"Toss";
}

- (void)configure:(NSString *)appKey
{
  [[TossLoginBridge shared] configureWithAppKey:appKey];
}

- (void)isLoginAvailable:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject
{
  BOOL available = [[TossLoginBridge shared] isLoginAvailable];
  resolve(@(available));
}

- (void)login:(NSString *)policy
      resolve:(RCTPromiseResolveBlock)resolve
       reject:(RCTPromiseRejectBlock)reject
{
  dispatch_async(dispatch_get_main_queue(), ^{
    [[TossLoginBridge shared] loginWithPolicy:policy
                                  completion:^(NSString * _Nullable authCode,
                                               NSString * _Nullable errorCode,
                                               NSString * _Nullable errorMessage,
                                               BOOL cancelled) {
      if (authCode != nil) {
        resolve(authCode);
      } else if (cancelled) {
        reject(@"CANCELLED", @"User cancelled login", nil);
      } else {
        reject(errorCode ?: @"UNKNOWN", errorMessage ?: @"Unknown error", nil);
      }
    }];
  });
}

- (void)moveToBridgePageForNoApp
{
  dispatch_async(dispatch_get_main_queue(), ^{
    [[TossLoginBridge shared] moveToBridgePageForNoApp];
  });
}

- (void)handleOpenUrl:(NSString *)url
              resolve:(RCTPromiseResolveBlock)resolve
               reject:(RCTPromiseRejectBlock)reject
{
  NSURL *nsUrl = [NSURL URLWithString:url];
  if (nsUrl != nil) {
    BOOL handled = [[TossLoginBridge shared] handleOpenUrl:nsUrl];
    resolve(@(handled));
  } else {
    reject(@"INVALID_URL", @"Invalid URL provided", nil);
  }
}

- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
    (const facebook::react::ObjCTurboModule::InitParams &)params
{
    return std::make_shared<facebook::react::NativeTossSpecJSI>(params);
}

@end
