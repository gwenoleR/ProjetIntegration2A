// Generated by Apple Swift version 3.1 (swiftlang-802.0.53 clang-802.0.42)
#pragma clang diagnostic push

#if defined(__has_include) && __has_include(<swift/objc-prologue.h>)
# include <swift/objc-prologue.h>
#endif

#pragma clang diagnostic ignored "-Wauto-import"
#include <objc/NSObject.h>
#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>

#if !defined(SWIFT_TYPEDEFS)
# define SWIFT_TYPEDEFS 1
# if defined(__has_include) && __has_include(<uchar.h>)
#  include <uchar.h>
# elif !defined(__cplusplus) || __cplusplus < 201103L
typedef uint_least16_t char16_t;
typedef uint_least32_t char32_t;
# endif
typedef float swift_float2  __attribute__((__ext_vector_type__(2)));
typedef float swift_float3  __attribute__((__ext_vector_type__(3)));
typedef float swift_float4  __attribute__((__ext_vector_type__(4)));
typedef double swift_double2  __attribute__((__ext_vector_type__(2)));
typedef double swift_double3  __attribute__((__ext_vector_type__(3)));
typedef double swift_double4  __attribute__((__ext_vector_type__(4)));
typedef int swift_int2  __attribute__((__ext_vector_type__(2)));
typedef int swift_int3  __attribute__((__ext_vector_type__(3)));
typedef int swift_int4  __attribute__((__ext_vector_type__(4)));
typedef unsigned int swift_uint2  __attribute__((__ext_vector_type__(2)));
typedef unsigned int swift_uint3  __attribute__((__ext_vector_type__(3)));
typedef unsigned int swift_uint4  __attribute__((__ext_vector_type__(4)));
#endif

#if !defined(SWIFT_PASTE)
# define SWIFT_PASTE_HELPER(x, y) x##y
# define SWIFT_PASTE(x, y) SWIFT_PASTE_HELPER(x, y)
#endif
#if !defined(SWIFT_METATYPE)
# define SWIFT_METATYPE(X) Class
#endif
#if !defined(SWIFT_CLASS_PROPERTY)
# if __has_feature(objc_class_property)
#  define SWIFT_CLASS_PROPERTY(...) __VA_ARGS__
# else
#  define SWIFT_CLASS_PROPERTY(...)
# endif
#endif

#if defined(__has_attribute) && __has_attribute(objc_runtime_name)
# define SWIFT_RUNTIME_NAME(X) __attribute__((objc_runtime_name(X)))
#else
# define SWIFT_RUNTIME_NAME(X)
#endif
#if defined(__has_attribute) && __has_attribute(swift_name)
# define SWIFT_COMPILE_NAME(X) __attribute__((swift_name(X)))
#else
# define SWIFT_COMPILE_NAME(X)
#endif
#if defined(__has_attribute) && __has_attribute(objc_method_family)
# define SWIFT_METHOD_FAMILY(X) __attribute__((objc_method_family(X)))
#else
# define SWIFT_METHOD_FAMILY(X)
#endif
#if defined(__has_attribute) && __has_attribute(noescape)
# define SWIFT_NOESCAPE __attribute__((noescape))
#else
# define SWIFT_NOESCAPE
#endif
#if defined(__has_attribute) && __has_attribute(warn_unused_result)
# define SWIFT_WARN_UNUSED_RESULT __attribute__((warn_unused_result))
#else
# define SWIFT_WARN_UNUSED_RESULT
#endif
#if !defined(SWIFT_CLASS_EXTRA)
# define SWIFT_CLASS_EXTRA
#endif
#if !defined(SWIFT_PROTOCOL_EXTRA)
# define SWIFT_PROTOCOL_EXTRA
#endif
#if !defined(SWIFT_ENUM_EXTRA)
# define SWIFT_ENUM_EXTRA
#endif
#if !defined(SWIFT_CLASS)
# if defined(__has_attribute) && __has_attribute(objc_subclassing_restricted)
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# else
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# endif
#endif

