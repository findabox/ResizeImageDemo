//
//  ViewController.m
//  MZResizePhotosDemo
//
//  Created by User on 2/19/16.
//  Copyright © 2016 User. All rights reserved.
//

#import "ViewController.h"
#import "MZResizePhotosManager.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (IBAction)pressStartConvert:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSURL *inputURL = [NSURL fileURLWithPath:[defaults objectForKey:kRPInputURLKey]];
    NSURL *outputURL = [NSURL fileURLWithPath:[defaults objectForKey:kRPOutputURLKey]];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *width = [formatter numberFromString:[defaults objectForKey:kRPPhotoWidth]];
    NSNumber *height = [formatter numberFromString:[defaults objectForKey:kRPPhotoHeight]];
    
    NSDictionary *options =@{
                             kRPInputURLKey:inputURL,
                             kRPOutputURLKey:outputURL,
                             kRPPhotoWidth:width,
                             kRPPhotoHeight:height
                             };
    [MZResizePhotosManager resizePhotosWithOption:options complete:NULL];
}

@end
