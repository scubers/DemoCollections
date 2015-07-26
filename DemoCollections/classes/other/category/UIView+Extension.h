//
//  UIView+Extension.h
//

#import <UIKit/UIKit.h>

@interface UIView (Extension)
@property (assign, nonatomic          ) CGFloat x;
@property (assign, nonatomic          ) CGFloat y;
@property (assign, nonatomic, readonly) CGFloat maxX;
@property (assign, nonatomic, readonly) CGFloat maxY;
@property (assign, nonatomic          ) CGFloat width;
@property (assign, nonatomic          ) CGFloat height;
@property (assign, nonatomic          ) CGSize  size;
@property (assign, nonatomic          ) CGPoint origin;
@end
