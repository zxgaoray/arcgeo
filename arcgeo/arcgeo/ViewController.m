//
//  ViewController.m
//  arcgeo
//
//  Created by apple on 2016/12/25.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    //UI
    AGSMapView * mainMapView;

    AGSGeometryEngine *_geometryEngine;
    AGSGraphicsLayer *_graphicsLayer;
    AGSSpatialReference *_sptialRef4326;

}
@end

static const CGFloat kCoordinateX = 120.0;
static const CGFloat kCoordinateY = 30.0;
static const CGFloat kZoomResolution = 38.21851414253662;
static NSString * const kBaseMapUrl = @"http://services.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer";

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setTitle:@"map"];
    // Do any additional setup after loading the view, typically from a nib.

    [self buildView];

    _sptialRef4326 = [[AGSSpatialReference alloc] initWithWKID:4326];
    AGSPoint* mpt = [[AGSPoint alloc] initWithX:kCoordinateX y:kCoordinateY spatialReference:_sptialRef4326];

    _geometryEngine = [[AGSGeometryEngine alloc] init];
    AGSPoint* center = (AGSPoint* )[_geometryEngine projectGeometry:mpt toSpatialReference:[[AGSSpatialReference alloc] initWithWKID:102100]];

    [mainMapView centerAtPoint:center animated:NO];
    [mainMapView zoomToResolution:kZoomResolution animated:NO];

    [mainMapView setLayerDelegate:self];
    [[mainMapView callout] setDelegate:self];

    NSURL* url = [NSURL URLWithString:kBaseMapUrl];
    AGSTiledMapServiceLayer *tiledLayer = [AGSTiledMapServiceLayer tiledMapServiceLayerWithURL:url];
    [mainMapView addMapLayer:tiledLayer withName:@"Basemap Tiled Layer"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)buildView {
    mainMapView = [[AGSMapView alloc] initWithFrame:CGRectZero];
    [mainMapView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [[self view] addSubview:mainMapView];

    NSDictionary *dict = NSDictionaryOfVariableBindings(mainMapView);

    [[self view] addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[mainMapView]-(0)-|" options:0 metrics:nil views:dict]];
    [[self view] addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(0)-[mainMapView]-(0)-|" options:0 metrics:nil views:dict]];
}


@end
