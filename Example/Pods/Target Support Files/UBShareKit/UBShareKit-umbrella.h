#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "UBShareKit.h"
#import "UBDefaultShareView.h"
#import "UBShareButton.h"
#import "UIView+imageCorner.h"
#import "UBShareKitDataGetter.h"
#import "UBShareResources.h"
#import "UBShareView.h"
#import "UBShareViewController.h"
#import "UBShareViewControllerDelegate.h"
#import "UBWeakQueue.h"
#import "UBShareActivitiesControl.h"
#import "UBShareKitCore.h"
#import "UBShareModel.h"

FOUNDATION_EXPORT double UBShareKitVersionNumber;
FOUNDATION_EXPORT const unsigned char UBShareKitVersionString[];

