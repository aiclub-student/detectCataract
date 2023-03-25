//
//  ContentView.swift
//  detectCataract
//
//  Created by Amit Gupta on 3/23/23.
//

import SwiftUI

/*

import SwiftUI
import Alamofire
import SwiftyJSON

struct ContentView: View {
    @State var animalName = " "
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage? = UIImage(named: "paws")
    @State var imageSource=UIImagePickerController.SourceType.photoLibrary
    
    var body: some View {
        HStack {
            VStack (alignment: .center,
                    spacing: 20){
                Text("Check your eyes")
                    .font(.system(.largeTitle, design: .rounded))
                    .fontWeight(.bold)
                        Text(animalName)
                        Image(uiImage: inputImage!).resizable()
                            .aspectRatio(contentMode: .fit)
                        //Text(animalName)
                        Button("From Library"){
                            imageSource = .camera
                            self.buttonPressed()
                        }
                        .padding(.all, 14.0)
                        .foregroundColor(.white)
                            .background(Color.green)
                        .cornerRadius(10)
                Button("Take Photo"){
                    imageSource = .photoLibrary
                    self.buttonPressed()
                }
                .padding(.all, 14.0)
                .foregroundColor(.white)
                    .background(Color.green)
                .cornerRadius(10)
            }
            .font(.title)
        }.sheet(isPresented: $showingImagePicker, onDismiss: processImage) {
            ImagePicker(image: self.$inputImage, source: imageSource)
        }
    }
    
    func buttonPressed() {
        print("Button pressed")
        self.showingImagePicker = true
    }
    
    func processImage() {
        self.showingImagePicker = false
        self.animalName="Checking..."
        guard let inputImage = inputImage else {return}
        print("Processing image due to Button press")
        let imageJPG=inputImage.jpegData(compressionQuality: 0.0034)!
        let imageB64 = Data(imageJPG).base64EncodedData()
        let uploadURL="https://askai.aiclub.world/5757c28f-6cee-4734-a4da-ff274e48438c"
        
        AF.upload(imageB64, to: uploadURL).responseJSON { response in
            
            debugPrint(response)
            switch response.result {
               case .success(let responseJsonStr):
                   print("\n\n Success value and JSON: \(responseJsonStr)")
                   let myJson = JSON(responseJsonStr)
                let predictedValue = myJson["predicted_label"].string
                   print("Saw predicted value \(String(describing: predictedValue))")

                   let predictionMessage = predictedValue!
                   self.animalName=predictionMessage
               case .failure(let error):
                   print("\n\n Request failed with error: \(error)")
               }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

 */

struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Binding var image: UIImage?
    var source: UIImagePickerController.SourceType

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        print("Called make UI View Controller with source = \(source)")
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        //picker.sourceType = .camera
        picker.sourceType = source
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
