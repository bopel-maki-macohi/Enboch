package videoManagers;

#if hxvlc
typedef EnboVideo = DesktopVideo;
#elseif html5
typedef EnboVideo = WebVideo;
#else
typedef EnboVideo = Null;
#end
