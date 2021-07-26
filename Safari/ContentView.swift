//
//  ContentView.swift
//  Safari
//
//  Created by Zane Kleinberg on 7/25/21.
//

import SwiftUI
import WebKit
import PureSwiftUITools
import Combine
import Cocoa
import Foundation

struct ContentView: View {
    @State var current_nav_view: String = "Main"
    @State var forward_or_backward = false
    @State var url_search: String = ""
    @State var google_search: String = ""
    @State var editing_state_url: String = "None"
    @State var editing_state_google: String = "None"
    @State var current_webpage_title: String = ""
    @State private var webViewHeight: CGFloat = .zero
    @State var offset: CGPoint = CGPoint(0,0)
    @State var first_load: Bool = true
    @State var selecting_tab: Bool = false
    @State var instant_background_change: Bool = false
    @State var can_tap_view: Bool = true
    @StateObject var views: ObservableArray<WebViewStore> = try! ObservableArray(array: [WebViewStore()]).observeChildrenChanges()
    @StateObject var tab_monitor: TabMonitor = TabMonitor()
    @State var active_tab: Int = 0
    @State var will_remove_object: WebViewStore = WebViewStore()
    @State var did_add_to_end: Bool = false
    @State var show_bookmarks: Bool = false
    @State var show_share:Bool = false
    @State var bookmark_name: String = ""
    @State var show_save_bookmark: Bool = false
    @State var is_editing_bookmarks: Bool = false
    @State var new_page_delay: Bool = false
    @State var active_page_title: String = ""
    @State var show_tab_view: Bool = false
    @ObservedObject var bm_observer: bookmarks_observer
    @ObservedObject var hs_observer: history_observer
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                safari_title_bar(forward_or_backward: $forward_or_backward, current_nav_view: $current_nav_view, url_search: $url_search, google_search: $google_search, editing_state_url: $editing_state_url, editing_state_google: $editing_state_google, bm_observer: bm_observer, webViewStore: views.array[tab_monitor.active_tab], current_webpage_title: active_page_title).frame(minHeight: 80, maxHeight: 80)
                safari_tab_view(tab_monitor: tab_monitor, views: views, active_page_title: $active_page_title, hs_observer: hs_observer).transition(.move(edge: .top)).frame(width: geometry.size.width, height: show_tab_view ? 24 : 0)
                Webview(dynamicHeight: $webViewHeight, offset: $offset, selecting_tab:$selecting_tab, webview: views.array[tab_monitor.active_tab].webView).id(UUID())
            }.frame(width: geometry.size.width, height: geometry.size.height).onChange(of: views.array[tab_monitor.active_tab].webView.url) {_ in
                url_search = views.array[tab_monitor.active_tab].webView.url?.relativeString ?? ""
            }.onChange(of: views.array.count, perform: {_ in
           //     withAnimation {
                if views.array.count > 1 {
                    show_tab_view = true
                } else {
                    show_tab_view = false
                }
             //   }
            }).onChange(of: views.array[tab_monitor.active_tab].webView.url) {_ in
                hs_observer.history.append(history_id(name: views.array[tab_monitor.active_tab].webView.title ?? "" == "" ? "Untitled" : views.array[tab_monitor.active_tab].webView.title ?? "", url: views.array[tab_monitor.active_tab].webView.url?.relativeString ?? ""))
            }
            
        }   .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name.init("addTab"))) {_ in
            views.array.append(WebViewStore())
            tab_monitor.active_tab = views.array.endIndex - 1
        } .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name.init("selected_bookmark"))) {_ in
            if bm_observer.selected_bookmark.hasPrefix("https://") || bm_observer.selected_bookmark.hasPrefix("http://") {
                guard let url = URL(string: "\(bm_observer.selected_bookmark)") else { return }
                //   print("here 1")
                views.array[tab_monitor.active_tab].webView.load(URLRequest(url: url))
            //    values[index] = self.webViewStore.webView.url?.relativeString ?? ""
            } else if bm_observer.selected_bookmark.contains("www") {
                guard let url = URL(string: "https://\(bm_observer.selected_bookmark)") else { return }
                // print("here 2")
                views.array[tab_monitor.active_tab].webView.load(URLRequest(url: url))
               // url_search = self.webViewStore.webView.url?.relativeString ?? ""
            } else {
                guard let url = URL(string: "https://\(bm_observer.selected_bookmark)") else { return }
                //  print("here 3")
                views.array[tab_monitor.active_tab].webView.load(URLRequest(url: url))
              //  url_search =  self.webViewStore.webView.url?.relativeString ?? ""
                //searchTextOnGoogle(urlString)
            }
        }.onReceive(NotificationCenter.default.publisher(for: NSNotification.Name.init("selected_history"))) {_ in
            if hs_observer.selected_history.hasPrefix("https://") || hs_observer.selected_history.hasPrefix("http://") {
                guard let url = URL(string: "\(hs_observer.selected_history)") else { return }
                //   print("here 1")
                views.array[tab_monitor.active_tab].webView.load(URLRequest(url: url))
            //    values[index] = self.webViewStore.webView.url?.relativeString ?? ""
            } else if hs_observer.selected_history.contains("www") {
                guard let url = URL(string: "https://\(hs_observer.selected_history)") else { return }
                // print("here 2")
                views.array[tab_monitor.active_tab].webView.load(URLRequest(url: url))
               // url_search = self.webViewStore.webView.url?.relativeString ?? ""
            } else {
                guard let url = URL(string: "https://\(hs_observer.selected_history)") else { return }
                //  print("here 3")
                views.array[tab_monitor.active_tab].webView.load(URLRequest(url: url))
              //  url_search =  self.webViewStore.webView.url?.relativeString ?? ""
                //searchTextOnGoogle(urlString)
            }
        }
    }
    }


