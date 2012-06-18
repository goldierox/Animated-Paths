//
//  AnimatedPathViewController.m
//  AnimatedPath
//
//  Created by Ole Begemann on 08.12.10.
//  Copyright 2010 Ole Begemann. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <CoreText/CoreText.h>

#import "AnimatedPathViewController.h"

@interface AnimatedPathViewController ()

@end

@implementation AnimatedPathViewController

@dynamic drawingView;
@synthesize brushPaths=_brushPaths;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _brushPaths = [[NSMutableArray alloc] init];
    
    [self.drawingView setupDrawingLayer];
}

- (void)dealloc {
    [self.brushPaths release];
    [super dealloc];
}

- (DrawingView *) drawingView {
    return (DrawingView *)self.view;
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation  {
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}


- (void)viewDidUnload  {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (IBAction) replayButtonTapped:(id)sender {
    [self.drawingView setAnimatingPlayback:YES];
    [self.drawingView setNeedsDisplay];
}

- (IBAction) clearCanvas:(id)sender {
    [self.brushPaths removeAllObjects];
    [self.drawingView setNeedsDisplay];
}

#pragma mark DrawingViewDelegate methods

- (void) finishedDrawingStroke:(UIBezierPath *)completedStroke {
    [self.brushPaths addObject:completedStroke];
}

@end