import QtQuick 2.15
import QtQml.StateMachine 1.15 as DSM
import "."


DSM.StateMachine {
    id: stateMachine
    running: true
    property alias editValueActive: stateWorking.editTemperatureActive
    property alias workingState: stateWorking
    property alias standbyActive: stateStandby.active

    signal heatingStopped

    initialState: stateStandby
    DSM.State{
        id: stateStandby
        DSM.SignalTransition{
            targetState: stateWorking
            signal: doTurnOn
        }
        onEntered: console.log("--> Entered Standby")
        onExited: console.log("<-- Exited Standby")
    }
    Working{
        id: stateWorking
        DSM.SignalTransition{
            targetState: stateStandby
            signal: doStandby
        }
    }
}
