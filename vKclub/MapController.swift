import UIKit
import GoogleMaps

class kiriromLocation: NSObject {
    
    let title: String
    let location: CLLocationCoordinate2D
    let dec  : String
    
    let zoom: Float
    
    init(title: String, location: CLLocationCoordinate2D, dec: String,zoom: Float) {
        self.title = title
        self.location = location
        self.dec = dec
        self.zoom = zoom
    }
    
}

class MapController: UIViewController,GMSMapViewDelegate,CLLocationManagerDelegate{
    
    @IBOutlet weak var Ima: UIImageView!
    var mapView: GMSMapView?
    var locationManager = CLLocationManager()
    
    var currentDestination: kiriromLocation?
    
    
    let markerLocation = [
        
        kiriromLocation(title: "Kirirom Institute of Technology", location: CLLocationCoordinate2DMake(11.3152,104.0676),dec: "The first boarding school in Cambodia, specialized in software engineering. Students are also engaged in internship projects while studying.", zoom: 14),
        
        kiriromLocation(title: "Activity Center", location: CLLocationCoordinate2DMake(11.3165,104.0648),dec: "Pleasant activity staff offers the information regarding various types of activities. Activity in fresh air helps you refresh your mind. Open 8:00-17:00.", zoom: 14),
        
        kiriromLocation(title: "Pine View Kitchen", location: CLLocationCoordinate2DMake(11.3167,104.0653),dec: "At the open space restaurant, Pine View Kitchen helps you enjoy a chef’s special full course of modern Khmer cuisine.", zoom: 14),
        
        kiriromLocation(title: "Reception", location: CLLocationCoordinate2DMake(11.3174,104.0649),dec: "Customers can be welcomed to vKirirom Pine Resort. Open 8:00-20:00.Our staffs can speak English, Khmer, Japanese. Customers are provided with amenities as well.", zoom: 14),
        
        kiriromLocation(title: "Conference Tent", location: CLLocationCoordinate2DMake(11.3137,104.0667),dec: "A tent which occupies large space which is suitable for big events, conferences and many activities. Even during rainy days, this large tent provides enjoyable indoor activity.", zoom: 14),
        
        kiriromLocation(title: "Moringa", location: CLLocationCoordinate2DMake(11.3154,104.0638),dec: "Khmer style nature fused restaurant which serves Khmer original meals. You can also buy breads and drinks here.", zoom: 14),
        
        
        kiriromLocation(title: "Villa JasmineVilla Jasmine", location: CLLocationCoordinate2DMake(11.3181,104.0633),dec: "Quite elegant cottage which promises you a lot of pleasant experiences on the cool Kirirom Mountain top for couples and small families.", zoom: 14),
        
        kiriromLocation(title: "Villa Suite", location: CLLocationCoordinate2DMake(11.3180,104.0655),dec: "Modern designed luxury room. This two-bedroom villa with a mezzanine level is suitable for big families or groups.", zoom: 14),
        
        kiriromLocation(title: "Pipe Room", location: CLLocationCoordinate2DMake(11.3126,104.0628),dec: "The most uniquely designed room derived from an earthen pipe which serves best amongst all.", zoom: 14),
        
        kiriromLocation(title: "Luxury Tent", location: CLLocationCoordinate2DMake(11.3145,104.0646),dec: "High quality tent with comfortable hotel type room. Modern tent houses which have a king size bed and a nice shower room.", zoom: 14),
        
        kiriromLocation(title: "Khmer Cottage", location: CLLocationCoordinate2DMake(11.3149,104.0644),dec: "Khmer farmers' open-style houses which are nicely decorated with natural materials. Best rooms to experience real Khmer tradition and feel the natural fresh air.", zoom: 14),
        
        kiriromLocation(title: "Playground Field", location: CLLocationCoordinate2DMake( 11.3162, 104.0654),dec: "Enjoy many kinds of activities including football, tennis, volleyball, bubble sumo etc. Feel free to ask our activity staff for details.", zoom: 14),
        
        kiriromLocation(title: "Camping Area", location: CLLocationCoordinate2DMake( 11.3134,  104.0648),dec: "Enjoy camping with camp fire in a large area space with high level of security provided.", zoom: 14),
        
        kiriromLocation(title: "Kirirom Lake", location: CLLocationCoordinate2DMake( 11.3344,104.0516  ),dec: "A beautiful lake, provides enough water supply for all the villager", zoom: 14),
        
        kiriromLocation(title: "Village", location: CLLocationCoordinate2DMake( 11.3348, 104.0550  ),dec: "A Village where people enjoy living on Kirirom Mountain with a perfect view.", zoom: 14),
        
        kiriromLocation(title: "Ministry of Environment", location: CLLocationCoordinate2DMake( 11.3330,104.0531   ),dec: "Ministry of Environment that supports the whole Kirirom environment.", zoom: 14),
        kiriromLocation(title: "", location: CLLocationCoordinate2DMake( 11.3165, 104.0658  ),dec: "Stay in one of our specially designed bungalows and experience the invigorating fresh air and peaceful life in the pine forests of kirirom", zoom: 14),
        
        kiriromLocation(title: "Bungalow", location: CLLocationCoordinate2DMake( 11.3165, 104.0658  ),dec: "Stay in one of our specially designed bungalows and experience the invigorating fresh air and peaceful life in the pine forests of kirirom", zoom: 14),
        kiriromLocation(title: "Swimming Pool", location: CLLocationCoordinate2DMake( 11.316, 104.0658 ),dec: "Enjoy swimming with your family and friends with the surrounded pine trees and the fresh air.", zoom: 14),
        
        kiriromLocation(title: "Tennis Court", location: CLLocationCoordinate2DMake( 11.3121, 104.0653 ),dec: "Enjoy playing tennis on top of the mountain surrounded by pine trees.", zoom: 14),
        
        kiriromLocation(title: "Parking Area", location: CLLocationCoordinate2DMake( 11.3169, 104.0647),dec: "Big secure parking space for customers vehicle.", zoom: 14),
        
        kiriromLocation(title: "Container Cafe", location: CLLocationCoordinate2DMake( 11.313, 104.0654),dec: "Big secure parking space for customers vehicle.", zoom: 14),
        
        kiriromLocation(title: "Farm", location: CLLocationCoordinate2DMake( 11.3134,104.0636),dec: "An organic farm that grows a variety of foods such as Strawberry, Pineapple, Passions etc.", zoom: 14),
        
        kiriromLocation(title: "Crazy Hill", location: CLLocationCoordinate2DMake( 11.3136,104.0751),dec: "An outdoor party stage for big event in the top mountain of kirirom. You can enjoy lunch, BBQ and also drinks with karaoke.", zoom: 14),
        
        kiriromLocation(title: "Dragon Statue", location: CLLocationCoordinate2DMake(  11.3409,104.059),dec: "Dragon Statues (snake God) whose four heads are landmark, is situated in the center of the center of the intersection.", zoom: 14),
        
        kiriromLocation(title: "Old Kirirom Pagoda", location: CLLocationCoordinate2DMake(  11.3201,104.0362),dec: "It is a Buddhist temple with the longest histroy in Kirirom.It makes you back to the good days in Cambodia.Please follow this good manners when worship ping the temple.", zoom: 14),
        
        kiriromLocation(title: "New Kirirom Pagoda", location: CLLocationCoordinate2DMake( 11.3304,104.0769),dec: "On the top of the stairs of gentle slope. A mural paining drawn Buddha's life inside of the building is also an sightseeing spot.", zoom: 14),
        kiriromLocation(title: "New Kirirom Pagoda", location: CLLocationCoordinate2DMake( 11.3304,104.0769),dec: "On the top of the stairs of gentle slope. A mural paining drawn Buddha's life inside of the building is also an sightseeing spot.", zoom: 14),
        kiriromLocation(title: "Otrosek Waterfall", location: CLLocationCoordinate2DMake( 11.3111,104.0784),dec: "This place us know to those in the know, and it is loved by locals. We recommend you to visit there during the rainy season.", zoom: 14),
         
        kiriromLocation(title: "Srash Srang Lake", location: CLLocationCoordinate2DMake( 11.3291,104.0379),dec: "The landscape is almost as if it is a framed picture. You can feel the magnificence of the nature while being away from the hustle and bustle of the city.", zoom: 14),
        kiriromLocation(title: "King's Residence", location: CLLocationCoordinate2DMake( 11.3309,104.0606),dec: "The residence,which quietly stands among a pine grove,was a old fashioned cottage built of bricks.", zoom: 14),
        
        kiriromLocation(title: "Visitor Center", location: CLLocationCoordinate2DMake( 11.3351, 104.0407),dec: "A visitor center which introduce the history of Kirirom. It is a wonderful photogenic spot.", zoom: 14),
        
        kiriromLocation(title: "Football Court", location: CLLocationCoordinate2DMake( 11.3133, 104.065),dec: "Customers can also enjoy playing football with their friends together in the resort.", zoom: 14),
        
        
        kiriromLocation(title: "Volleyball Court", location: CLLocationCoordinate2DMake(11.3129, 104.0657),dec: "Customers can also enjoy playing volleyball with their friends together in the resort.", zoom: 14),
        
        kiriromLocation(title: "Kirirom Elementary School", location: CLLocationCoordinate2DMake(11.3345,  104.0553),dec: "It is the only elementary school established by mainly vKirirom stuff.For the bright future of children regardless of the envirionment the were grown up.", zoom: 14),
        
        kiriromLocation(title: "Bopha Road", location: CLLocationCoordinate2DMake( 11.3138,104.0727  ),dec: "The 2km short cut road that opens up from an entrance of our resort to Conference Tent.", zoom: 14),
        
        kiriromLocation(title: "Bell tent", location: CLLocationCoordinate2DMake( 11.3126,104.0646 ),dec: "Glamping, glamourous camping provides you a good sleep on a fluffy bed.", zoom: 14),
        
        kiriromLocation(title: "Climbing Theater", location: CLLocationCoordinate2DMake( 11.3158,104.0649 ),dec: "It is a multi-purpose building which during day time can be used to enjoy wall climbing as well as a movie screen at night time.", zoom: 14),
        ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Map()
        
    }
    