class TabMonitor: ObservableObject {
    @Published var active_tab: Int = 0 {
        willSet {
        objectWillChange.send()
        }
    }
}
struct safari_tab_view: View {
    @StateObject var tab_monitor: TabMonitor
    @State var hovered_tab: Int?
    @State var tabs = ["Twitter", "Facebook", "Youtube", "Gmail"]
    @StateObject var views: ObservableArray<WebViewStore>
    @State var rf: Bool = true
    @State var active_tab_title = ""
    @State var resetter: Bool = false
    @Binding var active_page_title: String
    @ObservedObject var hs_observer: history_observer
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: -25) {
                
                ForEach(Array(views.array.enumerated()), id: \.element.id) {index, tab in
                    if tab_monitor.active_tab == index {
                        ZStack {
                            HStack(spacing: 0) {
                                Image("ActiveTabLeftCap")
                                Image("ActiveTabFill").frame(width: 225 * (CGFloat(views.array.count) > geometry.size.width/250 ? CGFloat(geometry.size.width/(242 * (CGFloat(views.array.count)))) : CGFloat(1)))
                                Image("ActiveTabRightCap")
                            }
                            Text(active_tab_title != "" ? active_tab_title : "Untitled").font(.custom("Lucida Grande Bold", size: 11)).foregroundColor(Color(red: 40/255, green: 40/255, blue: 40/255)).shadow(color: Color.white.opacity(0.6), radius: 0, x: 0.0, y: 1).frame(maxWidth: 175 * (CGFloat(views.array.count) > geometry.size.width/250 ? CGFloat(geometry.size.width/(242 * (CGFloat(views.array.count)))) : CGFloat(1)))
                            if hovered_tab == index {
                                Button(action:{
                                    let idx = index
                                    if idx != 0, idx == views.array.endIndex - 1 {
                                    tab_monitor.active_tab = idx - 1
                                    }
                                    views.array.remove(at: idx)
                                    resetter.toggle()
                                }) {
                                Image("ActiveTabClose")
                                }.buttonStyle(PlainButtonStyle()).offset(x: -106.25 * (CGFloat(views.array.count) > geometry.size.width/250 ? CGFloat(geometry.size.width/(242 * (CGFloat(views.array.count)))) : CGFloat(1)))
                            }
                        }.zIndex(.infinity).onHover { hover in
                                if hover {
                                    if hovered_tab == nil {
                                        hovered_tab = index
                                    }
                                } else {
                                    hovered_tab = nil
                                }
                        }.padding(.leading, 12.5 * (CGFloat(views.array.count) > geometry.size.width/250 ? CGFloat(geometry.size.width/(242 * (CGFloat(views.array.count)))) : CGFloat(1)))
                    }
                    else {
                        ZStack {
                            HStack(spacing: 0) {
                                Image("InactiveTabLeftCap").opacity(tab == views.array.first ? 0 : 1)
                                Image("InactiveTabFill").frame(width: (225 + 12.5)  * (CGFloat(views.array.count) > geometry.size.width/250 ? CGFloat(geometry.size.width/(242 * (CGFloat(views.array.count)))) : CGFloat(1)))
                                Image("InactiveTabRightCap")
                            }
                            Text(tab.webView.title ?? "" != "" ? tab.webView.title ?? "" : "Untitled").font(.custom("Lucida Grande Bold", size: 11)).foregroundColor(Color(red: 40/255, green: 40/255, blue: 40/255)).shadow(color: Color.white.opacity(0.6), radius: 0, x: 0.0, y: 1).offset(x: 12.5/2 * (CGFloat(views.array.count) > geometry.size.width/250 ? CGFloat(geometry.size.width/(242 * (CGFloat(views.array.count)))) : CGFloat(1))).frame(maxWidth: 175 * (CGFloat(views.array.count) > geometry.size.width/250 ? CGFloat(geometry.size.width/(242 * (CGFloat(views.array.count)))) : CGFloat(1)))
                            if hovered_tab == index {
                                Button(action:{
                                    let idx = index
                                    if idx < tab_monitor.active_tab {
                                    tab_monitor.active_tab = tab_monitor.active_tab - 1
                                    }
                                        views.array.remove(at: idx)
                                    
                                }) {
                                Image("InactiveTabClose")
                                }.buttonStyle(PlainButtonStyle()).offset(x: (-225/2 * (CGFloat(views.array.count) > geometry.size.width/250 ? CGFloat(geometry.size.width/(242 * (CGFloat(views.array.count)))) : CGFloat(1))) + (tab == views.array.first ? 0 : 12.5))

                                }
                        }.onTapGesture {
                            tab_monitor.active_tab = index
                            hovered_tab = index
                        }.zIndex(Double(views.array.count - (views.array.firstIndex(of: tab) ?? 0))).onHover { hover in
                                if hover {
                                    if hovered_tab == nil {
                                    hovered_tab = index
                                    }
                                } else {
                                    hovered_tab = nil
                                }
                        }
                    }
                }
            
                Spacer()
                Button(action: {
                    
                    views.array.append(WebViewStore())
                    tab_monitor.active_tab = views.array.endIndex - 1
                   // views.observeChildrenChanges()
                 //   active_tab = views.array.endIndex
                    
                }) {
                    Image("AW AddTabButton").padding(.trailing, 2.5)
                }.buttonStyle(PlainButtonStyle())
            }.background(Image("InactiveTabFill").frame(width: geometry.size.width, height: 24)).frame(width: geometry.size.width, height: 24)
        }.onReceive(views.array[tab_monitor.active_tab].objectWillChange){_ in
            if views.array[tab_monitor.active_tab].webView.title ?? "" != "" {
             active_tab_title = views.array[tab_monitor.active_tab].webView.title ?? ""
                active_page_title = views.array[tab_monitor.active_tab].webView.title ?? ""
            }
          //   views.array[tab_monitor.active_tab].objectWillChange.send()
         }.onChange(of: tab_monitor.active_tab) {_ in
             active_tab_title = views.array[tab_monitor.active_tab].webView.title ?? ""
            active_page_title = views.array[tab_monitor.active_tab].webView.title ?? ""
         }.onChange(of: resetter) {_ in
            active_tab_title = views.array[tab_monitor.active_tab].webView.title ?? ""
            active_page_title = views.array[tab_monitor.active_tab].webView.title ?? ""
        }
    }
}



