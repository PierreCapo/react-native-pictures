#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(Pictures, NSObject)

RCT_EXTERN_METHOD(openPictureViewer:(NSString)url
                  withResolver:(RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject)

+ (BOOL)requiresMainQueueSetup
{
  return NO;
}

@end
