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

$.fn.tab = (config) ->
	mode = 'html'
	tab = this
	$(this).click ->
		$(tab).removeClass "selected-tab"
		$(this).addClass "selected-tab"

	$('#pageview').click ->
		console.log "www"
		if mode == 'text'
			mode = 'html'
			result = $('#previewtext').text()
			$('#previewtext').replaceWith('<div id="previewtext">'+result+'</div>')
			@

	$('#source').click ->
		console.log "ttt"
		if mode == 'html'
			mode = 'text'
			result = $('#previewtext').html()
			$('#previewtext').replaceWith('<pre id="previewtext"></pre>')
			$('#previewtext').text(result)
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

mode = 'html'
parseBcml = ->
	text = $('#text').val()
	console.log(text)
	$.post(
		'/parse'
		{
			'text': text
		}
		(data)->
			if mode == 'text'
				$('#previewtext').text(data)
			if mode == 'html'
				$('#previewtext').html(data)
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
	console.log "hello"
	@

$ ->
	$('.nav').menu()
	$('.tabs').tab()
	$('.download').download()
	$.startCodeMirror('text')
	@
	return