public class WebViewStore: ObservableObject, Identifiable, Equatable {
    public static func == (lhs: WebViewStore, rhs: WebViewStore) -> Bool {
        return lhs.webView == rhs.webView
    }
    
    @Published public var webView: WKWebView {
        didSet {
            setupObservers()
        }
    }
    
    public init(webView: WKWebView = WKWebView()) {
        self.webView = webView
        self.webView.customUserAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 11_4) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.1.1 Safari/605.1.15"
        setupObservers()
    }
    
    private func setupObservers() {
        func subscriber<Value>(for keyPath: KeyPath<WKWebView, Value>) -> NSKeyValueObservation {
            return webView.observe(keyPath, options: [.prior]) { _, change in
                if change.isPrior {
                    self.objectWillChange.send()
                }
            }
        }
        // Setup observers for all KVO compliant properties
        observers = [
            subscriber(for: \.title),
            subscriber(for: \.url),
            subscriber(for: \.isLoading),
            subscriber(for: \.estimatedProgress),
            subscriber(for: \.hasOnlySecureContent),
            subscriber(for: \.serverTrust),
            subscriber(for: \.canGoBack),
            subscriber(for: \.canGoForward)
        ]
    }
    
    private var observers: [NSKeyValueObservation] = []
    
    public subscript<T>(dynamicMember keyPath: KeyPath<WKWebView, T>) -> T {
        webView[keyPath: keyPath]
    }
}


