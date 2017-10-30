var dp;
var app = angular.module('app', ['daypilot']).controller('DemoCtrl', function($scope, $timeout, $http) {

    $scope.roomType = "0";

    $scope.$watch("roomType", function() {
        loadResources();
    });

    $scope.navigatorConfig = {
        selectMode: "month",
        showMonths: 3,
        skipMonths: 3,
        locale: "es-es",
        onTimeRangeSelected: function(args) {
            if ($scope.scheduler.visibleStart().getDatePart() <= args.day && args.day < $scope.scheduler.visibleEnd()) {
                $scope.scheduler.scrollTo(args.day, "fast");  // just scroll
            }
            else {
                loadEvents(args.day);  // reload and scroll
            }
        }
    };

    $scope.schedulerConfig = {
        visible: false, // will be displayed after loading the resources
        scale: "Manual",
        timeline: getTimeline(),
        timeHeaders: [ { groupBy: "Month", format: "MMMM yyyy" }, { groupBy: "Day", format: "d" } ],
        eventDeleteHandling: "Update",
        allowEventOverlap: false,
        cellWidthSpec: "Auto",
        eventHeight: 50,
        rowHeaderColumns: [
            {title: "Cuarto", width: 80},
            {title: "Capacidad", width: 80}
        ],
        onBeforeResHeaderRender: function(args) {
            var beds = function(count) {
                return count + " cama" + (count > 1 ? "s" : "");
            };

            args.resource.columns[0].html = beds(args.resource.capacity);
            args.resource.columns[1].html = args.resource.status;
            switch (args.resource.status) {
                case "Dirty":
                    args.resource.cssClass = "status_dirty";
                    break;
                case "Cleanup":
                    args.resource.cssClass = "status_cleanup";
                    break;
            }
            args.resource.areas = [{
                top:3,
                right:4,
                height:14,
                width:14,
                action:"JavaScript",
                js: function(r) {
                    var modal = new DayPilot.Modal();
                    modal.onClosed = function(args) {
                        loadResources();
                    };
                    modal.showUrl("room_edit.php?id=" + r.id);
                },
                v:"Hover",
                css:"icon icon-edit",
            }];
        },
        onEventMoved: function (args) {
            $http.post("/reservation/move", {
                id: args.e.id(),
                newStart: args.newStart.toString(),
                newEnd: args.newEnd.toString(),
                newResource: args.newResource
            }).then(function(response) {
                dp.message("Ok");
                loadEvents();
            });
        },
        onEventResized: function (args) {
            $http.post("/reservation/resize", {
                id: args.e.id(),
                newStart: args.newStart.toString(),
                newEnd: args.newEnd.toString(),
                resource: args.e.resource()
            }).then(function() {
                dp.message("Ok");
                loadEvents();
            });
        },
        onEventDeleted: function(args) {
            $http.post("/reservation/delete", {
                id: args.e.id()
            }).then(function() {
                dp.message("Eliminada");
                loadEvents();
            });
        },
        onTimeRangeSelected: function (args) {
            var modal = new DayPilot.Modal();
            modal.closed = function() {
                dp.clearSelection();

                // reload all events
                var data = this.result;
                if (data && data.result === "OK") {
                    loadEvents();
                }
            };

            var reservation = {
                'start': args.start,
                'end': args.end,
                'resource': args.resource
            };

            sessionStorage.setItem('newReservation', JSON.stringify(reservation));

            modal.showUrl("views/components/nuevaReserva.html");
        },
        onEventClick: function(args) {
            var modal = new DayPilot.Modal();
            modal.closed = function() {
                // reload all events
                var data = this.result;
                if (data && data.result === "OK") {
                    loadEvents();
                }
            };

            sessionStorage.setItem('reservationId', args.e.id());
            modal.showUrl("views/components/editarReserva.html");
        },
        onBeforeEventRender: function(args) {
            var start = new DayPilot.Date(args.data.start);
            var end = new DayPilot.Date(args.data.end);

            var now = new DayPilot.Date();
            var today = new DayPilot.Date().getDatePart();
            var status = "";

            // customize the reservation bar color and tooltip depending on status
            switch (args.e.status) {

                case "New":
                    var in2days = today.addDays(1);

                    if (start < in2days) {
                        args.data.barColor = 'red';
                        status = 'Expirada (no confirmada)';
                    }
                    else {
                        args.data.barColor = 'orange';
                        status = 'Nueva';
                    }
                    break;

                case "Confirmed":
                    var arrivalDeadline = today.addHours(18);

                    if (start < today || (start === today && now > arrivalDeadline)) { // must arrive before 6 pm
                        args.data.barColor = "#f41616";  // red
                        status = 'Late arrival';
                    }
                    else {
                        args.data.barColor = "green";
                        status = "Confirmada";
                    }
                    break;

                case 'Arrived': // arrived
                    var checkoutDeadline = today.addHours(10);

                    if (end < today || (end === today && now > checkoutDeadline)) { // must checkout before 10 am
                        args.data.barColor = "#f41616";  // red
                        status = "Late checkout";
                    }
                    else
                    {
                        args.data.barColor = "#1691f4";  // blue
                        status = "Arrived";
                    }
                    break;

                case 'CheckedOut': // checked out
                    args.data.barColor = "gray";
                    status = "Checked out";
                    break;

                default:
                    status = "";
                    break;
            }

            status = "";
            args.data.barColor = "green";

            // customize the reservation HTML: text, start and end dates
            args.data.html = args.data.bubbleHtml + " " + args.data.text + " (" + start.toString("M/d/yyyy") + " - " + end.toString("M/d/yyyy") + ")" + "<br /><span style='color:gray'>" + status + "</span>";

            // reservation tooltip that appears on hover - displays the status text
            args.e.toolTip = args.data.text + " (" + start.toString("M/d/yyyy") + " - " + end.toString("M/d/yyyy") + ")";

            // add a bar highlighting how much has been paid already (using an "active area")
            var paid = args.e.paid;
            var paidColor = "#aaaaaa";
            /*
            args.data.areas = [
                { bottom: 10, right: 4, html: "<div style='color:" + paidColor + "; font-size: 8pt;'>Paid: " + paid + "%</div>", v: "Visible"},
                { left: 4, bottom: 8, right: 4, height: 2, html: "<div style='background-color:" + paidColor + "; height: 100%; width:" + paid + "%'></div>" }
            ];
            */
        }
    };

    $scope.addRoom = function() {
        var modal = new DayPilot.Modal();
        modal.onClosed = function(args) {
            loadResources();
        };
        modal.showUrl('views/components/nuevoCuarto.html');
    };

    $timeout(function() {
        dp = $scope.scheduler;  // debug
        dp.locale = "es-es";
        loadEvents(DayPilot.Date.today());
    });

    // loads events; switches the Scheduler visible range if "day" supplied
    function loadEvents(day) {
        var from = $scope.scheduler.visibleStart();
        var to = $scope.scheduler.visibleEnd();
        if (day) {
            from = new DayPilot.Date(day).firstDayOfMonth();
            to = from.addMonths(1);
        }

        var params = {
            start: from.toString(),
            end: to.toString()
        };

        $http.post("/reservation/events", params).then(function(response) {
            if (day) {
                $scope.schedulerConfig.timeline = getTimeline(day);
                $scope.schedulerConfig.scrollTo = day;
                $scope.schedulerConfig.scrollToAnimated = "fast";
                $scope.schedulerConfig.scrollToPosition = "left";
            }
            $scope.events = response.data;
        });
    }

    function loadResources() {
        var params = {
            capacity: $scope.roomType
        };
        $http.post("/room/available", params, {headers:{'Content-Type': 'application/json'}}).then(function(response) {
            $scope.schedulerConfig.resources = response.data;
            $scope.schedulerConfig.visible = true;
        });
    }

    function getTimeline(date) {
        var date = date || DayPilot.Date.today();
        var start = new DayPilot.Date(date).firstDayOfMonth();
        var days = start.daysInMonth();

        var timeline = [];

        var checkin = 12;
        var checkout = 12;

        for (var i = 0; i < days; i++) {
            var day = start.addDays(i);
            timeline.push({start: day.addHours(checkin), end: day.addDays(1).addHours(checkout) });
        }

        return timeline;
    }
});
