import QtQuick 2.15
import QtQuick.Window 2.15
import "Screens"
import "States"
import "ViewModel"

Window {
    id: root
    width: 640
    height: 480
    visible: true
    title: qsTr("Abstract Baking Oven")

    property QtObject sm: stateMachine
    property alias vm: workingScreen.viewModel


    signal doStandby
    signal doTurnOn
    signal doSelectMode(int modeType)
    signal doStop
    signal doEditDone
    signal doEditTemperature(QtObject vm)

    Connections{
        target: stateMachine
        function onHeatingStopped()
        {
            ViewModel.stopHeating()
        }
    }

    // State Machine

    StateMachine{
        id: stateMachine
    }


    Item {
        id: stateMachineMock

        property bool editValueActive: false
        property bool standbyActive: true
        property QtObject workingState: QtObject {
            id: workingState
            property bool editTemperatureActive: false
            property bool isIdle: true
        }

        //Outgoing signal
        signal heatingStopped

        //Test signals
        signal doTurnOnReceived
        signal doStandbyReceived
        signal doSelectModeReceived
        signal doStopReceived
        signal doEditTemperatureReceived
        signal doEditDoneReceived

        Connections {
            target: root
            function onDoTurnOn(){
                stateMachineMock.doTurnOnReceived()
            }
        }

        Connections {
            target: root
            function onDoStandby(){
                stateMachineMock.doStandbyReceived()
            }
        }

        Connections {
            target: root
            function onDoSelectMode(){
                stateMachineMock.doSelectModeReceived()
            }
        }

        Connections {
            target: root
            function onDoStop(){
                stateMachineMock.doStopReceived()
            }
        }

        Connections {
            target: root
            function onDoEditTemperature(){
                stateMachineMock.doEditTemperatureReceived()
            }
        }

        Connections {
            target: root
            function onDoEditDone(){
                stateMachineMock.doEditDoneReceived()
            }
        }
        
        function setStandbyActive(aStandbyActive)
        {
            standbyActive = aStandbyActive === "true"
        }

        function setWorkingScreenIdle(aIdleActive)
        {
            workingState.isIdle = aIdleActive === "true"
        }

        function setEditValueActive(aEditValueActive)
        {
            editValueActive = aEditValueActive === "true"
        }

        function setEditTemperatureActive(aEditTemperatureActive)
        {
            workingState.editTemperatureActive = aEditTemperatureActive === "true"
        }
    }

    // Visual Components
    BlankScreen{
        anchors.fill: parent
        // connection to the state machine
        visible: sm.standbyActive
        z: 1
    }

    WorkingScreen{
        id: workingScreen
        anchors.fill: parent
        // hold the state of the state machine
        stateObject: sm.workingState
        viewModel: ViewModel
    }
}
