import QtQuick 2.15
import QtQml.StateMachine 1.15 as DSM
import "../ViewModel"
DSM.State {
    id: working
    
    property alias editTemperatureActive: editTemperature.active
    property alias isIdle: heatingOff.active
    
    initialState: heatingOff
    DSM.State
    {
        id: heatingOff
        DSM.SignalTransition{
            targetState: heatingOn
            signal: doSelectMode
            
        }
    }
    
    DSM.State{
        id: heatingOn
        initialState: parametersIdle
        DSM.SignalTransition{
            targetState: heatingOff
            signal: doStop
            onTriggered: heatingStopped()
        }
        
        property QtObject viewModel
        onEntered: console.log("--> parameters")
        onExited: console.log("<-- parameters")
        DSM.State{
            id: parametersIdle
            DSM.SignalTransition{
                targetState: editTemperature
                signal: doEditTemperature
                onTriggered: vm => viewModel = vm
            }
            onEntered: console.log("--> parametersIdle")
            onExited: console.log("<-- parametersIdle")
        }
        DSM.State{
            id: editTemperature
            DSM.SignalTransition{
                targetState: parametersIdle
                signal: doEditDone
            }
            onEntered: console.log("--> editTemperature")
            onExited: console.log("<-- editTemperature")
        }
    }
    
    
}
