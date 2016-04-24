import QtQuick 2.6
import QtQuick.Window 2.2
import QtQuick.Controls 1.4
import HKManager 1.0

Window {
    visible: true

    HKManager {
        id: hkManager
        readHeartRate: hrSwitch.checked
        readBirthDate: bdSwitch.checked
    }

    Column {
        Row {
            Label {
                text: "Heart rate"
            }
            Switch {
                id: hrSwitch
            }
        }
        Row {
            Label {
                text: "Birth date"
            }
            Switch {
                id: bdSwitch
            }
        }
        Row {
            Button {
                text: "Authorize"
                onClicked: {
                    hkManager.requestAuthorization()
                }
            }
            Button {
                text: "Heart rate"
                onClicked: {
                    hkManager.getHeartRate()
                }
            }
            Button {
                text: "Birth date"
                onClicked: {
                    var birthDate = hkManager.getBirthDate();
                    console.log("birth date:", birthDate)
                    lblBirthDate.text = birthDate
                }
            }
            Label {
                id: lblBirthDate
                text: ""
            }
        }
    }


}