struct Webview : NSViewRepresentable {
    @Binding var dynamicHeight: CGFloat
    @Binding var offset: CGPoint
    @Binding var selecting_tab: Bool
    var webview: WKWebView = WKWebView()
    var oldContentOffset = CGPoint.zero
    var originalcenter = CGPoint.zero
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: Webview
        
        init(_ parent: Webview) {
            self.parent = parent
        }
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            decisionHandler(WKNavigationActionPolicy(rawValue: WKNavigationActionPolicy.allow.rawValue + 2)!)
        }
        
    }
    
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeNSView(context: Context) -> WKWebView  {
        webview.navigationDelegate = context.coordinator
        // webview.scrollView.backgroundColor = UIColor(red: 93/255, green: 99/255, blue: 103/255, alpha: 1.0)
        webview.configuration.suppressesIncrementalRendering = true
        return webview
    }
    
    func updateNSView(_ uiView: WKWebView, context: Context) {
        //  webview.scrollView.backgroundColor = UIColor(red: 93/255, green: 99/255, blue: 103/255, alpha: 1.0)
    }
}


struct safari_title_bar : View {
    @Binding var forward_or_backward: Bool
    @Binding var current_nav_view: String
    @Binding var url_search: String
    @Binding var google_search: String
    @Binding var editing_state_url: String
    @Binding var editing_state_google: String
    @State var progress: Double = 1.0
    @State var url_height: CGFloat = 0
    @State private var isFocused = false
    @ObservedObject var bm_observer: bookmarks_observer
    var webViewStore: WebViewStore
    var current_webpage_title: String
    var no_right_padding: Bool?
    private let gradient = LinearGradient([.white, .white], to: .trailing)
    private let cancel_gradient = LinearGradient([(color: Color(red: 164/255, green: 175/255, blue:191/255), location: 0), (color: Color(red: 124/255, green: 141/255, blue:164/255), location: 0.51), (color: Color(red: 113/255, green: 131/255, blue:156/255), location: 0.51), (color: Color(red: 112/255, green: 130/255, blue:155/255), location: 1)], from: .top, to: .bottom)
    var body :some View {
        GeometryReader{ geometry in
            ZStack {
                LinearGradient(gradient: Gradient(stops: [.init(color:Color(red: 206/255, green: 206/255, blue: 206/255), location: 0.0), .init(color:Color(red: 167/255, green: 167/255, blue: 167/255), location: 1.0)]), startPoint: .top, endPoint: .bottom).innerShadowBottom(color: Color(red: 230/255, green: 230/255, blue: 230/255), radius: 0.025)
                //.border_bottom(width: 1, edges: [.bottom], color: Color(red: 178/255, green: 178/255, blue: 178/255)).border_bottom(width: 1, edges: [.bottom], color: Color(red: 45/255, green: 48/255, blue: 51/255))
                VStack(spacing: 0) {
                    //   Spacer()
                    HStack {
                        Spacer()
                        Text(current_webpage_title != "" ? current_webpage_title : "Untitled").foregroundColor(Color.black).font(.custom("Lucida Grande", size: 14)).shadow(color: Color.white.opacity(0.51), radius: 0, x: 0.0, y: 2/3).padding([.leading, .trailing], 24)
                        Spacer()
                    }.frame(height: 80/3)
                    //  Spacer()
                    HStack {
                        ZStack {
                            forward_backward_view(can_go_back: webViewStore.webView.canGoBack, can_go_forward: webViewStore.webView.canGoForward, back_action: {webViewStore.webView.goBack()}, forward_action: {webViewStore.webView.goForward()}).frame(width: 60, height: 24)
                        }.cornerRadius(4).strokeRoundedRectangle(4, Color(red: 79/255, green: 79/255, blue: 79/255), lineWidth: 0.9).frame(width: 60 + 1.8, height: 24 + 1.8).clipped().shadow(color: Color(red: 201/255, green: 201/255, blue: 201/255), radius: 0, x: 0, y: 1)
                        ZStack {
                            RoundedRectangle(cornerRadius:4).fill(progress == 1.0 ? LinearGradient([(color: Color.white, location: 0)], from: .top, to: .bottom) : progress == 0.0 ? LinearGradient([(color: Color.white, location: 0)], from: .top, to: .bottom) : LinearGradient([(color: Color(red: 148/255, green: 182/255, blue:215/255),  location: 0), (color: Color(red: 148/255, green: 182/255, blue:215/255),  location: 0.05), (color: Color(red: 172/255, green: 206/255, blue:242/255), location: 0.05), (color: Color(red: 172/255, green: 206/255, blue:242/255), location: 0.25), (color: Color(red: 153/255, green: 199/255, blue:244/255), location: 0.35), (color: Color(red: 137/255, green: 194/255, blue:243/255), location: 0.45), (color: Color(red: 137/255, green: 194/255, blue:243/255), location: 0.60), (color: Color(red: 176/255, green: 208/255, blue:242/255),  location: 0.8), (color: Color(red: 176/255, green: 208/255, blue:242/255), location: 1)], from: .top, to: .bottom)).frame(width: geometry.size.width*2/3-95, height: 24)
                            url_search_bar(url_search: $url_search, editing_state_url: $editing_state_url, progress: $progress, bm_observer: bm_observer, webViewStore: webViewStore).frame(width:geometry.size.width*2/3-95, height: 24)
                        }.strokeRoundedRectangle(4, LinearGradient([Color(red: 79/255, green: 79/255, blue: 79/255), Color(red: 69/255, green: 69/255, blue: 69/255)], from: .top, to: .bottom), lineWidth: 0.9).frame(width: geometry.size.width*2/3-95 + 1.8, height: 24 + 1.8).clipped().shadow(color: Color(red: 201/255, green: 201/255, blue: 201/255), radius: 0, x: 0, y: 1).strokeRoundedRectangle(4, editing_state_url == "Foc" ? LinearGradient([Color.blue.opacity(0.7)], from : .top, to:.bottom) : LinearGradient([Color.clear.opacity(0)], from: .top, to: .bottom), lineWidth: editing_state_url == "Foc" ? 3 : 0)
                        
                        ZStack {
                            google_search_bar(google_search: $google_search, url_search: $url_search, editing_state_google: $editing_state_google, webViewStore: webViewStore).frame(width: geometry.size.width*1/3, height: 24)
                        }.clipped().strokeCapsule(LinearGradient([Color(red: 79/255, green: 79/255, blue: 79/255), Color(red: 114/255, green: 114/255, blue: 114/255)], from: .top, to: .bottom), lineWidth: 0.9).frame(width: geometry.size.width*1/3 + 1.8, height: 24 + 1.8).shadow(color: Color(red: 201/255, green: 201/255, blue: 201/255), radius: 0, x: 0, y: 1).strokeCapsule(editing_state_google == "Foc" ? LinearGradient([Color.blue.opacity(0.7)], from : .top, to:.bottom) : LinearGradient([Color.clear.opacity(0)], from: .top, to: .bottom), lineWidth: editing_state_google == "Foc" ? 3 : 0)
                        
                        
                    }.frame(height: 80/3)
                    HStack {
                        bookmarks_view(webViewStore: webViewStore).offset(y: -1)
                        Spacer()
                    }.frame(height: 80/3)
                    //  Spacer()
                }
            }
        }
    }
}

