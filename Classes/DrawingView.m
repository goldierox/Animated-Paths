//
//  DrawingView.m
//  AnimatedPaths
//
//  Created by Seth on 6/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DrawingView.h"

@interface DrawingView ()

@property (nonatomic, retain) UIBezierPath *drawingPath;
@property (nonatomic, retain) UIColor *brushColor;
@property (nonatomic, retain) CALayer *animationLayer;
@property (nonatomic, retain) CAShapeLayer *pathLayer;
@property (nonatomic, readonly) CGPathRef pathToAnimate;

@end

@implementation DrawingView

@dynamic pathToAnimate;
@synthesize drawingPath=_drawingPath;
@synthesize brushColor=_brushColor;
@synthesize animatingPlayback=_animatingPlayback;
@synthesize animationLayer=_animationLayer;
@synthesize pathLayer=_pathLayer;
@synthesize delegate=_delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [self.brushColor setStroke];
    
    if (self.isAnimatingPlayback) {
        [self startAnimation];
    }
    else {
        // The brush paths should be stored in the controller, not the view
        for (UIBezierPath *path in [self.delegate brushPaths]) {
            [path strokeWithBlendMode:kCGBlendModeNormal alpha:1.0];
        }
        [self.drawingPath strokeWithBlendMode:kCGBlendModeNormal alpha:1.0];
    }

}

- (void) setupDrawingLayer
{
    if (self.animationLayer == nil) {
        self.animationLayer = [CALayer layer];
        
        CGRect animationFrame = self.frame;
        animationFrame.origin.x = 0;
        animationFrame.origin.y = 0;
        self.animationLayer.frame = animationFrame;
        [self.layer addSublayer:self.animationLayer];
    }
    
    if (self.pathLayer != nil) {
        [self.pathLayer removeFromSuperlayer];
        self.pathLayer = nil;
    }
    
    CAShapeLayer *pathLayer = [CAShapeLayer layer];
    pathLayer.frame = self.animationLayer.frame;
    pathLayer.bounds = self.animationLayer.bounds;
    pathLayer.geometryFlipped = NO;
    pathLayer.strokeColor = [[UIColor blackColor] CGColor];
    pathLayer.fillColor = nil;
    pathLayer.lineWidth = 10.0f;
    pathLayer.lineJoin = kCALineJoinBevel;
    
    [self.animationLayer addSublayer:pathLayer];
    
    self.pathLayer = pathLayer;
}
         
 - (void) startAnimation
 {
     [self.pathLayer removeAllAnimations];
     
     UIBezierPath *combinedPath = [UIBezierPath bezierPath];
     for (UIBezierPath *path in [self.delegate brushPaths]) {
         [combinedPath appendPath:path];
     }
     [self setPathStyles:self.drawingPath];
     self.pathLayer.path = combinedPath.CGPath;
     
     CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
     pathAnimation.duration = 3.0;
     pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
     pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
     pathAnimation.delegate = self;
     [self.pathLayer addAnimation:pathAnimation forKey:@"strokeEnd"];
 }

- (void) animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    self.animatingPlayback = NO;
    [self setupDrawingLayer];
    [self setNeedsDisplay];
}

- (void) setPathStyles:(UIBezierPath *)path {
    path.lineCapStyle = kCGLineCapRound;
    path.miterLimit = 0;
    path.lineWidth = 10;
}

#pragma mark - Touch Methods
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *mytouch = [[touches allObjects] objectAtIndex:0];
    if (self.drawingPath == nil) {
        self.drawingPath = [[UIBezierPath alloc] init];
        [self setPathStyles:self.drawingPath];
    }
    else {
        NSLog(@"drawingPath should be nil at this point!");
    }
    
    [self.drawingPath moveToPoint:[mytouch locationInView:self]];
    
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    UITouch *mytouch = [[touches allObjects] objectAtIndex:0];
    [self.drawingPath addLineToPoint:[mytouch locationInView:self]];
    [self setNeedsDisplay];
    
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.delegate respondsToSelector:@selector(finishedDrawingStroke:)]) {
        [self.delegate finishedDrawingStroke:self.drawingPath];
    }
    
    self.drawingPath = nil;
}

@end
