import UIKit
import Alamofire
import SnapKit
class ViewController: UIViewController {
    let cv: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        return collectionView
    }()
    let iv: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView()
        return indicatorView
    }()
    var images = [
        "https://random.dog/9f297526-70cc-432b-a00e-2198e9eccfe8.jpg",
        "https://random.dog/8f969962-5ca9-418c-95e0-7b37817294b1.jpg",
        "https://random.dog/C35XPEgVUAEUkCm.jpg",
        "https://random.dog/00186969-c51d-462b-948b-30a7e1735908.jpg",
        "https://random.dog/4e460068-825d-4277-a269-00e0675b0faf.jpg",
        "https://random.dog/046e5758-d1ef-436f-b7e2-530134562445.jpg",
        "https://random.dog/f355626a-5868-4a22-b173-a7c8571abb80.jpg",
        "https://random.dog/6129aa24-e224-4f7b-8058-e33cca8bfab0.JPG"
    ]
    var img: [UIImage?] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        configurecv()
        configureiv()
        fetchData()
    }
    func configurecv() {
        view.addSubview(cv)
        cv.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        cv.delegate = self
        cv.dataSource = self
        cv.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.reuseIdentifier)
    }
    func configureiv() {
        view.addSubview(iv)
        iv.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    func fetchData() {
        let dispatchGroup = DispatchGroup()
        iv.startAnimating()
        for url in images {
            dispatchGroup.enter()
            AF.request(url).responseData { response in
                switch response.result {
                case .success(let data):
                    if let image = UIImage(data: data) {
                        self.img.append(image)
                    } else {
                        self.img.append(nil)
                    }
                case .failure(let error):
                    print(error)
                }
                dispatchGroup.leave()
            }
        }
        dispatchGroup.notify(queue: .main) {
            self.iv.stopAnimating()
            self.cv.reloadData()
        }
    }
}
extension ViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return img.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.reuseIdentifier, for: indexPath) as! ImageCell
        cell.imageView.image = img[indexPath.item]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width / 2 - 10, height: collectionView.bounds.width / 2 - 10)
    }
}
class ImageCell: UICollectionViewCell {
    static let reuseIdentifier = "ImageCell"
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
