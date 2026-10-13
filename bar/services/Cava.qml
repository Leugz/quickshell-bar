import Quickshell
import Quickshell.Io
import Quickshell.Services.Mpris
pragma Singleton

Singleton {
    id: root

    readonly property bool isPlaying: Mpris.players.values.some((p) => {
        return p.isPlaying;
    })
    property var heights: [10, 10, 10, 10, 10, 10, 10, 10, 10, 10]

    onIsPlayingChanged: {
        if (!isPlaying) {
            heights = [6, 6, 6, 6, 6, 6, 6, 6, 6, 6];
        }
    }

    Process {
        running: root.isPlaying
        command: ["cava", "-p", Quickshell.shellDir + "/config/cava.conf"]

        stdout: SplitParser {
            onRead: (data) => {
                if (!data)
                    return ;

                const vals = data.trim().split(";").filter((s) => {
                    return s !== "";
                }).map(Number);
                if (vals.length >= 10)
                    root.heights = vals.map((h) => {
                    return (isNaN(h) || h < 4) ? 4 : h;
                });

            }
        }

    }

}
