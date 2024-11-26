// Define the AngularJS application
var app = angular.module('myApp', []);

// Define the controller
app.controller('MainController', ['$scope', function ($scope) {
    $scope.userText = '';

    // Function to change the background color using YUI
    $scope.changeBackground = function () {
        YUI().use('node', function (Y) {
            var outputDiv = Y.one('#output');
            outputDiv.setStyle('backgroundColor', getRandomColor());
        });
    };

    // Utility function to generate a random color
    function getRandomColor() {
        return '#' + Math.floor(Math.random() * 16777215).toString(16);
    }
}]);
