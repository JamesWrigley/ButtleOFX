import QtQuick 2.1
import QtQuick.Layouts 1.0
import QtQuick.Controls 1.0

Rectangle {
	id: footer
    color: "#141414"

    property string filter: "*"
    property variant selected
    property int nbInSeq

    signal changeFilter(string newFilter)
    signal openFolder(string newFolder)

    RowLayout {
		anchors.fill: parent
        spacing: 10

        Item {
			Layout.fillHeight: true
			Layout.fillWidth: true
        }

        Text {
            id: nbOfFiles
            text: {
                if(selected.count > 1){
                    selected.count + " files selected"
                }if(selected.count == 1){
                    selected.get(0).fileType == "Sequence" ? nbInSeq + " files in Sequence" : ""
                }
            }

            color: "white"
        }

        Text {
            id: size
            text: {
                var res=0
                if(selected.count > 1){

                    for(var i=0; i< selected.count; ++i)
                    {
                        res = res + selected.get(i).fileSize
                    }
                    res = res / 1024.
                    "Size: " + res.toFixed(2) + " Ko"
                }else{
                    res = selected.get(i).fileSize / 1024.
                    selected.get(i).fileSize <= 0.0 ? "" : "Size: " + res.toFixed(2) + " Ko"
                }
            }
            color: "white"
        }

        ComboBox {
            width: 200
            model: [ "*", ".jpg", ".png", ".raw" ]


            onCurrentTextChanged: {
                changeFilter(currentText)
                //console.log("currentText = " + currentText)
            }
        }

		Button{
			id: openButton
            text: "Import"
            height: parent.height - 5
			
			// import selected files in the graph
            onClicked: {
                _buttleData.currentGraphWrapper = _buttleData.graphWrapper
                _buttleData.currentGraphIsGraph()
                // if before the viewer was showing an image from the brower, we change the currentView
                if (_buttleData.currentViewerIndex > 9){
                    _buttleData.currentViewerIndex = player.lastView
                    if (player.lastNodeWrapper != undefined)
                        _buttleData.currentViewerNodeWrapper = player.lastNodeWrapper
                    player.changeViewer(player.lastView)
                }
                
                for(var i=0; i< selected.count; ++i)
                {
                    _buttleManager.nodeManager.dropFile(selected.get(i).filepath, 10*i, 10*i)
                }

            }
		}
	}
}

