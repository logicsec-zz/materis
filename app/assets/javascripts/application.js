// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require foundation
//= require turbolinks
//= require jquery.turbolinks
//= require bootstrap-notify
//= require select2
//= require cocoon
//= require jquery.minicolors
//= require jquery.minicolors.simple_form
//= require Chart.bundle
//= require chartkick
//= require_tree .

$(function(){ $(document).foundation(); });

function infiniteScroll() {
    if ($('.scroll-loop').size() > 0) {
        return $('.scroll2watch').on('scroll', function (e) {
            var load_more_url;
            load_more_url = $(e.target).find('a.next_page').attr('href');
            if (load_more_url && $(e.target).find('.paginator').height() - $(e.target).closest('.scroll2watch').scrollTop() - 60 < $(e.target).closest('.scroll2watch').height()) {
                $(e.target).find('.pagination').html('loading...');
                $.getScript(load_more_url);
            }
            return;
        });
    }
}



function copyTextToClipboard(text) {
    var textArea = document.createElement("textarea");

    textArea.style.position = 'fixed';
    textArea.style.top = 0;
    textArea.style.left = 0;


    textArea.style.width = '2em';
    textArea.style.height = '2em';

    textArea.style.padding = 0;

    textArea.style.border = 'none';
    textArea.style.outline = 'none';
    textArea.style.boxShadow = 'none';

    textArea.style.background = 'transparent';

    textArea.value = text;

    document.body.appendChild(textArea);

    textArea.select();

    try {
        var successful = document.execCommand('copy');
        var msg = successful ? 'successful' : 'unsuccessful';
    } catch (err) {
    }

    document.body.removeChild(textArea);
}

function CopyLink(url) {
    copyTextToClipboard(url);
    $('.alert-area').notify({message: { text: 'Project URL Copied to the Clipboard' }, type: 'tracker-alert', fadeOut: { enabled: true, delay: 10000 }}).show();
}