//
//  File.swift
//  Arfof Demo
//
//  Created by Qualwebs on 26/01/24.
//

import UIKit
import MapKit

class CalloutView: UIView {

    weak var annotation: MKAnnotation?

    enum BubblePointerType {
        case rounded
        case straight(angle: CGFloat)
    }
    
    private let bubblePointerType = BubblePointerType.rounded
    private let inset = UIEdgeInsets(top: 5, left: 5, bottom: 10, right: 5)

    /// Shape layer for callout bubble

    private let bubbleLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.strokeColor = UIColor.black.cgColor
        layer.fillColor = K_PURPLE_LIGHT_COLOR.cgColor
        layer.lineWidth = 0.5
        return layer
    }()

    let contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()

    init(annotation: MKAnnotation) {
        self.annotation = annotation

        super.init(frame: .zero)

        configureView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Configure the view.

    private func configureView() {
        translatesAutoresizingMaskIntoConstraints = false

        addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor, constant: inset.top / 2.0),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -inset.bottom - inset.right / 2.0),
            contentView.leftAnchor.constraint(equalTo: leftAnchor, constant: inset.left / 2.0),
            contentView.rightAnchor.constraint(equalTo: rightAnchor, constant: -inset.right / 2.0),
            contentView.widthAnchor.constraint(greaterThanOrEqualToConstant: inset.left + inset.right),
            contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: inset.top + inset.bottom)
        ])

        addBackgroundButton(to: contentView)

        layer.insertSublayer(bubbleLayer, at: 0)
    }

    // if the view is resized, update the path for the callout bubble

    override func layoutSubviews() {
        super.layoutSubviews()

        updatePath()
    }

    // Override hitTest to detect taps within our callout bubble

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let contentViewPoint = convert(point, to: contentView)
        return contentView.hitTest(contentViewPoint, with: event)
    }
}

// MARK: - Public interface

extension CalloutView {

    @objc func didTouchUpInCallout(_ sender: Any) {
        // this is intentionally blank
    }

    func add(to annotationView: MKAnnotationView) {
        annotationView.addSubview(self)

        // constraints for this callout with respect to its superview

        NSLayoutConstraint.activate([
            bottomAnchor.constraint(equalTo: annotationView.topAnchor, constant: annotationView.calloutOffset.y),
            centerXAnchor.constraint(equalTo: annotationView.centerXAnchor, constant: annotationView.calloutOffset.x)
        ])
    }
}

// MARK: - Private methods

private extension CalloutView {


    func updatePath() {
        let path = UIBezierPath()
        var point = CGPoint(x: bounds.width - inset.right, y: bounds.height - inset.bottom)
        var controlPoint: CGPoint

        path.move(to: point)

        switch bubblePointerType {
        case .rounded:
            addRoundedCalloutPointer(to: path)

        case .straight(let angle):
            addStraightCalloutPointer(to: path, angle: angle)
        }

        // bottom left

        point.x = inset.left
        path.addLine(to: point)

        // lower left corner

        controlPoint = CGPoint(x: 0, y: bounds.height - inset.bottom)
        point = CGPoint(x: 0, y: controlPoint.y - inset.left)
        path.addQuadCurve(to: point, controlPoint: controlPoint)

        // left

        point.y = inset.top
        path.addLine(to: point)

        // top left corner

        controlPoint = CGPoint.zero
        point = CGPoint(x: inset.left, y: 0)
        path.addQuadCurve(to: point, controlPoint: controlPoint)

        // top

        point = CGPoint(x: bounds.width - inset.left, y: 0)
        path.addLine(to: point)

        // top right corner

        controlPoint = CGPoint(x: bounds.width, y: 0)
        point = CGPoint(x: bounds.width, y: inset.top)
        path.addQuadCurve(to: point, controlPoint: controlPoint)

        // right

        point = CGPoint(x: bounds.width, y: bounds.height - inset.bottom - inset.right)
        path.addLine(to: point)

        // lower right corner

        controlPoint = CGPoint(x: bounds.width, y: bounds.height - inset.bottom)
        point = CGPoint(x: bounds.width - inset.right, y: bounds.height - inset.bottom)
        path.addQuadCurve(to: point, controlPoint: controlPoint)

        path.close()

        bubbleLayer.path = path.cgPath
    }

    func addRoundedCalloutPointer(to path: UIBezierPath) {
        // lower right
        var point = CGPoint(x: bounds.width / 2.0 + inset.bottom, y: bounds.height - inset.bottom)
        path.addLine(to: point)

        // right side of arrow

        var controlPoint = CGPoint(x: bounds.width / 2.0, y: bounds.height - inset.bottom)
        point = CGPoint(x: bounds.width / 2.0, y: bounds.height)
        path.addQuadCurve(to: point, controlPoint: controlPoint)

        // left of pointer

        controlPoint = CGPoint(x: point.x, y: bounds.height - inset.bottom)
        point = CGPoint(x: point.x - inset.bottom, y: controlPoint.y)
        path.addQuadCurve(to: point, controlPoint: controlPoint)
    }

    func addStraightCalloutPointer(to path: UIBezierPath, angle: CGFloat) {
        // lower right
        var point = CGPoint(x: bounds.width / 2.0 + tan(angle) * inset.bottom, y: bounds.height - inset.bottom)
        path.addLine(to: point)

        // right side of arrow

        point = CGPoint(x: bounds.width / 2.0, y: bounds.height)
        path.addLine(to: point)

        // left of pointer

        point = CGPoint(x: bounds.width / 2.0 - tan(angle) * inset.bottom, y: bounds.height - inset.bottom)
        path.addLine(to: point)
    }
    func addBackgroundButton(to view: UIView) {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: view.topAnchor),
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        button.addTarget(self, action: #selector(didTouchUpInCallout(_:)), for: .touchUpInside)
    }
}
