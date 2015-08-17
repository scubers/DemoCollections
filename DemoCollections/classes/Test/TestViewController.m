//
//  TestViewController.m
//  DemoCollections
//
//  Created by mima on 15/8/5.
//  Copyright (c) 2015年 王俊仁. All rights reserved.
//

#import "TestViewController.h"
#import "UIView+Extension.h"
#import "Masonry.h"
#import "ReactiveCocoa.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <CoreLocation/CoreLocation.h>

@interface TestViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UITextView *tv;

@end

@implementation TestViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        
        [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            
            
            if ([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto])
            {
                NSLog(@"%@", [result valueForProperty:ALAssetPropertyURLs]);
                
                UIImage *img = [UIImage imageWithCGImage:[result defaultRepresentation].fullScreenImage];
                
                NSData *data = UIImageJPEGRepresentation(img, 0.1);
                
                img = [UIImage imageWithData:data];
                
                NSLog(@"%ld", data.length);
                
                UIImageView *view = [[UIImageView alloc] initWithImage:img];
                
                UIScrollView *sc = [[UIScrollView alloc] initWithFrame:self.view.bounds];
                
                sc.delegate = self;
                
                sc.zoomScale = 0.5;
                sc.maximumZoomScale = 1;
                sc.minimumZoomScale = 0.1;
                sc.contentSize = view.size;
                
                [sc addSubview:view];
                [self.view addSubview:sc];
                
                if (index == 2) {
                    *stop = YES;
                }
            }
            
        }];
        
    } failureBlock:^(NSError *error) {
        
    }];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return scrollView.subviews.firstObject;
}


- (void)dealloc
{
    NSLog(@"");
}


@end
