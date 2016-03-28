// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//

//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require bootstrap-sprockets
//= require_tree .
//= require bootstrap-tagsinput
//= require gravtastic
//= require bootstrap-treeview

(function ($, window){
    function CoreCode() {
        $(".show-value-props").click(this.showValueProps);
        this.detectActive(window.location.pathname);
    }

    CoreCode.prototype.showValueProps = function(e){
// console.log(e);
        e.preventDefault();
        if ($("#rest-vps").css("display") === "none"){
            $("#rest-vps").addClass("animated fadeIn");
            $("#rest-vps").toggle();
            $(e.currentTarget).children("span").removeClass("fa-chevron-down").addClass("fa-chevron-up");
            //console.log($(e.target).children("span").attr("class"));
        } else {
            $("#rest-vps").toggle();
            $(e.currentTarget).children("span").removeClass("fa-chevron-up").addClass("fa-chevron-down");
        }
    };

    CoreCode.prototype.detectActive = function(currentPath){
// console.log(currentPath);
// var page = currentPath.split("/").pop();
        var page = currentPath;
        $("ul.navbar-nav").children("li").each(function(index, element){
            var link = $(element).children("a")[0];
// console.log(link);
            if ($(link).attr("href") === page){
                $(link).addClass("nav-active");
            }
        });
    };

    new CoreCode();

})($, window, undefined);