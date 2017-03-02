//
//  dialView.m
//  EFAnimationMenu
//
//  Created by bb on 16/9/14.
//  Copyright © 2016年 Jueying. All rights reserved.
//

#import "CSYDialView.h"


//#define RADIUS 110.0  //旋转半径
#define BUNTTONNUM 7
//#define TAGTOP 1003
#define TAGSTART 1001   //tag标志从1001开始计数
#define TIME 1.25
#define SCALENUMBER 1
//#define T = 0.1 * 2.0 * M_PI   //偏移角度

int queueArray [BUNTTONNUM][BUNTTONNUM] = {
    {5,6,0,1,2,3,4},
    {4,5,6,0,1,2,3},
    {3,4,5,6,0,1,2},
    {2,3,4,5,6,0,1},
    {1,2,3,4,5,6,0},
    {0,1,2,3,4,5,6},
    {6,0,1,2,3,4,5},
};

@interface CSYDialView ()

@property (nonatomic, assign) CGPoint preMovePoint;           //充当辅助的记录点
@property (nonatomic, assign) int currentQueueNumber;         //当前队列的编号
@property (nonatomic, assign) float angleAddUp;               //角度累加

@property NSArray *titleArray;            //标题数组
@property NSArray *imageArray;            //图片数组

//@property (nonatomic, assign) NSInteger buttonNum;          //按钮数量
//@property (nonatomic, weak) NSMutableArray *queueArray;     //辅助的队列数组
@property (nonatomic ,assign) float radius;                   //半径

@end

@implementation CSYDialView



+ (instancetype)getDialViewFromXib{
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *className = NSStringFromClass([self class]);
    NSArray *objs = [bundle loadNibNamed:className owner:nil options:nil];
    return [objs lastObject];
    
}


- (IBAction)clickGoButton:(id)sender {

    NSLog(@"%@", self.titleArray[self.currentQueueNumber]);
    if([self.delegate respondsToSelector:@selector(clickGoButtonView:)])
    {
        //send the delegate function with the amount entered by the user
        //将当前被选中的标题传递进去
        [self.delegate clickGoButtonView:self.titleArray[self.currentQueueNumber]];
    }
}

/**
 设置dialView显示的按钮
 
 @param titleArray 必须为NSString类型
 */
- (void) setButtonTitle:(NSArray*) titleArray
{
    
    if(titleArray.count == BUNTTONNUM)
    {
        //重新设置titleArray
        self.titleArray = titleArray;
        //删除所有子图
        for (NSInteger i = 0; i < BUNTTONNUM; i++) {
            UIView *subViews = [self viewWithTag:TAGSTART+i];
            [subViews removeFromSuperview];
        }
        //[self.dialView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        //刷新视图
        [self configViews];
    }
}

/**
 返回当前队列的队列编号，也就等于被选中的button
 
 @return 返回队列编号
 */
-(int)getCurrentQueueNumber
{
    return self.currentQueueNumber;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    NSLog(@"dialView awake from nib!");
    
//    NSString *className = NSStringFromClass([self class]);
    //初始化子控件
//    [[NSBundle mainBundle] loadNibNamed:className owner:self options:nil];
}
- (void)drawRect:(CGRect)rect
{
    NSLog(@"diaView drawRect！");
    
    [super drawRect:rect];
    
    for (NSInteger i = 0; i < BUNTTONNUM; i++) {

        UIButton *buttonView = [self viewWithTag:TAGSTART + i];
        
        if(buttonView)
        {
            buttonView.backgroundColor = [UIColor whiteColor];
            buttonView.layer.borderWidth = 1;
            buttonView.layer.borderColor = [UIColor blackColor].CGColor;
        

        }
    }
    
//    [self addSubview:self.dialView];
//    CGRect subRect = self.frame;
//    subRect.origin.x = 0;
//    subRect.origin.y = 0;
////    self.dialView.frame = subRect;
    
//        [self configViews];
}



