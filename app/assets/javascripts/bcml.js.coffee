# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$.fn.menu = (config) ->
	$("> li",this).hover ->
		$("ul",this).show()
		position = $(this).position()
		$("ul",this).css {
			'top':position.top,
			'left':position.left + 100
		}
	, ->
		$("ul",this).hide()
	@

mode = 'html'
$.fn.tab = (config) ->
	tab = this
	$(this).click ->
		$(tab).removeClass "selected-tab"
		$(this).addClass "selected-tab"

	$('#pageview').click ->
		if mode == 'text'
			mode = 'html'
			result = $('#previewFrame').contents().find('#previewtext').text()
			$('#previewFrame').replaceWith('<iframe srcdoc=\'<div id="previewtext">'+result.replace(/\'/g,"&#39;")+'</div>\' sandbox="allow-same-origin" frameborder=0 id="previewFrame"></iframe>')
			$('#previewFrame').load ->
				$('#previewFrame').contents().find('#previewtext').css("font-family","'Lucida Grande','Hiragino Kaku Gothic ProN',Meiryo, sans-serif")
			@

	$('#source').click ->
		if mode == 'html'
			mode = 'text'
			result = $('#previewFrame').contents().find('#previewtext').html()
			$('#previewFrame').contents().find('#previewtext').replaceWith('<pre id="previewtext"></pre>')
			$('#previewFrame').contents().find('#previewtext').text(result)
			$('#previewFrame').contents().find('#previewtext').css("font-family","'Lucida Grande','Hiragino Kaku Gothic ProN',Meiryo, sans-serif")
			@

	@

$.fn.ajax = (config) ->
	$(this).click ->
		$.ajax
			url: $(this).attr('href')
			type: "GET"
			dataType: "html"
			success: (data) ->
				$(config).html(data)
				$('.tabs').tab()
		return false
	@

$.fn.download = (config) ->
	$(this).click ->
		href = $(this).attr('href')
		content = $(href).val()
		blob = new Blob([ content ])
		window.URL = window.URL || window.webkitURL
		$(this).attr 'download',content.slice(0,6)+'.txt'
		$(this).attr 'href',window.URL.createObjectURL(blob)
	@

#bcmlで変換した文字列をプレビューに挿入
parseBcml = ->
	text = $('#text').val()
	$.post(
		'/parse'
		{
			'text': text,
			'config': localStorage.config
		}
		(data)->
			if mode == 'text'
				$('#previewFrame').contents().find('#previewtext').text(data)
				$('#previewFrame').contents().find('#previewtext').css("font-family","'Lucida Grande','Hiragino Kaku Gothic ProN',Meiryo, sans-serif")
			if mode == 'html'
				srcdoc = '\'<div id="previewtext">'+data.replace(/\'/g,"&#39;")+'</div>\''
				$('#previewFrame').replaceWith('<iframe srcdoc='+srcdoc+' sandbox="allow-same-origin" frameborder=0 id="previewFrame"></iframe>')
				$('#previewFrame').load ->
					$('#previewFrame').contents().find('#previewtext').css("font-family","'Lucida Grande','Hiragino Kaku Gothic ProN',Meiryo, sans-serif")
			@
	)
	@

$.startCodeMirror = (config) ->
	editor = CodeMirror.fromTextArea(document.getElementById(config),{
			mode: "bcml",
			lineNumbers: true,
			lineWrapping: true
		})
	timer = ""
	editor.on("change", ->
		editor.save()
		clearTimeout(timer)
		timer = setTimeout(parseBcml, 500)
	)
	@

$ ->
	$(document).ajaxSend (event, jqxhr, settings) ->
		if settings.url is '/ajax?template=usage' or settings.url is '/ajax?template=configedit' or settings.url is '/ajax?template=edit'
			$('#wrap').html("<div id='loading'><img src='assets/load.gif'/></div>")
		return

	$('.nav').menu()
	$('.tabs').tab()
	$('.download').download()
	$.startCodeMirror('text')
	@
	return
