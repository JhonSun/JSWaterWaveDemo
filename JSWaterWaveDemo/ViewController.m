//
//  ViewController.m
//  JSWaterWaveDemo
//
//  Created by lianditech on 2017/8/22.
//  Copyright © 2017年 lianditech. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@property (nonatomic, strong) CAShapeLayer *shapeLayer1;
@property (nonatomic, strong) CAShapeLayer *maskLayer;
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, assign) CGFloat radius;//圆的半径
@property (nonatomic, assign) CGFloat A;
@property (nonatomic, assign) CGFloat ω;
@property (nonatomic, assign) CGFloat φ;
@property (nonatomic, assign) CGFloat speed;
@property (nonatomic, assign) CGFloat h;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*
     y = Asin(ωx + φ);
     A:波峰
     ω：周期
     φ：初相位
     h：高度
     */
    
    self.radius = 150;
    self.speed = 0.1;
    self.φ = M_PI;
    self.h = 300;
    self.A = 10;
    self.ω = 2 * M_PI / self.view.frame.size.width;
    
    CAShapeLayer *circleShapeLayer = [CAShapeLayer layer];
    circleShapeLayer.fillColor = [UIColor greenColor].CGColor;
    [self.view.layer addSublayer:circleShapeLayer];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddArc(path, NULL, self.view.center.x, self.view.center.y, self.radius,  0, M_PI * 2, YES);
    circleShapeLayer.path = path;
    
    self.shapeLayer = [CAShapeLayer layer];
    self.shapeLayer.fillColor = [UIColor whiteColor].CGColor;
    self.shapeLayer.opacity = 0.7;
    [self.view.layer addSublayer:self.shapeLayer];
    self.shapeLayer.mask = self.maskLayer;
    
    self.shapeLayer1 = [CAShapeLayer layer];
    self.shapeLayer1.fillColor = [UIColor whiteColor].CGColor;
    self.shapeLayer1.opacity = 0.8;
    [self.view.layer addSublayer:self.shapeLayer1];
    self.shapeLayer1.mask = self.maskLayer;
    
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(currentWave)];
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)currentWave {
    //第一条波浪线
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, self.h);
    CGFloat y = 0.f;
    for (CGFloat x = 0; x <= self.view.frame.size.width;x++) {
        y = self.A * sin(self.ω * x + self.φ) + self.h;
        CGPathAddLineToPoint(path, NULL, x, y);
    }
    CGPathAddLineToPoint(path, NULL, self.view.frame.size.width, self.view.frame.size.height);
    CGPathAddLineToPoint(path, NULL, 0, self.view.frame.size.height);
    CGPathCloseSubpath(path);
    self.shapeLayer.path = path;
    CGPathRelease(path);
    
    //第二条波浪线
    CGMutablePathRef path1 = CGPathCreateMutable();
    CGPathMoveToPoint(path1, NULL, 0, self.h);
    CGFloat y1 = 0.f;
    for (CGFloat x1 = 0; x1 <= self.view.frame.size.width;x1++) {
        y1 = self.A * sin(self.ω * x1 + self.φ + M_PI / 4) + self.h;
        CGPathAddLineToPoint(path1, NULL, x1, y1);
    }
    CGPathAddLineToPoint(path1, NULL, self.view.frame.size.width, self.view.frame.size.height);
    CGPathAddLineToPoint(path1, NULL, 0, self.view.frame.size.height);
    CGPathCloseSubpath(path1);
    self.shapeLayer1.path = path1;
    CGPathRelease(path1);
    self.φ -= self.speed;
}

#pragma mark - lazy
- (CAShapeLayer *)maskLayer {
    if (!_maskLayer) {
        _maskLayer = [CAShapeLayer layer];
        CGMutablePathRef maskPath = CGPathCreateMutable();
        CGPathAddArc(maskPath, NULL, self.view.center.x, self.view.center.y, self.radius,  0, M_PI * 2, YES);
        _maskLayer.path = maskPath;
    }
    return _maskLayer;
}


@end
