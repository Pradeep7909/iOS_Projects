//
//  File2.swift
//  iOS App
//
//  Created by Qualwebs on 26/01/24.
//

import UIKit
import MapKit

protocol MyCalloutViewDelegate: AnyObject {
    func mapView(_ mapView: MKMapView, didTapDetailsButton button: UIButton, for annotation: MKAnnotation)
}

class MyCalloutView: CalloutView {

    private var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = .preferredFont(forTextStyle: .callout)

        return label
    }()

    private var subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = .preferredFont(forTextStyle: .caption1)

        return label
    }()

    private var detailsButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Details", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 3

        return button
    }()

    override init(annotation: MKAnnotation) {
        super.init(annotation: annotation)
        configure()
        updateContents(for: annotation)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("Should not call init(coder:)")
    }

    /// Update callout contents

    private func updateContents(for annotation: MKAnnotation) {
        titleLabel.text = annotation.title ?? "Unknown"
        subtitleLabel.text = annotation.subtitle ?? nil
    }

    /// Add constraints for subviews of `contentView`

    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(detailsButton)
        detailsButton.addTarget(self, action: #selector(didTapDetailsButton(_:)), for: .touchUpInside)

        let views: [String: UIView] = [
            "titleLabel": titleLabel,
            "subtitleLabel": subtitleLabel,
            "detailsButton": detailsButton
        ]

        let vflStrings = [
            "V:|-[titleLabel]-[subtitleLabel]-[detailsButton]-|",
            "H:|-[titleLabel]-|",
            "H:|-[subtitleLabel]-|",
            "H:|-[detailsButton]-|"
        ]

        for vfl in vflStrings {
            contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: vfl, metrics: nil, views: views))
        }
    }

    override func didTouchUpInCallout(_ sender: Any) {
        print("didTouchUpInCallout")
    }

    @objc func didTapDetailsButton(_ sender: UIButton) {
        if let mapView = mapView, let delegate = mapView.delegate as? MyCalloutViewDelegate {
            delegate.mapView(mapView, didTapDetailsButton: sender, for: annotation!)
        }
    }
    var mapView: MKMapView? {
        var view = superview
        while view != nil {
            if let mapView = view as? MKMapView { return mapView }
            view = view?.superview
        }
        return nil
    }
}
