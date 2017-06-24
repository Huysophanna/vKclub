import UIKit
import GoogleMaps

class VacationDestination: NSObject {
    
    let name: String
    let location: CLLocationCoordinate2D
    let zoom: Float
    
    init(name: String, location: CLLocationCoordinate2D, zoom: Float) {
        self.name = name
        self.location = location
        self.zoom = zoom
    }
    
}

class MapController: UIViewController {
    
    @IBOutlet weak var Ima: UIImageView!
    var mapView: GMSMapView?
    
    var currentDestination: VacationDestination?
    
    let destinations = [VacationDestination(name: "Embarcadero Bart Station", location: CLLocationCoordinate2DMake(37.792905, -122.397059), zoom: 14), VacationDestination(name: "Ferry Building", location: CLLocationCoordinate2DMake(37.795434, -122.39473), zoom: 18), VacationDestination(name: "Coit Tower", location: CLLocationCoordinate2DMake(37.802378, -122.405811), zoom: 15), VacationDestination(name: "Fisherman's Wharf", location: CLLocationCoordinate2DMake(37.808, -122.417743), zoom: 15), VacationDestination(name: "Golden Gate Bridge", location: CLLocationCoordinate2DMake(37.807664, -122.475069), zoom: 13)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Map()
        
    }
    
    func Map(){
        
        //map view
        GMSServices.provideAPIKey("AIzaSyA0QlNOrMY6JU7wqgBXBamQq1v9wbR11Z0")
        let camera = GMSCameraPosition.camera(withLatitude: 11.3167, longitude: 104.0651, zoom: 12)
        mapView = GMSMapView.map(withFrame:  .zero, camera: camera)
        view = mapView
        
        //Map overlay
        
        let southWest = CLLocationCoordinate2D(latitude: 11.3432, longitude:104.0842 )
        let northEast = CLLocationCoordinate2D(latitude: 11.3044, longitude: 104.0322)
        let overlayBounds = GMSCoordinateBounds(coordinate: southWest, coordinate: northEast)
        let icon  = UIImage(named: "vmap")!
        let overlay = GMSGroundOverlay(bounds: overlayBounds, icon: icon)
        overlay.bearing = 0
        overlay.map = mapView
        
        
        
        
    }
    
   
    
}
