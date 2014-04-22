var angles = angular.module("angles", []);

angles.chart = function (type,$timeout) {
    return { 
        restrict: "A",
        scope: {
            data: "=",
            options: "=",
            id: "@",
            width: "=",
            height: "=",
            resize: "=",
            chart: "@"
        },
        link: function ($scope, $elem) {

            $timeout(function(){
                 var ctx = $elem[0].getContext("2d");
                var autosize = false;
                chart = new Chart(ctx);

                $scope.size = function () {
                    if ($scope.width <= 0) {
                        $elem.width($elem.parent().width());
                        $elem.height($elem.parent().height());
                        ctx.canvas.width = $elem.width();
                        ctx.canvas.height = ctx.canvas.width / 2;               
                    } else {
                        ctx.canvas.width = $scope.width || ctx.canvas.width;
                        ctx.canvas.height = $scope.height || ctx.canvas.height;
                        autosize = true;
                    }               
                }

                $scope.$watch("data", function (newVal, oldVal) { 
                    // if data not defined, exit
                    if ($scope.chart) { type = $scope.chart; }
                    
                    if(autosize){
                        $scope.size();
                        chart = new Chart(ctx);
                    } else if (!newVal) return;
                    
                    chart[type]($scope.data, $scope.options);
                }, true);
                
                if ($scope.resize) {
                    angular.element(window).bind('resize', function () {
                        $scope.size();
                        chart = new Chart(ctx);
                        chart[type]($scope.data, $scope.options);
                    });             
                }
                
                $scope.size();
                var chart = new Chart(ctx);


             
            },500,true);

            
        }
    }
}


/* Aliases for various chart types */
angles.directive("chart", function ($timeout) { return angles.chart('',$timeout); });
angles.directive("linechart", function ($timeout) { return angles.chart("Line",$timeout); });
angles.directive("barchart", function ($timeout) { return angles.chart("Bar",$timeout); });
angles.directive("radarchart", function ($timeout) { return angles.chart("Radar",$timeout); });
angles.directive("polarchart", function ($timeout) { return angles.chart("PolarArea",$timeout); });
angles.directive("piechart", function ($timeout) { return angles.chart("Pie",$timeout); });
angles.directive("doughnutchart", function ($timeout) { return angles.chart("Doughnut",$timeout); });
angles.directive("donutchart", function ($timeout) { return angles.chart("Doughnut",$timeout); });