import QtQuick 2.2

Rectangle {
    width: 600
    height: 400

    /**
    24: 13:39
    12: 01:30 PM

    is24hour = !is24hour;
    */
    property bool is24hour: true

    property bool useCurrentTime: true


    function showTime() {
        var date = getDate();

        var txt = "";
        if (is24hour) {
            txt = date.getHours().toString(); // 13
        }
        else {
            // 00 --> 12
            txt = String(date.getHours() % 12); // 1
            if (txt == "0") {
                txt = "12";
            }
        }
        if (txt.length == 1) {
            txt = "0" + txt; // 01
        }

        txt += ":";

        var min = date.getMinutes().toString();
        if (min.length == 1) {
            min = "0" + min;
        }

        txt += min;

        return txt;
    }

    function showAMPM() {
        var txt = "";
        var date = getDate();

        if (date.getHours() > 11) {
           txt = "PM";
        }
        else {
           txt = "AM";
        }
        return txt;
    }

    function getDate() {
        var date = new Date();

        // For testing purposes...
        if (!useCurrentTime) {
          date.setHours(0);
        }

        return date;
    }

    Component.onCompleted: {
        console.log(showTime());
    }

    //textField.text = showTime();

    // field.visible = !is24hour;

}
