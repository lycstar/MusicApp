//
//  PlaylistView.swift
//  MusicApp
//
//  Created by lycstar on 2023/2/4.
//

import Foundation
import SwiftUI
import AVFoundation

class PlaylistModel: ObservableObject {
    
    @Published var base64Data:String?
    
    @Published var playlist:Playlist?
    
    @Published var curMusic:Track?
    
    @Published var playing:Bool = false
    
    var avPlayer : AVPlayer?
    
    func play(track:Track){
        if(track.id == nil){
            return
        }
        Task{
            let url = await Api.fetchMusicUrl(id:track.id!)
            if url == nil {
                return
            }
            let playUrl = URL(string : url!)
            if playUrl == nil {
                return
            }
            DispatchQueue.main.async {
                self.curMusic = track
            }
            if avPlayer == nil {
                avPlayer = AVPlayer(url: playUrl!);
                avPlayer?.play()
                DispatchQueue.main.async {
                    self.playing = true
                }
            } else {
                avPlayer!.pause()
                avPlayer!.replaceCurrentItem(with: AVPlayerItem(url: playUrl!))
                avPlayer!.play()
                DispatchQueue.main.async {
                    self.playing = true
                }
            }
        }
    }
    
    func pauseAndPlay(){
        if avPlayer?.timeControlStatus == .playing{
            avPlayer?.pause()
            playing = false
        }else if avPlayer?.timeControlStatus == .paused{
            avPlayer?.play()
            playing = true
        }
    }
    
    init() {
        try! AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback,
                                                         mode: .default,
                                                         policy:AVAudioSession.RouteSharingPolicy.longFormAudio,
                                                         options: [])
        DispatchQueue.main.async {
            Task{
                self.playlist = await Api.fetchPlaylist()
            }
        }
    }
}

struct PlaylistView: View{
    
    @ObservedObject var playlistModel = PlaylistModel()
    
    var body: some View{
        NavigationView{
            ZStack(alignment: Alignment.bottom){
                
                ScrollView{
                    
                    VStack(alignment: HorizontalAlignment.leading){
                        if(playlistModel.playlist != nil && playlistModel.playlist?.tracks != nil){
                            
                            AsyncImage(url: URL(string:Api.fetchSmallImage(url: playlistModel.playlist!.coverImgUrl))) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 200, height: 200)
                            } placeholder: {
                                Color.gray.opacity(0.1).frame(width: 200, height: 200)
                            }.cornerRadius(10)
                                .transition(AnyTransition.scale.animation(.easeInOut(duration:0.35)))
                                .padding(.leading,20)
                                .padding(.trailing,20)
                                .padding(.top,20)
                                .padding(.bottom,10)
                            
                            if(playlistModel.playlist != nil && playlistModel.playlist?.description != nil){
                                Text(playlistModel.playlist!.description!).font(.subheadline).padding(.leading,20).padding(.trailing,10).padding(.bottom,5)
                            }
                            
                            ForEach(playlistModel.playlist!.tracks!,id: \.id) {track in
                                
                                VStack(alignment: HorizontalAlignment.leading){
                                    
                                    Text(track.name ?? "").padding(.leading,20).padding(.trailing,20).lineLimit(1).padding(.bottom,2)
                                    
                                    Text(track.artistsName()).padding(.leading,20).font(.subheadline).lineLimit(1).font(.subheadline).padding(.trailing,20).padding(.trailing,10)
                                    
                                }.frame(maxWidth:.infinity,alignment: .leading).contentShape(Rectangle()) .onTapGesture {
                                    playlistModel.play(track: track)
                                }
                                Divider()
                            }
                        }
                    }
                }.padding(.bottom, playlistModel.curMusic != nil ? 70:0 )
                
                if(playlistModel.curMusic != nil ){
                    HStack{
                        HStack(){
                            AsyncImage(url: URL(string: playlistModel.curMusic!.al?.picUrl ?? "")){image in
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .cornerRadius(4)
                                    .frame(width: 42, height: 42)
                            } placeholder: {
                                Color.gray.opacity(0.1).frame(width: 42, height: 42)
                            }.padding(.leading,2).padding(.trailing,2)
                            
                            VStack(alignment: HorizontalAlignment.leading){
                                Text(playlistModel.curMusic!.name ?? "").lineLimit(1)
                                Text(playlistModel.curMusic!.artistsName()).font(.subheadline).lineLimit(1)
                            }
                            
                            Spacer()
                            
                            Image(uiImage: UIImage(systemName: playlistModel.playing ?"pause.fill":"play.fill")!).resizable().scaledToFill().frame(width: 20,height: 20).padding(.all,10).contentShape(Rectangle()).onTapGesture{
                                playlistModel.pauseAndPlay()
                            }.padding(.trailing,10)
                            
                        }.frame(height: 50).padding(.all,10)
                        
                    }.background(BlurView()).cornerRadius(10.0).padding(.all,10)
                    
                }
                
            }.navigationBarTitle(
                (playlistModel.playlist != nil && playlistModel.playlist?.tracks != nil)
                ?Text(playlistModel.playlist?.name ?? ""):Text("歌单")
                , displayMode: .large)
        }
    }
}

struct BlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style = .systemUltraThinMaterial
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}
