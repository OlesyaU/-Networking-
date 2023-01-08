//
//  PhotosViewController.swift
//  Navigation
//
//  Created by Олеся on 16.04.2022.
//

import UIKit
import iOSIntPackage

class PhotosViewController: UIViewController {
    
    private var photos = Photo.getPhotos()
    private var photos2 = Photo.getDoudlePhotos()
    private let constraint: CGFloat = 8
    private let processor = ImageProcessor()
    private var testErrorPhotos = [UIImage]()
    
    
    private lazy var collection: UICollectionView =  {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.dataSource = self
        collection.delegate = self
        collection.register(PhotosCollectionViewCell.self, forCellWithReuseIdentifier: PhotosCollectionViewCell.identifier)
        return collection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        title = "Photo Gallery"
        navigationController?.navigationBar.topItem?.backButtonTitle = "Back"
        layout()
        //                errorsHandle()
        //        filteringImage(images: photos)
        filteringImage(images: testErrorPhotos)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    private func layout(){
        view.addSubview(collection)
        NSLayoutConstraint.activate([
            collection.topAnchor.constraint(equalTo: view.topAnchor),
            collection.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collection.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collection.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
    }
}
// MARK: - UICollectionViewDataSource
extension PhotosViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //        photos.count
        //        photos2.count
        testErrorPhotos.count
        //        в этот метод надо поставить тестовый(пустой) массив
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotosCollectionViewCell.identifier, for: indexPath) as? PhotosCollectionViewCell else {return UICollectionViewCell()}
        //        в этот метод надо поставить тестовый(пустой) массив
        //        let photo = photos[indexPath.item]
        //        let photo = photos2[indexPath.item]
        let photo = testErrorPhotos[indexPath.item]
        cell.configure(photo: photo)
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension PhotosViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - constraint * 4)/3
        return CGSize(width: width, height: width)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: constraint, left: constraint, bottom: constraint, right: constraint)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        constraint
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        constraint
    }
}

extension PhotosViewController {
    //        в этот метод надо поставить тестовый(пустой) массив
    private func filteringImage(images: [UIImage]) -> Result<[UIImage],VCErrors> {
        let start = DispatchTime.now().uptimeNanoseconds
        if !images.isEmpty {
            processor.processImagesOnThread(sourceImages: images, filter: .sepia(intensity: 1.0), qos: .userInitiated, completion: { [weak self] images in
                self?.photos = images
                //                self?.photos2 = images
                //                self?.testErrorPhotos = images
                    .compactMap{$0}
                    .map{UIImage(cgImage: $0)}
                DispatchQueue.main.async {
                    [weak self] in
                    self?.collection.reloadData()
                    let end = DispatchTime.now().uptimeNanoseconds
                    let allTime = Int(end - start)/1000000000
                    print("Время на наложение фильтра \(allTime) секунд")
                }
            })
            return .success(images)
        } else {
            let aleart = UIAlertAction(title: "OK", style: .cancel)
            let act = UIAlertController(title: "OOOOPS", message: "Sorrryyyy...no data, pictures does not loaded", preferredStyle: .alert)
            act.addAction(aleart)
            present(act, animated: true)
            print("NO Data for show")
            return .failure(VCErrors.noData)
        }
    }
    
    private func errorsHandle() {
        do {
            try filteringImage(images: testErrorPhotos)
        }
        catch let error as VCErrors {
            switch error {
                case .noData:
                    let aleart = UIAlertAction(title: "OK", style: .cancel)
                    let act = UIAlertController(title: "OOOOPS", message: "Sorrryyyy...no data, pictures does not loaded", preferredStyle: .alert)
                    act.addAction(aleart)
                    present(act, animated: true)
                default:
                    print("default")
            }
        }
    }
}
//class PhotosViewController ошибка тут- пустой массив картинок
// надо немного попереставлять массив и передавать его в метод private func filteringImage(images: [UIImage])...оставила первую реализацию с обработкой ошибок тоже, чтобы Вы посмотрели правильно ли он реализован(надеюсь что да 🤞)


// Используем разные приоритеты и стандартный массив картинок:
//Время на наложение фильтра 9 секунд - sourceImages: photos, filter: .noir, qos: .userInteractive,
//Время на наложение фильтра 9 секунд - sourceImages: photos, filter: .noir, qos:  .userInitiated,
//Время на наложение фильтра 9 секунд - sourceImages: photos, filter: .noir, qos: .utility,
//Время на наложение фильтра 10 секунд - sourceImages: photos, filter: .noir, qos: .background,
//Время на наложение фильтра 9 секунд - sourceImages: photos, filter: .noir, qos: .default.

// Используем разные приоритеты и удвоенный массив картинок: надо заменить(перекомментировать код) в 4 местах - в параметрах метода наложения фильтра, в замыкании метода и в методах  cellForRowAt и numberOfItemsInSection
//Время на наложение фильтра 17 секунд - sourceImages: photos2, filter: .noir, qos: .userInteractive
//Время на наложение фильтра 17 секунд - sourceImages: photos2, filter: .noir, qos: .userInitiated
//Время на наложение фильтра 18 секунд - sourceImages: photos2, filter: .noir, qos: .utility
//Время на наложение фильтра 52 секунд - sourceImages: photos2, filter: .noir, qos: .background (скроллила )
//Время на наложение фильтра 46 секунд - sourceImages: photos2, filter: .noir, qos: .background ( НЕ СКРОЛЛИЛА)
//Время на наложение фильтра 17 секунд - sourceImages: photos2, filter: .noir, qos:  .default
