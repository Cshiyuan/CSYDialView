//
//  dialView.h
//  EFAnimationMenu
//
//  Created by bb on 16/9/14.
//  Copyright © 2016年 Jueying. All rights reserved.
//

#import <UIKit/UIKit.h>

//typedef enum : NSUInteger {
//    YEAR,   //
//    MONTH,   //
//    DAY,
//    HOUR,
//    MINUTE
//} dia;

@protocol CSYDialViewDelegate <NSObject>

- (void) clickGoButtonView:(NSString *)string;

@end

#pragma mark - DialView
@interface CSYDialView : UIView

//@property (strong, nonatomic) IBOutlet UIView *dialView;

@property (weak, nonatomic) IBOutlet UIButton *goButton;

@property (assign, nonatomic) id<CSYDialViewDelegate> delegate;   //委托

-(int)getCurrentQueueNumber;

- (void) setButtonTitle:(NSArray*) titleArray;

+(instancetype)getDialViewFromXib;


@end



