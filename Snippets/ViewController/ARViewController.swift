//
//  ARViewController.swift
//  Snippets
//
//  Created by 温蟾圆 on 2021/1/27.
//

import ARKit
import UIKit
import QuartzCore
import SceneKit

class ARViewController: UIViewController {
    
    lazy var sceneView = ARSCNView()
    lazy var scnView = SCNView()
    
    private var blendShapes = [ARFaceAnchor.BlendShapeLocation: NSNumber]()
    private var eulerAngles: simd_float3?
    
    var contentNode: SCNNode?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Test 3D"
        
        view.addSubview(sceneView)
        sceneView.session.delegate = self
        
        let scene = SCNScene(named: "art.scnassets/facial-setup-final.scn")!
        contentNode = scene.rootNode.childNodes[0]
        contentNode?.scale = SCNVector3(8, 8, 8)
        
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 15)
        
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = .omni
        scene.rootNode.addChildNode(lightNode)
        lightNode.position = SCNVector3(x: 0, y: 0, z: 20)
        
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = UIColor.darkGray
        scene.rootNode.addChildNode(ambientLightNode)
        
        view.addSubview(scnView)
        scnView.delegate = self
        scnView.frame = view.frame
        scnView.scene = scene
        scnView.rendersContinuously = true
        scnView.showsStatistics = true
        scnView.backgroundColor = .black
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard ARFaceTrackingConfiguration.isSupported else {
            navigationController?.popViewController(animated: true)
            return
        }
        let configuration = ARFaceTrackingConfiguration()
        configuration.isLightEstimationEnabled = true
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
}

extension ARViewController: ARSessionDelegate {
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        
        guard let faceAnchor = frame.anchors.first as? ARFaceAnchor else {
            return
        }
        blendShapes = faceAnchor.blendShapes
        eulerAngles = faceAnchor.transform.eulerAngles
    }
}

extension ARViewController: SCNSceneRendererDelegate {
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        DispatchQueue.main.async {
            for (key, value) in self.blendShapes {
                self.contentNode?.morpher?.setWeight(CGFloat(value.floatValue), forTargetNamed: key.rawValue)
            }
            if self.eulerAngles != nil {
                self.contentNode?.eulerAngles = SCNVector3(self.eulerAngles!.x + .pi / 2, self.eulerAngles!.y, self.eulerAngles!.z)
                self.contentNode?.geometry?.subdivisionLevel = 0
            }
            
        }
    }
}
