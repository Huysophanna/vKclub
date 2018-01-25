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
        
        kiriromLocation(title: "Kirirom Institute of Technology", location: CLLocationCoordinate2DMake(11.3152,104.0676),dec: "The first boarding school in Cambodia, specialized in software engineering and offers internship while studying.", zoom: 14),
        
        kiriromLocation(title: "Activity Center", location: CLLocationCoordinate2DMake(11.3165,104.0648),dec: "Information regarding various types of fun activities to refresh your mind. Open 8:00am - 5pm", zoom: 14),
        
        kiriromLocation(title: "Pine View Kitchen", location: CLLocationCoordinate2DMake(11.3167,104.0653),dec: "An open space restaurant where you can enjoy modern Khmer cuisine", zoom: 14),
        
        kiriromLocation(title: "Reception", location: CLLocationCoordinate2DMake(11.3174,104.0649),dec: "VKirirom Pine Resort reception welcomes customers from 8 AM to 8 PM. Our helpful staffs can speak English, Japanese, and Khmer. Amenities for customers are provided here as well.", zoom: 14),
        
        kiriromLocation(title: "Conference Tent", location: CLLocationCoordinate2DMake(11.3137,104.0667),dec: "A large tent which is suitable for big events,conferences and many activities even during rainy days.", zoom: 14),
        
        kiriromLocation(title: "Moringa", location: CLLocationCoordinate2DMake(11.3154,104.0638),dec: "Khmer style infused restaurant which serves authentic Khmer meals and sells breads and drinks.", zoom: 14),
        
        
        kiriromLocation(title: "Villa Jasmine", location: CLLocationCoordinate2DMake(11.3181,104.0633),dec: "Quite elegant cottage which promises you a lot of pleasant experiences on the cool Kirirom Mountain top for couples and small families.", zoom: 14),
        
        kiriromLocation(title: "Villa Suite", location: CLLocationCoordinate2DMake(11.3180,104.0655),dec: "This two bedroom luxurious modern villa is suitable for big families or groups.", zoom: 14),
        
        kiriromLocation(title: "Pipe Room", location: CLLocationCoordinate2DMake(11.3126,104.0628),dec: "The most uniquely designed room derived from an earthen pipe which serves best amongst all.", zoom: 14),
        
        kiriromLocation(title: "Luxury Tent", location: CLLocationCoordinate2DMake(11.3145,104.0646),dec: "High quality modern tent houses offers the comfort of a hotel room in an outer space that features a king size bed and then nice shower room.", zoom: 14),
        
        kiriromLocation(title: "Khmer Cottage", location: CLLocationCoordinate2DMake(11.3149,104.0644),dec: "Khmer farmer style open houses built with natural materials to experience the Khmer tradition.", zoom: 14),
        
        kiriromLocation(title: "Playground Field", location: CLLocationCoordinate2DMake( 11.3162, 104.0654),dec: "Enjoy many kinds of activities including football, tennis, volleyball, bubble sumo etc. Feel free to ask our activity staff for details.", zoom: 14),
        
        kiriromLocation(title: "Camping Area", location: CLLocationCoordinate2DMake( 11.3134,  104.0648),dec: "Enjoy camping with camp fire in a large open space with high level of security.", zoom: 14),
        
        kiriromLocation(title: "Kirirom Lake", location: CLLocationCoordinate2DMake( 11.3344,104.0516  ),dec: "A beautiful lake,  which provides enough water supply for all the villagers", zoom: 14),
        
        kiriromLocation(title: "Village", location: CLLocationCoordinate2DMake( 11.3348, 104.0550  ),dec: "A Village where people enjoy living on Kirirom Mountain with nice view.", zoom: 14),
        
        kiriromLocation(title: "Ministry of Environment", location: CLLocationCoordinate2DMake( 11.3330,104.0531   ),dec: "Ministry of Environment that supports the whole Kirirom environment", zoom: 14),
        
        kiriromLocation(title: "Bungalow", location: CLLocationCoordinate2DMake( 11.3165, 104.0658  ),dec: "Come and stay in our specially designed Bungalows to experience the invigorating fresh air and peaceful life and the pine forest of Kirirom.", zoom: 14),
        kiriromLocation(title: "Swimming Pool", location: CLLocationCoordinate2DMake( 11.3168, 104.0658 ),dec: "Enjoy our outdoor swimming pool with family and friends.", zoom: 14),
        
        kiriromLocation(title: "Tennis Court", location: CLLocationCoordinate2DMake( 11.3121, 104.0653 ),dec: "Enjoy tennis on top of the mountain surrounded by pine trees.", zoom: 14),
        
        kiriromLocation(title: "Parking Area", location: CLLocationCoordinate2DMake( 11.3169, 104.0647),dec: "Large secure Parking space for customers.", zoom: 14),
        
        kiriromLocation(title: "Container Cafe", location: CLLocationCoordinate2DMake( 11.3139, 104.0654),dec: "Big secure parking space for customers vehicle.", zoom: 14),
        
        kiriromLocation(title: "Farm", location: CLLocationCoordinate2DMake( 11.3134,104.0636),dec: "An organic farm that grows a variety of foods such as Strawberry, Pineapple, Passions etc.", zoom: 14),
        
        kiriromLocation(title: "Crazy Hill", location: CLLocationCoordinate2DMake( 11.3136,104.0751),dec: "An outdoor stage for outdoor events and parties.", zoom: 14),
        
        kiriromLocation(title: "Dragon Statue", location: CLLocationCoordinate2DMake(  11.3409,104.0597),dec: "A landmark statue of snake god with four heads which is situated in the middle of the intersection.", zoom: 14),
        
        kiriromLocation(title: "Old Kirirom Pagoda", location: CLLocationCoordinate2DMake(  11.3201,104.0362),dec: "It is a Buddhist temple with the longest history in Kirirom. It reminds of the old good days in Cambodia. Please follow the appropriate pattern of worship there.", zoom: 14),
        
        kiriromLocation(title: "New Kirirom Pagoda", location: CLLocationCoordinate2DMake( 11.3304,104.0769),dec: "A mural painting of buddha's life inside of a building which is located.", zoom: 14),
        kiriromLocation(title: "Otrosek Waterfall", location: CLLocationCoordinate2DMake( 11.3111,104.0784),dec: "Otrosek Waterfall is a lovely place that is allowed by the locals and is highly recommended during rainy season.", zoom: 14),
        
        kiriromLocation(title: "Srash Srang Lake", location: CLLocationCoordinate2DMake( 11.3291,104.0379),dec: "A picture perfect landscape where you feel the magnificence of Nature. ", zoom: 14),
        kiriromLocation(title: "King's Residence", location: CLLocationCoordinate2DMake( 11.3309,104.0606),dec: "The King's residence is an Old- fashioned cottage built of bricks which stands quietly in Pine Grove.", zoom: 14),
        
        kiriromLocation(title: "Visitor Center", location: CLLocationCoordinate2DMake( 11.3351, 104.0407),dec: "A visitor center, which introduces the history of Kirirom. It is a wonderful photogenic spot.", zoom: 14),
        
        kiriromLocation(title: "Football Court", location: CLLocationCoordinate2DMake( 11.3133, 104.0657),dec: "Customers can enjoy football with their friends in the resort.", zoom: 14),
        
        
        kiriromLocation(title: "Valleyball Court", location: CLLocationCoordinate2DMake(11.3129, 104.0657),dec: "Customers can also enjoy volleyball with their friends in the resort.", zoom: 14),
        
        kiriromLocation(title: "Kirirom Elementary School", location: CLLocationCoordinate2DMake(11.3345,  104.0553),dec: "Established by the vKirirom stuff which is the only elementary school in Kirirom.", zoom: 14),
        
        kiriromLocation(title: "Bopha Road", location: CLLocationCoordinate2DMake( 11.3138,104.0727  ),dec: "A 2 km shortcut road from the entrance of the resort to the conference tent.", zoom: 14),
        
        kiriromLocation(title: "Bell tent", location: CLLocationCoordinate2DMake( 11.3126,104.0646 ),dec: "Glamping, glamourous camping provides you a good sleep on a fluffy bed.", zoom: 14),
        
        kiriromLocation(title: "Climbing Theater", location: CLLocationCoordinate2DMake( 11.3158,104.0649 ),dec: "A multipurpose building which is used for wall climbing during the day and as a movie screen night time at night.", zoom: 14),
        kiriromLocation(title: "First Waterfall", location: CLLocationCoordinate2DMake( 11.3438,104.0348 ),dec: "The most beautiful waterfall in Kirirom mountain which attracts lots of tourists who comes to visit.", zoom: 14),

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
