//
//  ViewController.swift
//  ImDetection
//
//  Created by Godwin Adejo Ebikwo on 03/11/2018.
//  Copyright © 2018 Godwin Adejo Ebikwo. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

/// ViewController
class ViewController: UIViewController{
    
    var CatXNode = SCNNode()
    
    /// IBOutlet(s)
    @IBOutlet weak var BlurView: UIVisualEffectView!
    @IBOutlet var sceneView: ARSCNView!
    @IBAction func placeScreenButton(_ sender: UIButton) {
    }
    @IBAction func plusButtonTapped(_ sender: UIButton) {
    }
    @IBAction func MinusButtonTapped(_ sender: UIButton) {
    }
    
    /// Variable Declaration(s)
    var ImageHighlight: SCNAction {
        return .sequence([
            .wait(duration: 0.25),
            .fadeOpacity(to: 0.75, duration: 0.25),
            .fadeOpacity(to: 0.15, duration: 0.25),
            .fadeOpacity(to: 0.75, duration: 0.25),
            .fadeOut(duration: 0.5),
            .removeFromParentNode()
            ])
    }
    
    /// View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureARImageTracking()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Pause the view's session
        sceneView.session.pause()
    }
}

// MARK: - UI Related Method(s)
extension ViewController {
    
    func prepareUI() {
        // Set the view's delegate
        sceneView.delegate = self
    }
    
    func configureARImageTracking() {
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()
        if let imageTrackingReference = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: Bundle.main) {
            configuration.trackingImages = imageTrackingReference
            configuration.maximumNumberOfTrackedImages = 1
        } else {
            print("Error: Failed to get image tracking referencing image.")
        }
        // Run the view's session
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
}

// MARK: - UIButton Action(s)
extension ViewController {
    
    @IBAction func tapBtnRefresh(_ sender: UIButton) {
        configureARImageTracking()
    }
}

// MARK: - ARSCNViewDelegate
extension ViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        /// Casting down ARAnchor to `ARImageAnchor`.
        if let imageAnchor =  anchor as? ARImageAnchor {
            let imageSize = imageAnchor.referenceImage.physicalSize
            
            let plane = SCNPlane(width: CGFloat(imageSize.width), height: CGFloat(imageSize.height))
            plane.firstMaterial?.diffuse.contentsTransform = SCNMatrix4Translate(SCNMatrix4MakeScale(1, -1, 1), 0, 1, 0)
            
            let imageAnimationNode = SCNNode(geometry: plane)
            imageAnimationNode.eulerAngles.x = -.pi / 2
            imageAnimationNode.opacity = 0.25
            node.addChildNode(imageAnimationNode)
            
            imageAnimationNode.runAction(ImageHighlight) {
                // About
                let aboutSpriteKitScene = SKScene(fileNamed: "About")
                aboutSpriteKitScene?.isPaused = false
                
                let aboutCatPlane = SCNPlane(width: CGFloat(imageSize.width * 1.5), height: CGFloat(imageSize.height * 1.2))
                aboutCatPlane.firstMaterial?.diffuse.contents = aboutSpriteKitScene
                aboutCatPlane.firstMaterial?.diffuse.contentsTransform = SCNMatrix4Translate(SCNMatrix4MakeScale(1, -1, 1), 0, 1, 0)
                
                let aboutCatNode = SCNNode(geometry: aboutCatPlane)
                aboutCatNode.geometry?.firstMaterial?.isDoubleSided = true
                aboutCatNode.eulerAngles.x = -.pi / 2
                aboutCatNode.position = SCNVector3Zero
                node.addChildNode(aboutCatNode)
                
                let moveAction = SCNAction.move(by: SCNVector3(0.25, 0, 0), duration: 0.8)
                aboutCatNode.runAction(moveAction, completionHandler: {
                    let titleNode = aboutSpriteKitScene?.childNode(withName: "TitleNode")
                    titleNode?.run(SKAction.moveTo(y: 90, duration: 1.0))
                    
                    let name = aboutSpriteKitScene?.childNode(withName: "DescriptionNode")
                    name?.run(SKAction.moveTo(y: -30, duration: 1.0))
                    
                    // 3D animal
                    let CatScene = SCNScene(named: "art.scnassets/animals.scn")!
                    let CatNode = CatScene.rootNode.childNodes.first!
                    CatNode.scale = SCNVector3(0.022, 0.022, 0.022)
                    CatNode.eulerAngles.x = -.pi / 2
                    CatNode.position = SCNVector3Zero
                    CatNode.position.z = 0.05
                    let rotationAction = SCNAction.rotateBy(x: 0, y: 0, z: 0.5, duration: 1)
                    let inifiniteAction = SCNAction.repeatForever(rotationAction)
                    CatNode.runAction(inifiniteAction)
                    node.addChildNode(CatNode)
                    
                    // Cat Info
                    let CatInfoSpriteKitScene = SKScene(fileNamed: "CatInfo")
                    CatInfoSpriteKitScene?.isPaused = false
                    
                    let CatInfoPlane = SCNPlane(width: CGFloat(imageSize.width * 1.5), height: CGFloat(imageSize.height * 1.2))
                    CatInfoPlane.firstMaterial?.diffuse.contents = CatInfoSpriteKitScene
                    CatInfoPlane.firstMaterial?.diffuse.contentsTransform = SCNMatrix4Translate(SCNMatrix4MakeScale(1, -1, 1), 0, 1, 0)
                    
                    let CatInfoNode = SCNNode(geometry: CatInfoPlane)
                    CatInfoNode.geometry?.firstMaterial?.isDoubleSided = true
                    CatInfoNode.eulerAngles.x = -.pi / 2
                    CatInfoNode.position = SCNVector3Zero
                    node.addChildNode(CatInfoNode)
                    
                    let move1Action = SCNAction.move(by: SCNVector3(-0.25, 0, 0), duration: 0.8)
                    CatInfoNode.runAction(move1Action, completionHandler: {
                        let titleNode = CatInfoSpriteKitScene?.childNode(withName: "TitleNode")
                        
                        let dept1 = CatInfoSpriteKitScene?.childNode(withName: "Dept1Node")
                        dept1?.run(SKAction.fadeOut(withDuration: 0.0))
                        
                        let dept2 = CatInfoSpriteKitScene?.childNode(withName: "Dept2Node")
                        dept2?.run(SKAction.fadeOut(withDuration: 0.0))
                        
                        titleNode?.run(SKAction.moveTo(x: 0, duration: 1.0), completion: {
                            dept1?.run(SKAction.moveTo(y: 30, duration: 0.8))
                            dept1?.run(SKAction.fadeIn(withDuration: 1.0), completion: {
                                dept2?.run(SKAction.moveTo(y: -80, duration: 0.8))
                                dept2?.run(SKAction.fadeIn(withDuration: 1.0))
                            })
                        })
                        
                    })
                })
            }
        } else {
            print("Error: Failed to get ARImageAnchor")
        }
    }
    
     func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        print("Error didFailWithError: \(error.localizedDescription)")
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        print("Error sessionWasInterrupted: \(session.debugDescription)")
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        print("Error sessionInterruptionEnded : \(session.debugDescription)")
    }
}
