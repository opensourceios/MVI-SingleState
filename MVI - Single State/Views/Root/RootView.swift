//
//  RootView.swift
//  MVI - Single State
//
//  Created by Vyacheslav Ansimov on 26.07.2020.
//  Copyright © 2020 Vyacheslav Ansimov. All rights reserved.
//

import SwiftUI

struct RootView: View {

    @ObservedObject private var intent: RootIntent

    var body: some View {
        ZStack {
            imageView()
                .onTapGesture(perform: intent.onTapImage)
            errorView()
            loadView()
        }
        .overlay(RootRouter(screen: intent.model.routerSubject))
        .onAppear(perform: intent.onAppear)
    }

    static func build() -> some View {
        let intent = RootIntent()
        let view = RootView(intent: intent)
        return view
    }
}

// MARK: - Private - Views
private extension RootView {

    private func imageView() -> some View {
        Group { () -> AnyView  in
            if let image = intent.model.image {
                return Image(uiImage: image)
                    .resizable()
                    .toAnyView()
            } else {
                return Color.gray.toAnyView()
            }
        }
        .cornerRadius(6)
        .shadow(radius: 2)
        .frame(width: 100, height: 100)
    }

    private func loadView() -> some View {
        guard intent.model.isLoading else {
            return EmptyView().toAnyView()
        }
        return ZStack {
            Color.white
            Text("Loading")
        }.toAnyView()
    }

    private func errorView() -> some View {
        guard intent.model.error != nil else {
            return EmptyView().toAnyView()
        }
        return ZStack {
            Color.white
            Text("Fail")
        }.toAnyView()
    }
}

#if DEBUG
// MARK: - Previews
struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView.build()
    }
}
#endif
