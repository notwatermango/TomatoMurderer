//
//  RadarView.swift
//  TomatoMurderer
//
//  Created by mg0 on 29/04/24.
//

import SwiftUI
import RealityKit
import ARKit
import AVFAudio

struct RadarView: View {
    @EnvironmentObject var appState: AppState
    
    @State private var distance : Float = 0.0
    @State private var showingAlert = false
    @State private var showingCamera = false
    
    @State var yeaySoundEffect: AVAudioPlayer?
    
    var body: some View {
        ZStack {
            if showingCamera {
                ARViewContainer(distance: $distance, showingAlert: $showingAlert)
                    .edgesIgnoringSafeArea(.all)
                if showingAlert {
                    Text("🎊")
                        .onAppear {
                            playSoundEffect()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                appState.switchView = .ending
                            }
                        }
                }
            } else {
                ARViewContainer(distance: $distance, showingAlert: $showingAlert)
                    .edgesIgnoringSafeArea(.all)
                    .hidden()
                
                VStack {
                    Spacer()
                    if distance < 0.5 {
                        Image("radioThree")
                            .resizable()
                            .frame(width: 200, height: 200)
                    } else if distance < 1 {
                        Image("radioTwo")
                            .resizable()
                            .frame(width: 200, height: 200)
                    } else if distance < 3 {
                        Image("radioOne")
                            .resizable()
                            .frame(width: 200, height: 200)
                    } else {
                        Image("radioZero")
                            .resizable()
                            .frame(width: 200, height: 200)
                    }
                    Spacer()
                    Button(action: {
                        //change the state of the ARViewContainer not hidden
                        showingCamera.toggle()
                    }) {
                        Image(systemName: "camera.viewfinder")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .padding(.bottom, 40)
                    }
                    .disabled(distance > 0.5)
                }
            }
        }
    }
    
    func playSoundEffect() {
        let soundPath = Bundle.main.path(forResource: "yeay.mp3", ofType: nil)!
        let soundURL = URL(fileURLWithPath: soundPath)
        
        
        do {
            yeaySoundEffect = try AVAudioPlayer(contentsOf: soundURL)
            yeaySoundEffect?.play()
        } catch {
            print("Error playing sound: \(error.localizedDescription)")
        }
    }
}

struct ARViewContainer : UIViewRepresentable{
    @Binding var distance: Float
    @Binding var showingAlert: Bool
    @State private var isTapped = false
    
    //    @State private var positionX: Float = Float.random(in: -0.5 ... 0)
    //    @State private var positionY: Float = Float.random(in: -0.5 ... 0)
    //    @State private var positionZ: Float = Float.random(in: -5 ... -3)
    
    @State private var positionX: Float = 0
    @State private var positionY: Float = 0
    @State private var positionZ: Float = -0.5
    
    var model = Model3D(name: "Knife_kitchen_old")
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal, .vertical]
        config.environmentTexturing = .automatic
        
        if ARWorldTrackingConfiguration.supportsSceneReconstruction(.meshWithClassification) {
            config.sceneReconstruction = .meshWithClassification
        }
        
        arView.session.delegate = context.coordinator
        arView.session.run(config)
        
        let model = Model3D(name: "Knife_kitchen_old")
        
        addARObject(to: arView, model: model, positionX: positionX, positionY: positionY, positionZ: positionZ)
        
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handleTap(_:)))
        arView.addGestureRecognizer(tapGesture)
        
        return arView
    }
    
    
    func updateUIView(_ uiView: ARView, context: Context) {
    }
    
    func makeCoordinator() -> ARSessionDelegateCoordinator {
        return ARSessionDelegateCoordinator(distance: $distance, showingAlert: $showingAlert, positionX: $positionX, positionY: $positionY, positionZ: $positionZ)
    }
    
    //    private func addARObject(to arView: ARView) {
    //        let box = MeshResource.generateBox(size: 0.00000001)
    //        let material = SimpleMaterial(color: .blue, isMetallic: true)
    //        let boxEntity = ModelEntity(mesh: box, materials: [material])
    //
    //        guard let entity = model.modelEntity else {
    //            let anchor = AnchorEntity(world: [positionX, positionY, positionZ]) // Position the object 0.5 meters in front of the camera
    //            anchor.addChild(boxEntity)
    //            arView.scene.anchors.append(anchor)
    //            return
    //        }
    //
    //        let anchor = AnchorEntity(world: [positionX, positionY, positionZ]) // Position the object 0.5 meters in front of the camera
    //        anchor.addChild(entity)
    //        arView.scene.anchors.append(anchor)
    //    }
    private func addARObject(to arView: ARView, model: Model3D, positionX: Float, positionY: Float, positionZ: Float) {
        guard let modelEntity = model.modelEntity else {
            // Model not loaded yet, wait for it to load
            DispatchQueue.main.async {
                // Try adding the AR object again after the model is loaded
                self.addARObject(to: arView, model: model, positionX: positionX, positionY: positionY, positionZ: positionZ)
            }
            return
        }
        
        let anchor = AnchorEntity(world: [positionX, positionY, positionZ]) // Position the object at the specified coordinates
        anchor.addChild(modelEntity)
        arView.scene.anchors.append(anchor)
    }
    
}


class ARSessionDelegateCoordinator : NSObject, ARSessionDelegate {
    
    @Binding var distance : Float
    @Binding var showingAlert: Bool
    @Binding var positionX: Float
    @Binding var positionY: Float
    @Binding var positionZ: Float
    
    init(distance: Binding<Float>, showingAlert: Binding<Bool>, positionX: Binding<Float>, positionY: Binding<Float>, positionZ: Binding<Float>) {
        _distance = distance
        _showingAlert = showingAlert
        _positionX = positionX
        _positionY = positionY
        _positionZ = positionZ
    }
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        let cameraTransform = frame.camera.transform
        let cameraPosition = SIMD3<Float>(cameraTransform.columns.3.x, cameraTransform.columns.3.y, cameraTransform.columns.3.z)
        let objectPosition = SIMD3<Float>(positionX, positionY, positionZ) // -0.5 is the ar object placement
        let distanceVector = cameraPosition - objectPosition
        let distancePosition = sqrt(distanceVector.x * distanceVector.x + distanceVector.y * distanceVector.y + distanceVector.z * distanceVector.z)
        distance = distancePosition
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        if !showingAlert {
            showingAlert = true
        }
    }
}

#Preview {
    RadarView()
}
