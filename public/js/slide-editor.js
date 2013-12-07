(function($) {
	$.fn.slideEditor = function() {
		$('.slide-container').click(function(e) {
			var target = e.target || e.srcElement;
			$('.editable').each(function() {
				console.log($(target).html());
				if (target != this) {
					$(this).removeClass("selected");
					$(this).attr('contenteditable', 'false');
				} else {
				}
			});
		});
		// 文本
		$('.slide-btn-insert-text').on('click', function() {
			$.fn.slideEditor.addComponent('slide-component textbox', '<div class="editable" data-button-class="all">Text</div>');
		});
		// 图片
		$('.slide-btn-insert-image').on('click', function() {
			$("#slide-insert-image-modal input[type=file]").each(function() {
				for (var i = 0, f; f = this.files[i]; i++) {
					if (!f.type.match('image.*')) {
						continue;
					}
					var reader = new FileReader();
					reader.readAsDataURL(f);
					reader.onload = function(e) {
						$.fn.slideEditor.addComponent('slide-component', '<img src="' + this.result + '" style="width:100%;height:100%"/>');
					};
				}
			});

			$("#slide-insert-image-modal").modal('hide');
		});
		// 视频
		$('.slide-btn-insert-video').on('click', function() {
			$("#slide-insert-video-modal input[type=file]").each(function() {
				for (var i = 0, f; f = this.files[i]; i++) {
					if (!f.type.match('video.*')) {
						continue;
					}
					var url = URL.createObjectURL(this.files[0]);
					$.fn.slideEditor.addComponent('slide-component', '<video controls="controls" src="' + url + '" style="width:100%;height:100%"/>');
				}
			});

			$("#slide-insert-video-modal").modal('hide');
		});
	};
	
	$.fn.slideEditor.lastIndex = 0;

	$.fn.slideEditor.addComponent = function(classname, component) {
		$component = $('<div class="' + classname + '" style="top: 30%; left: 30%;">'
				+ '<div class="handle north NE"></div>'
				+ '<div class="handle north NN"></div>'
				+ '<div class="handle north NW"></div>'
				+ '<div class="handle north WW"></div>'
				+ '<div class="handle north EE"></div>'
				+ '<div class="handle north SW"></div>'
				+ '<div class="handle north SS"></div>'
				+ '<div class="handle north SE"></div>'
				+ component + '</div>');

		$component.click(function() {
			var attr = $(this).prop("className");
			$(this).toggleClass("selected");
		}).dblclick(function() {
			var attr = $(this).prop("className");
			if (attr.indexOf("textbox") > -1) {
				var div = $(this).children('div.editable');
//				if (span.attr('contenteditable') != true) {
//					span.attr('contenteditable','true');
//					span.focus();
//				}
				div.addClass("selected");
			}
			//$(this).toggleClass("selected");
		}).mouseout(function(ev, dd) {
//			var attr = $(this).prop("className");
//			if (attr.indexOf("textbox") > -1) {
//				var span = $(this).children('span');
//				span.attr('contenteditable','false');
//				span.removeClass("selected");
//			} else {
//				$(this).removeClass("selected");
//			}
		}).drag("init", function() {
			if ($(this).is('.selected'))
				return $('.selected');
		}).drag("start", function(ev, dd) {
			$(this).addClass("dragging");
			dd.attr = $(ev.target).prop("className");
			dd.width = $(this).width();
			dd.height = $(this).height();

		}).drag("end", function() {
			$(this).removeClass("dragging");
		}).drag(function(ev, dd) {
			var props = {};
			if (dd.attr.indexOf("north") > -1) {
				if (dd.attr.indexOf("E") > -1) {
					props.width = Math.max(32, dd.width + dd.deltaX);
				}
				if (dd.attr.indexOf("S") > -1) {
					props.height = Math.max(32, dd.height + dd.deltaY);
				}
				if (dd.attr.indexOf("W") > -1) {
					props.width = Math.max(32, dd.width - dd.deltaX);
					props.left = dd.originalX + dd.width - props.width;
				}
				if (dd.attr.indexOf("N") > -1) {
					props.height = Math.max(32, dd.height - dd.deltaY);
					props.top = dd.originalY + dd.height - props.height;
				}
			} else {
				props.top = dd.offsetY;
				props.left = dd.offsetX;
			}
			$(this).css(props);
		}, {relative: true, not: '.selected'});
		$('.slide-container').append($component);
		// 嵌入编辑器
		var article = Backbone.Model.extend({
			defaults: {
				connect: 'Default Title'
			}
		});

		var articleView = Backbone.View.extend({
			initialize: function() {
				_.bindAll(this, 'save');
			},
			events: {
				'dblclick': 'editableClick'
			},
			editableClick: etch.editableInit,
			save: function() {

			}

		});
		var model = new article();
		var view = new articleView({model: model, el: $component, tagName: $component.tagName});
		// 加入右键
		$.contextMenu({
			selector: '.slide-component',
			build: function($trigger, e) {
				var target = e.target || e.srcElement;
						console.log($(target).html());
				return {
					callback: function(key, options) {
						$.fn.slideEditor.lastIndex += 1;
						$(target).closest('.slide-component').css('z-index', $.fn.slideEditor.lastIndex);
						console.log($(target).closest('.slide-component').css('z-index'));
					},
					items: {
						"top": {name: "移到最上层"}
					}
				};
			}
		});
	};
})(jQuery);