//重写initWithCoder:用代码添加子控件
- (id)initWithCoder:(NSCoder *)aDecoder {

    if (self = [super initWithCoder:aDecoder]) {
        
        self.titleArray = [NSArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7", nil];
        
        //如需要修改，请将如下image改为自己的图片
        self.imageArray = [NSArray arrayWithObjects:@"home_a4_r21_c7",@"home_a4_r8_c8",@"home_a4_r12_c8",@"home_a4_r16_c8",@"home_a4_r10_c8",@"home_a4_r14_c8",@"home_a4_r18_c8",nil];
        //添加当前点队列状态
        self.currentQueueNumber = 0;
        //    [self configViews];
        
        //添加拖动手势
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
        [self addGestureRecognizer:panGesture];

        [self configViews];
    }
    
    return self;
}

//给子控件布局
- (void)layoutSubviews {
    
    //一定要调用父类的layoutSubviews方法
    [super layoutSubviews];
    
    NSLog(@"layoutSubviews");
    
    self.radius = self.frame.size.width * 0.3482;
    
//    CGFloat centery = self.center.y;  //转动的中心
//    CGFloat centerx = self.center.x;
    CGFloat centery = self.frame.size.width/2;
    CGFloat centerx = self.frame.size.width/2;
    //NSString *arrayTitle[]= {self.titleArray[1],@"Button1",@"Button2",@"Button3",@"Button4",@"Button5",@"Button6"};
    float buttonViewRadius = (self.frame.size.width * 0.3035) * 0.9;  //计算圆按钮的直径
    
    for (NSInteger i = 0; i < BUNTTONNUM; i++) {
        
        
        //这个tag应该放置的位置
        CGFloat tmpy =  centery + self.radius * cos(2.0 * M_PI * queueArray[self.currentQueueNumber][i] / BUNTTONNUM + 0.040*2.0*M_PI);
        CGFloat tmpx =	centerx - self.radius * sin(2.0 * M_PI * queueArray[self.currentQueueNumber][i] / BUNTTONNUM + 0.040*2.0*M_PI);
        
        UIButton *buttonView = [self viewWithTag:TAGSTART + i];

        buttonView.layer.cornerRadius = buttonViewRadius/2;
        buttonView.frame = CGRectMake(0.0, 0.0, buttonViewRadius, buttonViewRadius);
        buttonView.center = CGPointMake(tmpx, tmpy);

        buttonView.backgroundColor = [UIColor colorWithRed:164.0/255.0 green:206.0/255.0 blue:238.0/255.0 alpha:1];
        buttonView.layer.borderWidth = 1;
        buttonView.layer.borderColor = [UIColor colorWithRed:115.0/255.0 green:166.0/255.0 blue:56.0/255.0 alpha:1].CGColor;
        
        //调整图片和文字的为上下摆放
        [self setImageAndTitleLeft:0.0 button:buttonView];
    }


}

/**
 *  初始化视图
 */
- (void)configViews
{
    
    NSLog(@"configViews");
    
    for (NSInteger i = 0; i < BUNTTONNUM; i++) {
        
        //如果已经画出就不用在画了。
        UIView *view = [self viewWithTag:TAGSTART + i];
        if(view)
            return;

        //根据tag查找
        //创建圆角buttonView
        UIButton *buttonView = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        //获取图片
        UIImage *image = [UIImage imageNamed:self.imageArray[i]];
        //使得图片不被渲染，保持原来颜色
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        //插入图片
        [buttonView setImage:image forState:UIControlStateNormal];
        
        //设置标题
        [buttonView setTitle:self.titleArray[i] forState:UIControlStateNormal];
        //设置标题字体大小
        buttonView.titleLabel.font = [UIFont systemFontOfSize: 10.0];
        //设置tag
        [buttonView setTag:TAGSTART+i];
        //设置按钮大小
//        buttonView.frame = CGRectMake(0.0, 0.0, buttonViewRadius, buttonViewRadius);
        
        //NSLog(@"%f",self.frame.size.width * 0.3035);
        //设置圆形
        //设置背景颜色
        buttonView.backgroundColor = [UIColor colorWithRed:164.0/255.0 green:206.0/255.0 blue:238.0/255.0 alpha:1];
        buttonView.layer.borderWidth = 1;
        buttonView.layer.borderColor = [UIColor colorWithRed:115.0/255.0 green:166.0/255.0 blue:56.0/255.0 alpha:1].CGColor;
//        buttonView.layer.cornerRadius = buttonViewRadius/2;
        buttonView.layer.masksToBounds = YES;
        [buttonView setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
        
        //设置UIButton不能与用户交互
        buttonView.userInteractionEnabled = false;
        
        //设置按钮应该所处于的位置
//        buttonView.center = CGPointMake(tmpx, tmpy);
        

        
        //并不添加到dialView中，而是直接添加到自身的类
        [self addSubview:buttonView];
    }
    
}

#pragma mark - panGesture
/**
 *  panGesture手势响应事件
 *
 *  @param sender UIPanGestureRecoginzer
 */
-(void) panGesture:(id)sender
{
    UIPanGestureRecognizer *panGesture = sender;
    
    if(panGesture.state == UIGestureRecognizerStateBegan)
    {
        NSLog(@"UIGestureRecognizerStateBegan");
        self.preMovePoint = CGPointMake(0, 0);
        self.angleAddUp = 0;                      //清空累积的角度数
    }
    
    CGPoint currentmovePoint = [panGesture translationInView:self];
    
    CGPoint movePoint = CGPointMake(currentmovePoint.x - self.preMovePoint.x, currentmovePoint.y - self.preMovePoint.y);
    self.preMovePoint = currentmovePoint;
    
  //  NSLog(@"%@",NSStringFromCGPoint(movePoint));
    
    CGPoint currentStartPoint = [panGesture locationInView:self];
    CGPoint currentEndPoint = CGPointMake(currentStartPoint.x + movePoint.x, currentStartPoint.y + movePoint.y);
    
    //获得旋转中心
    CGPoint center = CGPointMake(self.frame.size.width/2, self.frame.size.width/2);
    
    float lengthCen2Start = [self distanceFromPointX:center distanceToPointY:currentStartPoint];
    float lengthCen2End = [self distanceFromPointX:center distanceToPointY:currentEndPoint];
    float lengthStart2End = [self distanceFromPointX:currentStartPoint distanceToPointY:currentEndPoint];
    
    //利用公式计算cos值
    float cosValue = (lengthCen2Start  * lengthCen2Start + lengthCen2End * lengthCen2End - lengthStart2End*lengthStart2End)/(2*lengthCen2Start*lengthCen2End);
    
    //利用acos函数返回弧度
  //  NSLog(@"cosValue %f",cosValue);
    double angle = acos(cosValue);
    
    //第一象限
    if((currentStartPoint.x < center.x) && (currentStartPoint.y < center.y) && (currentEndPoint.x < center.x) && (currentEndPoint.y < center.y))
    {
        
        if(fabs(movePoint.x)/fabs(movePoint.y) >= 1)   //x的权重比较大
        {
            if(movePoint.x > 0)       //往右，顺时针
            {
                angle = angle;
            }
            else                      //否则往左，逆时针
            {
                angle = -1 * angle;
            }
        }
        else                         //y的权重比较大
        {
            if(movePoint.y > 0)      //向下，逆时针
            {
                angle = -1 * angle;
            }
            else                     //向上，顺时针
            {
                angle = angle;
            }
        }
    }
    //第二象限
    if((currentStartPoint.x > center.x) && (currentStartPoint.y < center.y) && (currentEndPoint.x > center.x) && (currentEndPoint.y < center.y))
    {
        
        if(fabs(movePoint.x)/fabs(movePoint.y) >= 1)   //x的权重比较大
        {
            if(movePoint.x > 0)       //往右，顺时针
            {
                angle = angle;
            }
            else                      //否则往左，逆时针
            {
                angle = -1 * angle;
            }
        }
        else                         //y的权重比较大
        {
            if(movePoint.y > 0)      //向下，顺时针
            {
                angle = angle;
            }
            else                     //向上，逆时针
            {
                angle = -1 * angle;
            }
        }
    }
    //第三象限
    if((currentStartPoint.x < center.x) && (currentStartPoint.y > center.y) && (currentEndPoint.x < center.x) && (currentEndPoint.y > center.y))
    {
        
        if(fabs(movePoint.x)/fabs(movePoint.y) >= 1)   //x的权重比较大
        {
            if(movePoint.x > 0)       //往右，逆时针
            {
                angle = -1 * angle;
            }
            else                      //否则往左，顺时针
            {
                angle = angle;
            }
        }
        else                         //y的权重比较大
        {
            if(movePoint.y > 0)      //向下，逆时针
            {
                angle = -1 * angle;
            }
            else                     //向上，顺时针
            {
                angle = angle;
            }
        }
    }
    //第四象限
    if((currentStartPoint.x > center.x) && (currentStartPoint.y > center.y) && (currentEndPoint.x > center.x) && (currentEndPoint.y > center.y))
    {
        
        if(fabs(movePoint.x)/fabs(movePoint.y) >= 1)   //x的权重比较大
        {
            if(movePoint.x > 0)       //往右，逆时针
            {
                angle = -1 * angle;
            }
            else                      //否则往左，顺时针
            {
                angle = angle;
            }
        }
        else                         //y的权重比较大
        {
            if(movePoint.y > 0)      //向下，顺时针
            {
                angle = angle;
            }
            else                     //向上，逆时针
            {
                angle = -1 * angle;
            }
        }
    }
    //开始点在第一象限，结束点在第三象限
    if((currentStartPoint.x < center.x) && (currentStartPoint.y < center.y) && (currentEndPoint.x < center.x) && (currentEndPoint.y > center.y))
        angle = -1 * angle;
    //开始点在第二象限，结束点在第四象限
    if((currentStartPoint.x < center.x) && (currentStartPoint.y > center.y) && (currentEndPoint.x > center.x) && (currentEndPoint.y > center.y))
        angle = -1 * angle;
    //开始点在第四象限，结束点在第二象限
    if((currentStartPoint.x > center.x) && (currentStartPoint.y > center.y) && (currentEndPoint.x > center.x) && (currentEndPoint.y < center.y))
        angle = -1 * angle;
    //开始点在第二象限，结束点在第一象限
    if((currentStartPoint.x > center.x) && (currentStartPoint.y < center.y) && (currentEndPoint.x < center.x) && (currentEndPoint.y < center.y))
        angle = -1 * angle;
    
    
    for (NSInteger i = 0; i < BUNTTONNUM; i++) {
        UIView *view = [self viewWithTag:TAGSTART + i];
        
        //切换UIButton的旋转中心
        [self correctAnchorPointForView:view];
        //开始旋转按钮围绕dialView图层中心
        view.transform = CGAffineTransformRotate(view.transform, angle);
        //将anchorPoint默认
        [self setDefaultAnchorPointforView:view];
        // 使按钮旋转，使得按钮保持水平
        view.transform = CGAffineTransformRotate(view.transform, -angle);
        // 将anchorPoint设置为默认
        [self setDefaultAnchorPointforView:view];
        
    }
    
    
    self.angleAddUp = self.angleAddUp + angle;
    
    
    if(panGesture.state == UIGestureRecognizerStateEnded)  //如果panGesture结束
    {
        
        //计算累积角度
        int num = -1 * ((self.angleAddUp) / ((2*M_PI)/BUNTTONNUM));
        //进行一个预测移位
        float num2 = self.angleAddUp + (num * ((2*M_PI)/BUNTTONNUM));
        NSLog(@"%f", ((2*M_PI)/BUNTTONNUM));
        float num3 = ((2*M_PI)/BUNTTONNUM) * 0.5;
        if(num2 > num3)
            num = num - 1;
        
        int tempCurrentQueueNumber = self.currentQueueNumber + num;
        if(tempCurrentQueueNumber > 6)
        {
            tempCurrentQueueNumber = tempCurrentQueueNumber % 7;
        }
        if(tempCurrentQueueNumber < 0)
        {
            //取绝对值
            tempCurrentQueueNumber = abs(tempCurrentQueueNumber);
            tempCurrentQueueNumber = tempCurrentQueueNumber % 7;
            
            if(tempCurrentQueueNumber == 0)
                tempCurrentQueueNumber = 0;
            else
                tempCurrentQueueNumber = 7 - tempCurrentQueueNumber;
        }
        
        self.currentQueueNumber = tempCurrentQueueNumber;
        NSLog(@"currentQueueNumber is %d",self.currentQueueNumber);
        NSLog(@"currentQueueNumber is %@",self.titleArray[self.currentQueueNumber]);
        
        //末尾对准的
        for(int i = 0; i < BUNTTONNUM; i++)
        {
            [self ajustButtonViewPoint:i];
        }
    }
    
}
/**
 *  获得两点之间的距离
 *
 *  @param start 开始的CGPoint
 *  @param end   结束的CGPoint
 *
 *  @return 返回两点的距离
 */
-(float)distanceFromPointX:(CGPoint)start distanceToPointY:(CGPoint)end{
    float distance;
    CGFloat xDist = (end.x - start.x);
    CGFloat yDist = (end.y - start.y);
    distance = sqrt((xDist * xDist) + (yDist * yDist));
    return distance;
}

/**
 *  调整View对应所在队列应该在的位置
 *
 *  @param i 对应的UIButton的tag
 */
-(void)ajustButtonViewPoint:(int)i
{
    UIView *view = [self viewWithTag:TAGSTART + i];
    
    CGFloat centery = self.frame.size.width/2;
    CGFloat centerx = self.frame.size.width/2;
    
    
    //这个tag应该放置的位置应该在 array[self.currentQueueNumber][i]
    CGFloat tmpy =  centery + self.radius * cos(2.0 * M_PI * queueArray[self.currentQueueNumber][i] / BUNTTONNUM + 0.040 * 2.0 * M_PI);
    CGFloat tmpx =	centerx - self.radius * sin(2.0 * M_PI * queueArray[self.currentQueueNumber][i] / BUNTTONNUM + 0.040 * 2.0 * M_PI );
    
    //NSLog(@"view.center is %@  and %f , %f",NSStringFromCGPoint(view.center),tmpx,tmpy);
    
    
    view.center = CGPointMake(tmpx,tmpy);
    
}

#pragma mark - anchorPointTransformTools
/**
 *  对UIView设置指定的anchorPoint
 *
 *  @param anchorPoint 对UIView要设定的anchorPoint
 *  @param view        被设定的UIView
 */
- (void)setAnchorPoint:(CGPoint)anchorPoint forView:(UIView *)view
{
    CGPoint oldOrigin = view.frame.origin;
    view.layer.anchorPoint = anchorPoint;
    CGPoint newOrigin = view.frame.origin;
    
    CGPoint transition;
    transition.x = newOrigin.x - oldOrigin.x;
    transition.y = newOrigin.y - oldOrigin.y;
    
    view.center = CGPointMake (view.center.x - transition.x, view.center.y - transition.y);
}
/**
 *  恢复视图的默认anchorPoint
 *
 *  @param view 要恢复默认anchorPoint的UIView
 */
- (void)setDefaultAnchorPointforView:(UIView *)view
{
    [self setAnchorPoint:CGPointMake(0.5f, 0.5f) forView:view];
}
/**
 *  设定旋转的中心
 *
 *  @param view UIView
 */
- (void)correctAnchorPointForView:(UIView *)view
{
    CGPoint anchorPoint = CGPointZero;
    CGPoint superviewCenter = view.superview.center;
    //   superviewCenter是view的superview 的 center 在view.superview.superview中的坐标。
    CGPoint viewPoint = [view convertPoint:superviewCenter fromView:view.superview.superview];
    //   转换坐标，得到superviewCenter 在 view中的坐标
    anchorPoint.x = (viewPoint.x) / view.bounds.size.width;
    anchorPoint.y = (viewPoint.y) / view.bounds.size.height;
    
    [self setAnchorPoint:anchorPoint forView:view];
}

/**
 利用imageEdgeInset属性和titleEdgeInsets属性
 设置UIButton为上下摆放
 
 @param spacing 间距
 @param Button  要设置的button
 */
- (void)setImageAndTitleLeft:(float)spacing button:(UIButton*)Button {
    CGSize imageSize = Button.imageView.frame.size;
    CGSize titleSize = Button.titleLabel.frame.size;
    
    CGFloat totalHeight = (imageSize.height + titleSize.height + spacing);
    
    Button.imageEdgeInsets = UIEdgeInsetsMake( - (totalHeight - imageSize.height), 0.0, 0.0, - titleSize.width);
    
    Button.titleEdgeInsets = UIEdgeInsetsMake( 0.0, - imageSize.width, - (totalHeight - titleSize.height), 0.0);
}
@end;