struct bookmark: Identifiable {
    let id = UUID()
    let name: String
    let url: String
}


struct bookmarks_view: View {
    var bookmarks = [bookmark(name: "Apple", url: "http://apple.com"), bookmark(name: "Yahoo!", url: "http://yahoo.com"), bookmark(name: "Google Maps", url: "http://maps.google.com"), bookmark(name: "YouTube", url: "http://youtube.com"), bookmark(name: "Wikipedia", url: "http://wikipedia.com") ]
    var webViewStore: WebViewStore
    var body: some View {
        HStack(spacing: 15) {
            ForEach(bookmarks) {bookmark in
                Button(action: {
                    
                    if bookmark.url.hasPrefix("https://") || bookmark.url.hasPrefix("http://") {
                        guard let url = URL(string: "\(bookmark.url)") else { return }
                        //   print("here 1")
                        self.webViewStore.webView.load(URLRequest(url: url))
                    //    values[index] = self.webViewStore.webView.url?.relativeString ?? ""
                    } else if bookmark.url.contains("www") {
                        guard let url = URL(string: "https://\(bookmark.url)") else { return }
                        // print("here 2")
                        self.webViewStore.webView.load(URLRequest(url: url))
                       // url_search = self.webViewStore.webView.url?.relativeString ?? ""
                    } else {
                        guard let url = URL(string: "https://\(bookmark.url)") else { return }
                        //  print("here 3")
                        self.webViewStore.webView.load(URLRequest(url: url))
                      //  url_search =  self.webViewStore.webView.url?.relativeString ?? ""
                        //searchTextOnGoogle(urlString)
                    }
                    
                }) {
                    Text(bookmark.name).font(.custom("Lucida Grande Bold", size: 10.35)).foregroundColor(Color(red: 40/255, green: 40/255, blue: 40/255)).shadow(color: Color.white.opacity(0.6), radius: 0, x: 0.0, y: 1)
                }.buttonStyle(PlainButtonStyle())
            }
        }.padding(.leading, 10)
    }
}

