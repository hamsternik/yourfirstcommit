//
//  FileList.swift
//  YourFirstCommit
//
//  Created by Alex Antipov on 24.01.2023.
//

import SwiftUI


struct FileList: View {
    
    @State var filesList: [String] = ["README.md", "script.py", ".gitinore", "dummy-files-list.txt"]
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 6) {
            
            Text("Files list:").font(.title3)
            ForEach(filesList, id: \.self) { fileName in
                Text(fileName).font(.system(.body, design: .monospaced))
            }
                
        }
        .background(Color.gray.opacity(0.25))
        .padding()
        
    }
}

struct FileList_Previews: PreviewProvider {
    static var previews: some View {
        FileList()
    }
}
