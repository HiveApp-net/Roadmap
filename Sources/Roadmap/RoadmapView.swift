//
//  RoadmapView.swift
//  Roadmap
//
//  Created by Antoine van der Lee on 19/02/2023.
//

import SwiftUI

public struct RoadmapView<Header: View, Footer: View, LoadingPlaceholder: View>: View {
    @StateObject var viewModel: RoadmapViewModel
    let header: Header
    let footer: Footer
    let loadingPlaceholder: LoadingPlaceholder
    
    var centeredLoadingPlaceholder: some View {
        HStack {
            Spacer()
            loadingPlaceholder
            Spacer()
        }
    }

    public var body: some View {
        
        #if os(macOS)
        if #available(macOS 13.0, *) {
            List {
                header
                switch viewModel.state {
                    case .loading:
                        centeredLoadingPlaceholder
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                    case .idle:
                        ForEach(viewModel.features) { feature in
                            RoadmapFeatureView(viewModel: viewModel.featureViewModel(for: feature))
                                .listRowSeparator(.hidden)
                                .listRowBackground(Color.clear)
                        }
                }
                footer
            }
            .scrollContentBackground(.hidden)
            .listStyle(.plain)
        } else {
            List {
                header
                switch viewModel.state {
                    case .loading:
                        centeredLoadingPlaceholder
                    default:
                        ForEach(viewModel.features) { feature in
                            Section {
                                RoadmapFeatureView(viewModel: viewModel.featureViewModel(for: feature))
                            }
                        }
                }
                footer
            }
        }
        #else
        List {
            header
            switch viewModel.state {
                case .loading:
                    centeredLoadingPlaceholder
                        .listRowSeparator(.hidden)
                case .idle:
                    ForEach(viewModel.features) { feature in
                        RoadmapFeatureView(viewModel: viewModel.featureViewModel(for: feature))
                            .listRowSeparator(.hidden)
                    }
            }
            footer
        }
        .scrollContentBackground(.hidden)
        .listStyle(.plain)
        #endif
    }
}

public extension RoadmapView {
    init(
        configuration: RoadmapConfiguration,
        @ViewBuilder header: () -> Header = { EmptyView() },
        @ViewBuilder footer: () -> Footer = { EmptyView() },
        @ViewBuilder loadingPlaceholder: () -> LoadingPlaceholder = { EmptyView() }
    ) {
        self.init(
            viewModel: .init(configuration: configuration),
            header: header(),
            footer: footer(),
            loadingPlaceholder: loadingPlaceholder()
        )
    }
}

//public extension RoadmapView where Header == EmptyView, Footer == EmptyView {
//    init(configuration: RoadmapConfiguration) {
//        self.init(viewModel: .init(configuration: configuration), header: EmptyView(), footer: EmptyView())
//    }
//}
//
//public extension RoadmapView where Header: View, Footer == EmptyView {
//    init(configuration: RoadmapConfiguration, @ViewBuilder header: () -> Header) {
//        self.init(viewModel: .init(configuration: configuration), header: header(), footer: EmptyView())
//    }
//}
//
//public extension RoadmapView where Header == EmptyView, Footer: View {
//    init(configuration: RoadmapConfiguration, @ViewBuilder footer: () -> Footer) {
//        self.init(viewModel: .init(configuration: configuration), header: EmptyView(), footer: footer())
//    }
//}
//
//public extension RoadmapView where Header: View, Footer: View {
//    init(configuration: RoadmapConfiguration, @ViewBuilder header: () -> Header, @ViewBuilder footer: () -> Footer) {
//        self.init(viewModel: .init(configuration: configuration), header: header(), footer: footer())
//    }
//}

struct RoadmapView_Previews: PreviewProvider {
    static var previews: some View {
        RoadmapView(configuration: .sample())
        
        RoadmapView(configuration: .sample(), loadingPlaceholder:  {
            ProgressView()
        })
        .previewDisplayName("Custom Loading")
    }
}
