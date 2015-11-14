//
//  QTCalendarViewController.h
//  DemoCollections
//
//  Created by mima on 15/11/13.
//  Copyright © 2015年 王俊仁. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QTCalendarViewController;

typedef void(^QTCalendarViewControllerCompleteBlock)(QTCalendarViewController *controller ,NSDate *date);

@protocol QTCalendarViewControllerDelegate <NSObject>

- (void)calendarViewController:(QTCalendarViewController *)calendarController didSelectedDate:(NSDate *)date;

@end



@interface QTCalendarViewController : UITableViewController

@property (nonatomic, weak) id<QTCalendarViewControllerDelegate> delegate;

- (instancetype)initWithComplete:(QTCalendarViewControllerCompleteBlock)complete;
- (instancetype)initWithDate:(NSDate *)date complete:(QTCalendarViewControllerCompleteBlock)complete;

@end
