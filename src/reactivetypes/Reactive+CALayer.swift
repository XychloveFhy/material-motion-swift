/*
 Copyright 2016-present The Material Motion Authors. All Rights Reserved.

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

import UIKit

extension Reactive where O: CALayer {

  public var anchorPoint: ReactiveProperty<CGPoint> {
    let layer = _object
    return _properties.named(#function, onCacheMiss: {
      return createCoreAnimationProperty(#function,
                                          initialValue: layer.anchorPoint,
                                          externalWrite: { $0.anchorPoint = $1 },
                                          keyPath: "anchorPoint")
    })
  }

  public var anchorPointAdjustment: ReactiveProperty<AnchorPointAdjustment> {
    let anchorPoint = self.anchorPoint
    let position = self.position
    return _properties.named(#function, onCacheMiss: {
      return ReactiveProperty<AnchorPointAdjustment>("\(pretty(_object)).\(#function)", initialValue: .init(anchorPoint: anchorPoint.value, position: position.value)) {
        anchorPoint.value = $0.anchorPoint; position.value = $0.position
      }
    })
  }

  public var cornerRadius: ReactiveProperty<CGFloat> {
    let layer = _object
    return _properties.named(#function, onCacheMiss: {
      return createCoreAnimationProperty(#function,
                                          initialValue: layer.cornerRadius,
                                          externalWrite: { $0.cornerRadius = $1 },
                                          keyPath: "cornerRadius")
    })
  }

  public var height: ReactiveProperty<CGFloat> {
    let size = self.size
    return _properties.named(#function, onCacheMiss: {
      return createCoreAnimationProperty(#function,
                                          initialValue: size.value.height,
                                          externalWrite: { var dimensions = size.value; dimensions.height = $1; size.value = dimensions },
                                          keyPath: "bounds.size.height")
    })
  }

  public var opacityKeyPath: CoreAnimationKeyPath<CGFloat> {
    let layer = _object

    return _properties.named(#function, onCacheMiss: {
      return CoreAnimationKeyPath("opacity", onLayer: layer, property: opacity)
    })
  }

  public var opacity: ReactiveProperty<CGFloat> {
    let layer = _object
    return _properties.named(#function, onCacheMiss: {
      return createCoreAnimationProperty(#function,
                                          initialValue: CGFloat(layer.opacity),
                                          externalWrite: { $0.opacity = Float($1) },
                                          keyPath: "opacity")
    })
  }

  public var positionKeyPath: CoreAnimationKeyPath<CGPoint> {
    let layer = _object

    return _properties.named(#function, onCacheMiss: {
      return CoreAnimationKeyPath("position", onLayer: layer, property: position)
    })
  }

  public var position: ReactiveProperty<CGPoint> {
    let layer = _object
    return _properties.named(#function, onCacheMiss: {
      return createCoreAnimationProperty(#function,
                                          initialValue: layer.position,
                                          externalWrite: { $0.position = $1 },
                                          keyPath: "position")
    })
  }

  public var positionX: ReactiveProperty<CGFloat> {
    let position = self.position
    return _properties.named(#function, onCacheMiss: {
      return createCoreAnimationProperty(#function,
                                          initialValue: position.value.x,
                                          externalWrite: { var point = position.value; point.x = $1; position.value = point },
                                          keyPath: "position.x")
    })
  }

  public var positionYKeyPath: CoreAnimationKeyPath<CGFloat> {
    let layer = _object

    return _properties.named(#function, onCacheMiss: {
      return CoreAnimationKeyPath("position.y", onLayer: layer, property: positionY)
    })
  }

  public var positionY: ReactiveProperty<CGFloat> {
    let position = self.position
    return _properties.named(#function, onCacheMiss: {
      return createCoreAnimationProperty(#function,
                                          initialValue: position.value.y,
                                          externalWrite: { var point = position.value; point.y = $1; position.value = point },
                                          keyPath: "position.y")
    })
  }

  public var rotation: ReactiveProperty<CGFloat> {
    let layer = _object
    return _properties.named(#function, onCacheMiss: {
      return createCoreAnimationProperty(#function,
                                          initialValue: layer.value(forKeyPath: "transform.rotation.z") as! CGFloat,
                                          externalWrite: { $0.setValue($1, forKeyPath: "transform.rotation.z") },
                                          keyPath: "transform.rotation.z")
    })
  }

  public var scaleKeyPath: CoreAnimationKeyPath<CGFloat> {
    let layer = _object
    return _properties.named(#function, onCacheMiss: {
      return CoreAnimationKeyPath("transform.scale.xy", onLayer: layer, property: scale)
    })
  }

  public var scale: ReactiveProperty<CGFloat> {
    let layer = _object
    return _properties.named(#function, onCacheMiss: {
      return createCoreAnimationProperty(#function,
                                          initialValue: layer.value(forKeyPath: "transform.scale") as! CGFloat,
                                          externalWrite: { $0.setValue($1, forKeyPath: "transform.scale") },
                                          keyPath: "transform.scale.xy")
    })
  }

  public var size: ReactiveProperty<CGSize> {
    let layer = _object
    return _properties.named(#function, onCacheMiss: {
      return createCoreAnimationProperty(#function,
                                          initialValue: layer.bounds.size,
                                          externalWrite: { $0.bounds.size = $1 },
                                          keyPath: "bounds.size")
    })
  }

  public var shadowPath: ReactiveProperty<CGPath> {
    let layer = _object
    return _properties.named(#function, onCacheMiss: {
      return createCoreAnimationProperty(#function,
                                          initialValue: layer.shadowPath!,
                                          externalWrite: { $0.shadowPath = $1 },
                                          keyPath: "shadowPath")
    })
  }

  public var width: ReactiveProperty<CGFloat> {
    let size = self.size
    return _properties.named(#function, onCacheMiss: {
      return createCoreAnimationProperty(#function,
                                          initialValue: size.value.width,
                                          externalWrite: { var dimensions = size.value; dimensions.width = $1; size.value = dimensions },
                                          keyPath: "bounds.size.width")
    })
  }

  func createCoreAnimationProperty<T>(_ name: String, initialValue: T, externalWrite: @escaping (O, T) -> Void, keyPath: String) -> ReactiveProperty<T> {
    let layer = _object
    var decomposedKeys = Set<String>()
    var updateProperty: ((T) -> Void)?
    let property = ReactiveProperty("\(pretty(layer)).\(name)", initialValue: initialValue, externalWrite: { [weak layer] value in
      guard let layer = layer else { return }

      let actionsWereDisabled = CATransaction.disableActions()
      CATransaction.setDisableActions(true)
      externalWrite(layer, value)
      CATransaction.setDisableActions(actionsWereDisabled)
    }, coreAnimation: { [weak layer] event in
      guard let layer = layer else { return }

      switch event {
      case .add(let info):
        if let timeline = info.timeline {
          layer.timeline = timeline
        }

        let animation = info.animation.copy() as! CAPropertyAnimation

        animation.duration *= TimeInterval(simulatorDragCoefficient())

        if layer.speed == 0, let lastTimelineState = layer.lastTimelineState {
          animation.beginTime = TimeInterval(lastTimelineState.beginTime) + animation.beginTime
        } else {
          animation.beginTime = layer.convertTime(CACurrentMediaTime(), from: nil) + animation.beginTime
        }

        animation.keyPath = keyPath

        if let unsafeMakeAdditive = info.makeAdditive {
          let makeAdditive: ((Any, Any) -> Any) = { from, to in
            // When mapping properties to properties it's possible for the values to get implicitly
            // wrapped in an NSNumber instance. This may cause the generic makeAdditive
            // implementation to fail to cast to T, so we unbox the type here instead.
            if let from = from as? NSNumber, let to = to as? NSNumber {
              return from.doubleValue - to.doubleValue
            }
            return unsafeMakeAdditive(from, to)
          }

          if let basicAnimation = animation as? CABasicAnimation {
            basicAnimation.fromValue = makeAdditive(basicAnimation.fromValue!, basicAnimation.toValue!)
            basicAnimation.toValue = makeAdditive(basicAnimation.toValue!, basicAnimation.toValue!)
            basicAnimation.isAdditive = true

          } else if let keyframeAnimation = animation as? CAKeyframeAnimation {
            let lastValue = keyframeAnimation.values!.last!
            keyframeAnimation.values = keyframeAnimation.values!.map { makeAdditive($0, lastValue) }
            keyframeAnimation.isAdditive = true
          }
        }

        // Core Animation springs do not support multi-dimensional velocity, so we bear the burden
        // of decomposing multi-dimensional springs here.
        if let springAnimation = animation as? CASpringAnimation
          , springAnimation.isAdditive
          , let initialVelocity = info.initialVelocity as? CGPoint
          , let delta = springAnimation.fromValue as? CGPoint {
          let decomposed = decompose(springAnimation: springAnimation,
                                     delta: delta,
                                     initialVelocity: initialVelocity)

          CATransaction.begin()
          CATransaction.setCompletionBlock(info.onCompletion)
          layer.add(decomposed.0, forKey: info.key + ".x")
          layer.add(decomposed.1, forKey: info.key + ".y")
          CATransaction.commit()

          decomposedKeys.insert(info.key)
          return
        }

        if let initialVelocity = info.initialVelocity {
          applyInitialVelocity(initialVelocity, to: animation)
        }

        CATransaction.begin()
        CATransaction.setCompletionBlock(info.onCompletion)
        layer.add(animation, forKey: info.key + "." + keyPath)
        CATransaction.commit()

      case .remove(let key):
        if let presentationLayer = layer.presentation() {
          updateProperty?(presentationLayer.value(forKeyPath: keyPath) as! T)
        }
        if decomposedKeys.contains(key) {
          layer.removeAnimation(forKey: key + ".x")
          layer.removeAnimation(forKey: key + ".y")
          decomposedKeys.remove(key)

        } else {
          layer.removeAnimation(forKey: key + "." + keyPath)
        }
      }
    })

    updateProperty = { [weak property] value in
      guard let property = property else { return }
      property.value = value
    }
    var lastView: UIView?
    property.shouldVisualizeMotion = { [weak layer] view, containerView in
      guard let layer = layer else { return }

      if lastView != view, let lastView = lastView {
        lastView.removeFromSuperview()
      }
      view.isUserInteractionEnabled = false
      if let superlayer = layer.superlayer {
        view.frame = superlayer.convert(superlayer.bounds, to: containerView.layer)
      } else {
        view.frame = containerView.bounds
      }
      containerView.addSubview(view)
      lastView = view
    }

    return property
  }
}

private func decompose(springAnimation: CASpringAnimation, delta: CGPoint, initialVelocity: CGPoint) -> (CASpringAnimation, CASpringAnimation) {
  let xAnimation = springAnimation.copy() as! CASpringAnimation
  let yAnimation = springAnimation.copy() as! CASpringAnimation
  xAnimation.fromValue = delta.x
  yAnimation.fromValue = delta.y
  xAnimation.toValue = 0
  yAnimation.toValue = 0

  if delta.x != 0 {
    xAnimation.initialVelocity = initialVelocity.x / -delta.x
  }
  if delta.y != 0 {
    yAnimation.initialVelocity = initialVelocity.y / -delta.y
  }

  xAnimation.keyPath = springAnimation.keyPath! + ".x"
  yAnimation.keyPath = springAnimation.keyPath! + ".y"

  return (xAnimation, yAnimation)
}

private func applyInitialVelocity(_ initialVelocity: Any, to animation: CAPropertyAnimation) {
  if let springAnimation = animation as? CASpringAnimation, springAnimation.isAdditive {
    // Additive animations have a toValue of 0 and a fromValue of negative delta (where the model
    // value came from).
    guard let initialVelocity = initialVelocity as? CGFloat, let delta = springAnimation.fromValue as? CGFloat else {
      // Unsupported velocity type.
      return
    }
    if delta != 0 {
      // CASpringAnimation's initialVelocity is proportional to the distance to travel, i.e. our
      // delta.
      springAnimation.initialVelocity = initialVelocity / -delta
    }
  }
}
