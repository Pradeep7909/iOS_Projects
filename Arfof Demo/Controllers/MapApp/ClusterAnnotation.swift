//
//  ClusterAnnotation.swift
//  Arfof Demo
//
//  Created by Qualwebs on 24/01/24.
//

import Foundation
import MapKit

class UserAnnotationView: MKMarkerAnnotationView {
    static let preferredClusteringIdentifier = Bundle.main.bundleIdentifier! + ".UserAnnotationView"

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        clusteringIdentifier = UserAnnotationView.preferredClusteringIdentifier
        collisionMode = .circle
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var annotation: MKAnnotation? {
        willSet {
            clusteringIdentifier = UserAnnotationView.preferredClusteringIdentifier
        }
    }
}


class UserClusterAnnotationView: MKAnnotationView {
    static let preferredClusteringIdentifier = Bundle.main.bundleIdentifier! + ".UserClusterAnnotationView"

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        collisionMode = .circle
        updateImage()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var annotation: MKAnnotation? { didSet { updateImage() } }

    private func updateImage() {
        if let clusterAnnotation = annotation as? MKClusterAnnotation {
            self.image = image(count: clusterAnnotation.memberAnnotations.count)
        } else {
            self.image = image(count: 1)
        }
    }

    func image(count: Int) -> UIImage {
        let bounds = CGRect(origin: .zero, size: CGSize(width: 40, height: 40))

        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { _ in
            // Fill full circle with tricycle color
            UIBezierPath(ovalIn: bounds).fill()

            // Fill inner circle with white color
            UIColor.white.setFill()
            UIBezierPath(ovalIn: bounds.insetBy(dx: 8, dy: 8)).fill()

            // Finally draw count text vertically and horizontally centered
            let attributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.black,
                .font: UIFont.boldSystemFont(ofSize: 20)
            ]

            let text = "\(count)"
            let size = text.size(withAttributes: attributes)
            let origin = CGPoint(x: bounds.midX - size.width / 2, y: bounds.midY - size.height / 2)
            let rect = CGRect(origin: origin, size: size)
            text.draw(in: rect, withAttributes: attributes)
        }
    }
}
