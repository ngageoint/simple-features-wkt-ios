//
//  SFWTGeometryWriter.h
//  sf-wkt-ios
//
//  Created by Brian Osborn on 8/4/20.
//  Copyright © 2020 NGA. All rights reserved.
//

#import "SFMultiPoint.h"
#import "SFMultiLineString.h"
#import "SFMultiPolygon.h"
#import "SFCircularString.h"
#import "SFCompoundCurve.h"
#import "SFTIN.h"
#import "SFTriangle.h"

/**
 * Well Known Text writer
 */
@interface SFWTGeometryWriter : NSObject

/**
 * Write a geometry to a well-known text string
 *
 * @param geometry
 *            geometry
 * @return well-known text string
 */
+(NSString *) writeGeometry: (SFGeometry *) geometry;

/**
 * Initializer
 */
-(instancetype) init;

/**
 * Initializer
 *
 * @param text  mutable string
 */
-(instancetype) initWithText: (NSMutableString *) text;

/**
 * Get the well-known text
 *
 * @return text
 */
-(NSMutableString *) text;

/**
 * Write a geometry to well-known text
 *
 * @param geometry
 *            geometry
 */
-(void) write: (SFGeometry *) geometry;

/**
 * Write a Point
 *
 * @param point
 *            point
 */
-(void) writeWrappedPoint: (SFPoint *) point;

/**
 * Write a Point
 *
 * @param point
 *            point
 */
-(void) writePoint: (SFPoint *) point;

/**
 * Write a Line String
 *
 * @param lineString
 *            line string
 */
-(void) writeLineString: (SFLineString *) lineString;

/**
 * Write a Polygon
 *
 * @param polygon
 *            polygon
 */
-(void) writePolygon: (SFPolygon *) polygon;

/**
 * Write a Multi Point
 *
 * @param multiPoint
 *            multi point
 */
-(void) writeMultiPoint: (SFMultiPoint *) multiPoint;

/**
 * Write a Multi Line String
 *
 * @param multiLineString
 *            multi line string
 */
-(void) writeMultiLineString: (SFMultiLineString *) multiLineString;

/**
 * Write a Multi Polygon
 *
 * @param multiPolygon
 *            multi polygon
 */
-(void) writeMultiPolygon: (SFMultiPolygon *) multiPolygon;

/**
 * Write a Geometry Collection
 *
 * @param geometryCollection
 *            geometry collection
 */
-(void) writeGeometryCollection: (SFGeometryCollection *) geometryCollection;

/**
 * Write a Circular String
 *
 * @param circularString
 *            circular string
 */
-(void) writeCircularString: (SFCircularString *) circularString;

/**
 * Write a Compound Curve
 *
 * @param compoundCurve
 *            compound curve
 */
-(void) writeCompoundCurve: (SFCompoundCurve *) compoundCurve;

/**
 * Write a Curve Polygon
 *
 * @param curvePolygon
 *            curve polygon
 */
-(void) writeCurvePolygon: (SFCurvePolygon *) curvePolygon;

/**
 * Write a Polyhedral Surface
 *
 * @param polyhedralSurface
 *            polyhedral surface
 */
-(void) writePolyhedralSurface: (SFPolyhedralSurface *) polyhedralSurface;

/**
 * Write a TIN
 *
 * @param tin
 *            TIN
 */
-(void) writeTIN: (SFTIN *) tin;

/**
 * Write a Triangle
 *
 * @param triangle
 *            triangle
 */
-(void) writeTriangle: (SFTriangle *) triangle;

/**
 * Write a geometry to well-known text
 *
 * @param geometry
 *            geometry
 * @param string
 *            mutable string
 */
+(void) writeGeometry: (SFGeometry *) geometry toString: (NSMutableString *) string;

/**
 * Write a Point
 *
 * @param point
 *            point
 * @return well-known text string
 */
+(NSString *) writeWrappedPoint: (SFPoint *) point;

/**
 * Write a Point
 *
 * @param point
 *            point
 * @param string
 *            mutable string
 */
+(void) writeWrappedPoint: (SFPoint *) point toString: (NSMutableString *) string;

/**
 * Write a Point
 *
 * @param point
 *            point
 * @return well-known text string
 */
+(NSString *) writePoint: (SFPoint *) point;

/**
 * Write a Point
 *
 * @param point
 *            point
 * @param string
 *            mutable string
 */
+(void) writePoint: (SFPoint *) point toString: (NSMutableString *) string;

/**
 * Write a Line String
 *
 * @param lineString
 *            line string
 * @return well-known text string
 */
+(NSString *) writeLineString: (SFLineString *) lineString;

/**
 * Write a Line String
 *
 * @param lineString
 *            line string
 * @param string
 *            mutable string
 */
+(void) writeLineString: (SFLineString *) lineString toString: (NSMutableString *) string;