#if !defined(SWIFT_PROTOCOL)
# define SWIFT_PROTOCOL(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
# define SWIFT_PROTOCOL_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
#endif

#if !defined(SWIFT_EXTENSION)
# define SWIFT_EXTENSION(M) SWIFT_PASTE(M##_Swift_, __LINE__)
#endif

#if !defined(OBJC_DESIGNATED_INITIALIZER)
# if defined(__has_attribute) && __has_attribute(objc_designated_initializer)
#  define OBJC_DESIGNATED_INITIALIZER __attribute__((objc_designated_initializer))
# else
#  define OBJC_DESIGNATED_INITIALIZER
# endif
#endif
#if !defined(SWIFT_ENUM)
# define SWIFT_ENUM(_type, _name) enum _name : _type _name; enum SWIFT_ENUM_EXTRA _name : _type
# if defined(__has_feature) && __has_feature(generalized_swift_name)
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME) enum _name : _type _name SWIFT_COMPILE_NAME(SWIFT_NAME); enum SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_ENUM_EXTRA _name : _type
# else
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME) SWIFT_ENUM(_type, _name)
# endif
#endif
#if !defined(SWIFT_UNAVAILABLE)
# define SWIFT_UNAVAILABLE __attribute__((unavailable))
#endif
#if !defined(SWIFT_UNAVAILABLE_MSG)
# define SWIFT_UNAVAILABLE_MSG(msg) __attribute__((unavailable(msg)))
#endif
#if !defined(SWIFT_AVAILABILITY)
# define SWIFT_AVAILABILITY(plat, ...) __attribute__((availability(plat, __VA_ARGS__)))
#endif
#if !defined(SWIFT_DEPRECATED)
# define SWIFT_DEPRECATED __attribute__((deprecated))
#endif
#if !defined(SWIFT_DEPRECATED_MSG)
# define SWIFT_DEPRECATED_MSG(...) __attribute__((deprecated(__VA_ARGS__)))
#endif
#if defined(__has_feature) && __has_feature(modules)
@import UIKit;
@import CoreLocation;
@import Foundation;
@import ObjectiveC;
@import MapKit;
@import AVFoundation;
#endif

#pragma clang diagnostic ignored "-Wproperty-attribute-mismatch"
#pragma clang diagnostic ignored "-Wduplicate-method-arg"
@class UILabel;
@class UITextView;
@class UIButton;
@class NSBundle;
@class NSCoder;

