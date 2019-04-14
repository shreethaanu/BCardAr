//
//  ViewController.swift
//  strCardAr
//
//  Created by ShreeThaanu RK on 14/03/19.
//  Copyright © 2019 ShreeThaanu RK. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import AVFoundation
import SpriteKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        let configuration = ARImageTrackingConfiguration()
        guard  let arImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) else {
            return
        }
        configuration.trackingImages = arImages
        sceneView.session.run(configuration)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
    
        guard  anchor is ARImageAnchor else {
            return
        }
        
        guard let container = sceneView.scene.rootNode.childNode(withName: "Container", recursively: false) else {
            return
        }
        
        container.removeFromParentNode()
        node.addChildNode(container)
        container.isHidden = false
        
        let videoURL = Bundle.main.url(forResource: "video", withExtension: "mp4")!
        let VideoPlayer = AVPlayer(url: videoURL)
        let videoScene = SKScene(size: CGSize(width: 720.0, height: 1280.0))

        let videoNode = SKVideoNode(avPlayer: VideoPlayer)
        videoNode.position = CGPoint(x: videoScene.size.width/2, y: videoScene.size.height/2)
        videoNode.size = videoScene.size
        videoNode.yScale = -1
        videoNode.play()
        videoScene.addChild(videoNode)
        
       
        guard let video = container.childNode(withName: "video", recursively: true) else {
            return
        }
             video.geometry?.firstMaterial?.diffuse.contents = videoScene
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
}
