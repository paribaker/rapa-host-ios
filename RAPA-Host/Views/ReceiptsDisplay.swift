//
//  ReceiptsDisplayView
//  RAPA-Host
//
//  Created by Pari Work Temp on 12/14/24.
//

import SwiftUI

struct ReceiptsDisplayView: View {
    @Binding var currentIndex: Int
    @Binding var receipts: [ReceiptShape]
    var body: some View {
        TabView(selection: $currentIndex) {
             ForEach(0..<receipts.count, id: \.self) { index in
                 let receipt = receipts[index]
                 Group {
                     switch assetType(for: extractAssetExtension(from: receipt.asset ?? "")) {
                     case .image:
                         if receipt.assetUrl != nil && receipt.assetUrl!.isFileURL {
                             if let image = UIImage(contentsOfFile: receipt.assetUrl!.path) {
                                                 Image(uiImage: image)
                                                     .resizable()
                                                     .aspectRatio(contentMode: .fit)
                             }else {
                                 Text("An error occurred")
                             }
                         }else{
                             AsyncImage(url: receipt.assetUrl) { image in
                                 image.resizable()
                                     .aspectRatio(contentMode: .fit)
                                     .frame(maxWidth: UIScreen.main.bounds.width * 0.9)
                                     .padding()
                             } placeholder: {
                                 ProgressView()
                             }
                         }
 
                     case .pdf:
                         PDFViewer(url: receipt.assetUrl!)
                             .scaledToFill()
                     default:
                         Text("Unsupported Type")
                             .frame(maxWidth: UIScreen.main.bounds.width * 0.9)
                             .padding()
                     }
                 }
                 .tag(index)
             }
         }
         .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
    }
}

//#Preview {
//    AssetDisplay()
//}