/**
 * Write a Polygon
 *
 * @param polygon
 *            polygon
 * @return well-known text string
 */
+(NSString *) writePolygon: (SFPolygon *) polygon;

/**
 * Write a Polygon
 *
 * @param polygon
 *            polygon
 * @param string
 *            mutable string
 */
+(void) writePolygon: (SFPolygon *) polygon toString: (NSMutableString *) string;

/**
 * Write a Multi Point
 *
 * @param multiPoint
 *            multi point
 * @return well-known text string
 */
+(NSString *) writeMultiPoint: (SFMultiPoint *) multiPoint;

/**
 * Write a Multi Point
 *
 * @param multiPoint
 *            multi point
 * @param string
 *            mutable string
 */
+(void) writeMultiPoint: (SFMultiPoint *) multiPoint toString: (NSMutableString *) string;

/**
 * Write a Multi Line String
 *
 * @param multiLineString
 *            multi line string
 * @return well-known text string
 */
+(NSString *) writeMultiLineString: (SFMultiLineString *) multiLineString;

/**
 * Write a Multi Line String
 *
 * @param multiLineString
 *            multi line string
 * @param string
 *            mutable string
 */
+(void) writeMultiLineString: (SFMultiLineString *) multiLineString toString: (NSMutableString *) string;

/**
 * Write a Multi Polygon
 *
 * @param multiPolygon
 *            multi polygon
 * @return well-known text string
 */
+(NSString *) writeMultiPolygon: (SFMultiPolygon *) multiPolygon;

/**
 * Write a Multi Polygon
 *
 * @param multiPolygon
 *            multi polygon
 * @param string
 *            mutable string
 */
+(void) writeMultiPolygon: (SFMultiPolygon *) multiPolygon toString: (NSMutableString *) string;

/**
 * Write a Geometry Collection
 *
 * @param geometryCollection
 *            geometry collection
 * @return well-known text string
 */
+(NSString *) writeGeometryCollection: (SFGeometryCollection *) geometryCollection;

/**
 * Write a Geometry Collection
 *
 * @param geometryCollection
 *            geometry collection
 * @param string
 *            mutable string
 */
+(void) writeGeometryCollection: (SFGeometryCollection *) geometryCollection toString: (NSMutableString *) string;

/**
 * Write a Circular String
 *
 * @param circularString
 *            circular string
 * @return well-known text string
 */
+(NSString *) writeCircularString: (SFCircularString *) circularString;

/**
 * Write a Circular String
 *
 * @param circularString
 *            circular string
 * @param string
 *            mutable string
 */
+(void) writeCircularString: (SFCircularString *) circularString toString: (NSMutableString *) string;

/**
 * Write a Compound Curve
 *
 * @param compoundCurve
 *            compound curve
 * @return well-known text string
 */
+(NSString *) writeCompoundCurve: (SFCompoundCurve *) compoundCurve;

/**
 * Write a Compound Curve
 *
 * @param compoundCurve
 *            compound curve
 * @param string
 *            mutable string
 */
+(void) writeCompoundCurve: (SFCompoundCurve *) compoundCurve toString: (NSMutableString *) string;

/**
 * Write a Curve Polygon
 *
 * @param curvePolygon
 *            curve polygon
 * @return well-known text string
 */
+(NSString *) writeCurvePolygon: (SFCurvePolygon *) curvePolygon;

/**
 * Write a Curve Polygon
 *
 * @param curvePolygon
 *            curve polygon
 * @param string
 *            mutable string
 */
+(void) writeCurvePolygon: (SFCurvePolygon *) curvePolygon toString: (NSMutableString *) string;

/**
 * Write a Polyhedral Surface
 *
 * @param polyhedralSurface
 *            polyhedral surface
 * @return well-known text string
 */
+(NSString *) writePolyhedralSurface: (SFPolyhedralSurface *) polyhedralSurface;

/**
 * Write a Polyhedral Surface
 *
 * @param polyhedralSurface
 *            polyhedral surface
 * @param string
 *            mutable string
 */
+(void) writePolyhedralSurface: (SFPolyhedralSurface *) polyhedralSurface toString: (NSMutableString *) string;

/**
 * Write a TIN
 *
 * @param tin
 *            TIN
 * @return well-known text string
 */
+(NSString *) writeTIN: (SFTIN *) tin;

/**
 * Write a TIN
 *
 * @param tin
 *            TIN
 * @param string
 *            mutable string
 */
+(void) writeTIN: (SFTIN *) tin toString: (NSMutableString *) string;

/**
 * Write a Triangle
 *
 * @param triangle
 *            triangle
 * @return well-known text string
 */
+(NSString *) writeTriangle: (SFTriangle *) triangle;

/**
 * Write a Triangle
 *
 * @param triangle
 *            triangle
 * @param string
 *            mutable string
 */
+(void) writeTriangle: (SFTriangle *) triangle toString: (NSMutableString *) string;

@end