struct url_search_bar: View {
    @State var active_url: String = "" //work this in future
    @Binding var url_search: String
    @Binding var editing_state_url: String
    @Binding var progress: Double
    @ObservedObject var bm_observer: bookmarks_observer
    var webViewStore: WebViewStore
    private let gradient = LinearGradient([.white, .white], to: .trailing)
    private let cancel_gradient = LinearGradient([(color: Color(red: 164/255, green: 175/255, blue:191/255), location: 0), (color: Color(red: 124/255, green: 141/255, blue:164/255), location: 0.51), (color: Color(red: 113/255, green: 131/255, blue:156/255), location: 0.51), (color: Color(red: 112/255, green: 130/255, blue:155/255), location: 1)], from: .top, to: .bottom)
    var body: some View {
        HStack(spacing: 0) {
            Button(action:{
                if webViewStore.webView.url?.relativeString ?? "" != "" {
                let userDefaults = UserDefaults.standard

                                        // Read/Get Array of Strings
                var bookmarks: [String:String] = userDefaults.object(forKey: "bookmarks") as? [String:String] ?? [String: String]()

                                        // Append String to Array of Strings
                bookmarks.updateValue(webViewStore.webView.title ?? "" == "" ? "Untitled" : webViewStore.webView.title ?? "", forKey: webViewStore.webView.url?.relativeString ?? "")

                                        // Write/Set Array of Strings
                userDefaults.set(bookmarks, forKey: "bookmarks")
                bm_observer.update_bookmarks()
                }
            }) {
                ZStack {
                    Rectangle().fill(LinearGradient([Color(red: 254/255, green: 254/255, blue: 254/255), Color(red: 169/255, green: 169/255, blue: 169/255)], from: .top, to: .bottom))
                    Text("+").foregroundColor(webViewStore.webView.url?.relativeString ?? "" != "" ? Color.black : Color(red: 138/255, green: 138/255, blue: 138/255)).font(.system(size: 20, weight: .medium)).shadow(color: Color.white.opacity(0.8), radius: 0, x: 0.0, y: 1).offset(y: -1)
                    HStack {
                        Spacer()
                        Rectangle().fill(Color(red: 75/255, green: 75/255, blue: 75/255)).frame(width: 0.9, height: 24)
                    }
                }.frame(width: 30, height: 24)
            }.buttonStyle(PlainButtonStyle()).frame(width: 30, height: 24).clipped()
           // Spacer(minLength: 5)
            Image("BookmarkPreferences").resizable().scaledToFit().frame(width: 18, height: 18).padding(.leading, 2)
            HStack (alignment: .center,
                    spacing: 10) {
                TextField ("Go to this address", text: $url_search, onEditingChanged: {(editingChanged) in
                    if editingChanged {
                        editing_state_url = "Foc"
                    } else {
                        editing_state_url = "None"
                    }
                }) {
                    DispatchQueue.main.async { //omg
                        let window = NSApplication.shared.windows.first!
                        window.makeFirstResponder(nil)
                        
                    }
                    if url_search.hasPrefix("https://") || url_search.hasPrefix("http://") {
                        guard let url = URL(string: "\(url_search)") else { return }
                        //   print("here 1")
                        self.webViewStore.webView.load(URLRequest(url: url))
                        url_search = self.webViewStore.webView.url?.relativeString ?? ""
                    } else if url_search.contains("www") {
                        guard let url = URL(string: "https://\(url_search)") else { return }
                        // print("here 2")
                        self.webViewStore.webView.load(URLRequest(url: url))
                        url_search = self.webViewStore.webView.url?.relativeString ?? ""
                    } else {
                        guard let url = URL(string: "https://\(url_search)") else { return }
                        //  print("here 3")
                        self.webViewStore.webView.load(URLRequest(url: url))
                        url_search =  self.webViewStore.webView.url?.relativeString ?? ""
                        //searchTextOnGoogle(urlString)
                    }
                    withAnimation() {
                        editing_state_url = "None"
                    }
                }   .textFieldStyle(PlainTextFieldStyle()).font(.custom("Lucida Grande", size: 12)).foregroundColor(Color.black)
                Button(action:{
                    if (progress != 1 && progress != 0)  {
                        webViewStore.webView.stopLoading()
                    } else {
                        webViewStore.webView.reload()
                    }
                }) {
                    Image((progress != 1 && progress != 0) ? "stop_load" : "refresh")    .interpolation(.high)  .resizable().renderingMode(.template).scaledToFit().foregroundColor(Color(red: 89/255, green: 89/255, blue: 89/255)).rotationEffect(.degrees(-90)).padding([.top, .leading, .bottom], 5)
                }.buttonStyle(PlainButtonStyle())
                
            }.frame(height: 24)
            
            //   .padding([.top,.bottom], 5)
            .padding(.leading, 2)
            .cornerRadius(4)
            Spacer(minLength: 8)
        }     .cornerRadius(4) .ps_innerShadow(.roundedRectangle(4, LinearGradient([(color: Color.clear, location: progress != 1 ? progress : 0), (color: .white, progress != 1 ? progress : 0)], from: .leading, to: .trailing)), radius:1.8, offset: CGPoint(0, 1), intensity: 0).onReceive(webViewStore.objectWillChange) {_ in
            progress = webViewStore.webView.estimatedProgress
        }
    }
}

