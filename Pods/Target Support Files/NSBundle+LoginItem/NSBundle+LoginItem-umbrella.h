#ifdef __OBJC__
#import <Cocoa/Cocoa.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "NSBundle+LoginItem.h"

FOUNDATION_EXPORT double NSBundle_LoginItemVersionNumber;
FOUNDATION_EXPORT const unsigned char NSBundle_LoginItemVersionString[];

