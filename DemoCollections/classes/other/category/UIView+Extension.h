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
/**
 * 返回传入veiw的所有层级结构
 *
 * @param view 需要获取层级结构的view
 *
 * @return 字符串
 */
+ (NSString *)digView:(UIView *)view level:(int)level;
@end