struct forward_backward_view : View {
    var can_go_back: Bool
    var can_go_forward: Bool
    var back_action: () -> Void
    var forward_action: () -> Void
    var body: some View {
        GeometryReader {geometry in
            HStack(spacing: 0) {
                Button(action:{back_action()}) {
                    ZStack {
                        Rectangle().fill(LinearGradient([Color(red: 254/255, green: 254/255, blue: 254/255), Color(red: 169/255, green: 169/255, blue: 169/255)], from: .top, to: .bottom))
                        Text("◀").gradientForeground(colors: can_go_back ? [Color(red: 33/255, green: 33/255, blue: 33/255), Color(red: 55/255, green: 55/255, blue: 55/255)] : [Color(red: 138/255, green: 138/255, blue: 138/255)]).font(.custom("Lucida Grande", size: 12)).shadow(color: Color.white.opacity(0.8), radius: 0, x: 0.0, y: 1)
                    }.frame(width: 30, height: 24)
                }.buttonStyle(PlainButtonStyle()).frame(width: 30, height: 24).clipped()
                Rectangle().fill(Color(red: 75/255, green: 75/255, blue: 75/255)).frame(width: 0.9, height: 24)
                Button(action:{forward_action()}) {
                    ZStack {
                        Rectangle().fill(LinearGradient([Color(red: 254/255, green: 254/255, blue: 254/255), Color(red: 169/255, green: 169/255, blue: 169/255)], from: .top, to: .bottom))
                        Text("▶").gradientForeground(colors: can_go_forward ? [Color(red: 33/255, green: 33/255, blue: 33/255), Color(red: 55/255, green: 55/255, blue: 55/255)] : [Color(red: 138/255, green: 138/255, blue: 138/255)]).font(.custom("Lucida Grande", size: 12)).shadow(color: Color.white.opacity(0.8), radius: 0, x: 0.0, y: 1)
                    }.frame(width: 30, height: 24)
                }.buttonStyle(PlainButtonStyle()).frame(width: 30, height: 24).clipped()
            }
        }
    }
}

extension View {
    public func gradientForeground(colors: [Color]) -> some View {
        self.overlay(LinearGradient(gradient: .init(colors: colors),
                                    startPoint: .top,
                                    endPoint: .bottom))
            .mask(self)
    }
}

extension NSTextField { // << workaround !!!
    open override var focusRingType: NSFocusRingType {
        get { .none }
        set { }
    }
}


