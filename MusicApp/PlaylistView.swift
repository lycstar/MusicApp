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
    
    var avPlayer = AVPlayer()
    
    func play(id:Int?){
        if(id == nil){
            return
        }
        Task{
            let url = await Api.fetchMusicUrl(id:id!)
            if(url != nil){
                let playerItem = AVPlayerItem(url: URL(string:url!)!)
                avPlayer =  AVPlayer(playerItem: playerItem )
                avPlayer.play()
            }
        }
        
    }
    
    init() {
        try! AVAudioSession.sharedInstance().setCategory(.playback)
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
            ScrollView{
                VStack(alignment: HorizontalAlignment.leading){
                    if(playlistModel.playlist != nil && playlistModel.playlist?.tracks != nil){
                        AsyncImage(url: URL(string:Api.fetchSmallImage(url: playlistModel.playlist!.coverImgUrl))).frame(width: 200,height: 200).cornerRadius(10)
                            .transition(AnyTransition.scale.animation(.easeInOut(duration:0.35)))
                            .padding(.leading,20)
                            .padding(.trailing,20)
                            .padding(.top,20)
                            .padding(.bottom,10)
                        if(playlistModel.playlist != nil && playlistModel.playlist?.description != nil){
                            Text(playlistModel.playlist!.description!).padding(.leading,20).padding(.trailing,20).padding(.bottom,20)
                        }
                        ForEach(playlistModel.playlist!.tracks!,id: \.id) {track in
                            
                            VStack(alignment: HorizontalAlignment.leading){
                                Text(track.name ?? "").frame(height: 30).padding(.leading,20).padding(.trailing,20).onTapGesture {
                                    playlistModel.play(id: track.id)
                                }.font(.title3)
                                Text(Api.fetchCompleteArtistName(arList: track.ar ?? [])).frame(height: 20).padding(.leading,20).padding(.trailing,20).onTapGesture {
                                    playlistModel.play(id: track.id)
                                }
                            }
                            Divider()
                        }
                    }
                    
                    
                }
            }.navigationBarTitle(
                (playlistModel.playlist != nil && playlistModel.playlist?.tracks != nil)
                ?Text(playlistModel.playlist?.name ?? ""):Text("歌单")
                , displayMode: .large)
        }
    }
}