    func Map() {
        
        //map view
        GMSServices.provideAPIKey("AIzaSyA0QlNOrMY6JU7wqgBXBamQq1v9wbR11Z0")
        let camera = GMSCameraPosition.camera(withLatitude: 11.3167, longitude: 104.0651, zoom : 15)
        mapView = GMSMapView.map(withFrame:  .zero, camera: camera)
        mapView?.setMinZoom(10, maxZoom: 17)
        mapView?.settings.compassButton = true;
        
        mapView?.settings.myLocationButton = true;
        mapView?.isMyLocationEnabled = true
        
        
        
        view = mapView
        
        //Map overlay
      
        let southWest = CLLocationCoordinate2D(latitude: 11.3432, longitude:104.0323 )
        let northEast = CLLocationCoordinate2D(latitude: 11.3040, longitude: 104.0846)
        let overlayBounds = GMSCoordinateBounds(coordinate: southWest, coordinate: northEast)
        let icon  = UIImage(named: "vmap")!
        let overlay = GMSGroundOverlay(bounds: overlayBounds, icon: icon)
        overlay.bearing = 0
        overlay.map = mapView
        
        
        // Marker for each location
        
        if currentDestination == nil {
            currentDestination = markerLocation.first
        }
        
        for currentDestination in markerLocation{
            
            let marker = GMSMarker(position: currentDestination.location)
            marker.title = currentDestination.title
            marker.snippet = currentDestination.dec
            marker.icon = UIImage(named: "marker")

            marker.map = mapView
           
            
        }
        
      

        
        
        
        
        
        
    }
 
    
   
   
    
}
