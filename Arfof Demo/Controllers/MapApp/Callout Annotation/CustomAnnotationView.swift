
import UIKit
import MapKit

class CustomAnnotationView: MKPinAnnotationView {

    weak var calloutView: MyCalloutView?

    override var annotation: MKAnnotation? {
        willSet {
            calloutView?.removeFromSuperview()
        }
    }

    let animationDuration: TimeInterval = 0.25

    // MARK: - Initialization methods
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)

        canShowCallout = false
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - Show and hide callout as needed

    // If the annotation is selected, show the callout; if unselected, remove it
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if selected {
            self.calloutView?.removeFromSuperview()

            let calloutView = MyCalloutView(annotation: annotation as! MKShape)
            calloutView.add(to: self)
            self.calloutView = calloutView

            if animated {
                calloutView.alpha = 0
                UIView.animate(withDuration: animationDuration) {
                    calloutView.alpha = 1
                }
            }
        } else {
            guard let calloutView = calloutView else { return }

            if animated {
                UIView.animate(withDuration: animationDuration, animations: {
                    calloutView.alpha = 0
                }, completion: { _ in
                    calloutView.removeFromSuperview()
                })
            } else {
                calloutView.removeFromSuperview()
            }
        }
    }
    // Make sure that if the cell is reused that we remove it from the super view.
    override func prepareForReuse() {
        super.prepareForReuse()

        calloutView?.removeFromSuperview()
    }

    // MARK: - Detect taps on callout

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if let hitView = super.hitTest(point, with: event) { return hitView }

        if let calloutView = calloutView {
            let pointInCalloutView = convert(point, to: calloutView)
            return calloutView.hitTest(pointInCalloutView, with: event)
        }

        return nil
    }

}

