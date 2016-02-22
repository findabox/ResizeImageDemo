//
//  MZResizePhotos.m
//  MZResizePhotosDemo
//
//  Created by User on 2/19/16.
//  Copyright © 2016 User. All rights reserved.
//

#import "MZResizePhotosManager.h"
#import <AppKit/AppKit.h>

@interface MZResizePhotosManager()

@property (nonatomic, strong) NSURL *inputURL;

@property (nonatomic, strong) NSURL *outputURL;

@property (nonatomic, assign) NSNumber *photosWidth;

@property (nonatomic, assign) NSNumber *photosHeight;

@end

@implementation MZResizePhotosManager

+ (id)createResizePhotosManagerWithOption:(NSDictionary *)options
{
    MZResizePhotosManager *manager = [[MZResizePhotosManager alloc]init];
    
    if ([[options objectForKey:kRPInputURLKey] isKindOfClass:NSURL.class]) {
        manager.inputURL = [options objectForKey:kRPInputURLKey];
    }
    if ([[options objectForKey:kRPOutputURLKey] isKindOfClass:NSURL.class]) {
        manager.outputURL = [options objectForKey:kRPOutputURLKey];
    }
    if ([[options objectForKey:kRPPhotoWidth] isKindOfClass:NSNumber.class]) {
        manager.photosWidth = [options objectForKey:kRPPhotoWidth];
    }
    if ([[options objectForKey:kRPPhotoHeight] isKindOfClass:NSNumber.class]) {
        manager.photosHeight = [options objectForKey:kRPPhotoHeight];
    }
    
    return manager;
}

+ (NSError *)resizePhotosWithOption:(NSDictionary *)options complete:(void (^)(NSError *error))complete
{
    NSError *error;
    MZResizePhotosManager *manager = [MZResizePhotosManager createResizePhotosManagerWithOption:options];
    error = [manager verifyOptions];
    if (error) {
        return error;
    }
    [manager startResizeWithComplete:complete];
    return nil;
}

+ (BOOL)supportFileURL:(NSURL*)url
{
    return [MZResizePhotosManager fileTypeForURL:url] != -1;
}

+ (NSUInteger)fileTypeForURL:(NSURL *)url
{
    NSString *fileExt = [url pathExtension].lowercaseString;
    NSLog(@"%@", fileExt);
    NSBitmapImageFileType result;
    if ([fileExt isEqualToString:@"jp2"]) {
        result = NSJPEG2000FileType;
    } else if ([fileExt isEqualToString:@"jpeg"] || [fileExt isEqualToString:@"jpg"]) {
        result = NSJPEGFileType;
    } else if ([fileExt isEqualToString:@"tiff"]) {
        result = NSTIFFFileType;
    } else if ([fileExt isEqualToString:@"bmp"]) {
        result = NSBMPFileType;
    } else if ([fileExt isEqualToString:@"gif"]) {
        result = NSGIFFileType;
    } else if ([fileExt isEqualToString:@"png"]){
        result = NSPNGFileType;
    } else {
        result = -1;
    }
    return result;
}

- (NSError *)verifyOptions
{
    NSMutableString *domain = [NSMutableString stringWithString:@"Error:"];
    if (!self.inputURL &&
        ![self.inputURL isFileURL] &&
        [MZResizePhotosManager supportFileURL:self.inputURL]) {
        [domain appendString:@"Wrong Input! "];
    }
    if (!self.outputURL &&
        ![self.outputURL isFileURL] &&
        [MZResizePhotosManager supportFileURL:self.outputURL]) {
        [domain appendString:@"Wrong Output! "];
    }
    if (!self.photosWidth) {
        [domain appendString:@"Wrong Photo Width! "];
    }
    if (!self.photosHeight) {
        [domain appendString:@"Wrong Photo Height! "];
    }
    if ([domain isEqualToString:@"Error:"]) {
        return nil;
    }
    return [NSError errorWithDomain:domain code:0 userInfo:nil];
}

- (void)startResizeWithComplete:(void (^)(NSError *error))complete
{
    //read
    NSImage *sourceImage = [[NSImage alloc]initWithContentsOfURL:self.inputURL];
    
    //resize
    NSImage *newImage = [self resizeImage:sourceImage];
    
    //write
    NSError *error = [self writeImage:newImage];
    
    if (complete) {
        complete(error);
    }
}

- (NSImage *) resizeImage:(NSImage *)sourceImage
{
    NSSize newSize = NSMakeSize(self.photosWidth.floatValue, self.photosHeight.floatValue);
    NSImage *newImage = [[NSImage alloc]initWithSize:newSize];
    [newImage lockFocus];
    [sourceImage setSize:newSize];
    [[NSGraphicsContext currentContext] setImageInterpolation:NSImageInterpolationHigh];
    [sourceImage drawAtPoint:NSZeroPoint fromRect:CGRectMake(0, 0, newSize.width, newSize.height) operation:NSCompositeCopy fraction:1.0];
    [newImage unlockFocus];
    return newImage;
}

- (NSError *)writeImage:(NSImage *)image
{
    [image lockFocus] ;
    NSBitmapImageRep *imgRep = [[NSBitmapImageRep alloc] initWithFocusedViewRect:NSMakeRect(0.0, 0.0, image.size.width, image.size.height)] ;
    [image unlockFocus] ;
    NSBitmapImageFileType fileType = [MZResizePhotosManager fileTypeForURL:self.outputURL];
    NSData *data = [imgRep representationUsingType:fileType properties:@{}];
    NSError *error;
    BOOL success = [data writeToURL:self.outputURL
                           options:NSDataWritingAtomic
                             error:&error];
    if (!success) {
        return error;
    }
    return nil;
}

@end
