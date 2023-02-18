//
//  SearchFieldView.swift
//  YourFirstCommit
//
//  Created by Nikita Khomitsevych on 13.02.2023.
//

import SwiftUI

struct SearchFieldView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            SearchFieldView(searchString: .constant(""))
            SearchFieldView(searchString: .constant("hamsternik/yourfirstcommit"))
            SearchFieldView(searchString: .constant("r-ss/variables_playground"))
        }
        .padding(20)
        .background(Color.backgroundPreviews)
    }
}

/// Origin: https://github.com/razeware/emitron-iOS/blob/development/Emitron/Emitron/UI/Library/SearchFieldView.swift
struct SearchFieldView: View {
    private struct SizeKey: PreferenceKey {
        static func reduce(value: inout CGSize?, nextValue: () -> CGSize?) {
            value = value ?? nextValue()
        }
    }
    
    @Binding var searchString: String
    var action: (String) -> Void = { _ in }
    @State private var height: CGFloat?
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.searchFieldIcon)
                .frame(height: 25)
            
            TextField(
                "Search…",
                text: $searchString,
                onCommit: { action(searchString) }
            )
            .autocorrectionDisabled(true)
            .textInputAutocapitalization(.never)
            .keyboardType(.webSearch)
            .font(.system(size: UIFontMetrics.default.scaledValue(for: 15.0)))
            .foregroundColor(.searchFieldText)
            .contentShape(Rectangle())
            
            if !searchString.isEmpty {
                Button {
                    searchString = ""
                    action(searchString)
                } label: {
                    Image(systemName: "multiply.circle.fill")
                    // If we don't enforce a frame, the button doesn't register the tap action
                        .frame(width: 25, height: 25, alignment: .center)
                        .foregroundColor(.searchFieldIcon)
                }
            }
        }
        .padding(.vertical, 6)
        .padding(.horizontal, 10)
        .background(GeometryReader { proxy in
            Color.clear.preference(key: SizeKey.self, value: proxy.size)
        })
        .frame(height: height)
        .background(background)
        .padding(1)
        .padding(.bottom, 2)
        .onPreferenceChange(SizeKey.self) { size in
            height = size?.height
        }
    }
    
    var background: some View {
        RoundedRectangle(cornerRadius: 9)
            .fill(Color.searchFieldBackground)
            .shadow(color: .searchFieldShadow, radius: 1, x: 0, y: 2)
            .overlay(
                RoundedRectangle(cornerRadius: 9)
                    .stroke(Color.searchFieldBorder, lineWidth: 2)
            )
    }
}

// MARK: Colors

private extension Color {
    static var searchFieldBackground: Color {
        .init("search.background")
    }
    
    static var searchFieldBorder: Color {
        .init("search.border")
    }
    
    static var searchFieldIcon: Color {
        .init("search.icon.background")
    }
    
    static var searchFieldText: Color {
        .init("search.text")
    }
    
    static var searchFieldShadow: Color {
        .init("search.shadow")
    }
    
    static var backgroundPreviews: Color {
        .init("previews.background")
    }
}