SWIFT_CLASS("_TtC7JO_201721AccountViewController")
@interface AccountViewController : UIViewController
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified name;
@property (nonatomic, weak) IBOutlet UITextView * _Null_unspecified positions;
@property (nonatomic, weak) IBOutlet UITextView * _Null_unspecified tags;
@property (nonatomic, weak) IBOutlet UIButton * _Null_unspecified disconnect;
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified titre2;
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified titre1;
- (void)viewDidAppear:(BOOL)animated;
- (void)viewDidLoad;
- (void)didReceiveMemoryWarning;
- (IBAction)deconnexion:(id _Nonnull)sender;
- (nonnull instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end

@class UIWindow;
@class CLLocationManager;
@class UIApplication;
@class CLRegion;

SWIFT_CLASS("_TtC7JO_201711AppDelegate")
@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (nonatomic, strong) UIWindow * _Nullable window;
@property (nonatomic, readonly, strong) CLLocationManager * _Nonnull locationManager;
- (BOOL)application:(UIApplication * _Nonnull)application didFinishLaunchingWithOptions:(NSDictionary<UIApplicationLaunchOptionsKey, id> * _Nullable)launchOptions SWIFT_WARN_UNUSED_RESULT;
- (void)handleEventForRegion:(CLRegion * _Null_unspecified)region;
- (NSString * _Nullable)noteFromRegionIdentifier:(NSString * _Nonnull)identifier SWIFT_WARN_UNUSED_RESULT;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


@interface AppDelegate (SWIFT_EXTENSION(JO_2017)) <CLLocationManagerDelegate>
- (void)locationManager:(CLLocationManager * _Nonnull)manager didEnterRegion:(CLRegion * _Nonnull)region;
- (void)locationManager:(CLLocationManager * _Nonnull)manager didExitRegion:(CLRegion * _Nonnull)region;
@end


SWIFT_CLASS("_TtC7JO_201724DetailFeedViewController")
@interface DetailFeedViewController : UIViewController
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified t;
@property (nonatomic, weak) IBOutlet UITextView * _Null_unspecified content;
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified tags;
- (void)viewDidLoad;
- (void)didReceiveMemoryWarning;
- (nonnull instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end

@class UITableView;
@class UIRefreshControl;
@class UITableViewCell;
@class UIStoryboardSegue;

SWIFT_CLASS("_TtC7JO_201718FeedViewController")
@interface FeedViewController : UIViewController <UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, copy) NSString * _Nonnull tag;
@property (nonatomic, weak) IBOutlet UITableView * _Null_unspecified tableView;
@property (nonatomic, strong) UIRefreshControl * _Nonnull refreshControl;
- (void)handleRefreshWithRefreshControl:(UIRefreshControl * _Nonnull)refreshControl;
- (void)getPost;
- (void)viewDidAppear:(BOOL)animated;
- (void)viewDidLoad;
- (void)didReceiveMemoryWarning;
- (NSInteger)tableView:(UITableView * _Nonnull)tableView numberOfRowsInSection:(NSInteger)section SWIFT_WARN_UNUSED_RESULT;
- (UITableViewCell * _Nonnull)tableView:(UITableView * _Nonnull)tableView cellForRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath SWIFT_WARN_UNUSED_RESULT;
- (void)tableView:(UITableView * _Nonnull)tableView didSelectRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath;
- (void)prepareForSegue:(UIStoryboardSegue * _Nonnull)segue sender:(id _Nullable)sender;
- (nonnull instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC7JO_201713Geotification")
@interface Geotification : NSObject <MKAnnotation, NSCoding>
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic) CLLocationDistance radius;
@property (nonatomic, copy) NSString * _Nonnull identifier;
@property (nonatomic, copy) NSString * _Nonnull note;
@property (nonatomic, readonly, copy) NSString * _Nullable title;
@property (nonatomic, readonly, copy) NSString * _Nullable subtitle;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)decoder OBJC_DESIGNATED_INITIALIZER;
- (void)encodeWithCoder:(NSCoder * _Nonnull)coder;
- (BOOL)isEqualAt:(Geotification * _Nonnull)geotification SWIFT_WARN_UNUSED_RESULT;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
@end

@class UITextField;

