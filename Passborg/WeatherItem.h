
#import <CoreData/CoreData.h>
#import <MapKit/MapKit.h>

enum WeatherConditions
{
    Sunny = 0,
    PartlyCloudy,
    Cloudy,
    Showers,
    Thunderstorms,
    Snow
};

@interface WeatherItem : NSObject <MKAnnotation>
{
    NSString *title;
    NSDictionary *place;
    NSNumber *low;
    NSNumber *high;
    NSNumber *condition;
    
    CLLocationCoordinate2D coordinate;
@public
    double latitude;
    double longitude;
}

@property (nonatomic, retain) NSString *title;
@property (strong,nonatomic,retain) NSDictionary *place;
@property (nonatomic, retain) NSNumber *low;
@property (nonatomic, retain) NSNumber *high;
@property (nonatomic, retain) NSNumber *condition;

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

@end
