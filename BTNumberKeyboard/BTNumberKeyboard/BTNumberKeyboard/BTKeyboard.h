//
//  BTKeyboard.h
//  BTNumberKeyboard
//
//  Created by leishen on 2020/1/29.
//  Copyright © 2020 leishen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class BTKeyboard;
@protocol BTKeyboardDelegate <NSObject>

- (void)mkNumberKeyboard:(BTKeyboard*)numberKeyboard didSelectItem:(NSNumber*)item;

@end
@interface BTKeyboard : UIView

@property (nonatomic, weak) id<BTKeyboardDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