struct google_search_bar: View {
    @Binding var google_search: String
    @Binding var url_search: String
    @Binding var editing_state_google: String
    var webViewStore: WebViewStore
    private let gradient = LinearGradient([.white, .white], to: .trailing)
    private let cancel_gradient = LinearGradient([(color: Color(red: 164/255, green: 175/255, blue:191/255), location: 0), (color: Color(red: 124/255, green: 141/255, blue:164/255), location: 0.51), (color: Color(red: 113/255, green: 131/255, blue:156/255), location: 0.51), (color: Color(red: 112/255, green: 130/255, blue:155/255), location: 1)], from: .top, to: .bottom)
    var body: some View {
        HStack(spacing: 0) {
            Image("SearchMagGlass").padding(.leading, 2)
           // Spacer(minLength: 5)
            HStack (alignment: .center,
                    spacing: 10) {
                TextField ("Google", text: $google_search, onEditingChanged: { (editingChanged) in
                    if editingChanged {
                        editing_state_google = "Foc"
                    } else {
                        editing_state_google = "None"
                    }
                }) {
                    if google_search != "" {
                        let link = google_search.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                        guard let url = URL(string: "https://google.com/search?q=\(String(link ?? ""))") else { return }
                        print(url)
                        self.webViewStore.webView.load(URLRequest(url:url))
                        url_search =  self.webViewStore.webView.url?.relativeString ?? ""
                        google_search = ""
                        withAnimation() {
                            editing_state_google = "None"
                        }
                    }
                }.textFieldStyle(PlainTextFieldStyle()).textFieldStyle(PlainTextFieldStyle()).font(.custom("Lucida Grande", size: 13))
            }
            
            .padding([.top,.bottom], 5)
            .padding(.leading, 5)
            .cornerRadius(40)
            Spacer(minLength: 8)
        } .ps_innerShadow(.capsule(gradient), radius:1.8, offset: CGPoint(0, 1), intensity: 0)
    }
}

extension View {
    
    func border_bottom(width: CGFloat, edges: [Edge], color: Color) -> some View {
        overlay(EdgeBorder(width: width, edges: edges).foregroundColor(color))
    }
    func innerShadowBottom(color: Color, radius: CGFloat = 0.1) -> some View {
        modifier(InnerShadow_Bottom(color: color, radius: min(max(0, radius), 1)))
    }
    func innerShadowBottomView(color: Color, radius: CGFloat = 0.1) -> some View {
        modifier(InnerShadow_Bottom_View(color: color, radius: min(max(0, radius), 1)))
    }
    
}

private struct InnerShadow_Bottom_View: ViewModifier {
    var color: Color = .gray
    var radius: CGFloat = 0.1
    
    private var colors: [Color] {
        [color.opacity(0.75), color.opacity(0.0), .clear]
    }
    
    func body(content: Content) -> some View {
        GeometryReader { geo in
            content
                .overlay(LinearGradient(gradient: Gradient(colors: self.colors), startPoint: .bottom, endPoint: .top)
                            .frame(height: self.radius * self.minSide(geo)),
                         alignment: .bottom)
        }
    }
    
    func minSide(_ geo: GeometryProxy) -> CGFloat {
        CGFloat(3) * min(geo.size.width, geo.size.height) / 2
    }
}

private struct InnerShadow_Bottom: ViewModifier {
    var color: Color = .gray
    var radius: CGFloat = 0.1
    
    private var colors: [Color] {
        [color.opacity(0.75), color.opacity(0.0), .clear]
    }
    
    func body(content: Content) -> some View {
        GeometryReader { geo in
            content
                .overlay(LinearGradient(gradient: Gradient(colors: self.colors), startPoint: .top, endPoint: .bottom)
                            .frame(height: self.radius * self.minSide(geo)),
                         alignment: .top)
        }
    }
    
    func minSide(_ geo: GeometryProxy) -> CGFloat {
        CGFloat(3) * min(geo.size.width, geo.size.height) / 2
    }
}

struct EdgeBorder: Shape {
    
    var width: CGFloat
    var edges: [Edge]
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        for edge in edges {
            var x: CGFloat {
                switch edge {
                case .top, .bottom, .leading: return rect.minX
                case .trailing: return rect.maxX - width
                }
            }
            
            var y: CGFloat {
                switch edge {
                case .top, .leading, .trailing: return rect.minY
                case .bottom: return rect.maxY - width
                }
            }
            
            var w: CGFloat {
                switch edge {
                case .top, .bottom: return rect.width
                case .leading, .trailing: return self.width
                }
            }
            
            var h: CGFloat {
                switch edge {
                case .top, .bottom: return self.width
                case .leading, .trailing: return rect.height
                }
            }
            path.addPath(Path(CGRect(x: x, y: y, width: w, height: h)))
        }
        return path
    }
}

class ObservableArray<T>: ObservableObject {
    
    
    @Published var array:[T] = []
    var cancellables = [AnyCancellable]()
    
    init(array: [T]) {
        self.array = array
        
    }
    
    func observeChildrenChanges<T: ObservableObject>() -> ObservableArray<T> {
        let array2 = array as! [T]
        array2.forEach({
            let c = $0.objectWillChange.sink(receiveValue: { _ in self.objectWillChange.send() })
            
            // Important: You have to keep the returned value allocated,
            // otherwise the sink subscription gets cancelled
            self.cancellables.append(c)
        })
        return self as! ObservableArray<T>
    }
    
    
}
