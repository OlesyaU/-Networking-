//
//  LocationController.swift
//  Navigation
//
//  Created by Олеся on 01.05.2023.
//

import UIKit
import MapKit
import CoreLocation

class LocationController: UIViewController, MKMapViewDelegate {
    private lazy var mapView = MKMapView()
    private let locationManager = CLLocationManager()
    private var ourPlace = CLLocationCoordinate2D()
    private var endPlace = CLLocationCoordinate2D()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpMap()
        configureMapView()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        locationManager.requestWhenInUseAuthorization()
        ourPlace = getStartLocation()
        tapToClear()
        addGesturePin()
       
    }
    
    private func getStartLocation()-> CLLocationCoordinate2D {
        guard let startLocation = locationManager.location?.coordinate else {
            print("locationManager is \(locationManager)")
            return CLLocationCoordinate2D()
        }
        return startLocation
    }
    
    private func addGesturePin(){
        let setPin = UILongPressGestureRecognizer(target: self, action: #selector(addAnnotation))
        setPin.minimumPressDuration = 0.5
        mapView.addGestureRecognizer(setPin)
    }
    
    private func tapToClear(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(сlearAnnotation))
        let loc =  tap.location(in: mapView)
        var coord = mapView.convert(loc, toCoordinateFrom: mapView)
        tap.numberOfTapsRequired = 3
        mapView.addGestureRecognizer(tap)
   }
    
    @objc func addAnnotation(gestureRecognizer:UIGestureRecognizer){
        var touchPoint = gestureRecognizer.location(in: mapView)
        var newCoordinates = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        let annotation = MKPointAnnotation()
        annotation.coordinate = newCoordinates
        mapView.addAnnotation(annotation)
        endPlace = newCoordinates
        addRoute()
    }
    @objc func сlearAnnotation(){
        let aleart = UIAlertController(title: "Удалить все пины", message: "Хотите удалить все точки и маршруты?", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "Да, удалить", style: .destructive) {_ in
            
            self.mapView.removeAnnotations(self.mapView.annotations)
            self.mapView.removeOverlays(self.mapView.overlays)
        }
        
        let action2 = UIAlertAction(title: "Нет, оставить", style: .cancel)
        aleart.addAction(action1)
        aleart.addAction(action2)
        self.present(aleart, animated: true)
    }
    
    private func setUpMap(){
        mapView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mapView)
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func configureMapView() {
        mapView.mapType = .hybrid
        mapView.showsUserLocation = true
        mapView.isUserInteractionEnabled = true
        
        //            Задаем zoom (MKMapView не имеет данного свойства)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            let region = MKCoordinateRegion(center: self!.ourPlace, latitudinalMeters: 1000, longitudinalMeters: 1000)
            self?.mapView.setRegion(region, animated: true)
        }
       mapView.showsTraffic = true
    }
    
    private func checkUserLocationPermissions() {
        
        switch locationManager.authorizationStatus {
            case .notDetermined:
                locationManager.delegate = self
                locationManager.requestWhenInUseAuthorization()
                print("сработал кейс авторизации разрешения пользователя \(locationManager.authorizationStatus)")
            case .authorizedAlways, .authorizedWhenInUse:
                mapView.showsUserLocation = true
                print("сработал кейс авторизации разрешения пользователя \(locationManager.authorizationStatus)")
            case .denied, .restricted:
                showAleartAutorization()
                print("сработал кейс авторизации разрешения пользователя \(locationManager.authorizationStatus)")
            @unknown default:
                fatalError("Не обрабатываемый статус")
                print("сработал кейс авторизации разрешения пользователя \(locationManager.authorizationStatus)")
        }
    }
    
    private func showAleartAutorization() {
        let aleart = UIAlertController(title: "Определение геолокации отключено", message: "Пожалуйста зайдите в настройки вашего телефона и разрешите доступ к геолокации", preferredStyle: .alert)
        let action = UIAlertAction(title: "Понятно", style: .cancel)
        aleart.addAction(action)
        self.present(aleart, animated: true)
    }
}

extension LocationController: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkUserLocationPermissions()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
        mapView.setRegion(region, animated: true)
    }
    
    private func addRoute() {
        let directionRequest = MKDirections.Request()
        
        let sourcePlaceMark = MKPlacemark(coordinate: ourPlace)
        let sourceMapItem = MKMapItem(placemark: sourcePlaceMark)
        
        let destinationPlaceMark = MKPlacemark(coordinate: endPlace)
        let destinationMapItem = MKMapItem(placemark: destinationPlaceMark)
        
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .automobile
        
        // Высчитываем путь
        let directions = MKDirections(request: directionRequest)
        directions.calculate { [weak self] response, error -> Void in
            guard let self = self else {
                return
            }
            
            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }
                
                return
            }
            
            let route = response.routes[0]
            self.mapView.delegate = self
            self.mapView.addOverlay(route.polyline, level: .aboveRoads)
            
            let rect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor(red: 17.0/255.0, green: 147.0/255.0, blue: 255.0/255.0, alpha: 1)
        renderer.lineWidth = 5.0
        return renderer
    }
}
