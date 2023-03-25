//
//  LocalAIView.swift
//  detectCataract
//
//  Created by Amit Gupta on 3/23/23.
//

import SwiftUI




import SwiftUI
import CoreML
import Vision

struct LocalAIView: View {
    
    @State var eyeDiagnosis = " "
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage? = UIImage(named: "eyes")
    @State var imageSource=UIImagePickerController.SourceType.photoLibrary
    
    //@State private var image: Image?
    //@State private var classification = "Unknown"
    
    let model = try! VNCoreMLModel(for: CataractClassifier1_1().model)
    
    var body: some View {
        VStack {
            Text("Detect cataract")
                .font(.system(size: 40))
                .fontWeight(.bold)
            Text(eyeDiagnosis)
                .font(.system(size: 30))
            Image(uiImage: inputImage!).resizable()
                .aspectRatio(contentMode: .fit)
            Button("From Library"){
                imageSource = .photoLibrary
                self.buttonPressed()
            }
            .padding(.all, 14.0)
            .foregroundColor(.white)
            .background(Color.green)
            .cornerRadius(10)
            Button("Take Photo Local"){
                imageSource = .camera
                self.buttonPressed()
            }
            .padding(.all, 14.0)
            .foregroundColor(.white)
            .background(Color.green)
            .cornerRadius(10)
        }
        .sheet(isPresented: $showingImagePicker, onDismiss: processImage) {
            ImagePicker(image: self.$inputImage, source: imageSource)
        }
    }
    
    func buttonPressed() {
        print("Button pressed")
        self.showingImagePicker = true
    }
    
    func processImage() {
        guard let ciImage = CIImage(image: inputImage!) else {
            print("Unable to create CIImage")
            return
        }
        
        let request = VNCoreMLRequest(model: model) { request, error in
            guard let results = request.results as? [VNClassificationObservation],
                  let topResult = results.first else {
                print("Unable to classify image")
                return
            }
            
            self.eyeDiagnosis = topResult.identifier
        }
        // request.usesCPUOnly = true // To run on the simulator
        
        let handler = VNImageRequestHandler(ciImage: ciImage)
        do {
            try handler.perform([request])
        } catch {
            print("Failed to perform classification: \(error.localizedDescription)")
        }
    }
}


struct LocalAIView_Previews: PreviewProvider {
    static var previews: some View {
        LocalAIView()
    }
}

