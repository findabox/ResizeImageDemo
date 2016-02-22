//
//  MZResizePhotos.h
//  MZResizePhotosDemo
//
//  Created by User on 2/19/16.
//  Copyright © 2016 User. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kRPInputURLKey @"kMZResizePhotosFilePathKey"
#define kRPOutputURLKey @"kMZResizePhotosOutPathKey"
#define kRPPhotoWidth @"kResizePhotosWidthKey"
#define kRPPhotoHeight @"kResizePhotosHeightKey"

@interface MZResizePhotosManager : NSObject

+ (NSError *)resizePhotosWithOption:(NSDictionary *)options complete:(void (^)(NSError *error))complete;

@end