SWIFT_CLASS("_TtC7JO_201720LaunchViewController")
@interface LaunchViewController : UIViewController <UIScrollViewDelegate, UITableViewDataSource, UITextFieldDelegate, UITableViewDelegate>
@property (nonatomic, copy) NSArray<NSString *> * _Nonnull tags;
@property (nonatomic, copy) NSArray<NSString *> * _Nonnull interestTag;
@property (nonatomic, weak) IBOutlet UITableView * _Null_unspecified interets;
@property (nonatomic, weak) IBOutlet UITextField * _Null_unspecified twitterAccount;
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified titre;
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified titre1;
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified twit;
@property (nonatomic, weak) IBOutlet UIButton * _Null_unspecified start;
- (IBAction)go:(id _Nonnull)sender;
- (BOOL)textFieldShouldReturn:(UITextField * _Nonnull)textField SWIFT_WARN_UNUSED_RESULT;
- (void)viewDidLoad;
- (void)didReceiveMemoryWarning;
- (NSInteger)tableView:(UITableView * _Nonnull)tableView numberOfRowsInSection:(NSInteger)section SWIFT_WARN_UNUSED_RESULT;
- (UITableViewCell * _Nonnull)tableView:(UITableView * _Nonnull)tableView cellForRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath SWIFT_WARN_UNUSED_RESULT;
- (void)tableView:(UITableView * _Nonnull)tableView didSelectRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath;
- (void)tableView:(UITableView * _Nonnull)tableView didDeselectRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath;
- (nonnull instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end

@class MKMapItem;
@class MKMapView;
@class MKPlacemark;

SWIFT_CLASS("_TtC7JO_201719LocationSearchTable")
@interface LocationSearchTable : UITableViewController
@property (nonatomic, copy) NSArray<MKMapItem *> * _Nonnull matchingItems;
@property (nonatomic, strong) MKMapView * _Nullable mapView;
- (NSString * _Nonnull)parseAddressWithSelectedItem:(MKPlacemark * _Nonnull)selectedItem SWIFT_WARN_UNUSED_RESULT;
- (nonnull instancetype)initWithStyle:(UITableViewStyle)style OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end


@interface LocationSearchTable (SWIFT_EXTENSION(JO_2017))
- (void)tableView:(UITableView * _Nonnull)tableView didSelectRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath;
@end

@class UISearchController;

@interface LocationSearchTable (SWIFT_EXTENSION(JO_2017)) <UISearchResultsUpdating>
- (void)updateSearchResultsForSearchController:(UISearchController * _Nonnull)searchController;
@end


@interface LocationSearchTable (SWIFT_EXTENSION(JO_2017))
- (NSInteger)tableView:(UITableView * _Nonnull)tableView numberOfRowsInSection:(NSInteger)section SWIFT_WARN_UNUSED_RESULT;
- (UITableViewCell * _Nonnull)tableView:(UITableView * _Nonnull)tableView cellForRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath SWIFT_WARN_UNUSED_RESULT;
@end


@interface MKMapView (SWIFT_EXTENSION(JO_2017))
- (void)zoomToUserLocation;
@end

@class CLCircularRegion;

SWIFT_CLASS("_TtC7JO_201717MapViewController")
@interface MapViewController : UIViewController
@property (nonatomic, weak) IBOutlet MKMapView * _Null_unspecified mapView;
@property (nonatomic, copy) NSArray<Geotification *> * _Nonnull geotifications;
@property (nonatomic, strong) CLLocationManager * _Nonnull locationManager;
@property (nonatomic, strong) UISearchController * _Null_unspecified resultSearchController;
@property (nonatomic, strong) MKPlacemark * _Nullable selectedPin;
- (void)viewDidAppear:(BOOL)animated;
- (void)viewDidLoad;
- (void)loadAllGeotifications;
- (void)saveAllGeotifications;
- (void)addWithGeotification:(Geotification * _Nonnull)geotification;
- (void)removeWithGeotification:(Geotification * _Nonnull)geotification;
- (IBAction)zoomToCurrentLocationWithSender:(id _Nonnull)sender;
- (CLCircularRegion * _Nonnull)regionWithGeotification:(Geotification * _Nonnull)geotification SWIFT_WARN_UNUSED_RESULT;
- (void)startMonitoringWithGeotification:(Geotification * _Nonnull)geotification;
- (void)stopMonitoringWithGeotification:(Geotification * _Nonnull)geotification;
- (void)getDirections;
- (nonnull instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end


@interface MapViewController (SWIFT_EXTENSION(JO_2017))
- (void)dropPinZoomInPlacemark:(MKPlacemark * _Nonnull)placemark;
@end

@class MKAnnotationView;
@class UIControl;

@interface MapViewController (SWIFT_EXTENSION(JO_2017)) <MKMapViewDelegate>
- (MKAnnotationView * _Nullable)mapView:(MKMapView * _Nonnull)mapView viewForAnnotation:(id <MKAnnotation> _Nonnull)annotation SWIFT_WARN_UNUSED_RESULT;
- (void)mapView:(MKMapView * _Nonnull)mapView annotationView:(MKAnnotationView * _Nonnull)view calloutAccessoryControlTapped:(UIControl * _Nonnull)control;
@end


@interface MapViewController (SWIFT_EXTENSION(JO_2017)) <CLLocationManagerDelegate>
- (void)locationManager:(CLLocationManager * _Nonnull)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status;
- (void)locationManager:(CLLocationManager * _Nonnull)manager monitoringDidFailForRegion:(CLRegion * _Nullable)region withError:(NSError * _Nonnull)error;
- (void)locationManager:(CLLocationManager * _Nonnull)manager didFailWithError:(NSError * _Nonnull)error;
@end


@interface NSNumber (SWIFT_EXTENSION(JO_2017))
@property (nonatomic, readonly) BOOL isBool;
@end

@class UIImageView;

SWIFT_CLASS("_TtC7JO_201726QrCodeViewerViewController")
@interface QrCodeViewerViewController : UIViewController
@property (nonatomic, weak) IBOutlet UIImageView * _Null_unspecified qrCode;
- (void)viewDidLoad;
- (void)didReceiveMemoryWarning;
- (nonnull instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end

@class UIView;
@class AVCaptureSession;
@class AVCaptureVideoPreviewLayer;
@class AVCaptureOutput;
@class AVCaptureConnection;

SWIFT_CLASS("_TtC7JO_201724ScanQRCodeViewController")
@interface ScanQRCodeViewController : UIViewController <AVCaptureMetadataOutputObjectsDelegate>
@property (nonatomic, strong) IBOutlet UILabel * _Null_unspecified messageLabel;
@property (nonatomic, strong) IBOutlet UIView * _Null_unspecified topbar;
@property (nonatomic, strong) AVCaptureSession * _Nullable captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer * _Nullable videoPreviewLayer;
@property (nonatomic, strong) UIView * _Nullable qrCodeFrameView;
@property (nonatomic) BOOL readed;
- (void)viewDidLoad;
- (void)captureOutput:(AVCaptureOutput * _Null_unspecified)captureOutput didOutputMetadataObjects:(NSArray * _Null_unspecified)metadataObjects fromConnection:(AVCaptureConnection * _Null_unspecified)connection;
- (void)didReceiveMemoryWarning;
- (nonnull instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC7JO_201716SearchAnnotation")
@interface SearchAnnotation : NSObject <MKAnnotation>
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString * _Null_unspecified name;
@property (nonatomic, copy) NSString * _Null_unspecified title;
@property (nonatomic, copy) NSString * _Null_unspecified subtitle;
- (nonnull instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate name:(NSString * _Nonnull)name OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
@end


SWIFT_CLASS("_TtC7JO_201723SearchTagViewController")
@interface SearchTagViewController : UIViewController <UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, copy) NSArray<NSString *> * _Nonnull tags;
@property (nonatomic, copy) NSString * _Nonnull selectedTag;
@property (nonatomic, weak) IBOutlet UITableView * _Null_unspecified tableView;
- (void)viewDidAppear:(BOOL)animated;
- (void)viewDidLoad;
- (void)didReceiveMemoryWarning;
- (NSInteger)tableView:(UITableView * _Nonnull)tableView numberOfRowsInSection:(NSInteger)section SWIFT_WARN_UNUSED_RESULT;
- (UITableViewCell * _Nonnull)tableView:(UITableView * _Nonnull)tableView cellForRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath SWIFT_WARN_UNUSED_RESULT;
- (void)tableView:(UITableView * _Nonnull)tableView didSelectRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath;
- (void)prepareForSegue:(UIStoryboardSegue * _Nonnull)segue sender:(id _Nullable)sender;
- (nonnull instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end


@interface UIViewController (SWIFT_EXTENSION(JO_2017))
- (void)showAlertWithTitle:(NSString * _Nullable)title message:(NSString * _Nullable)message;
- (void)translateWithChaine:(NSString * _Nonnull)chaine to:(NSString * _Nonnull)to completion:(void (^ _Nonnull)(NSString * _Nonnull))completion;
@end

#pragma clang diagnostic pop
