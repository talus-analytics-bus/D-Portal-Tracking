
var dquery=exports;

// running in browser
if(typeof window !== 'undefined')
{
	window.$ = window.jQuery = require("jquery");
	var split=require("jquery.splitter")
//	var term=(require("jquery.terminal"))()

	var ui=require("./jquery-ui.js")

//	var tree=require("jstree/dist/jstree.js")
}

var plated=require("plated").create({},{pfs:{}}) // create a base instance for inline chunks with no file access

dquery.chunks={}
plated.chunks.fill_chunks( require('fs').readFileSync(__dirname + '/chunks.html', 'utf8'), dquery.chunks )
plated.chunks.fill_chunks( require('fs').readFileSync(__dirname + '/chunks.css', 'utf8'), dquery.chunks )

plated.plate=function(str){ return plated.chunks.replace(str,dquery.chunks) }

dquery.opts={}
dquery.opts.test=false

dquery.start=function(opts){
	for(var n in opts) { dquery.opts[n]=opts[n] } // copy opts
	$(dquery.start_loaded)
}

dquery.start_loaded=async function(){

	var ace=require("brace")
	require("brace/ext/modelist")
	require("brace/theme/twilight")

	require("brace/mode/javascript")
	require("brace/mode/json")
	require("brace/mode/html")
	require("brace/mode/css")
	require("brace/mode/markdown")
	require("brace/mode/sh")
	require("brace/mode/gitignore")

	$("html").prepend(plated.plate('<style>{css}</style>')) // load our styles

	$("html").prepend("<style>"+require("jquery.splitter/css/jquery.splitter.css")+"</style>")
	$("html").prepend("<style>"+require('fs').readFileSync(__dirname + '/jquery-ui.css', 'utf8')+"</style>")

	$("body").empty().append(plated.plate('{body}')) // fill in the base body

	var resize_timeout;
	var resize_func=function(event) {
		var f=function() {
			$("#split").height("100%")
			$("#split_left").height("100%")
			$("#split_right").height("100%")
			window.dispatchEvent(new Event('resize'));
		};
		clearTimeout(resize_timeout);
		timresize_timeouteout=setTimeout(f,100);
	};
	$( window ).resize(resize_func) // keep height full
	$("#split").height("100%").split({orientation:'vertical',limit:5,position:'50%',onDrag: resize_func });

	$("#menubar").menu({
		position: { my: 'left top', at: 'left bottom' },
		blur: function() {
			$(this).menu('option', 'position', { my: 'left top', at: 'left bottom' });
		},
		focus: function(e, ui) {
			if ($('#menubar').get(0) !== $(ui).get(0).item.parent().get(0)) {
				$(this).menu('option', 'position', { my: 'left top', at: 'right top' });
			}
		},
	})
	
	$("#menubar").on( "menuselect", function(e,ui){
		var id=ui.item.attr("id")
		dquery.click(id)
	})
		
	dquery.editor=ace.edit("editor");
	dquery.editor.setTheme("ace/theme/twilight");
	dquery.editor.$blockScrolling = Infinity 

	dquery.hash=window.location.hash
	var session=dquery.editor.getSession()
	session.setValue( decodeURI( dquery.hash.substr(1) ) )

	window.setInterval(dquery.cron,1000) // start cron tasks

}

dquery.cron=async function()
{
	if(dquery.cron.lock) { return; } // there can be only one
	dquery.cron.lock=true
	
	var session=dquery.editor.getSession()
	var undo=session.getUndoManager()
	if( !undo.isClean() )
	{
		dquery.hash="#"+encodeURI(session.getValue())
		window.location.hash=dquery.hash
		undo.markClean()
	}
	
	if( dquery.hash != window.location.hash ) // update editor with any chnages to hash (browser forward/back buttons)
	{
		dquery.hash = window.location.hash
		session.setValue( decodeURI( dquery.hash.substr(1) ) )
	}

	dquery.cron.lock=false
}

dquery.click=async function(id)
{
	switch(id)
	{
		default:
			console.log("unhandled click "+id)
		break
	}
}


