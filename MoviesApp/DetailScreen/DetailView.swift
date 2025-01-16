import UIKit

class DetailView: UIView {
    
    private final let constant: CGFloat = 10
    private final let iconsConstant: CGFloat = 20
    private final let posterHeight: CGFloat = 180
    private final let posterWidth: CGFloat = 120
    var onTrailerButtonTap: (() -> Void)?
    var onSaveButtonTap: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(hex: "242A32")
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .clear
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    lazy var imagesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
        return collectionView
    }()
    
    lazy var ratingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Color.orangeRating
        label.font = UIFont(name: "Montserrat-Medium", size: 16)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var ratingImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.image = UIImage(named: "rating")
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var ratingStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [ratingImage, ratingLabel])
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.layoutMargins = UIEdgeInsets(top: 2, left: 5, bottom: 2, right: 5)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.alignment = .center
        stackView.backgroundColor = UIColor(hex: "242A32", alpha: 0.7)
        stackView.clipsToBounds = true
        stackView.layer.cornerRadius = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Montserrat-Bold", size: 24)
        label.textColor = Color.white
        label.numberOfLines = 0
        return label
    }()
    
    lazy var yearLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Montserrat-Medium", size: 16)
        label.textColor = Color.stackColor
        return label
    }()
    
    lazy var durationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Montserrat-Medium", size: 16)
        label.textColor = Color.stackColor
        return label
    }()
    
    lazy var genreLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Montserrat-Medium", size: 16)
        label.textColor = Color.stackColor
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Montserrat-Medium", size: 16)
        label.numberOfLines = 0
        label.textColor = Color.white
        return label
    }()
    
    private lazy var starsLabel: UILabel = {
        let label = UILabel()
        label.textColor = Color.white
        label.text = "Актеры: "
        label.font = UIFont(name: "Montserrat-Bold", size: 24)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
        
    lazy var starsNamesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Montserrat-Medium", size: 16)
        label.numberOfLines = 0
        label.textColor = Color.white
        return label
    }()
    
    lazy var trailerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Посмотреть трейлер", for: .normal)
        button.titleLabel?.font = UIFont(name: "Montserrat-Medium", size: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "play.rectangle"), for: .normal)
        button.setImage(UIImage(systemName: "play.rectangle.fill"), for: .highlighted)
        button.addAction(trailerAction, for: .touchUpInside)

        return button
    }()
    
    lazy var favoriteButton: UIButton = {
        let button = UIButton(type: .custom, primaryAction: onSaveButtonTapAction)
        button.setImage(UIImage(systemName:"bookmark"), for: .normal)
        return button
    }()
    
    private lazy var onSaveButtonTapAction = UIAction { [weak self] _ in
        guard let self else { return }
        self.onSaveButtonTap?()
    }
    
    private lazy var trailerAction = UIAction { [weak self] _ in
        guard let self else { return }
        self.onTrailerButtonTap?()
    }
    
    private lazy var yearImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.image = UIImage(named: "calendar")
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var durationImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.image = UIImage(named: "clock")
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var genreImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.image = UIImage(systemName: "ticket")
        image.tintColor = UIColor(hex: "92929D")
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var yearDurationGenreStack: UIStackView = {
        func createDivider() -> UILabel {
            let label = UILabel()
            label.text = "|"
            label.textColor = Color.stackColor
            label.textAlignment = .center
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }
        
        let stackView = UIStackView(arrangedSubviews: [yearImage, yearLabel, createDivider(), durationImage, durationLabel, createDivider(), genreImage, genreLabel])
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private func setupUI() {
        addSubview(scrollView)
        scrollView.addSubview(imagesCollectionView)
        scrollView.addSubview(posterImageView)
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(ratingStack)
        scrollView.addSubview(yearDurationGenreStack)
        scrollView.addSubview(descriptionLabel)
        scrollView.addSubview(starsLabel)
        scrollView.addSubview(starsNamesLabel)
        scrollView.addSubview(trailerButton)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            
            imagesCollectionView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: constant),
            imagesCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imagesCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imagesCollectionView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.3),
            
            posterImageView.topAnchor.constraint(equalTo: imagesCollectionView.bottomAnchor, constant: -posterHeight/2),
            posterImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: constant*4),
            posterImageView.widthAnchor.constraint(equalToConstant: posterWidth),
            posterImageView.heightAnchor.constraint(equalToConstant: posterHeight),
            
            titleLabel.topAnchor.constraint(equalTo: imagesCollectionView.bottomAnchor, constant: constant*2),
            titleLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: constant),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -constant),
            
            ratingStack.bottomAnchor.constraint(equalTo: imagesCollectionView.bottomAnchor, constant: -constant),
            ratingStack.trailingAnchor.constraint(equalTo: imagesCollectionView.trailingAnchor, constant: -constant),
            ratingStack.widthAnchor.constraint(equalTo: imagesCollectionView.widthAnchor, multiplier: 0.15),
            ratingStack.heightAnchor.constraint(equalTo: imagesCollectionView.heightAnchor, multiplier: 0.1),
            
            ratingImage.heightAnchor.constraint(equalTo: ratingStack.heightAnchor, multiplier: 0.6),
            ratingImage.widthAnchor.constraint(equalTo: ratingImage.heightAnchor),
            
            yearImage.heightAnchor.constraint(equalToConstant: iconsConstant),
            yearImage.widthAnchor.constraint(equalToConstant: iconsConstant),
            durationImage.heightAnchor.constraint(equalToConstant: iconsConstant),
            durationImage.widthAnchor.constraint(equalToConstant: iconsConstant),
            genreImage.heightAnchor.constraint(equalToConstant: iconsConstant),
            genreImage.widthAnchor.constraint(equalToConstant: iconsConstant),
            
            yearDurationGenreStack.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: constant*3),
            yearDurationGenreStack.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: yearDurationGenreStack.bottomAnchor, constant: constant*3),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: constant),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -constant),
            
            starsLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: constant),
            starsLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: constant),
            starsLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -constant),
            
            starsNamesLabel.topAnchor.constraint(equalTo: starsLabel.bottomAnchor, constant: constant),
            starsNamesLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: constant),
            starsNamesLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -constant),
            
            trailerButton.topAnchor.constraint(equalTo: starsNamesLabel.bottomAnchor, constant: constant),
            trailerButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            trailerButton.heightAnchor.constraint(equalToConstant: 50),
            trailerButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -constant)
        ])
    }
}

extension DetailView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
}

		
